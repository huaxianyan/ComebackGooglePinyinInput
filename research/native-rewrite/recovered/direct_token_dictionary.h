// Actual DirectTokenDictionary payload and DFS query semantics; see NOTICE.
#ifndef COMEBACK_RECOVERED_DIRECT_TOKEN_DICTIONARY_H
#define COMEBACK_RECOVERED_DIRECT_TOKEN_DICTIONARY_H
#include "flat_integer_table.h"
#include "token_manager_selection.h"
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
private:
    friend class DirectTokenCursor;
    DirectTokenDictionary(std::int32_t selector, std::int32_t language, bool case_sensitive,
                         const FlatIntegerTableView& starts, const FlatIntegerTableView& lengths);
    bool Encode(std::string_view input, bool target, std::uint32_t& id, std::string& canonical);
    std::int32_t selector_;
    std::int32_t language_;
    bool case_sensitive_;
    FlatIntegerTableView starts_;
    FlatIntegerTableView lengths_;
    std::atomic<std::uint32_t> dynamic_counter_{0};
};

// Nonnull successfully loaded dictionary. Input is complete valid UTF-8, as in
// the supported original resources; malformed Unicode, BFS and in-place model
// reconfiguration are not restored. This is a real single-frame native cursor.
class DirectTokenCursor {
public:
    explicit DirectTokenCursor(std::shared_ptr<DirectTokenDictionary> dictionary);
    bool Push(std::int32_t selector, std::int32_t language,
              std::string_view input, bool target);
    // Original 0x1b08ec really returns false, even after a successful Push.
    bool NextFrame() const { return false; }
    bool Done() const { return !active_ || done_; }
    bool Current(KeyToken& output) const;
    void Advance() { done_ = true; }
    bool Pop();
    void Reset();
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
