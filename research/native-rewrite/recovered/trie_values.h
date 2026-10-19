// Fixed-store branch of VariableValueLengthTrie; Google-derived logic under NOTICE.
#ifndef COMEBACK_RECOVERED_TRIE_VALUES_H
#define COMEBACK_RECOVERED_TRIE_VALUES_H

#include "fixed_phrase_table.h"
#include "datrie_view.h"

namespace comeback::recovered {

// Common four-byte LE reference publication, including owning-region COW.
bool WriteTrieValueReference(std::uint32_t record_id, OwnedByteRegion& reference);

// Append the value before publishing a four-byte LE table-offset reference.
// Failure publishing the reference retains the appended record. Output may share
// its old bytes with other handles; writable access follows OwnedByteRegion COW.
bool AppendTrieValue(FixedPhraseTable& records, const OwnedByteRegion& value,
                     OwnedByteRegion& reference);
// Reference must be exactly four bytes and value must match the stored width.
// Inputs must remain valid during writable access; overlapping copies follow
// the original memcpy restriction, not a new self-update contract.
bool UpdateTrieValue(FixedPhraseTable& records, const OwnedByteRegion& reference,
                     const OwnedByteRegion& value);

// Resolve a terminal ID through its four-byte offset and copy the real value
// into the output region, following the native copied-value lifetime contract.
bool ReadTrieValueByNodeId(const DATrieView& trie, const FixedPhraseTable& records,
                           std::uint32_t node, OwnedByteRegion& value);

// Fixed-store EditorImpl insertion: try existing-value update first, otherwise
// append the value and insert its reference. A later key failure retains the
// appended value. The optional ID is published only by the insertion branch;
// successful existing-value updates leave it untouched, as in the native entry.
bool InsertTrieValue(DATrieView& trie, OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                      FixedPhraseTable& records, std::string_view key, const OwnedByteRegion& value,
                      std::uint32_t* terminal = nullptr, const DATrieNodeMove* notify = nullptr);

}  // namespace comeback::recovered
#endif
