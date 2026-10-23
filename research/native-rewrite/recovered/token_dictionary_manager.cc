// Recovered active-pair selection and real DFS child creation; see NOTICE.
#include "token_dictionary_manager.h"
#include "token_dictionary_setting.pb.h"
#include "direct_token_dictionary.h"
#include "forward_token_dictionary.h"
#include <type_traits>
#include <utility>

namespace comeback::recovered {
std::shared_ptr<TokenDictionaryManager> TokenDictionaryManager::Load(
    const std::string& setting, TokenModelResources& resources) {
    i18n_input::engine::hmm::proto::TokenDictionaryDataSetting parsed;
    if (!parsed.ParseFromString(setting) || parsed.iterator_options_size() != 0) return nullptr;
    auto manager = std::shared_ptr<TokenDictionaryManager>(new TokenDictionaryManager);
    constexpr std::int32_t kUnsetLanguage = -1;
    auto language = kUnsetLanguage;
    for (const auto& data_id : parsed.data_id()) {
        const auto resolved = resources.Resolve(data_id);
        if (resolved.status == TokenModelResources::Resolution::Status::Unsupported) return nullptr;
        if (resolved.status == TokenModelResources::Resolution::Status::Missing) continue;
        const auto* model = std::get_if<TokenDictionaryModel>(resolved.model);
        if (!model) return nullptr;
        const auto key = std::visit([](const auto& dictionary) {
            using Dictionary = typename std::decay_t<decltype(dictionary)>::element_type;
            if constexpr (std::is_same_v<Dictionary, DirectTokenDictionary>) {
                return std::make_pair(dictionary->Selector(), dictionary->LanguageId());
            } else {
                return std::make_pair(dictionary->Metadata().selector(), dictionary->Metadata().language_id());
            }
        }, *model);
        // Native 0x1948d0 reduces every resolved item before active-pair
        // first-winner filtering. Preserve configured order and the -1 sentinel.
        if (language == kUnsetLanguage) language = key.second;
        else if (language != key.second) language = kUnknownTokenLanguage;
        manager->active_.emplace(key, *model);
    }
    manager->language_id_ = language == kUnsetLanguage ? kUnknownTokenLanguage : language;
    return manager;
}

bool TokenDictionaryManager::FillTokenText(KeyToken& token) const {
    const auto kind = static_cast<std::int32_t>(TokenKindFromId(token.id));
    const bool literal = (token.id & kTokenLiteralBit) != 0;
    const auto selected = active_.lower_bound({kind, literal ? 0 : token.auxiliary});
    if (selected == active_.end() || selected->first.first != kind ||
        (!literal && selected->first.second != token.auxiliary)) return false;
    return std::visit([&](const auto& dictionary) {
        return dictionary->FillTokenText(token);
    }, selected->second);
}

bool TokenDictionaryManager::UsingReversedTokens() const {
    // Original 0x192314 initializes +0xb8 to true; 0x1948d0 replaces it only
    // for a nonempty active set and requires all active flags to agree.
    if (active_.empty()) return true;
    return std::visit([](const auto& dictionary) {
        using Dictionary = typename std::decay_t<decltype(dictionary)>::element_type;
        if constexpr (std::is_same_v<Dictionary, DirectTokenDictionary>) {
            return dictionary->UsingReversedTokens();
        } else {
            return false; // Original Forward getter 0x1b2720 is constant false.
        }
    }, active_.begin()->second);
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
