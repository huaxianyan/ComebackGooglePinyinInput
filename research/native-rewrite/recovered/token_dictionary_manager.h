// Ordinary resolved-resource activation and DFS factory; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_DICTIONARY_MANAGER_H
#define COMEBACK_RECOVERED_TOKEN_DICTIONARY_MANAGER_H
#include "owned_byte_region.h"
#include "token_manager_cursor.h"
#include <map>
#include <variant>

namespace comeback::recovered {
class DirectTokenDictionary;
class ForwardTokenDictionaryView;

class TokenDictionaryManager {
public:
    // Complete class-enveloped images in setting-list order, already resolved
    // by the caller. Ordinary non-reversed Direct/Forward only. Unsupported or
    // invalid images return null, not a partially ready or empty replacement.
    // Resource-ID accessors, settings wire parsing and reconfiguration are absent.
    static std::shared_ptr<TokenDictionaryManager> LoadActive(
        const std::vector<OwnedByteRegion>& resolved_resources);
    // Original 0x1941fc returns a Manager even when no dictionary is active.
    // Fresh cursors share the loaded models, including Direct's dynamic counter.
    std::unique_ptr<TokenDictionaryCursor> CreateDfsCursor() const;
private:
    using Model = std::variant<std::shared_ptr<DirectTokenDictionary>,
                               std::shared_ptr<ForwardTokenDictionaryView>>;
    TokenDictionaryManager() = default;
    // Original signed pair key. First insertion wins; factory traversal is sorted.
    std::map<std::pair<std::int32_t, std::int32_t>, Model> active_;
};
}  // namespace comeback::recovered
#endif
