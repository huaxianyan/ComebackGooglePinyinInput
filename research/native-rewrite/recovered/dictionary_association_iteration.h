// Current fixed-store association traversal; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_ASSOCIATION_ITERATION_H
#define COMEBACK_RECOVERED_DICTIONARY_ASSOCIATION_ITERATION_H

#include "mutable_dictionary_image.h"
#include "single_trie_mutable_dictionary_image.h"
#include "payload_codec.h"
#include <string>
#include <vector>

namespace comeback::recovered {
struct DictionaryAssociationEntry {
    std::string forward_key;
    std::string reverse_key;
    EncodedPayload payload{};
};
// Ready current-format storage only. Snapshot native forward-key/pool order;
// unreadable entries follow the original cursor/read failure path, not sorting.
// SingleTrie emits only a record whose first node ID matches the current key;
// the second endpoint's shared-list reference is not another emitted entry.
// No edits, ownership detaches, metadata repair or synthetic readiness state.
template <typename Backend>
bool SnapshotDictionaryAssociations(const Backend& dictionary,
                                     std::vector<DictionaryAssociationEntry>& output);
}  // namespace comeback::recovered
#endif
