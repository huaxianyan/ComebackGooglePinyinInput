// Ordinary source conversion from 0x19550c and its real callers; see NOTICE.
#include "token_query.h"
#include "token_dictionary_manager.h"
#include "learning_key.h"
#include <utility>

namespace comeback::recovered {
bool ConvertSourceTokens(const TokenDictionaryManager& manager,
                         const std::vector<std::string>& input,
                         const std::vector<std::int32_t>& languages, std::vector<KeyToken>& output) {
    const bool reverse_text = manager.UsingReversedTokens();
    // Ordinary Manager factories return a real DFS cursor even when empty.
    // The native BFS alternative is selected only by a null primary interface.
    auto cursor = manager.CreateDfsCursor();
    cursor->Reset();
    output.resize(input.size());
    for (std::size_t i = input.size(); i != 0; --i) {
        if (!LookupTokenQuery(cursor.get(), input[i - 1], reverse_text, languages[i - 1],
                              true, &output[input.size() - i])) return false;
    }
    // Native slot 10 deletes the DFS iterator on success and on failure. RAII
    // releases the host cursor and children, not a cloned original object ABI.
    return true;
}
std::vector<GeneratedLearningKey> GenerateUnexpandedLearningKeys(
    const TokenDictionaryManager& manager, const std::vector<std::string>& input,
    const std::vector<std::int32_t>& languages) {
    std::vector<GeneratedLearningKey> result;
    // Original 0x18ccb0, before any conversion or per-model counter mutation.
    if (input.size() != languages.size()) return result;
    if (manager.LanguageId() == kUnknownTokenLanguage) {
        for (const auto language : languages) if (language == kUnknownTokenLanguage) return result;
    }
    std::vector<KeyToken> tokens;
    if (!ConvertSourceTokens(manager, input, languages, tokens)) return result;
    // Original 0x18db08 stores binary32 1, flag true, category 0. Only fields
    // actually consumed by learning_key are projected; no fake expansion mask.
    GeneratedLearningKey key{{}, 0x1p+0f, true, 0};
    key.parts.reserve(tokens.size());
    for (auto& token : tokens) key.parts.push_back(std::move(token.text));
    result.push_back(std::move(key));
    return result;
}
}  // namespace comeback::recovered
