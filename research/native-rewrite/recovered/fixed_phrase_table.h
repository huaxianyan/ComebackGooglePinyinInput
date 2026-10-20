// Recovered FixedPhraseTable heap backend; Google-derived material: see NOTICE.
#ifndef COMEBACK_RECOVERED_FIXED_PHRASE_TABLE_H
#define COMEBACK_RECOVERED_FIXED_PHRASE_TABLE_H

#include "owned_byte_region.h"

#include <cstddef>
#include <cstdint>

namespace comeback::recovered {

// Records have a fixed byte width. IDs are aligned byte offsets, not ordinals.
// Returned views must be reacquired after mutation. Append input must remain
// valid across storage growth; this is not an overlapping/self-append API.
class FixedPhraseTable {
public:
    explicit FixedPhraseTable(std::uint32_t record_size) : record_size_(record_size) {}
    bool Initialize();
    // Eight-byte count/width header followed by used bytes and zero padding to
    // eight-byte alignment. This is a memory image, not a stream I/O backend.
    bool Serialize(OwnedByteRegion& output) const;
    // Restores the image's width, not the constructor width. Return the aligned
    // logical advance (even when final padding is absent), or zero on failure.
    std::uint64_t Load(const OwnedByteRegion& input);
    bool AppendRecord(const std::uint8_t* data, std::size_t size, std::uint64_t& record_id);
    bool ReadRecord(std::uint64_t record_id, const std::uint8_t*& data, std::size_t& size) const;
    bool MutableRecord(std::uint64_t record_id, std::uint8_t*& data, std::size_t& size);
    std::uint32_t RecordCount() const;
    std::uint32_t RecordSize() const { return record_size_; }
    // Clear retains storage; count/usage reset even if obtaining the native
    // zeroing pointer fails. It clears the table, rather than deleting one ID.
    void Clear();

private:
    bool Contains(std::uint64_t record_id) const;
    std::uint32_t record_size_;
    bool ready_ = false;
    std::uint32_t record_count_ = 0;
    std::size_t used_size_ = 0;
    OwnedByteRegion bytes_;
};

}  // namespace comeback::recovered
#endif
