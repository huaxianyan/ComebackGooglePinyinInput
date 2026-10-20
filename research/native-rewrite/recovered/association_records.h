// Recovered association wire operations; Google-derived logic remains under NOTICE.
#ifndef COMEBACK_RECOVERED_ASSOCIATION_RECORDS_H
#define COMEBACK_RECOVERED_ASSOCIATION_RECORDS_H

#include "index_pool.h"

#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace comeback::recovered {

using EncodedAssociationReference = std::array<std::uint8_t, sizeof(std::uint32_t)>;

// Native packing keeps 23 index bits and nine count bits, without saturation.
EncodedAssociationReference EncodeAssociationReference(IndexRange reference);
bool DecodeAssociationReference(const std::uint8_t* bytes, std::size_t size,
                                IndexRange& reference);

// Native value patch: optional reference at 0, optional checksum at 4 when
// enabled, and optional trailing data at 4 or 6. Preserve omitted fields/suffix.
// Caller supplies valid, nonoverlapping bytes. Sequential writes retain earlier
// changes on a later capacity failure.
bool PatchAssociationValue(std::uint8_t* bytes, std::size_t size, bool has_checksum,
                            const IndexRange* reference, const std::string_view* data,
                            const std::uint16_t* checksum = nullptr);

enum class AssociationRecordLayout { TargetKey, KeyPair };

// TargetKey uses first_key only; KeyPair uses both key fields. Null field
// pointers preserve existing bytes, including a null payload pointer. A supplied
// empty payload writes zero bytes. Storage is neither resized nor cleared.
// Writes are sequential: a later failure retains earlier completed writes.
bool PatchAssociationRecord(AssociationRecordLayout layout, std::uint8_t* bytes,
                            std::size_t size, const std::uint32_t* first_key,
                            const std::uint32_t* second_key, const std::string_view* payload);

class FixedPhraseTable;

struct AssociationRecordLocation {
    std::uint32_t position;
    std::uint32_t record_id;
};
// Native 0x1c3ac8: resolve a pool index, publish the optional record ID, then
// read its borrowed fixed-table view. A later table failure retains that ID.
bool ReadAssociationRecordAt(const FixedPhraseTable& records, const IndexPoolView& pool,
                              std::uint32_t index, const std::uint8_t*& data,
                              std::size_t& size, std::uint32_t* record_id = nullptr);
// Shared first-match lookup used by deletion and node-ID repair.
bool FindAssociationRecord(const FixedPhraseTable& records, const IndexPoolView& pool,
                            IndexRange reference, std::uint32_t key,
                            AssociationRecordLocation& location);

struct AssociationSide;
// Native 0x1c4d08: resolve both keys and copy the first matching record's
// payload through the actual forward trie/pool/table, without writable access.
bool ReadDictionaryAssociationPayload(const AssociationSide& forward, const AssociationSide& reverse,
                                       std::string_view forward_key, std::string_view reverse_key,
                                       OwnedByteRegion& output);

// Native association append stores the record before linking its ID into the
// list. A link failure leaves that record appended; there is no rollback.
bool AppendAssociationRecord(FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, const std::uint8_t* data,
                              std::size_t size, IndexRange& reference);
// TargetKey layout only: remove the first matching association, leaving its
// fixed-table record intact. This does not edit either enclosing trie.
bool RemoveAssociationRecord(const FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, std::uint32_t key, IndexRange& reference);

class DATrieView;
// Concrete directional storage view, matching the reader/pool/record dependencies
// of native NodeIdUpdator. This owns no storage or synthetic readiness state.
struct AssociationSide {
    DATrieView& trie;
    FixedPhraseTable& values;
    OwnedByteRegion& metadata;
    OwnedByteRegion& cells;
    FixedPhraseTable& records;
};
// Native first-match record update. With both optional pointers null, establish
// existence without requesting writable record access. Shared by editing and
// node-ID repair; missing matches and partial writes follow the existing lookup.
bool UpdateAssociationRecord(const AssociationSide& side, IndexRange reference,
                               std::uint32_t target, const std::uint32_t* new_target,
                               const std::string_view* payload);

// Native void notification: stop at the first failed lookup/update, retaining
// earlier repaired reverse records. Does not move DATrie nodes itself.
void UpdateMovedNodeId(const AssociationSide& moved, const AssociationSide& opposite,
                       std::uint32_t old_id, std::uint32_t new_id);

}  // namespace comeback::recovered
#endif
