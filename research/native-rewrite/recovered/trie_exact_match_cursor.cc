// Native 0x1d6d94 / 0x1d4674 / 0x1d4298 exact cursor state; see NOTICE.
#include "trie_exact_match_cursor.h"

namespace comeback::recovered {
bool TrieExactMatchCursor::Append(const DATrieView& trie, std::string_view segment) {
    const auto path = frames_.empty() ? trie.FindNode(segment) : trie.FindNode(segment, frames_.back().path);
    if (path == 0) {
        terminal_ = 0;
        return false;
    }
    frames_.push_back({key_.size(), path});
    key_.append(segment.data(), segment.size());
    terminal_ = trie.TerminalAtPath(path);
    // Native refresh preserves the previous value word when no terminal exists.
    if (terminal_ != 0) trie.ReadTerminalValue(terminal_, value_);
    return true;
}

bool TrieExactMatchCursor::Pop() {
    terminal_ = value_ = 0;
    if (frames_.empty()) return false;
    key_.resize(frames_.back().previous_length);
    frames_.pop_back();
    return true;
}

void TrieExactMatchCursor::Reset() {
    key_.clear();
    frames_.clear();
    terminal_ = value_ = 0;
}
}  // namespace comeback::recovered
