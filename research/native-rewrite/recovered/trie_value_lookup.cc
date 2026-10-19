// Copied-value lookup for the fixed-store trie branch; Google-derived: NOTICE.
#include "trie_values.h"
#include "datrie_view.h"

#include <cstring>

namespace comeback::recovered {

bool ReadTrieValueByNodeId(const DATrieView& trie, const FixedPhraseTable& records,
                           std::uint32_t node, OwnedByteRegion& value) {
    std::uint32_t record_id = 0;
    const std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    if (!trie.ReadTerminalValue(node, record_id) || !records.ReadRecord(record_id, bytes, size)) {
        return false;
    }
    if (value.Size() != size && !value.Resize(size)) return false;
    auto* output = value.MutableData();
    if (output == nullptr) return false;
    std::memcpy(output, bytes, size);
    return true;
}

bool ReadTrieValueByKey(const DATrieView& trie, const FixedPhraseTable& records,
                         std::string_view key, std::uint32_t& terminal, OwnedByteRegion& value) {
    const auto found = trie.FindTerminal(key);
    if (found == 0) return false;
    terminal = found;
    return ReadTrieValueByNodeId(trie, records, found, value);
}

}  // namespace comeback::recovered
