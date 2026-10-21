// Native token-manager qualification and target admission, not lookup; NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_MANAGER_SELECTION_H
#define COMEBACK_RECOVERED_TOKEN_MANAGER_SELECTION_H
#include "key_expansion.h"
#include <set>
#include <utility>

namespace comeback::recovered {
inline constexpr std::int32_t kAnyTokenSelector = -1;
inline constexpr std::int32_t kUnknownTokenLanguage = 26;
// Native 0x194438. First attribute's business name remains unknown. Language
// and selector match symmetrically against their distinct native wildcards.
bool MatchesTokenDictionary(std::int32_t dictionary_selector,
    std::int32_t dictionary_language, std::int32_t query_selector,
    std::int32_t query_language);

// One real 0x193278 collection pass. Call only for successful child outputs;
// this neither queries nor advances children and holds no invented results.
// Source admits every result. Target admits the first class/text pair, not the
// first full token identity. No sorting or scoring. Construct anew per pass.
class ManagerTokenAdmission {
public:
    explicit ManagerTokenAdmission(bool is_source) : is_source_(is_source) {}
    bool Include(const KeyToken& token);
private:
    bool is_source_;
    std::set<std::pair<std::uint32_t, std::string>> seen_;
};
}  // namespace comeback::recovered
#endif
