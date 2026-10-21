// Native token identity, collection result and expansion normalization; NOTICE.
#include "key_expansion.h"
#include "score_math.h"
#include <utility>

namespace comeback::recovered {
bool SameKeyTokenIdentity(const KeyToken& left, const KeyToken& right) {
    return left.id == right.id && left.auxiliary == right.auxiliary &&
           left.identity_bit == right.identity_bit;
}

bool CollectedExpansionResult(const std::vector<ScoredKeyToken>& results,
    const KeyToken& source, bool accept_single_identity) {
    if (results.empty()) return false;
    return accept_single_identity || results.size() != 1 ||
           !SameKeyTokenIdentity(results.front().token, source);
}

void NormalizeAndPruneExpansions(std::vector<ScoredKeyToken>& results) {
    if (results.empty()) return;
    float total = results.front().score;
    for (std::size_t i = 1; i < results.size(); ++i) total = AddLogScores(total, results[i].score);
    constexpr float cutoff = -0x1.266666p+1f;  // Native word 0xc0133333.
    std::size_t retained = 0;
    for (std::size_t i = 0; i < results.size(); ++i) {
        results[i].score = results[i].score - total;
        if (results[i].score >= cutoff) {
            if (retained != i) std::swap(results[retained], results[i]);
            ++retained;
        }
    }
    results.erase(results.begin() + retained, results.end());
}
}  // namespace comeback::recovered
