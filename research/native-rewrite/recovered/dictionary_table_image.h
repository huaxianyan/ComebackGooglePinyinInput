// Shared P-TABLE / DA-TRIE image envelope; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_TABLE_IMAGE_H
#define COMEBACK_RECOVERED_DICTIONARY_TABLE_IMAGE_H
#include <cstdint>

namespace comeback::recovered {
class OwnedByteRegion;
enum class DictionaryTableKind { IndexPool, DATrie };

// Signature, CRC64, metadata and active data. Output differs from both inputs;
// this memory codec does not model the native stream's partial I/O failures.
bool SerializeDictionaryTableImage(DictionaryTableKind kind, const OwnedByteRegion& metadata,
                                    const OwnedByteRegion& data, OwnedByteRegion& output);
// Return the consumed frame length or zero, allowing trailing input. DATrie
// additionally validates parent/free chains. Pool cells detach on load; DATrie
// nodes retain a parent slice. Reacquire all borrowed views after installation.
std::uint64_t LoadDictionaryTableImage(DictionaryTableKind kind, const OwnedByteRegion& input,
                                       OwnedByteRegion& metadata, OwnedByteRegion& data);
}  // namespace comeback::recovered
#endif
