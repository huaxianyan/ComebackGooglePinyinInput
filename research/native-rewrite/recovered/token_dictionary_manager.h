// Ordinary resolved-resource activation and DFS factory; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_DICTIONARY_MANAGER_H
#define COMEBACK_RECOVERED_TOKEN_DICTIONARY_MANAGER_H
#include "token_dictionary_resources.h"
#include "token_manager_cursor.h"
#include <map>

namespace comeback::recovered {
class TokenDictionaryManager {
public:
    // Serialized TokenDictionaryDataSetting, original data-ID lookup and active
    // pair selection. Missing IDs are skipped as at 0x1948d0. Malformed settings,
    // nonempty iterator options or unsupported resource profiles return null.
    // This fresh builder does not implement in-place setting failure/reconfigure.
    static std::shared_ptr<TokenDictionaryManager> Load(
        const std::string& setting, TokenDictionaryResources& resources);
    // Original 0x1941fc returns a Manager even when no dictionary is active.
    // Fresh cursors share the loaded models, including Direct's dynamic counter.
    std::unique_ptr<TokenDictionaryCursor> CreateDfsCursor() const;
    // Native slot 15: first active model's flag, or the fresh constructor's
    // true default when empty. Ordinary supported models are all non-reversed.
    bool UsingReversedTokens() const;
    // Original slot 8: configured-order language reduction, not a sorted-active
    // set recomputation. Empty/unset and mixed languages yield UNKNOWN_LANGUAGE.
    std::int32_t LanguageId() const { return language_id_; }
private:
    TokenDictionaryManager() = default;
    // Original signed pair key. First insertion wins; factory traversal is sorted.
    std::map<std::pair<std::int32_t, std::int32_t>, TokenDictionaryModel> active_;
    std::int32_t language_id_ = kUnknownTokenLanguage;
};
}  // namespace comeback::recovered
#endif
