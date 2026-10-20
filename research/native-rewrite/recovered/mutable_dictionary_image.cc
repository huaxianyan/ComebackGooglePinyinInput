// Native 0x1c6660 / 0x1c71a4 composition; Google-derived behavior, see NOTICE.
#include "mutable_dictionary_image.h"
#include "dictionary_alignment.h"
#include "dictionary_string_image.h"
#include "dictionary_table_image.h"

#include <cstring>
#include <string>
#include <utility>

namespace comeback::recovered {
namespace {
constexpr std::string_view kVariableTrie = "VariableValueLengthTrie";
constexpr std::string_view kDATrie = "DATrie";
constexpr std::string_view kFixedTable = "FixedPhraseTable";

class ImageWriter {
public:
    bool Append(const OwnedByteRegion& image) {
        const auto start = bytes.Size();
        const auto size = detail::AlignDictionaryBytes(image.Size());
        if (!bytes.Resize(start + size)) return false;
        auto* data = bytes.MutableData();
        if (data == nullptr) return false;
        if (image.Size() != 0) std::memcpy(data + start, image.Data(), image.Size());
        std::memset(data + start + image.Size(), 0, size - image.Size());
        return true;
    }
    bool Named(std::string_view name, const OwnedByteRegion& image) {
        OwnedByteRegion tag;
        return SerializeDictionaryStringImage(name, tag) && Append(tag) && Append(image);
    }
    OwnedByteRegion bytes;
};

class ImageReader {
public:
    explicit ImageReader(const OwnedByteRegion& image) : input(image) {}
    OwnedByteRegion Remaining() const { return input.Slice(position, input.Size() - position); }
    bool Advance(std::uint64_t size) {
        if (size == 0 || size > input.Size() - position) return false;
        position += static_cast<std::size_t>(size);
        return true;
    }
    bool Name(std::string_view expected) {
        std::string name;
        const auto size = LoadDictionaryStringImage(Remaining(), name);
        return name == expected && Advance(size);
    }
    std::size_t position = 0;
private:
    const OwnedByteRegion& input;
};

bool WriteFixed(ImageWriter& writer, const FixedPhraseTable& table) {
    OwnedByteRegion image;
    return table.Serialize(image) && writer.Named(kFixedTable, image);
}

bool WriteTrie(ImageWriter& writer, const DictionaryTrieStorage& trie) {
    ImageWriter body;
    OwnedByteRegion image;
    return SerializeDictionaryTableImage(DictionaryTableKind::DATrie, trie.metadata, trie.nodes, image) &&
           body.Named(kDATrie, image) && WriteFixed(body, trie.values) &&
           writer.Named(kVariableTrie, body.bytes);
}

bool WritePool(ImageWriter& writer, const OwnedByteRegion& metadata, const OwnedByteRegion& cells) {
    OwnedByteRegion image;
    return SerializeDictionaryTableImage(DictionaryTableKind::IndexPool, metadata, cells, image) &&
           writer.Append(image);
}

bool ReadFixed(ImageReader& reader, FixedPhraseTable& table) {
    if (!reader.Name(kFixedTable)) return false;
    return reader.Advance(table.Load(reader.Remaining()));
}

bool ReadTrie(ImageReader& reader, DictionaryTrieStorage& trie) {
    if (!reader.Name(kVariableTrie) || !reader.Name(kDATrie)) return false;
    const auto size = LoadDictionaryTableImage(DictionaryTableKind::DATrie, reader.Remaining(),
                                                trie.metadata, trie.nodes);
    return reader.Advance(detail::AlignDictionaryBytes(size)) && ReadFixed(reader, trie.values);
}

bool ReadPool(ImageReader& reader, OwnedByteRegion& metadata, OwnedByteRegion& cells) {
    const auto size = LoadDictionaryTableImage(DictionaryTableKind::IndexPool, reader.Remaining(),
                                                metadata, cells);
    return reader.Advance(detail::AlignDictionaryBytes(size));
}
}  // namespace

bool SerializeMutableDictionary(const MutableDictionaryStorage& dictionary, OwnedByteRegion& output) {
    ImageWriter writer;
    std::string metadata;
    OwnedByteRegion image;
    if (!dictionary.metadata.SerializeToString(&metadata) ||
        !SerializeDictionaryStringImage(metadata, image) || !writer.Append(image) ||
        !WriteTrie(writer, dictionary.forward) || !WriteTrie(writer, dictionary.reverse) ||
        !WritePool(writer, dictionary.forward_pool_metadata, dictionary.forward_pool_cells) ||
        !WritePool(writer, dictionary.reverse_pool_metadata, dictionary.reverse_pool_cells) ||
        !WriteFixed(writer, dictionary.forward_records) || !WriteFixed(writer, dictionary.reverse_records)) {
        return false;
    }
    output = std::move(writer.bytes);
    return true;
}

std::uint64_t LoadMutableDictionary(const OwnedByteRegion& input, MutableDictionaryStorage& output) {
    ImageReader reader(input);
    MutableDictionaryStorage loaded;
    std::string metadata;
    const auto size = LoadDictionaryStringImage(reader.Remaining(), metadata);
    if (!reader.Advance(size) || !loaded.metadata.ParseFromString(metadata) ||
        !ReadTrie(reader, loaded.forward) || !ReadTrie(reader, loaded.reverse) ||
        !ReadPool(reader, loaded.forward_pool_metadata, loaded.forward_pool_cells) ||
        !ReadPool(reader, loaded.reverse_pool_metadata, loaded.reverse_pool_cells) ||
        !ReadFixed(reader, loaded.forward_records) || !ReadFixed(reader, loaded.reverse_records)) return 0;
    output = std::move(loaded);
    return reader.position;
}
}  // namespace comeback::recovered
