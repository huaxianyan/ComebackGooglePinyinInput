// Ordinary ForwardTokenDictionary resource projection; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#define COMEBACK_RECOVERED_FORWARD_TOKEN_DICTIONARY_H
#include "flat_integer_table.h"
#include "forward_token_metadata.pb.h"
#include "token_manager_selection.h"
#include <marisa.h>
#include <memory>
#include <vector>

namespace comeback::recovered {
enum class ForwardTokenColumn : std::size_t { Id, Score, Meta, Code, NodeId, Count };

// Real mapped Marisa and five native FlatVectors. Supports the eight ordinary
// original resources: no trie value records, code-point UTF-8 text encoding,
// no encoded-token trie and empty field_10. Other native profiles return null,
// not a ready dictionary with default/fabricated columns. Not a DFS/BFS cursor.
class ForwardTokenDictionaryView {
public:
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
    marisa::Trie trie_;
};
}  // namespace comeback::recovered
#endif
