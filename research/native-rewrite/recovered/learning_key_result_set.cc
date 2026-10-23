// Native selected-key admission and ordered result projection; see NOTICE.
#include "learning_key_result_set.h"
#include "key_expansion.h"
#include "score_math.h"
#include <algorithm>
#include <utility>

namespace comeback::recovered {
bool LearningKeyResultSet::TokenIdsLess::operator()(
    const std::vector<std::uint32_t>& left, const std::vector<std::uint32_t>& right) const {
    if (left.size() != right.size()) return left.size() < right.size();
    return std::lexicographical_compare(left.begin(), left.end(), right.begin(), right.end());
}

void LearningKeyResultSet::Admit(float path_score,
    const std::vector<const ScoredKeyToken*>& selection) {
    std::vector<std::uint32_t> ids;
    ids.reserve(selection.size());
    GeneratedLearningKey key{{}, ExpLogScore(path_score), true, 0};
    key.parts.reserve(selection.size());
    for (const auto* choice : selection) {
        ids.push_back(choice->token.id);
        key.parts.push_back(choice->token.text);
        key.flag30 = key.flag30 && choice->marker != 0;
    }
    keys_.try_emplace(std::move(ids), std::move(key));
}

void LearningKeyResultSet::CopyTo(std::vector<GeneratedLearningKey>& output) const {
    output.clear();
    output.reserve(keys_.size());
    for (const auto& entry : keys_) output.push_back(entry.second);
}
}  // namespace comeback::recovered
