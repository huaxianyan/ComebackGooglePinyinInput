// Ordinary ForwardTokenDictionary resource projection; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#define COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#include "flat_integer_table.h"
#include "forward_token_metadata.pb.h"
#include "token_manager_selection.h"
#include "token_dictionary_cursor.h"
#include <marisa/grimoire/trie/louds-trie.h>
#include <string_view>
#include <memory>
#include <vector>

namespace comeback::recovered {
enum class ForwardTokenColumn : std::size_t { Id, Score, Meta, Code, NodeId, Count };

// Real mapped Marisa and five native FlatVectors. Supports the eight ordinary
// original resources: no trie value records, code-point UTF-8 text encoding,
// no encoded-token trie and empty field_10. Other native profiles return null,
// not a ready dictionary with default/fabricated columns. ExactCursor below is
// the inner Marisa frame stack, not Forward's outer DFS/BFS coordinator.
class ForwardTokenDictionaryView {
public:
    class ExactCursor;
    class Cursor;
    using MetadataProto = i18n_input::engine::hmm::proto::ForwardTokenDictionaryMetaData;
    static std::shared_ptr<ForwardTokenDictionaryView> Load(const OwnedByteRegion& payload);
    const MetadataProto& Metadata() const { return metadata_; }
    const FlatIntegerTableView& Table(ForwardTokenColumn column) const {
        return tables_[static_cast<std::size_t>(column)];
    }
    const OwnedByteRegion& PrefixScores() const { return prefix_scores_; }
    // Native 0x1b4d48 for the loaded CODEPOINT_UTF8 / empty-field_10 profile.
    // Writes text only; no table membership or identity/auxiliary rewrite.
    bool FillTokenText(KeyToken& token) const;
    // Full prepared strings, complete valid UTF-8. True case_sensitive uses
    // native strlen copy (including embedded-NUL truncation), not Unicode fold.
    // One exact source key maps to one native record in this no-value profile;
    // no candidate ranking, interpolation or composite-frame state is replaced.
    bool ReadExactSource(const std::string& input, std::int32_t selector,
                         std::int32_t language, KeyToken& output) const;
    // Actual Forward current-token branch, not the whole upper lookup helper.
    // Ordinary literal target requires one code point after the C-string copy.
    bool ReadTarget(const std::string& input, std::int32_t selector,
                    std::int32_t language, KeyToken& output) const;
private:
    // Original owner constructor 0x1b3388; only its default ordinary profile.
    static constexpr std::int32_t kDefaultResultLimit = 128;
    std::string PrepareSource(const std::string& input) const;
    void ReadSourceToken(std::size_t index, std::size_t length, KeyToken& output) const;
    bool ReadLiteralTarget(const std::string& input, std::int32_t language, KeyToken& output) const;
    ForwardTokenDictionaryView(const OwnedByteRegion& image, const MetadataProto& metadata,
        std::vector<FlatIntegerTableView>&& tables, const OwnedByteRegion& prefix_scores);
    // Keep the source alive until AFTER the mapped marisa object is destroyed.
    OwnedByteRegion image_;
    MetadataProto metadata_;
    std::vector<FlatIntegerTableView> tables_;
    OwnedByteRegion prefix_scores_;
    marisa::grimoire::trie::LoudsTrie trie_;
};

// Loaded ordinary dictionary required. Push accepts prepared bytes; casing and
// Forward source/target coordination belong to the outer iterator, not this one.
class ForwardTokenDictionaryView::ExactCursor {
public:
    explicit ExactCursor(std::shared_ptr<const ForwardTokenDictionaryView> dictionary);
    bool Push(std::string_view bytes);
    bool Pop();
    void Reset();
    void Advance() { has_current_ = false; }
    std::size_t Depth() const { return frames_.size(); }
    bool HasCurrent() const { return has_current_; }
    // Like the original getter, valid result use requires HasCurrent(). The key
    // spans the full accumulated query, not only the most recent input segment.
    const marisa::Key& Current() const { return agent_.key(); }
private:
    struct Frame { std::size_t bytes, node, position; };
    std::shared_ptr<const ForwardTokenDictionaryView> dictionary_;
    std::string query_;
    std::vector<Frame> frames_;
    marisa::Agent agent_;
    bool has_current_ = false;
};
// Ordinary source/target projection, not a multi-record ranked Forward iterator.
// Source Push records call order; NextFrame applies segments from the stack top.
// A loaded dictionary and complete valid UTF-8 inputs are required.
class ForwardTokenDictionaryView::Cursor : public TokenDictionaryCursor {
public:
    explicit Cursor(std::shared_ptr<const ForwardTokenDictionaryView> dictionary);
    bool Push(std::int32_t selector, std::int32_t language, const std::string& input, bool target) override;
    bool NextFrame() override;
    bool Done() const override;
    bool Current(KeyToken& output) override;
    // Like the native getter, use only while !Done().
    float Attribute() override;
    void Advance() override { position_ = target_mode_ ? 1 : static_cast<std::int16_t>(position_ + 1); }
    bool Pop() override;
    void Reset() override;
private:
    std::shared_ptr<const ForwardTokenDictionaryView> dictionary_;
    ExactCursor exact_;
    std::vector<std::string> pending_;
    std::vector<std::string> applied_;
    std::int16_t position_ = kDefaultResultLimit;
    std::uint16_t row_ = 0;
    std::uint16_t length_ = 0;
    bool has_record_ = false;
    bool synchronized_ = false;
    bool target_mode_ = false;
    std::int32_t query_language_ = kUnknownTokenLanguage;
};
}  // namespace comeback::recovered
#endif
