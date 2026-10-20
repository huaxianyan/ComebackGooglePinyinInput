// Original compaction payload decisions; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_COMPACTION_H
#define COMEBACK_RECOVERED_DICTIONARY_COMPACTION_H

#include "payload_codec.h"
#include <vector>

namespace comeback::recovered {
// Inputs are decoded native payloads, not arbitrary application counters.
// No lexical or stable-order tie-break is added when the original compares equal.
bool DictionaryCompactionPrecedes(const PayloadMetadata& left, std::uint16_t left_day,
                                  const PayloadMetadata& right, std::uint16_t right_day);
bool IsDictionaryCompactionCandidate(const PayloadMetadata& payload, std::uint16_t day,
                                     std::int32_t cutoff_day);
struct DictionaryCompactionPlan {
    std::vector<std::size_t> order;
    std::size_t keep_count = 0;
    bool changed = false;
};
// order[0..keep_count) is the retained prefix; the suffix is native deletion
// order. reported_count is the model's count, not an inferred vector length.
DictionaryCompactionPlan PlanDictionaryCompaction(const std::vector<EncodedPayload>& payloads,
                                                  std::uint64_t reported_count,
                                                  std::uint64_t limit,
                                                  std::int32_t cutoff_day);
}  // namespace comeback::recovered
#endif
