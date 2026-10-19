// Google-derived list/storage coordination; see NOTICE and association-records.md.
#include "association_records.h"
#include "fixed_phrase_table.h"

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

}  // namespace comeback::recovered
