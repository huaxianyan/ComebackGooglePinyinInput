// Native SingleTrieMutableDictionary composition; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_MUTABLE_DICTIONARY_IMAGE_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_MUTABLE_DICTIONARY_IMAGE_H

#include "dictionary_submodel_image.h"
#include "mutable_dictionary_metadata.pb.h"

namespace comeback::recovered {
// Three native submodels, sharing the actual metadata message and primitives
// with MutableDictionary. This codec does not implement native factory defaults
// or SingleTrie word editing. Borrowed views must be reacquired after mutation.
struct SingleTrieMutableDictionaryStorage {
    i18n_input::engine::hmm::proto::MutableDictionaryMetaData metadata;
    DictionaryTrieStorage trie;
    OwnedByteRegion range_metadata;
    OwnedByteRegion range_cells;
    FixedPhraseTable phrases{0};
};

bool WriteSingleTrieMutableDictionaryImage(const SingleTrieMutableDictionaryStorage& dictionary,
                                          const DictionaryImageSink& sink);
// Current protobuf format only, with VariableValueLengthTrie(DATrie,
// FixedPhraseTable), IndexPool and FixedPhraseTable backends. Return consumed
// bytes, or zero; publish only after all three load (native 0x1cb034).
std::uint64_t LoadSingleTrieMutableDictionary(const OwnedByteRegion& input,
                                            SingleTrieMutableDictionaryStorage& output);
}  // namespace comeback::recovered
#endif
