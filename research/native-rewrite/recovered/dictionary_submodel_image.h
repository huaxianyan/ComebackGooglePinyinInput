// Shared named submodels; Google-derived wire behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_SUBMODEL_IMAGE_H
#define COMEBACK_RECOVERED_DICTIONARY_SUBMODEL_IMAGE_H

#include "fixed_phrase_table.h"
#include "dictionary_image_writer.h"
#include <string_view>

namespace comeback::recovered {
struct DictionaryTrieStorage {
    OwnedByteRegion metadata;
    OwnedByteRegion nodes;
    FixedPhraseTable values{0};
};

namespace detail {
class DictionaryImageReader {
public:
    explicit DictionaryImageReader(const OwnedByteRegion& image) : input(image) {}
    OwnedByteRegion Remaining() const { return input.Slice(position, input.Size() - position); }
    bool Advance(std::uint64_t size);
    bool Name(std::string_view expected);
    std::size_t position = 0;
private:
    const OwnedByteRegion& input;
};

bool WriteDictionaryFixed(const DictionaryImageSink& sink, const FixedPhraseTable& table);
bool WriteDictionaryTrie(const DictionaryImageSink& sink, const DictionaryTrieStorage& trie);
bool WriteDictionaryPool(const DictionaryImageSink& sink, const OwnedByteRegion& metadata,
                         const OwnedByteRegion& cells);
bool ReadDictionaryFixed(DictionaryImageReader& reader, FixedPhraseTable& table);
bool ReadDictionaryTrie(DictionaryImageReader& reader, DictionaryTrieStorage& trie);
bool ReadDictionaryPool(DictionaryImageReader& reader, OwnedByteRegion& metadata, OwnedByteRegion& cells);
}  // namespace detail
}  // namespace comeback::recovered
#endif
