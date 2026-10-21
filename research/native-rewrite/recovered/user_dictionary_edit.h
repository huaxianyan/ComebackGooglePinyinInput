// Native user-model removal policy/count adjustment; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_H

#include "association_editor.h"
#include "single_trie_association.h"
#include "user_dictionary_image.h"

namespace comeback::recovered {
void AdjustUserDictionaryTotalCount(i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
                                     std::int32_t old_count, std::int32_t new_count);
// Ready current model; editors must refer to this dictionary and remain exclusive.
// MutableDictionaryStorage takes forward/reverse AssociationEditor references;
// SingleTrieMutableDictionaryStorage takes one SingleTrieAssociationEditor.
// keep_marker=false removes physically; true retains a zero-count deleted marker
// with the native real day. Already-zero entries cannot be marked again. Only a
// successful backend mutation adjusts outer weight, with the native category-2 exception.
template <typename Backend, typename... Editors>
bool RemoveUserDictionaryAssociation(UserDictionaryStorage<Backend>& dictionary,
                                      std::string_view first_key, std::string_view second_key,
                                      bool keep_marker, Editors&... editors);
}  // namespace comeback::recovered
#endif
