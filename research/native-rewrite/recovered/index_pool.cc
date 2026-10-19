// Google-derived reconstruction; see NOTICE and index-pool.md.
#include "index_pool.h"
#include "little_endian.h"
#include "owned_byte_region.h"

#include <algorithm>
#include <cstring>
#include <limits>
#include <vector>

namespace comeback::recovered {
namespace {
constexpr std::size_t kCellSize = sizeof(std::uint32_t);
constexpr std::size_t kMetadataSize = 2 * kCellSize;
constexpr std::uint32_t kSentinelCellCount = 2;
constexpr std::uint32_t kOccupied = 0x80000000;
constexpr std::uint32_t kRecordMask = ~kOccupied;
constexpr std::uint32_t kInvalidRecord = 0xffffffff;
constexpr auto kMaxRangeField =
    static_cast<std::uint32_t>(std::numeric_limits<std::int32_t>::max());
constexpr unsigned kLinkShift = 2;
constexpr std::uint32_t kLengthTagMask = (std::uint32_t{1} << kLinkShift) - 1;

// AArch64 SBFIZ sign-extends the 32-bit cell count before scaling by four.
std::size_t SignedCellByteSize(std::uint32_t count) {
    return static_cast<std::size_t>(static_cast<std::int64_t>(static_cast<std::int32_t>(count)) *
                                    static_cast<std::int64_t>(kCellSize));
}
}  // namespace

std::uint32_t IndexPoolView::ReadWord(std::uint32_t index) const {
    return detail::ReadLittleEndian<std::uint32_t>(bytes_ + index * kCellSize);
}

void IndexPoolView::WriteWord(std::uint32_t index, std::uint32_t value) {
    detail::WriteLittleEndian(value, bytes_ + index * kCellSize);
}

std::uint32_t IndexPoolView::CellCount() const {
    if (metadata_size_ < kMetadataSize) return 0;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(metadata_ + kCellSize);
    return count <= size_ / kCellSize ? count : 0;
}

bool IndexPoolView::ValidRange(IndexRange range) const {
    const auto count = CellCount();
    return range.first_index <= kMaxRangeField && range.count <= kMaxRangeField &&
           range.count != 0 && range.first_index < count &&
           range.count <= count - range.first_index;
}

bool IndexPoolView::ReadRecordId(std::uint32_t index, std::uint32_t& value) const {
    if (index < kSentinelCellCount || index > kMaxRangeField || index >= CellCount()) return false;
    const auto word = ReadWord(index);
    value = (word & kOccupied) != 0 ? word & kRecordMask : kInvalidRecord;
    return value != kInvalidRecord;
}

bool IndexPoolView::WriteRecordId(std::uint32_t index, std::uint32_t value) {
    if (index < kSentinelCellCount || index >= CellCount()) return false;
    WriteWord(index, value | kOccupied);
    return true;
}

bool IndexPoolView::ReadFreeRange(std::uint32_t index, IndexRange& range) const {
    if (index >= CellCount()) return false;
    auto count = ReadWord(index) & kLengthTagMask;
    if (count == kLengthTagMask) {
        if (CellCount() - index <= 2) return false;
        count = ReadWord(index + 2);
    }
    range = {index, count};
    return true;
}

bool IndexPoolView::ReadNextFreeRange(std::uint32_t index, IndexRange& range) const {
    if (index >= CellCount()) return false;
    const auto next = (ReadWord(index) >> kLinkShift) & (kRecordMask >> kLinkShift);
    return ReadFreeRange(next, range);
}

bool IndexPoolView::LinkFreeRanges(IndexRange previous, IndexRange next) {
    if (!ValidRange(previous) || !ValidRange(next)) return false;
    const auto tag = previous.count < kLengthTagMask ? previous.count : kLengthTagMask;
    WriteWord(previous.first_index, tag | (next.first_index << kLinkShift));
    if (previous.count >= kLengthTagMask) {
        WriteWord(previous.first_index + 2, previous.count);
    }
    if (next.count >= 2) {
        WriteWord(next.first_index + 1, previous.first_index);
    }
    return true;
}

bool IndexPoolView::IsFreeCell(std::uint32_t index) const {
    return index < CellCount() && (ReadWord(index) & kOccupied) == 0;
}

bool IndexPoolView::ReadPreviousFreeRange(std::uint32_t index, IndexRange& range) const {
    if (!IsFreeCell(index)) return false;
    if ((ReadWord(index) & kLengthTagMask) != 1) {
        if (CellCount() - index < 2) return false;
        return ReadFreeRange(ReadWord(index + 1) & kRecordMask, range);
    }
    IndexRange previous{};
    if (!ReadFreeRange(0, previous)) return false;
    for (;;) {
        IndexRange next{};
        if (!ReadNextFreeRange(previous.first_index, next) || next.first_index == 0) return false;
        if (next.first_index == index) {
            range = previous;
            return true;
        }
        previous = next;
    }
}

bool IndexPoolView::ReadListNeighbors(IndexRange range, IndexRange& previous,
                                      IndexRange& next) const {
    return ValidRange(range) && ReadPreviousFreeRange(range.first_index, previous) &&
           ReadNextFreeRange(range.first_index, next);
}

bool IndexPoolView::FindFreeRange(std::int32_t count, IndexRange& range) const {
    IndexRange current{};
    if (!ReadFreeRange(0, current)) return false;
    for (;;) {
        if (!ReadNextFreeRange(current.first_index, range)) return false;
        if (range.first_index == 0) {
            range.count = 0;
            return true;
        }
        if (count <= static_cast<std::int32_t>(range.count)) return true;
        current = range;
    }
}

bool IndexPoolView::ClaimFreeRange(IndexRange& range, const std::uint32_t* values,
                                   std::size_t count) {
    if (!ValidRange(range) || range.first_index < kSentinelCellCount || count > range.count) return false;
    IndexRange previous{}, next{};
    if (!ReadListNeighbors(range, previous, next)) return false;
    // The native fill loop does not aggregate cell-write status; its range was
    // validated before the loop. This view performs no relocation during writes.
    for (std::uint32_t index = 0; index < count; ++index) {
        WriteRecordId(range.first_index + index, values[index]);
    }
    if (range.count != count) {
        // ARM loads the old descriptor before storing the claimed length.
        const IndexRange remainder{range.first_index + static_cast<std::uint32_t>(count),
                                   range.count - static_cast<std::uint32_t>(count)};
        range.count = static_cast<std::uint32_t>(count);
        if (!LinkFreeRanges(previous, remainder)) return false;
        previous = remainder;
    }
    return LinkFreeRanges(previous, next);
}

bool IndexPoolView::ReadAdjacentFreeRanges(IndexRange range,
                                          std::optional<IndexRange>& previous,
                                          std::optional<IndexRange>& next) const {
    previous.reset();
    next.reset();
    const auto end = range.first_index + range.count;
    if (IsFreeCell(end)) {
        IndexRange neighbor{};
        if (!ReadFreeRange(end, neighbor)) return false;
        next = neighbor;
    }
    if (range.first_index <= kSentinelCellCount || !IsFreeCell(range.first_index - 1)) return true;
    if (next && next->count >= 2) {
        IndexRange neighbor{};
        if (!ReadPreviousFreeRange(next->first_index, neighbor)) return false;
        previous = neighbor;
    } else {
        auto start = range.first_index;
        while (start > kSentinelCellCount && IsFreeCell(start - 1)) --start;
        previous = IndexRange{start, range.first_index - start};
    }
    return true;
}

bool IndexPoolView::ReleaseRange(IndexRange& range) {
    if (!ValidRange(range) || range.first_index < kSentinelCellCount) return false;
    std::optional<IndexRange> left, right;
    if (!ReadAdjacentFreeRanges(range, left, right)) return false;
    auto merged = range;
    if (left) {
        merged.first_index = left->first_index;
        merged.count += left->count;
    }
    if (right) merged.count += right->count;
    if (!ValidRange(merged)) return false;

    IndexRange previous{}, next{};
    if (left) {
        if (!ReadListNeighbors(*left, previous, next)) return false;
        if (right && !ReadNextFreeRange(right->first_index, next)) return false;
    } else if (right) {
        if (!ReadListNeighbors(*right, previous, next)) return false;
    } else {
        if (!ReadFreeRange(0, previous)) return false;
        for (;;) {
            if (!ReadNextFreeRange(previous.first_index, next)) return false;
            if (next.first_index == 0 || next.first_index >= merged.first_index) break;
            previous = next;
        }
    }
    std::memset(bytes_ + merged.first_index * kCellSize, 0, merged.count * kCellSize);
    range = merged;
    if (!LinkFreeRanges(previous, range)) return false;
    return LinkFreeRanges(range, next);
}

bool InitializeIndexPool(OwnedByteRegion& metadata, OwnedByteRegion& cells) {
    // Native initialization resizes cells before metadata, but does not check
    // allocation failures. Report failure here instead of dereferencing null.
    if (!cells.Resize(kSentinelCellCount * kCellSize)) return false;
    auto* bytes = cells.MutableData();
    if (bytes == nullptr || !metadata.Resize(kMetadataSize)) return false;
    auto* header = metadata.MutableData();
    if (header == nullptr) return false;
    detail::WriteLittleEndian(std::uint32_t{0}, header);
    detail::WriteLittleEndian(kSentinelCellCount, header + kCellSize);
    detail::WriteLittleEndian(kSentinelCellCount, bytes);
    detail::WriteLittleEndian(std::uint32_t{0}, bytes + kCellSize);
    return true;
}

bool AllocateIndexRange(OwnedByteRegion& metadata, OwnedByteRegion& cells,
                        std::int32_t count, IndexRange& range) {
    if (count <= 0) return false;
    auto* bytes = cells.MutableData();
    if (bytes == nullptr) return false;
    IndexPoolView view(metadata.Data(), metadata.Size(), bytes, cells.Size());
    IndexRange available{};
    if (!view.FindFreeRange(count, available)) return false;
    const auto requested = static_cast<std::uint32_t>(count);
    if (available.count < requested) {
        auto* header = metadata.MutableData();
        if (header == nullptr) return false;
        const auto active = detail::ReadLittleEndian<std::uint32_t>(header + kCellSize);
        view = IndexPoolView(header, metadata.Size(), bytes, cells.Size());
        IndexRange tail{};
        if (!view.ReadPreviousFreeRange(0, tail)) return false;
        const auto reusable = tail.first_index != 0 && tail.first_index + tail.count == active
                                  ? tail.count : 0;
        const auto old_capacity = static_cast<std::uint32_t>(cells.Size() / kCellSize);
        const auto required = active + requested - reusable;
        if (static_cast<std::int32_t>(old_capacity) < static_cast<std::int32_t>(required)) {
            // FCVTZS saturates positive binary64 results at signed INT32_MAX.
            const auto scaled = static_cast<std::uint32_t>(std::min(
                static_cast<double>(active) * 1.25, static_cast<double>(kMaxRangeField)));
            const auto triple_request = active + requested * 3u;
            auto capacity = static_cast<std::int32_t>(scaled) >=
                                    static_cast<std::int32_t>(triple_request)
                                ? scaled : triple_request;
            capacity += capacity & 1u;
            if (!cells.Resize(SignedCellByteSize(capacity))) return false;
            bytes = cells.MutableData();
            if (bytes == nullptr) return false;
            std::memset(bytes + SignedCellByteSize(old_capacity), 0,
                        SignedCellByteSize(capacity - old_capacity));
        }
        auto added = requested - reusable;
        added += added & 1u;
        detail::WriteLittleEndian(active + added, header + kCellSize);
        // Both pointers may have changed after COW/resize. Active extent is
        // committed before marking cells and releasing the appended range.
        view = IndexPoolView(header, metadata.Size(), bytes, cells.Size());
        available = {active, added};
        for (std::int32_t index = 0; index < static_cast<std::int32_t>(added); ++index) {
            // The native loop does not aggregate individual write statuses.
            view.WriteRecordId(active + static_cast<std::uint32_t>(index), 0);
        }
        if (!view.ReleaseRange(available)) return false;
    }
    // Native constructs the zero-ID vector before assigning the output range.
    const std::vector<std::uint32_t> values(static_cast<std::size_t>(requested), 0);
    range = available;
    return view.ClaimFreeRange(range, values.data(), values.size());
}

}  // namespace comeback::recovered
