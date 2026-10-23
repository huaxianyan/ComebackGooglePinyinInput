// Original category grouping and ordered sequential expansion; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_EXPANDER_MANAGER_H
#define COMEBACK_RECOVERED_TOKEN_EXPANDER_MANAGER_H
#include "token_model_resources.h"
#include "token_expander_cursor.h"
#include <map>

namespace comeback::recovered {
class TokenExpanderManager {
public:
    // Original repeated-data-ID setting, not a caller-made expander vector.
    // Missing IDs/category zero are skipped as at 0x196d30. An unsupported
    // backend fails this fresh builder; no partial native reconfiguration claim.
    static std::shared_ptr<TokenExpanderManager> Load(
        const std::string& setting, TokenModelResources& resources);
    class Cursor final : public TokenExpanderCursor {
    public:
        bool Reset(const KeyToken& input) override;
        bool Current(KeyToken& output, float* score = nullptr) const override;
        void Advance() override;
        bool Exhausted() const override { return current_ == results_.end(); }
    private:
        friend class TokenExpanderManager;
        explicit Cursor(std::vector<std::unique_ptr<TokenExpanderCursor>> children);
        void Apply(TokenExpanderCursor& child);
        using Results = std::map<KeyToken, float, decltype(&KeyTokenIdentityLess)>;
        std::vector<std::unique_ptr<TokenExpanderCursor>> children_;
        Results results_{KeyTokenIdentityLess};
        Results::const_iterator current_;
    };
    // Concatenate groups in request order, keeping configured order and repeated
    // selections. No matching children still yields a real identity iterator.
    std::unique_ptr<Cursor> CreateCursor(const std::vector<std::int32_t>& categories) const;
private:
    TokenExpanderManager() = default;
    std::map<std::int32_t, std::vector<std::shared_ptr<DirectMappingTokenExpander>>> groups_;
};
}  // namespace comeback::recovered
#endif
