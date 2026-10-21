// Fixed-store VariableValueLengthTrie::EditorImpl coordination; see NOTICE.
#include "trie_values.h"
#include "little_endian.h"

namespace comeback::recovered {

bool UpdateTrieValueByKey(TrieValueEditor& editor, const DATrieView& trie, FixedPhraseTable& records,
                           std::string_view key, const OwnedByteRegion& value) {
    editor.cursor.Reset();
    if (!editor.cursor.Append(trie, key) || editor.cursor.Done()) return false;
    editor.cursor.CopyReference(editor.reference);
    return UpdateTrieValue(records, editor.reference, value);
}

bool InsertTrieValue(TrieValueEditor& editor, DATrieView& trie, OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                      FixedPhraseTable& records, std::string_view key, const OwnedByteRegion& value,
                      std::uint32_t* terminal, const DATrieNodeMove* notify) {
    if (UpdateTrieValueByKey(editor, trie, records, key, value)) return true;
    // The native append branch runs even when an earlier update failed. Key
    // admission belongs to the underlying insertion, after the record append.
    if (!AppendTrieValue(records, value, editor.reference)) return false;
    return trie.InsertValue(metadata, nodes, key,
                            detail::ReadLittleEndian<std::uint32_t>(editor.reference.Data()), terminal, notify);
}

}  // namespace comeback::recovered
