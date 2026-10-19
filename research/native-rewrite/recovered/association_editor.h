// Concrete dual-trie editing dependencies; Google-derived behavior: see NOTICE.
#ifndef COMEBACK_RECOVERED_ASSOCIATION_EDITOR_H
#define COMEBACK_RECOVERED_ASSOCIATION_EDITOR_H

#include "association_records.h"
#include "owned_byte_region.h"

namespace comeback::recovered {

// Extend the shared directional dependencies with the owning trie regions.
// The side's borrowed trie must refer to these ready regions on entry.
struct AssociationEditor {
    AssociationSide& side;
    OwnedByteRegion& trie_metadata;
    OwnedByteRegion& trie_nodes;
    bool has_checksum;
    // Native coordinator-owned directional scratch, normalized here without
    // cloning its layout. Retain across calls: omitted payload fields preserve
    // previous scratch bytes, whereas a newly created key clears its value.
    OwnedByteRegion record_buffer{};
    OwnedByteRegion value_buffer{};
};

// Typed runtime state corresponding to native object +0x34 and +0x20; not a
// serialized header or a replacement for the enclosing dictionary container.
struct DictionaryEditState {
    std::uint32_t association_count;
    std::uint32_t flags;
};

// Native 0x1c52ac: remove both list entries before publishing either trie value.
// Sequential failures retain prior mutations. After first-side publication,
// second-side publication failure still decrements count and marks bit 0x10.
// No record erasure, persistence, readiness state or transaction is introduced.
bool RemoveDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  DictionaryEditState& state, std::string_view forward_key,
                                  std::string_view reverse_key);

enum class AssociationEditMode { CreateOrUpdate = 1, ExistingOnly = 2 };

// Native 0x1c5660: both modes first update an existing pair. Mode 1 also creates
// missing keys and appends both sides, with the native 511-entry bound. Cleanup
// removes empty endpoints only after the append path fails; earlier failures
// and completed record/list mutations are not rolled back. Scratch persists.
bool ModifyDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  DictionaryEditState& state,
                                  std::string_view forward_key, std::string_view reverse_key,
                                  const std::string_view* payload,
                                  const std::string_view* reverse_data, AssociationEditMode mode);

}  // namespace comeback::recovered
#endif
