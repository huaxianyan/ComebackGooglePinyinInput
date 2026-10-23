// Real key-generator expansion collection, native 0x18d07c; see NOTICE.
#include "key_expansion.h"
#include "token_dictionary_manager.h"
#include "token_expander_cursor.h"
#include <utility>

namespace comeback::recovered {
bool CollectTokenExpansions(const TokenDictionaryManager& dictionaries,
    TokenExpanderCursor* cursor, const KeyToken& source, float caller_score,
    std::uint8_t marker, std::vector<ScoredKeyToken>& output, bool accept_single_identity) {
    if (cursor == nullptr) return false;
    cursor->Reset(source);
    while (!cursor->Exhausted()) {
        ScoredKeyToken current{};
        if (cursor->Current(current.token, &current.score)) {
            dictionaries.FillTokenText(current.token);
            current.score = current.score + caller_score;
            current.marker = marker;
            output.push_back(std::move(current));
        }
        cursor->Advance();
    }
    return CollectedExpansionResult(output, source, accept_single_identity);
}
}  // namespace comeback::recovered
