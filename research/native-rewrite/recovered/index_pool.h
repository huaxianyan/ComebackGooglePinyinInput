// Recovered index-pool image operations; Google-derived logic remains under NOTICE.
#ifndef COMEBACK_RECOVERED_INDEX_POOL_H
#define COMEBACK_RECOVERED_INDEX_POOL_H

#include <cstddef>
#include <cstdint>

namespace comeback::recovered {

// Shared in-memory range for association references and pool extents.
struct IndexRange {
    std::uint32_t first_index;
    std::uint32_t count;
};

// Non-owning view over separate metadata and cell regions. The metadata's
// second word is the active count; cells 0/1 are the free-list sentinel/head/tail.
// Allocation, relocation, coalescing and whole-image validation are not implemented.
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
    bool LinkFreeRanges(IndexRange previous, IndexRange next);

private:
    std::uint32_t CellCount() const;
    bool ValidRange(IndexRange range) const;
    std::uint32_t ReadWord(std::uint32_t index) const;
    void WriteWord(std::uint32_t index, std::uint32_t value);

    const std::uint8_t* metadata_;
    std::size_t metadata_size_;
    std::uint8_t* bytes_;
    std::size_t size_;
};

}  // namespace comeback::recovered
#endif
