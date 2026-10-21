// Recovered 0x1a3758 composition, without a substitute backend; see NOTICE.
#include "user_dictionary_compaction.h"
#include "dictionary_association_iteration.h"
#include "dictionary_compaction.h"
#include "dictionary_day.h"
#include <cstring>

namespace comeback::recovered {
std::int32_t DictionaryCompactionCutoff(std::int64_t day) {
    const auto bits = static_cast<std::uint32_t>(day) - std::uint32_t{62};
    std::int32_t cutoff;
    std::memcpy(&cutoff, &bits, sizeof(cutoff));
    return cutoff;
}

template <typename Backend, typename... Editors>
bool CompactUserDictionary(UserDictionaryStorage<Backend>& dictionary,
                            std::uint64_t limit, Editors&... editors) {
    return CompactUserDictionaryAtCutoff(dictionary, limit,
                                         DictionaryCompactionCutoff(CurrentDictionaryDay()), editors...);
}

template <typename Backend, typename... Editors>
bool CompactUserDictionaryAtCutoff(UserDictionaryStorage<Backend>& dictionary,
                                    std::uint64_t limit, std::int32_t cutoff_day, Editors&... editors) {
    std::vector<DictionaryAssociationEntry> entries;
    if (!SnapshotDictionaryAssociations(dictionary.dictionary, entries)) return false;
    std::vector<EncodedPayload> payloads;
    payloads.reserve(entries.size());
    for (const auto& entry : entries) payloads.push_back(entry.payload);
    const auto reported = static_cast<std::uint64_t>(static_cast<std::int64_t>(
        dictionary.dictionary.metadata.association_count()));
    const auto plan = PlanDictionaryCompaction(payloads, reported, limit, cutoff_day);
    if (plan.changed) {
        for (auto position = plan.keep_count; position < plan.order.size(); ++position) {
            const auto& entry = entries[plan.order[position]];
            // Native ignores each return value and continues the deletion suffix;
            // this is not a transaction or a promise that every deletion succeeded.
            RemoveUserDictionaryAssociation(dictionary, entry.forward_key, entry.reverse_key,
                                             false, editors...);
        }
    }
    return true;
}
template bool CompactUserDictionary(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::uint64_t, AssociationEditor&, AssociationEditor&);
template bool CompactUserDictionary(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::uint64_t, SingleTrieAssociationEditor&);
template bool CompactUserDictionaryAtCutoff(UserDictionaryStorage<MutableDictionaryStorage>&,
    std::uint64_t, std::int32_t, AssociationEditor&, AssociationEditor&);
template bool CompactUserDictionaryAtCutoff(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
    std::uint64_t, std::int32_t, SingleTrieAssociationEditor&);
}  // namespace comeback::recovered
