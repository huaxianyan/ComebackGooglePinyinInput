// Google-derived list/storage coordination; see NOTICE and association-records.md.
#include "association_records.h"
#include "fixed_phrase_table.h"
#include "little_endian.h"

namespace comeback::recovered {

bool AppendAssociationRecord(FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, const std::uint8_t* data,
                              std::size_t size, IndexRange& reference) {
    std::uint64_t record_id = 0;
    if (!records.AppendRecord(data, size, record_id)) return false;
    // The native caller narrows the returned offset before writing a pool ID.
    const auto value = static_cast<std::uint32_t>(record_id);
    return reference.count == 0 ? CreateIndexRange(metadata, cells, value, reference)
                               : InsertIndexRange(metadata, cells, value, reference.count, reference);
}

bool FindAssociationRecord(const FixedPhraseTable& records, const IndexPoolView& pool,
                            IndexRange reference, std::uint32_t key,
                            AssociationRecordLocation& location) {
    for (std::uint32_t position = 0; position < reference.count; ++position) {
        std::uint32_t record_id = 0;
        const std::uint8_t* data = nullptr;
        std::size_t size = 0;
        if (!pool.ReadRecordId(reference.first_index + position, record_id) ||
            !records.ReadRecord(record_id, data, size)) return false;
        if (size >= sizeof(std::uint32_t) && detail::ReadLittleEndian<std::uint32_t>(data) == key) {
            location = {position, record_id};
            return true;
        }
    }
    return false;
}

bool RemoveAssociationRecord(const FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, std::uint32_t key, IndexRange& reference) {
    auto* bytes = cells.MutableData();
    if (bytes == nullptr) return false;
    IndexPoolView view(metadata.Data(), metadata.Size(), bytes, cells.Size());
    AssociationRecordLocation location{};
    return FindAssociationRecord(records, view, reference, key, location) &&
           view.EraseRecordId(location.position, reference);
}

}  // namespace comeback::recovered
