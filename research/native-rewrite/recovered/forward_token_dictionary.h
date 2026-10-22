// Ordinary ForwardTokenDictionary resource projection; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#define COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#include "flat_integer_table.h"
#include "forward_token_metadata.pb.h"
#include "token_manager_selection.h"
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
    using MetadataProto = i18n_input::engine::hmm::proto::ForwardTokenDictionaryMetaData;
    static std::shared_ptr<ForwardTokenDictionaryView> Load(const OwnedByteRegion& payload);
    const MetadataProto& Metadata() const { return metadata_; }
    const FlatIntegerTableView& Table(ForwardTokenColumn column) const {
        return tables_[static_cast<std::size_t>(column)];
    }
    const OwnedByteRegion& PrefixScores() const { return prefix_scores_; }
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
}  // namespace comeback::recovered
#endif
