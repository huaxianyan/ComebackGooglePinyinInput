// Comparator 0x19fc94 and candidate predicate in 0x1a3758; see NOTICE.
#include "dictionary_compaction.h"
#include <algorithm>
#include <numeric>
#include <utility>

namespace comeback::recovered {
bool DictionaryCompactionPrecedes(const PayloadMetadata& left, std::uint16_t left_day,
                                  const PayloadMetadata& right, std::uint16_t right_day) {
    if (left.count == 0 && !left.flag31) return false;
    if (right.count == 0 && !right.flag31) return true;
    if (left_day != right_day) return left_day > right_day;
    if (left.flag30 != right.flag30) return left.flag30;
    return static_cast<std::int32_t>(left.count) > static_cast<std::int32_t>(right.count);
}

bool IsDictionaryCompactionCandidate(const PayloadMetadata& payload, std::uint16_t day,
                                     std::int32_t cutoff_day) {
    return (static_cast<std::int32_t>(payload.count) > 0 || payload.flag31) && day >= cutoff_day;
}
DictionaryCompactionPlan PlanDictionaryCompaction(const std::vector<EncodedPayload>& payloads,
                                                  std::uint64_t reported_count,
                                                  std::uint64_t limit,
                                                  std::int32_t cutoff_day) {
    struct Decoded {
        PayloadMetadata metadata{};
        std::uint16_t day = 0;
    };
    std::vector<Decoded> decoded(payloads.size());
    std::uint64_t eligible = 0;
    for (std::size_t i = 0; i < payloads.size(); ++i) {
        DecodePayload(PayloadVersion::V21, payloads[i].data(), payloads[i].size(),
                      decoded[i].metadata, &decoded[i].day);
        if (IsDictionaryCompactionCandidate(decoded[i].metadata, decoded[i].day, cutoff_day)) ++eligible;
    }
    // Native UCVTF -> FMUL .9f -> FCVTZU; not Java's earlier .9d target.
    const auto bound = std::min(reported_count,
        static_cast<std::uint64_t>(static_cast<float>(limit) * 0.9f));
    DictionaryCompactionPlan plan;
    plan.order.resize(payloads.size());
    std::iota(plan.order.begin(), plan.order.end(), std::size_t{0});
    plan.changed = bound != reported_count || eligible != reported_count;
    plan.keep_count = plan.changed ? static_cast<std::size_t>(std::min(bound, eligible)) : payloads.size();
    if (!plan.changed) return plan;
    const auto before = [&](std::size_t left, std::size_t right) {
        return DictionaryCompactionPrecedes(decoded[left].metadata, decoded[left].day,
                                            decoded[right].metadata, decoded[right].day);
    };
    // Preserve the original heap's tie selection (right child unless it
    // precedes the left), rather than relying on a host STL's partial_sort.
    const auto sift = [&](std::size_t length) {
        if (length < 2) return;
        const auto value = plan.order[0];
        std::size_t hole = 0;
        for (std::size_t child = 1; child < length; child = hole * 2 + 1) {
            if (child + 1 < length && !before(plan.order[child + 1], plan.order[child])) ++child;
            if (!before(value, plan.order[child])) break;
            plan.order[hole] = plan.order[child];
            hole = child;
        }
        plan.order[hole] = value;
    };
    const auto keep = plan.keep_count;
    for (std::size_t i = 1; i < keep; ++i) {
        const auto value = plan.order[i];
        std::size_t hole = i;
        while (hole != 0) {
            const auto parent = (hole - 1) / 2;
            if (!before(plan.order[parent], value)) break;
            plan.order[hole] = plan.order[parent];
            hole = parent;
        }
        plan.order[hole] = value;
    }
    for (std::size_t i = keep; i < plan.order.size(); ++i) {
        if (before(plan.order[i], plan.order[0])) {
            std::swap(plan.order[i], plan.order[0]);
            sift(keep);
        }
    }
    for (std::size_t length = keep; length > 1;) {
        std::swap(plan.order[0], plan.order[--length]);
        sift(length);
    }
    return plan;
}
}  // namespace comeback::recovered
