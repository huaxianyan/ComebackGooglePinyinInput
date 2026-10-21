// Native 0x1a0cbc / 0x1a1a74 physical and kept-marker removal; see NOTICE.
#include "user_dictionary_edit.h"
#include "dictionary_day.h"
#include "payload_codec.h"
#include <tuple>
#include <type_traits>

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
    constexpr bool dual = std::is_same_v<Backend, MutableDictionaryStorage>;
    auto bound = std::tie(editors...);
    OwnedByteRegion payload;
    bool found;
    if constexpr (dual) {
        found = ReadDictionaryAssociationPayload(std::get<0>(bound).side, std::get<1>(bound).side,
                                                   first_key, second_key, payload);
    } else {
        found = ReadSingleTrieAssociationPayload(std::get<0>(bound).dictionary, first_key, second_key, payload);
    }
    PayloadMetadata old{};
    if (!found || !DecodePayload(PayloadVersion::V21, payload.Data(), payload.Size(), old, nullptr) ||
        (keep_marker && old.count == 0)) return false;
    EncodedPayload marker{};
    std::string_view replacement;
    if (keep_marker) {
        marker = EncodePayload(PayloadVersion::V21, {0, true, old.flag30, old.flag27, old.category},
                                 static_cast<std::uint16_t>(CurrentDictionaryDay()));
        replacement = {reinterpret_cast<const char*>(marker.data()), marker.size()};
    }
    bool changed;
    if constexpr (dual) {
        changed = keep_marker
            ? ModifyDictionaryAssociation(std::get<0>(bound), std::get<1>(bound), dictionary.dictionary.metadata,
                first_key, second_key, &replacement, nullptr, AssociationEditMode::ExistingOnly)
            : RemoveDictionaryAssociation(std::get<0>(bound), std::get<1>(bound), dictionary.dictionary.metadata,
                                            first_key, second_key);
    } else {
        changed = keep_marker
            ? ModifySingleTrieAssociation(std::get<0>(bound), first_key, second_key, &replacement,
                                            AssociationEditMode::ExistingOnly)
            : RemoveSingleTrieAssociation(std::get<0>(bound), first_key, second_key);
    }
    if (!changed) return false;
    if (old.category != 2) {
        AdjustUserDictionaryTotalCount(dictionary.metadata, static_cast<std::int32_t>(old.count), 0);
    }
    return true;
}

template bool RemoveUserDictionaryAssociation(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::string_view, std::string_view, bool, AssociationEditor&, AssociationEditor&);
template bool RemoveUserDictionaryAssociation(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::string_view, std::string_view, bool, SingleTrieAssociationEditor&);
}  // namespace comeback::recovered
