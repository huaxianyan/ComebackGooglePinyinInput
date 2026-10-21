// Native user-dictionary empty configuration; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_MUTABLE_DICTIONARY_INIT_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_MUTABLE_DICTIONARY_INIT_H

#include "single_trie_mutable_dictionary_image.h"

namespace comeback::recovered {
// Empty SingleTrie storage selected by UserDictionary::Initialize (0x1a259c),
// not a generic builder, outer UserDictionary or persistent-editor replacement.
// The caller supplies the original token category; count presence stays unset.
bool InitializeSingleTrieUserStorage(std::int32_t token_category,
                                     SingleTrieMutableDictionaryStorage& output);
}  // namespace comeback::recovered
#endif
