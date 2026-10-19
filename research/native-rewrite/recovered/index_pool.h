// Recovered index-pool image operations; Google-derived logic remains under NOTICE.
#ifndef COMEBACK_RECOVERED_INDEX_POOL_H
#define COMEBACK_RECOVERED_INDEX_POOL_H

#include <cstddef>
#include <cstdint>
#include <optional>

namespace comeback::recovered {

// Shared in-memory range for association references and pool extents.
struct IndexRange {
    std::uint32_t first_index;
    std::uint32_t count;
};

// Non-owning view over separate metadata and cell regions. The metadata's
// second word is the active count; cells 0/1 are the free-list sentinel/head/tail.
// Free-range reuse/coalescing require a valid ordered, acyclic free list.
// Storage growth, relocation, ownership and whole-image validation are external.
class IndexPoolView {
public:
    IndexPoolView(const std::uint8_t* metadata, std::size_t metadata_size,
                  std::uint8_t* bytes, std::size_t size)
        : metadata_(metadata), metadata_size_(metadata_size), bytes_(bytes), size_(size) {}

    // An inactive/out-of-range index preserves value. A free active cell assigns
    // 0xffffffff and reports false, matching the native checked read.
    bool ReadRecordId(std::uint32_t index, std::uint32_t& value) const;
    bool WriteRecordId(std::uint32_t index, std::uint32_t value);

    // Decode at a known node header. These do not establish free-list membership.
    bool ReadFreeRange(std::uint32_t index, IndexRange& range) const;
    bool ReadNextFreeRange(std::uint32_t index, IndexRange& range) const;
    bool ReadPreviousFreeRange(std::uint32_t index, IndexRange& range) const;
    bool LinkFreeRanges(IndexRange previous, IndexRange next);

    // A successful search with {0, 0} means that storage growth is needed.
    bool FindFreeRange(std::int32_t count, IndexRange& range) const;
    // Claim a real free-list range; preserve the native sequential write order.
    bool ClaimFreeRange(IndexRange& range, const std::uint32_t* values, std::size_t count);
    // The caller owns the occupied range. On success it becomes the merged free
    // range, which may start earlier and contain more cells than the input.
    bool ReleaseRange(IndexRange& range);

private:
    bool IsFreeCell(std::uint32_t index) const;
    bool ReadListNeighbors(IndexRange range, IndexRange& previous, IndexRange& next) const;
    bool ReadAdjacentFreeRanges(IndexRange range, std::optional<IndexRange>& previous,
                                std::optional<IndexRange>& next) const;
    std::uint32_t CellCount() const;
    bool ValidRange(IndexRange range) const;
    std::uint32_t ReadWord(std::uint32_t index) const;
    void WriteWord(std::uint32_t index, std::uint32_t value);

    const std::uint8_t* metadata_;
    std::size_t metadata_size_;
    std::uint8_t* bytes_;
    std::size_t size_;
};

class OwnedByteRegion;

// Operate on the separate owning regions; reuse IndexPoolView for node changes.
// Existing borrowed views must be reacquired after these operations.
// Allocation/initialization failure does not roll back prior buffer changes.
bool InitializeIndexPool(OwnedByteRegion& metadata, OwnedByteRegion& cells);
bool AllocateIndexRange(OwnedByteRegion& metadata, OwnedByteRegion& cells,
                        std::int32_t count, IndexRange& range);

}  // namespace comeback::recovered
#endif
