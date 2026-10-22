// Original Marisa ExactMatchIterator frames; Google-derived, see NOTICE.
#include "forward_token_dictionary.h"
#include <marisa/grimoire/trie/state.h>
#include <utility>

namespace comeback::recovered {
ForwardTokenDictionaryView::ExactCursor::ExactCursor(
    std::shared_ptr<const ForwardTokenDictionaryView> dictionary)
    : dictionary_(std::move(dictionary)) {
    agent_.init_state();
}

bool ForwardTokenDictionaryView::ExactCursor::Push(std::string_view bytes) {
    const auto previous_size = query_.size();
    if (!bytes.empty()) query_.append(bytes.data(), bytes.size());
    agent_.set_query(query_.data(), query_.size());
    auto& state = agent_.state();
    state.set_node_id(frames_.empty() ? 0 : frames_.back().node);
    state.set_query_pos(frames_.empty() ? 0 : frames_.back().position);
    const auto result = dictionary_->trie_.lookup(agent_, false);
    using Result = marisa::grimoire::trie::LoudsTrie::LookupResult;
    has_current_ = result == Result::Exact;
    if (result == Result::Missing) {
        query_.resize(previous_size);
        return false;
    }
    frames_.push_back({bytes.size(), state.node_id(), state.query_pos()});
    return true;
}

bool ForwardTokenDictionaryView::ExactCursor::Pop() {
    has_current_ = false;
    if (frames_.empty()) return false;
    query_.resize(query_.size() - frames_.back().bytes);
    frames_.pop_back();
    return true;
}

void ForwardTokenDictionaryView::ExactCursor::Reset() {
    has_current_ = false;
    query_.clear();
    frames_.clear();
}
}  // namespace comeback::recovered
