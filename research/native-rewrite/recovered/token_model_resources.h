// Immutable bundle bindings and one successful dictionary/expander cache; NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_MODEL_RESOURCES_H
#define COMEBACK_RECOVERED_TOKEN_MODEL_RESOURCES_H
#include "owned_byte_region.h"
#include <map>
#include <memory>
#include <string>
#include <utility>
#include <variant>
#include <vector>

namespace comeback::recovered {
class DirectTokenDictionary;
class ForwardTokenDictionaryView;
class DirectMappingTokenExpander;
using TokenDictionaryModel = std::variant<std::shared_ptr<DirectTokenDictionary>,
                                         std::shared_ptr<ForwardTokenDictionaryView>>;
using TokenResourceModel = std::variant<TokenDictionaryModel,
                                       std::shared_ptr<DirectMappingTokenExpander>>;
class TokenModelResources {
public:
    using Blobs = std::map<std::string, OwnedByteRegion>;
    using Bundles = std::map<std::string, Blobs>;
    // Original serialized DataSchemes select library/blob snapshots, not a
    // caller-made data-ID map. Successful initial memory registration only.
    // Unsupported fields, missing blobs or invalid schemes return null; native
    // partial publication, dlopen lifetime, update and invalidation are absent.
    static std::shared_ptr<TokenModelResources> Load(
        const std::vector<std::string>& schemes, const Bundles& bundles);
    struct Resolution {
        enum class Status { Missing, Ready, Unsupported };
        Status status;
        const TokenResourceModel* model;
    };
    // 0x198f28 caches successful models by ID, never failed creation. The class
    // loader is shared by native types 4/5; only real supported classes load here.
    // Consumers select their model family, not a second index or cache.
    Resolution Resolve(const std::string& data_id);
private:
    struct Source { std::int32_t data_type; OwnedByteRegion image; };
    using Sources = std::map<std::string, Source>;
    explicit TokenModelResources(Sources sources) : sources_(std::move(sources)) {}
    const Sources sources_;
    std::map<std::string, TokenResourceModel> cache_;
};
}  // namespace comeback::recovered
#endif
