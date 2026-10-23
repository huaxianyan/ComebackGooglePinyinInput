// Actual DirectMappingTokenExpander resources and child cursor; see NOTICE.
#ifndef COMEBACK_RECOVERED_DIRECT_MAPPING_TOKEN_EXPANDER_H
#define COMEBACK_RECOVERED_DIRECT_MAPPING_TOKEN_EXPANDER_H
#include "flat_integer_table.h"
#include "token_expander_cursor.h"
#include "token_expander_metadata.pb.h"
#include <array>
#include <memory>
#include <utility>

namespace comeback::recovered {
class DirectMappingTokenExpander {
public:
    // Payload AFTER the existing class-name string image. Ordinary complete
    // resources; native corrupt-image partial publication/diagnostics excluded.
    static std::shared_ptr<DirectMappingTokenExpander> Load(const OwnedByteRegion& payload);
    std::int32_t Category() const { return metadata_.expansion_type(); }
    // A concrete child cursor, NOT a ManagerIterator or key-generator facade.
    class Cursor final : public TokenExpanderCursor {
    public:
        explicit Cursor(std::shared_ptr<const DirectMappingTokenExpander> expander)
            : expander_(std::move(expander)) {}
        // Native rejection clears fallback but retains the previous range.
        // Caller must handle false; do not consume it as an accepted empty range.
        bool Reset(const KeyToken& input) override;
        // A mapped target writes ID/auxiliary only: caller text/identity survive.
        // Fallback copies the whole input. Optional score; no text resolution.
        bool Current(KeyToken& output, float* score = nullptr) const override;
        void Advance() override;
        bool Exhausted() const override { return remaining_ == 0 && !fallback_pending_; }
    private:
        std::shared_ptr<const DirectMappingTokenExpander> expander_;
        std::uint64_t position_ = 0;
        std::uint32_t remaining_ = 0;
        KeyToken fallback_;
        bool fallback_pending_ = false;
    };
private:
    using Metadata = i18n_input::engine::hmm::proto::TokenExpanderMetaData;
    DirectMappingTokenExpander(const Metadata& metadata, const FlatIntegerTableView& keys,
        const FlatIntegerTableView& positions, const OwnedByteRegion& targets,
        const OwnedByteRegion& scores);
    bool Lookup(std::uint32_t id, std::uint64_t& position, std::uint32_t& count) const;
    std::uint32_t Target(std::uint64_t position) const;
    Metadata metadata_;
    FlatIntegerTableView keys_;
    FlatIntegerTableView positions_;
    OwnedByteRegion targets_;
    OwnedByteRegion scores_;
    std::array<float, 256> score_table_;
};
}  // namespace comeback::recovered
#endif
