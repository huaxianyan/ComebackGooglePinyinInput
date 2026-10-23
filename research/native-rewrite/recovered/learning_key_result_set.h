// Combination-generator result admission, not candidate generation; see NOTICE.
#ifndef COMEBACK_RECOVERED_LEARNING_KEY_RESULT_SET_H
#define COMEBACK_RECOVERED_LEARNING_KEY_RESULT_SET_H
#include "learning_key.h"
#include <map>

namespace comeback::recovered {
struct ScoredKeyToken;
class LearningKeyResultSet {
public:
    // Native 0x18fc10 / 0x18fad8. Actual selected records, nonnull pointers and
    // nonzero IDs; finite path score supplied by the caller, not recomputed here.
    // Snapshot strings, convert score with the shared native exponential, AND
    // nonzero markers into the consumed flag, category zero at admission.
    // Same ID sequence keeps the FIRST record, regardless of score/text/flags.
    // No original token ABI, unused bit vector, stream or fallback backend.
    void Admit(float path_score, const std::vector<const ScoredKeyToken*>& selection);
    // Native 0x18f7b4 consumed projection: replace, not append. Length first,
    // then full unsigned IDs. Stored strings are owned independently of choices.
    void CopyTo(std::vector<GeneratedLearningKey>& output) const;
private:
    struct TokenIdsLess {
        bool operator()(const std::vector<std::uint32_t>& left,
                        const std::vector<std::uint32_t>& right) const;
    };
    std::map<std::vector<std::uint32_t>, GeneratedLearningKey, TokenIdsLess> keys_;
};
}  // namespace comeback::recovered
#endif
