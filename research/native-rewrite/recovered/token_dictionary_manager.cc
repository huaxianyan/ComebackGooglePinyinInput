// Recovered active-pair selection and real DFS child creation; see NOTICE.
#include "token_dictionary_manager.h"
#include "dictionary_string_image.h"
#include "direct_token_dictionary.h"
#include "forward_token_dictionary.h"
#include <type_traits>
#include <utility>

namespace comeback::recovered {
std::shared_ptr<TokenDictionaryManager> TokenDictionaryManager::LoadActive(
    const std::vector<OwnedByteRegion>& resolved_resources) {
    auto manager = std::shared_ptr<TokenDictionaryManager>(new TokenDictionaryManager);
    for (const auto& image : resolved_resources) {
        std::string name;
        const auto offset = LoadDictionaryStringImage(image, name);
        if (offset == 0 || offset > image.Size()) return nullptr;
        const auto payload = image.Slice(offset, image.Size() - offset);
        if (name == "DirectTokenDictionary") {
            auto dictionary = DirectTokenDictionary::Load(payload);
            if (!dictionary || dictionary->UsingReversedTokens()) return nullptr;
            const auto key = std::make_pair(dictionary->Selector(), dictionary->LanguageId());
            manager->active_.emplace(key, std::move(dictionary));
        } else if (name == "ForwardTokenDictionary") {
            auto dictionary = ForwardTokenDictionaryView::Load(payload);
            if (!dictionary) return nullptr;
            const auto key = std::make_pair(dictionary->Metadata().selector(), dictionary->Metadata().language_id());
            manager->active_.emplace(key, std::move(dictionary));
        } else {
            return nullptr;
        }
    }
    return manager;
}

std::unique_ptr<TokenDictionaryCursor> TokenDictionaryManager::CreateDfsCursor() const {
    std::vector<ManagerTokenCursor::Child> children;
    for (const auto& entry : active_) {
        auto cursor = std::visit([](const auto& dictionary) -> std::unique_ptr<TokenDictionaryCursor> {
            using Dictionary = typename std::decay_t<decltype(dictionary)>::element_type;
            if constexpr (std::is_same_v<Dictionary, DirectTokenDictionary>) {
                return std::make_unique<DirectTokenCursor>(dictionary);
            } else {
                return std::make_unique<ForwardTokenDictionaryView::Cursor>(dictionary);
            }
        }, entry.second);
        children.push_back({entry.first.first, entry.first.second, std::move(cursor)});
    }
    // The native factory resets its root after each insertion. These children
    // are freshly constructed in that same empty state, not reused live cursors.
    return std::unique_ptr<TokenDictionaryCursor>(new ManagerTokenCursor(std::move(children)));
}
}  // namespace comeback::recovered
