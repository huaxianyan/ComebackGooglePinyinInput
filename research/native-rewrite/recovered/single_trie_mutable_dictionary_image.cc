// Native 0x1ca3d8 / 0x1ca7f8 composition; Google-derived, see NOTICE.
#include "single_trie_mutable_dictionary_image.h"
#include "dictionary_string_image.h"
#include <string>
#include <utility>

namespace comeback::recovered {
bool WriteSingleTrieMutableDictionaryImage(const SingleTrieMutableDictionaryStorage& dictionary,
                                          const DictionaryImageSink& sink) {
    std::string metadata;
    OwnedByteRegion image;
    return dictionary.metadata.SerializeToString(&metadata) &&
           SerializeDictionaryStringImage(metadata, image) && sink(image.Data(), image.Size()) &&
           detail::WriteDictionaryTrie(sink, dictionary.trie) &&
           detail::WriteDictionaryPool(sink, dictionary.range_metadata, dictionary.range_cells) &&
           detail::WriteDictionaryFixed(sink, dictionary.phrases);
}

std::uint64_t LoadSingleTrieMutableDictionary(const OwnedByteRegion& input,
                                            SingleTrieMutableDictionaryStorage& output) {
    detail::DictionaryImageReader reader(input);
    SingleTrieMutableDictionaryStorage loaded;
    std::string metadata;
    const auto size = LoadDictionaryStringImage(reader.Remaining(), metadata);
    if (!reader.Advance(size) || !loaded.metadata.ParseFromString(metadata) ||
        !detail::ReadDictionaryTrie(reader, loaded.trie) ||
        !detail::ReadDictionaryPool(reader, loaded.range_metadata, loaded.range_cells) ||
        !detail::ReadDictionaryFixed(reader, loaded.phrases)) return 0;
    output = std::move(loaded);
    return reader.position;
}
}  // namespace comeback::recovered
