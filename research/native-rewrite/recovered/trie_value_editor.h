// Concrete VariableValueLengthTrie editor state, not a virtual-handle shell; NOTICE.
#ifndef COMEBACK_RECOVERED_TRIE_VALUE_EDITOR_H
#define COMEBACK_RECOVERED_TRIE_VALUE_EDITOR_H
#include "trie_exact_match_cursor.h"

namespace comeback::recovered {
// Native 0x1de788 owns a separate kind-zero cursor and an initially empty
// four-byte-reference scratch. The enclosing coordinator owns this state and
// the ready storage; each operation receives the current view after COW/growth.
struct TrieValueEditor {
    TrieExactMatchCursor cursor{};
    OwnedByteRegion reference{};
};
}  // namespace comeback::recovered
#endif
