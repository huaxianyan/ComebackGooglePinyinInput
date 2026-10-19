// Native NodeIdUpdator's reverse-reference repair; Google-derived: see NOTICE.
#include "association_records.h"
#include "fixed_phrase_table.h"
#include "trie_values.h"
#include "little_endian.h"

namespace comeback::recovered {

void UpdateMovedNodeId(const AssociationSide& moved, const AssociationSide& opposite,
                       std::uint32_t old_id, std::uint32_t new_id) {
    OwnedByteRegion value;
    IndexRange forward{};
    if (!ReadTrieValueByNodeId(moved.trie, moved.values, new_id, value) ||
        !DecodeAssociationReference(value.Data(), value.Size(), forward)) return;
    // The existing pool view takes a writable pointer, but these const views
    // only read IDs. Do not detach shared cell storage just to perform lookup.
    const IndexPoolView forward_pool(moved.metadata.Data(), moved.metadata.Size(),
                                     const_cast<std::uint8_t*>(moved.cells.Data()), moved.cells.Size());
    for (std::uint32_t position = 0; position < forward.count; ++position) {
        std::uint32_t record_id = 0;
        const std::uint8_t* data = nullptr;
        std::size_t size = 0;
        if (!forward_pool.ReadRecordId(forward.first_index + position, record_id) ||
            !moved.records.ReadRecord(record_id, data, size) || size < sizeof(std::uint32_t)) return;
        const auto other_id = detail::ReadLittleEndian<std::uint32_t>(data);
        IndexRange reverse{};
        if (!ReadTrieValueByNodeId(opposite.trie, opposite.values, other_id, value) ||
            !DecodeAssociationReference(value.Data(), value.Size(), reverse)) return;
        const IndexPoolView reverse_pool(opposite.metadata.Data(), opposite.metadata.Size(),
                                         const_cast<std::uint8_t*>(opposite.cells.Data()),
                                         opposite.cells.Size());
        AssociationRecordLocation location{};
        if (!FindAssociationRecord(opposite.records, reverse_pool, reverse, old_id, location)) return;
        std::uint8_t* writable = nullptr;
        if (!opposite.records.MutableRecord(location.record_id, writable, size) ||
            !PatchAssociationRecord(AssociationRecordLayout::TargetKey, writable, size,
                                    &new_id, nullptr, nullptr)) return;
    }
}

}  // namespace comeback::recovered
