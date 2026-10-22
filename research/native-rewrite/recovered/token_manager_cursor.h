// Recovered Manager match frames and lazy token cache; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_MANAGER_CURSOR_H
#define COMEBACK_RECOVERED_TOKEN_MANAGER_CURSOR_H
#include "token_dictionary_cursor.h"
#include <memory>
#include <vector>

namespace comeback::recovered {
// An ordered DFS factory snapshot of nonnull real ordinary child cursors.
// Registration/reconfiguration, BFS and original tree/vtable ABI are not ported.
class ManagerTokenCursor : public TokenDictionaryCursor {
public:
    struct Child {
        std::int32_t selector;
        std::int32_t language;
        std::unique_ptr<TokenDictionaryCursor> cursor;
    };
    explicit ManagerTokenCursor(std::vector<Child> children);
    bool Push(std::int32_t selector, std::int32_t language,
              const std::string& input, bool target) override;
    bool NextFrame() override;
    bool Done() const override;
    bool Current(KeyToken& output) override;
    float Attribute() override;
    void Advance() override;
    bool Pop() override;
    void Reset() override;
private:
    // Native cache records have a token and binary32 attribute, not a marker.
    struct Result { KeyToken token; float attribute; };
    void ClearCache();
    bool ChildrenDone() const;
    void SkipDoneChildren();
    void Materialize();
    std::vector<Child> children_;
    std::vector<std::vector<std::size_t>> frames_;
    std::int32_t child_index_ = 0;
    std::vector<Result> cache_;
    std::int32_t cache_index_ = 0;
    bool cache_ready_ = false;
    bool is_source_ = false;
};
}  // namespace comeback::recovered
#endif
