// Ordinary bundle class dispatch and data-ID cache projection; see NOTICE.
#include "token_dictionary_resources.h"
#include "dictionary_string_image.h"
#include "direct_token_dictionary.h"
#include "forward_token_dictionary.h"

namespace comeback::recovered {
TokenDictionaryResources::Resolution TokenDictionaryResources::Resolve(const std::string& data_id) {
    const auto cached = cache_.find(data_id);
    if (cached != cache_.end()) return {Resolution::Status::Ready, &cached->second};
    const auto source = sources_.find(data_id);
    if (source == sources_.end()) return {Resolution::Status::Missing, nullptr};
    const auto& image = source->second;
    std::string name;
    const auto offset = LoadDictionaryStringImage(image, name);
    if (offset == 0 || offset > image.Size()) return {Resolution::Status::Unsupported, nullptr};
    const auto payload = image.Slice(offset, image.Size() - offset);
    TokenDictionaryModel model;
    if (name == "DirectTokenDictionary") {
        auto dictionary = DirectTokenDictionary::Load(payload);
        if (!dictionary || dictionary->UsingReversedTokens()) return {Resolution::Status::Unsupported, nullptr};
        model = std::move(dictionary);
    } else if (name == "ForwardTokenDictionary") {
        auto dictionary = ForwardTokenDictionaryView::Load(payload);
        if (!dictionary) return {Resolution::Status::Unsupported, nullptr};
        model = std::move(dictionary);
    } else {
        return {Resolution::Status::Unsupported, nullptr};
    }
    const auto inserted = cache_.emplace(data_id, std::move(model));
    return {Resolution::Status::Ready, &inserted.first->second};
}
}  // namespace comeback::recovered
