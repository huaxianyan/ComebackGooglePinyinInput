// Immutable ordinary bundle bindings and successful-model cache; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_DICTIONARY_RESOURCES_H
#define COMEBACK_RECOVERED_TOKEN_DICTIONARY_RESOURCES_H
#include "owned_byte_region.h"
#include <map>
#include <memory>
#include <string>
#include <utility>
#include <variant>

namespace comeback::recovered {
class DirectTokenDictionary;
class ForwardTokenDictionaryView;
using TokenDictionaryModel = std::variant<std::shared_ptr<DirectTokenDictionary>,
                                         std::shared_ptr<ForwardTokenDictionaryView>>;
class TokenDictionaryResources {
public:
    // Original registered data IDs, not blob names. The caller supplies the
    // resolved bundle index; Android creators, locks and invalidation are absent.
    using Sources = std::map<std::string, OwnedByteRegion>;
    explicit TokenDictionaryResources(Sources sources) : sources_(std::move(sources)) {}
    struct Resolution {
        enum class Status { Missing, Ready, Unsupported };
        Status status;
        const TokenDictionaryModel* model;
    };
    // 0x198f28 caches successful models by ID, never failed creation.
    // Missing IDs can be skipped by activation; unsupported host profiles cannot.
    Resolution Resolve(const std::string& data_id);
private:
    const Sources sources_;
    std::map<std::string, TokenDictionaryModel> cache_;
};
}  // namespace comeback::recovered
#endif
