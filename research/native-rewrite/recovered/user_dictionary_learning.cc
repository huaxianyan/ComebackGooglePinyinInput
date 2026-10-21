// Native user-model existing/ensure/add-count control flow; Google-derived, see NOTICE.
#include "user_dictionary_learning.h"
#include "user_dictionary_edit_internal.h"
#include <algorithm>
#include <limits>

namespace comeback::recovered {
template <typename Backend, typename... Editors>
bool UpdateExistingUserDictionaryCount(UserDictionaryStorage<Backend>& dictionary,
    std::string_view first_key, std::string_view second_key, std::int32_t count,
    bool accumulate, bool flag27, std::int32_t category, Editors&... editors) {
    PayloadMetadata old{};
    if (!detail::ReadUserAssociationPayload(dictionary, first_key, second_key, true, old, editors...)) return false;
    const auto old_category = static_cast<std::int32_t>(old.category);
    if (old_category < category && !(category == 1 && old_category == 0)) return true;
    auto next_count = static_cast<std::uint32_t>(count);
    if (accumulate && (category == 2 || old_category != 2)) next_count += old.count;
    // Native 32-bit ADD wraps before the signed-negative clamp.
    if (next_count > static_cast<std::uint32_t>(std::numeric_limits<std::int32_t>::max())) next_count = 0;
    if (category == 2) next_count = next_count != 0 ? 1 : 0;
    const auto next_category = std::min(category, old_category);
    if (next_count == old.count && next_category == old_category) return true;
    return detail::PublishUserAssociationPayload(dictionary, first_key, second_key, old,
        {next_count, true, old.flag30, flag27, static_cast<std::uint32_t>(next_category)},
        AssociationEditMode::ExistingOnly, editors...);
}

template <typename Backend, typename... Editors>
bool EnsureUserDictionaryCount(UserDictionaryStorage<Backend>& dictionary,
    std::string_view first_key, std::string_view second_key, std::int32_t count,
    bool flag31, bool flag30, bool flag27, std::int32_t category,
    std::uint8_t edit_flags, Editors&... editors) {
    if (edit_flags == 0 || count < 0 || (flag31 && count == 0)) return false;
    PayloadMetadata old{0, false, false, false, 2};
    const bool found = detail::ReadUserAssociationPayload(dictionary, first_key, second_key, false, old, editors...);
    const auto old_category = static_cast<std::int32_t>(old.category);
    if (found && old_category < category) return true;
    if (count == 0) return RemoveUserDictionaryAssociation(dictionary, first_key, second_key, false, editors...);
    if (old_category == category && old.count >= static_cast<std::uint32_t>(count)) return true;
    return detail::PublishUserAssociationPayload(dictionary, first_key, second_key, old,
        {category == 2 ? 1u : static_cast<std::uint32_t>(count), flag31, flag30, flag27,
         static_cast<std::uint32_t>(category)}, AssociationEditMode::CreateOrUpdate, editors...);
}

template <typename Backend, typename... Editors>
bool AddUserDictionaryCount(UserDictionaryStorage<Backend>& dictionary,
    std::string_view first_key, std::string_view second_key, std::int32_t count,
    bool flag30, bool flag27, std::int32_t category, std::uint8_t edit_flags, Editors&... editors) {
    if (count <= 0 || (edit_flags & 1) == 0) return false;
    if (UpdateExistingUserDictionaryCount(dictionary, first_key, second_key, count, true, flag27, category, editors...)) {
        return true;
    }
    return EnsureUserDictionaryCount(dictionary, first_key, second_key, count, true,
                                     flag30, flag27, category, edit_flags, editors...);
}

template bool UpdateExistingUserDictionaryCount(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, std::int32_t, AssociationEditor&, AssociationEditor&);
template bool UpdateExistingUserDictionaryCount(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, std::int32_t, SingleTrieAssociationEditor&);
template bool EnsureUserDictionaryCount(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, bool, std::int32_t, std::uint8_t,
    AssociationEditor&, AssociationEditor&);
template bool EnsureUserDictionaryCount(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, bool, std::int32_t, std::uint8_t,
    SingleTrieAssociationEditor&);
template bool AddUserDictionaryCount(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, std::int32_t, std::uint8_t,
    AssociationEditor&, AssociationEditor&);
template bool AddUserDictionaryCount(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::string_view, std::string_view, std::int32_t, bool, bool, std::int32_t, std::uint8_t,
    SingleTrieAssociationEditor&);
}  // namespace comeback::recovered
