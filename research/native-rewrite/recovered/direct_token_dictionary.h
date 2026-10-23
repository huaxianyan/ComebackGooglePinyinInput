// Actual DirectTokenDictionary payload and DFS query semantics; see NOTICE.
#ifndef COMEBACK_RECOVERED_DIRECT_TOKEN_DICTIONARY_H
#define COMEBACK_RECOVERED_DIRECT_TOKEN_DICTIONARY_H
#include "flat_integer_table.h"
#include "token_manager_selection.h"
#include "token_dictionary_cursor.h"
#include <atomic>
#include <memory>
#include <string_view>

namespace comeback::recovered {
class DirectTokenCursor;
class DirectTokenDictionary {
public:
    // Payload after the class envelope. Original normal, nonempty range tables;
    // malformed/empty/overflow images are outside native failure-equivalence.
    // Failure returns null, never a ready dictionary with fabricated ranges.
    static std::shared_ptr<DirectTokenDictionary> Load(const OwnedByteRegion& payload);
    bool Contains(std::uint32_t codepoint) const;
    // Native 0x1b16c4, not DFS Current's saved-text copy. Writes text only;
    // zero clears it, literals bypass ranges, a rejected source leaves it intact.
    // IDs in this ordinary projection carry complete valid Unicode scalars.
    bool FillTokenText(KeyToken& token) const;
    std::int32_t Selector() const { return selector_; }
    std::int32_t LanguageId() const { return language_; }
    bool UsingReversedTokens() const { return reversed_tokens_; }
private:
    friend class DirectTokenCursor;
    DirectTokenDictionary(std::int32_t selector, std::int32_t language, bool case_sensitive,
                         bool reversed_tokens, const FlatIntegerTableView& starts,
                         const FlatIntegerTableView& lengths);
    bool Encode(std::string_view input, bool target, std::uint32_t& id, std::string& canonical);
    std::int32_t selector_;
    std::int32_t language_;
    bool case_sensitive_;
    bool reversed_tokens_;
    FlatIntegerTableView starts_;
    FlatIntegerTableView lengths_;
    std::atomic<std::uint32_t> dynamic_counter_{0};
};

// Nonnull successfully loaded dictionary. Input is complete valid UTF-8, as in
// the supported original resources; malformed Unicode, BFS and in-place model
// reconfiguration are not restored. This is a real single-frame native cursor.
class DirectTokenCursor : public TokenDictionaryCursor {
public:
    explicit DirectTokenCursor(std::shared_ptr<DirectTokenDictionary> dictionary);
    bool Push(std::int32_t selector, std::int32_t language,
              const std::string& input, bool target) override;
    // Original 0x1b08ec really returns false, even after a successful Push.
    bool NextFrame() override { return false; }
    bool Done() const override { return !active_ || done_; }
    bool Current(KeyToken& output) override;
    // Original 0x1b0918 returns binary32 zero, now consumed by Manager.
    float Attribute() override { return 0.0f; }
    void Advance() override { done_ = true; }
    bool Pop() override;
    void Reset() override;
private:
    std::shared_ptr<DirectTokenDictionary> dictionary_;
    bool active_ = false;
    bool done_ = true;
    std::uint32_t id_ = 0;
    std::int32_t query_language_ = kUnknownTokenLanguage;
    std::string text_;
};
}  // namespace comeback::recovered
#endif
