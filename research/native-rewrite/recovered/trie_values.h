// Fixed-store branch of VariableValueLengthTrie; Google-derived logic under NOTICE.
#ifndef COMEBACK_RECOVERED_TRIE_VALUES_H
#define COMEBACK_RECOVERED_TRIE_VALUES_H

#include "fixed_phrase_table.h"

namespace comeback::recovered {

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

}  // namespace comeback::recovered
#endif
