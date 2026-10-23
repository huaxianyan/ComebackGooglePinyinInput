// Shared bundle class dispatch and data-ID cache projection; see NOTICE.
#include "token_model_resources.h"
#include "bundle_data_scheme.pb.h"
#include "dictionary_string_image.h"
#include "direct_token_dictionary.h"
#include "forward_token_dictionary.h"
#include "direct_mapping_token_expander.h"

namespace comeback::recovered {
std::shared_ptr<TokenModelResources> TokenModelResources::Load(
    const std::vector<std::string>& schemes, const Bundles& bundles) {
    Sources sources;
    for (const auto& wire : schemes) {
        proto::BundleDataScheme scheme;
        if (!scheme.ParseFromString(wire) || !scheme.unknown_fields().empty() ||
            (scheme.has_format_version() && scheme.format_version() != 1)) return nullptr;
        for (const auto& entry : scheme.data()) {
            const auto library = bundles.find(scheme.bundle_library());
            if (library == bundles.end()) return nullptr;
            // Original 0x19915c selects the library's _binary_<name> symbols
            // for storage type 2. Other sources/options are outside this profile.
            if (!entry.unknown_fields().empty() || entry.storage_type() != 2 || entry.data_type() == 0) return nullptr;
            const auto blob = library->second.find(entry.blob_name());
            if (blob == library->second.end()) return nullptr;
            sources.insert_or_assign(entry.data_id(), Source{entry.data_type(), blob->second});
        }
    }
    return std::shared_ptr<TokenModelResources>(new TokenModelResources(std::move(sources)));
}

TokenModelResources::Resolution TokenModelResources::Resolve(const std::string& data_id) {
    const auto cached = cache_.find(data_id);
    if (cached != cache_.end()) return {Resolution::Status::Ready, &cached->second};
    const auto source = sources_.find(data_id);
    if (source == sources_.end()) return {Resolution::Status::Missing, nullptr};
    const auto type = source->second.data_type;
    if (type != 4 && type != 5) return {Resolution::Status::Unsupported, nullptr};
    const auto& image = source->second.image;
    std::string name;
    const auto offset = LoadDictionaryStringImage(image, name);
    if (offset == 0 || offset > image.Size()) return {Resolution::Status::Unsupported, nullptr};
    const auto payload = image.Slice(offset, image.Size() - offset);
    TokenResourceModel model;
    if (type == 5 && name == "DirectMappingTokenExpander") {
        auto expander = DirectMappingTokenExpander::Load(payload);
        if (!expander) return {Resolution::Status::Unsupported, nullptr};
        model = std::move(expander);
    } else if (type == 4 && name == "DirectTokenDictionary") {
        auto dictionary = DirectTokenDictionary::Load(payload);
        if (!dictionary || dictionary->UsingReversedTokens()) return {Resolution::Status::Unsupported, nullptr};
        model = TokenDictionaryModel{std::move(dictionary)};
    } else if (type == 4 && name == "ForwardTokenDictionary") {
        auto dictionary = ForwardTokenDictionaryView::Load(payload);
        if (!dictionary) return {Resolution::Status::Unsupported, nullptr};
        model = TokenDictionaryModel{std::move(dictionary)};
    } else {
        return {Resolution::Status::Unsupported, nullptr};
    }
    const auto inserted = cache_.emplace(data_id, std::move(model));
    return {Resolution::Status::Ready, &inserted.first->second};
}
}  // namespace comeback::recovered
