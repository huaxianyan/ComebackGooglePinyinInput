// Native SingleTrie ordered pair lookup/existing update; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_ASSOCIATION_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_ASSOCIATION_H

#include "single_trie_mutable_dictionary_image.h"
#include <string_view>

namespace comeback::recovered {
// Ready current SingleTrie storage. Records hold two ordered terminal IDs from
// one trie; both endpoint lists can refer to the same record. Copies its payload.
bool ReadSingleTrieAssociationPayload(const SingleTrieMutableDictionaryStorage& dictionary,
                                       std::string_view first_key, std::string_view second_key,
                                       OwnedByteRegion& output);
// Native existing-pair branch: exact declared payload width, first matching
// ordered record only. Does not create keys, append, alter count or learn weight.
// Input payload must remain valid/nonoverlapping across writable table access.
bool UpdateSingleTrieAssociationPayload(SingleTrieMutableDictionaryStorage& dictionary,
                                         std::string_view first_key, std::string_view second_key,
                                         std::string_view payload);
}  // namespace comeback::recovered
#endif
