// Fixed-store VariableValueLengthTrie::EditorImpl coordination; see NOTICE.
#include "trie_values.h"
#include "little_endian.h"

namespace comeback::recovered {

bool UpdateTrieValueByKey(const DATrieView& trie, FixedPhraseTable& records,
                           std::string_view key, const OwnedByteRegion& value) {
    OwnedByteRegion reference;
    const auto existing = trie.FindTerminal(key);
    std::uint32_t record_id = 0;
    return existing != 0 && trie.ReadTerminalValue(existing, record_id) &&
           WriteTrieValueReference(record_id, reference) && UpdateTrieValue(records, reference, value);
}

bool InsertTrieValue(DATrieView& trie, OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                      FixedPhraseTable& records, std::string_view key, const OwnedByteRegion& value,
                      std::uint32_t* terminal, const DATrieNodeMove* notify) {
    if (UpdateTrieValueByKey(trie, records, key, value)) return true;
    OwnedByteRegion reference;
    // The native append branch runs even when an earlier update failed. Key
    // admission belongs to the underlying insertion, after the record append.
    if (!AppendTrieValue(records, value, reference)) return false;
    return trie.InsertValue(metadata, nodes, key,
                            detail::ReadLittleEndian<std::uint32_t>(reference.Data()), terminal, notify);
}

}  // namespace comeback::recovered
