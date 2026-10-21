// Native 0x1a0cbc / 0x1a1a74 physical and kept-marker removal; see NOTICE.
#include "user_dictionary_edit.h"
#include "user_dictionary_edit_internal.h"

namespace comeback::recovered {
void AdjustUserDictionaryTotalCount(i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
                                     std::int32_t old_count, std::int32_t new_count) {
    // AArch64 add/sub wraps at 64 bits, then clamps a negative signed result.
    const auto value = static_cast<std::uint64_t>(metadata.total_count()) +
        static_cast<std::uint64_t>(static_cast<std::int64_t>(new_count)) -
        static_cast<std::uint64_t>(static_cast<std::int64_t>(old_count));
    metadata.set_total_count((value >> 63) != 0 ? 0 : static_cast<std::int64_t>(value));
}

template <typename Backend, typename... Editors>
bool RemoveUserDictionaryAssociation(UserDictionaryStorage<Backend>& dictionary,
                                      std::string_view first_key, std::string_view second_key,
                                      bool keep_marker, Editors&... editors) {
    PayloadMetadata old{};
    if (!detail::ReadUserAssociationPayload(dictionary, first_key, second_key, false, old, editors...) ||
        (keep_marker && old.count == 0)) return false;
    if (keep_marker) {
        return detail::PublishUserAssociationPayload(dictionary, first_key, second_key, old,
            {0, true, old.flag30, old.flag27, old.category}, AssociationEditMode::ExistingOnly, editors...);
    }
    auto bound = std::tie(editors...);
    bool changed;
    if constexpr (detail::kUsesSeparateAssociationSides<Backend>) {
        changed = RemoveDictionaryAssociation(std::get<0>(bound), std::get<1>(bound), dictionary.dictionary.metadata,
                                               first_key, second_key);
    } else {
        changed = RemoveSingleTrieAssociation(std::get<0>(bound), first_key, second_key);
    }
    if (changed) detail::AccountUserDictionaryEdit(dictionary.metadata, old, 0, old.category);
    return changed;
}

template bool RemoveUserDictionaryAssociation(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::string_view, std::string_view, bool, AssociationEditor&, AssociationEditor&);
template bool RemoveUserDictionaryAssociation(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::string_view, std::string_view, bool, SingleTrieAssociationEditor&);
}  // namespace comeback::recovered
