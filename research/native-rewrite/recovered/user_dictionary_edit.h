// Model-level physical deletion/count adjustment; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_H

#include "association_editor.h"
#include "user_dictionary_image.h"

namespace comeback::recovered {
void AdjustUserDictionaryTotalCount(i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
                                     std::int32_t old_count, std::int32_t new_count);
// Ready current model; both editors must refer to this dictionary. This is the
// original physical-delete branch, not the separately unimplemented tombstone path.
bool RemoveUserDictionaryAssociation(UserDictionaryStorage<MutableDictionaryStorage>& dictionary,
                                      AssociationEditor& forward, AssociationEditor& reverse,
                                      std::string_view forward_key, std::string_view reverse_key);
}  // namespace comeback::recovered
#endif
