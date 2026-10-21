// Native 0x1a0cbc and 0x1a1a74 physical deletion branch; see NOTICE.
#include "user_dictionary_edit.h"
#include "payload_codec.h"

namespace comeback::recovered {
void AdjustUserDictionaryTotalCount(i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
                                     std::int32_t old_count, std::int32_t new_count) {
    // AArch64 add/sub wraps at 64 bits, then clamps a negative signed result.
    const auto value = static_cast<std::uint64_t>(metadata.total_count()) +
        static_cast<std::uint64_t>(static_cast<std::int64_t>(new_count)) -
        static_cast<std::uint64_t>(static_cast<std::int64_t>(old_count));
    metadata.set_total_count((value >> 63) != 0 ? 0 : static_cast<std::int64_t>(value));
}

bool RemoveUserDictionaryAssociation(UserDictionaryStorage<MutableDictionaryStorage>& dictionary,
                                      AssociationEditor& forward, AssociationEditor& reverse,
                                      std::string_view forward_key, std::string_view reverse_key) {
    OwnedByteRegion payload;
    PayloadMetadata old{};
    if (!ReadDictionaryAssociationPayload(forward.side, reverse.side, forward_key, reverse_key, payload) ||
        !DecodePayload(PayloadVersion::V21, payload.Data(), payload.Size(), old, nullptr) ||
        !RemoveDictionaryAssociation(forward, reverse, dictionary.dictionary.metadata,
                                      forward_key, reverse_key)) return false;
    if (old.category != 2) {
        AdjustUserDictionaryTotalCount(dictionary.metadata, static_cast<std::int32_t>(old.count), 0);
    }
    return true;
}
}  // namespace comeback::recovered
