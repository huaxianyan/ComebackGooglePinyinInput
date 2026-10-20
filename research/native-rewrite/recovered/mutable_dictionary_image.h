// Current-format, fixed-store dictionary ownership; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_MUTABLE_DICTIONARY_IMAGE_H
#define COMEBACK_RECOVERED_MUTABLE_DICTIONARY_IMAGE_H

#include "fixed_phrase_table.h"
#include "owned_byte_region.h"
#include "mutable_dictionary_metadata.pb.h"

namespace comeback::recovered {
struct DictionaryTrieStorage {
    OwnedByteRegion metadata;
    OwnedByteRegion nodes;
    FixedPhraseTable values{0};
};

// Six actual submodels. Metadata is the sole owner of the association count and
// its optional presence. Borrowed views/editors must be rebuilt after loading.
// Supported native backend combination: VariableValueLengthTrie(DATrie,
// FixedPhraseTable), IndexPool, FixedPhraseTable. No fallback backend is used.
struct MutableDictionaryStorage {
    i18n_input::engine::hmm::proto::MutableDictionaryMetaData metadata;
    DictionaryTrieStorage forward;
    DictionaryTrieStorage reverse;
    OwnedByteRegion forward_pool_metadata;
    OwnedByteRegion forward_pool_cells;
    OwnedByteRegion reverse_pool_metadata;
    OwnedByteRegion reverse_pool_cells;
    FixedPhraseTable forward_records{0};
    FixedPhraseTable reverse_records{0};
};

bool SerializeMutableDictionary(const MutableDictionaryStorage& dictionary, OwnedByteRegion& output);
// Current (major >=3) protobuf format, not the legacy 24-byte metadata format.
// Returns complete bytes consumed, or zero. Publish only after all six models
// load, as in native 0x1c7814. Trailing input is available to the enclosing file.
std::uint64_t LoadMutableDictionary(const OwnedByteRegion& input, MutableDictionaryStorage& output);
}  // namespace comeback::recovered
#endif
