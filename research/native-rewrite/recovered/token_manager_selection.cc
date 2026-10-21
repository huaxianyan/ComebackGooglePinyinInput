// Original token-manager predicates and unique-target key; see NOTICE.
#include "token_manager_selection.h"

namespace comeback::recovered {
namespace {
constexpr std::int32_t kAnySelector = -1;
constexpr std::int32_t kUnknownLanguage = 26;
}
bool MatchesTokenDictionary(std::int32_t dictionary_selector,
    std::int32_t dictionary_language, std::int32_t query_selector,
    std::int32_t query_language) {
    return (dictionary_selector == query_selector || query_selector == kAnySelector ||
            dictionary_selector == kAnySelector) &&
           (dictionary_language == query_language || query_language == kUnknownLanguage ||
            dictionary_language == kUnknownLanguage);
}

bool ManagerTokenAdmission::Include(const KeyToken& token) {
    if (is_source_) return true;
    return seen_.emplace((token.id >> 28) & 7u, token.text).second;
}
}  // namespace comeback::recovered
