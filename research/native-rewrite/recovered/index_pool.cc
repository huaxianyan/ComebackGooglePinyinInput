// Google-derived reconstruction; see NOTICE and index-pool.md.
#include "index_pool.h"
#include "little_endian.h"

#include <limits>

namespace comeback::recovered {
namespace {
constexpr std::size_t kCellSize = sizeof(std::uint32_t);
constexpr std::uint32_t kOccupied = 0x80000000;
constexpr std::uint32_t kRecordMask = ~kOccupied;
constexpr std::uint32_t kInvalidRecord = 0xffffffff;
constexpr auto kMaxRangeField =
    static_cast<std::uint32_t>(std::numeric_limits<std::int32_t>::max());
constexpr unsigned kLinkShift = 2;
constexpr std::uint32_t kLengthTagMask = (std::uint32_t{1} << kLinkShift) - 1;
}  // namespace

std::uint32_t IndexPoolView::ReadWord(std::uint32_t index) const {
    return detail::ReadLittleEndian<std::uint32_t>(bytes_ + index * kCellSize);
}

void IndexPoolView::WriteWord(std::uint32_t index, std::uint32_t value) {
    detail::WriteLittleEndian(value, bytes_ + index * kCellSize);
}

std::uint32_t IndexPoolView::CellCount() const {
    if (metadata_size_ < 2 * kCellSize) return 0;
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
    if (index < 2 || index > kMaxRangeField || index >= CellCount()) return false;
    const auto word = ReadWord(index);
    value = (word & kOccupied) != 0 ? word & kRecordMask : kInvalidRecord;
    return value != kInvalidRecord;
}

bool IndexPoolView::WriteRecordId(std::uint32_t index, std::uint32_t value) {
    if (index < 2 || index >= CellCount()) return false;
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

}  // namespace comeback::recovered
