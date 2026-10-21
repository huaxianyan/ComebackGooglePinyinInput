// Native 0x1c6660 / 0x1c71a4 composition; Google-derived behavior, see NOTICE.
#include "mutable_dictionary_image.h"
#include "dictionary_string_image.h"

#include <string>
#include <utility>

namespace comeback::recovered {
bool WriteMutableDictionaryImage(const MutableDictionaryStorage& dictionary, const DictionaryImageSink& sink) {
    std::string metadata;
    OwnedByteRegion image;
    return dictionary.metadata.SerializeToString(&metadata) &&
           SerializeDictionaryStringImage(metadata, image) && sink(image.Data(), image.Size()) &&
           detail::WriteDictionaryTrie(sink, dictionary.forward) &&
           detail::WriteDictionaryTrie(sink, dictionary.reverse) &&
           detail::WriteDictionaryPool(sink, dictionary.forward_pool_metadata, dictionary.forward_pool_cells) &&
           detail::WriteDictionaryPool(sink, dictionary.reverse_pool_metadata, dictionary.reverse_pool_cells) &&
           detail::WriteDictionaryFixed(sink, dictionary.forward_records) &&
           detail::WriteDictionaryFixed(sink, dictionary.reverse_records);
}

bool SerializeMutableDictionary(const MutableDictionaryStorage& dictionary, OwnedByteRegion& output) {
    OwnedByteRegion image;
    if (!WriteMutableDictionaryImage(dictionary, [&](const std::uint8_t* data, std::size_t size) {
            return AppendDictionaryImageBytes(image, data, size);
        })) return false;
    output = std::move(image);
    return true;
}

std::uint64_t LoadMutableDictionary(const OwnedByteRegion& input, MutableDictionaryStorage& output) {
    detail::DictionaryImageReader reader(input);
    MutableDictionaryStorage loaded;
    std::string metadata;
    const auto size = LoadDictionaryStringImage(reader.Remaining(), metadata);
    if (!reader.Advance(size) || !loaded.metadata.ParseFromString(metadata) ||
        !detail::ReadDictionaryTrie(reader, loaded.forward) ||
        !detail::ReadDictionaryTrie(reader, loaded.reverse) ||
        !detail::ReadDictionaryPool(reader, loaded.forward_pool_metadata, loaded.forward_pool_cells) ||
        !detail::ReadDictionaryPool(reader, loaded.reverse_pool_metadata, loaded.reverse_pool_cells) ||
        !detail::ReadDictionaryFixed(reader, loaded.forward_records) ||
        !detail::ReadDictionaryFixed(reader, loaded.reverse_records)) return 0;
    output = std::move(loaded);
    return reader.position;
}
}  // namespace comeback::recovered
