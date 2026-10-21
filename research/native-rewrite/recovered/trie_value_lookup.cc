// Copied-value lookup for the fixed-store trie branch; Google-derived: NOTICE.
#include "trie_values.h"
#include "datrie_view.h"
#include "little_endian.h"

#include <cstring>

namespace comeback::recovered {

namespace {
bool CopyRecord(const FixedPhraseTable& records, std::uint32_t record_id, OwnedByteRegion& value) {
    const std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    if (!records.ReadRecord(record_id, bytes, size)) return false;
    if (value.Size() != size && !value.Resize(size)) return false;
    auto* output = value.MutableData();
    if (output == nullptr) return false;
    std::memcpy(output, bytes, size);
    return true;
}

}  // namespace

bool ReadTrieValueByNodeId(const DATrieView& trie, const FixedPhraseTable& records,
                           std::uint32_t node, OwnedByteRegion& value) {
    std::uint32_t record_id = 0;
    return trie.ReadTerminalValue(node, record_id) && CopyRecord(records, record_id, value);
}

bool TrieExactMatchCursor::ReadValue(const FixedPhraseTable& records, OwnedByteRegion& output) {
    // Native 0x1d630c reports success irrespective of the reference-copy status;
    // the following 0x1de920 resolution tests its resulting four-byte extent.
    WriteTrieValueReference(value_, reference_);
    return reference_.Size() == sizeof(std::uint32_t) &&
           CopyRecord(records, detail::ReadLittleEndian<std::uint32_t>(reference_.Data()), output);
}

bool ReadTrieValueByKey(TrieExactMatchCursor& cursor, const DATrieView& trie, const FixedPhraseTable& records,
                         std::string_view key, std::uint32_t& terminal, OwnedByteRegion& value) {
    cursor.Reset();
    if (!cursor.Append(trie, key) || cursor.Done()) return false;
    terminal = cursor.Terminal();
    return cursor.ReadValue(records, value);
}

}  // namespace comeback::recovered
