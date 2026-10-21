// Shared native lookup, payload publication and accounting; see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_INTERNAL_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_EDIT_INTERNAL_H

#include "user_dictionary_edit.h"
#include "dictionary_day.h"
#include "payload_codec.h"
#include <tuple>
#include <type_traits>

namespace comeback::recovered::detail {
template <typename Backend>
inline constexpr bool kUsesSeparateAssociationSides = std::is_same_v<Backend, MutableDictionaryStorage>;

// Native 0x1a14b8 composes actual lookup and codec decoding. Existing-count
// updates request the six-byte form; the discarded old day is not retained.
template <typename Backend, typename... Editors>
bool ReadUserAssociationPayload(UserDictionaryStorage<Backend>& dictionary,
                                std::string_view first_key, std::string_view second_key,
                                bool full_payload, PayloadMetadata& metadata, Editors&... editors) {
    OwnedByteRegion payload;
    bool found;
    if constexpr (kUsesSeparateAssociationSides<Backend>) {
        auto bound = std::tie(editors...);
        found = ReadDictionaryAssociationPayload(std::get<0>(bound).side, std::get<1>(bound).side,
                                                   first_key, second_key, payload);
    } else {
        found = ReadSingleTrieAssociationPayload(dictionary.dictionary, first_key, second_key, payload);
    }
    return found && (!full_payload || payload.Size() >= kPayloadSize) &&
        DecodePayload(PayloadVersion::V21, payload.Data(), payload.Size(), metadata, nullptr);
}

inline void AccountUserDictionaryEdit(i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
                                      const PayloadMetadata& before, std::uint32_t count, std::uint32_t category) {
    if (category != 2) {
        AdjustUserDictionaryTotalCount(metadata, before.category == 2 ? 0 : static_cast<std::int32_t>(before.count),
                                       static_cast<std::int32_t>(count));
    }
}

// Shared native tail: real day -> V21 bytes -> actual backend -> outer count.
// Accounting deliberately uses the pre-codec count, not its saturated encoding.
template <typename Backend, typename... Editors>
bool PublishUserAssociationPayload(UserDictionaryStorage<Backend>& dictionary,
                                    std::string_view first_key, std::string_view second_key,
                                    const PayloadMetadata& before, const PayloadMetadata& after,
                                    AssociationEditMode mode, Editors&... editors) {
    const auto encoded = EncodePayload(PayloadVersion::V21, after,
                                        static_cast<std::uint16_t>(CurrentDictionaryDay()));
    const std::string_view replacement(reinterpret_cast<const char*>(encoded.data()), encoded.size());
    auto bound = std::tie(editors...);
    bool changed;
    if constexpr (kUsesSeparateAssociationSides<Backend>) {
        // Native Ensure slot 0 passes an explicit empty suffix, not an omitted
        // pointer; preserve its writable-value/failure path even for zero bytes.
        const std::string_view empty_reverse_data;
        changed = ModifyDictionaryAssociation(std::get<0>(bound), std::get<1>(bound), dictionary.dictionary.metadata,
            first_key, second_key, &replacement,
            mode == AssociationEditMode::CreateOrUpdate ? &empty_reverse_data : nullptr, mode);
    } else {
        changed = ModifySingleTrieAssociation(std::get<0>(bound), first_key, second_key, &replacement, mode);
    }
    if (changed) AccountUserDictionaryEdit(dictionary.metadata, before, after.count, after.category);
    return changed;
}
}  // namespace comeback::recovered::detail
#endif
