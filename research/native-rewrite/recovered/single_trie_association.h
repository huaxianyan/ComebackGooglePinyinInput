// Native SingleTrie ordered pair lookup/existing update; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_ASSOCIATION_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_ASSOCIATION_H

#include "single_trie_mutable_dictionary_image.h"
#include "association_records.h"
#include "datrie_view.h"
#include <string_view>

namespace comeback::recovered {
// Ready current SingleTrie storage. Records hold two ordered terminal IDs from
// one trie; both endpoint lists can refer to the same record. Copies its payload.
bool ReadSingleTrieAssociationPayload(const SingleTrieMutableDictionaryStorage& dictionary,
                                       std::string_view first_key, std::string_view second_key,
                                       OwnedByteRegion& output);
// Native coordinator scratch, retained across calls. Omitted payload preserves
// the previous append buffer; this is not a runtime editor/readiness substitute.
struct SingleTrieAssociationEditor {
    // Native 0x1c9700 prepares record/pair-value scratch once; resize return
    // values are not promoted into a new constructor failure protocol.
    explicit SingleTrieAssociationEditor(SingleTrieMutableDictionaryStorage& storage);
    SingleTrieMutableDictionaryStorage& dictionary;
    // Native 0x1c9700 installs this for the editor lifetime. Bind storage, not
    // an individual operation's borrowed DATrie view; rebuild that view on use.
    DATrieNodeMove node_moved;
    OwnedByteRegion record_buffer{};
    OwnedByteRegion first_value{};
    OwnedByteRegion second_value{};
};
// Existing update and shared-record append use one coordinator. Sequential
// failures retain mutations; only the native self-key branch cleans an empty key.
// Caller keeps storage stable/exclusive and payload valid across writable access.
bool ModifySingleTrieAssociation(SingleTrieAssociationEditor& editor,
                                   std::string_view first_key, std::string_view second_key,
                                   const std::string_view* payload, AssociationEditMode mode);
// Native physical removal: erase list entries before publishing either endpoint,
// self-pairs once. Publish all endpoints before decrementing association count.
// Fixed records stay allocated; failure can retain earlier changes. No learning
// accumulator or tombstone policy is applied at this layer.
bool RemoveSingleTrieAssociation(SingleTrieAssociationEditor& editor,
                                   std::string_view first_key, std::string_view second_key);
}  // namespace comeback::recovered
#endif
