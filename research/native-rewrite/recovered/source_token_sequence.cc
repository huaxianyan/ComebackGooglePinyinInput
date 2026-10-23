// Ordinary source conversion from 0x19550c and its real callers; see NOTICE.
#include "token_query.h"
#include "token_dictionary_manager.h"

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
}  // namespace comeback::recovered
