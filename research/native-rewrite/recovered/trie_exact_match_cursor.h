// Native kind-zero DATrie/VariableValueLengthTrie state, ownership normalized; NOTICE.
#ifndef COMEBACK_RECOVERED_TRIE_EXACT_MATCH_CURSOR_H
#define COMEBACK_RECOVERED_TRIE_EXACT_MATCH_CURSOR_H
#include "datrie_view.h"
#include "fixed_phrase_table.h"
#include <string>
#include <vector>

namespace comeback::recovered {
// Pass a current borrowed view on each operation; no view survives COW/growth.
// Path frames are native node IDs, not re-resolved keys. Reset before reuse after
// mutation; this does not silently repair a cursor's stale path after relocation.
class TrieExactMatchCursor {
public:
    bool Append(const DATrieView& trie, std::string_view segment);
    // Pop truncates the path and clears both result words; it does not refresh.
    bool Pop();
    void Reset();
    void Next() { terminal_ = 0; }
    bool Done() const { return terminal_ == 0; }
    std::uint32_t Terminal() const { return terminal_; }
    std::size_t Depth() const { return frames_.size(); }
    // Read the cached reference even after Next/failing Append. A failed checked
    // record read retains output, as in existing copied-value lookup.
    bool ReadValue(const FixedPhraseTable& records, OwnedByteRegion& output);
    // Native 0x1d630c ignores the copy status rather than adding a failure gate.
    void CopyReference(OwnedByteRegion& output) const;
private:
    struct Frame { std::size_t previous_length; std::uint32_t path; };
    std::string key_;
    std::vector<Frame> frames_;
    std::uint32_t terminal_ = 0;
    std::uint32_t value_ = 0;
    OwnedByteRegion reference_;
};
}  // namespace comeback::recovered
#endif
