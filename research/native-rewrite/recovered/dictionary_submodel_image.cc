// Shared named submodels; Google-derived wire behavior, see NOTICE.
#include "dictionary_submodel_image.h"
#include "dictionary_alignment.h"
#include "dictionary_string_image.h"
#include "dictionary_table_image.h"
#include <string>

namespace comeback::recovered::detail {
namespace {
constexpr std::string_view kVariableTrie = "VariableValueLengthTrie";
constexpr std::string_view kDATrie = "DATrie";
constexpr std::string_view kFixedTable = "FixedPhraseTable";
}

bool DictionaryImageReader::Advance(std::uint64_t size) {
    if (size == 0 || size > input.Size() - position) return false;
    position += static_cast<std::size_t>(size);
    return true;
}

bool DictionaryImageReader::Name(std::string_view expected) {
    std::string name;
    const auto size = LoadDictionaryStringImage(Remaining(), name);
    return name == expected && Advance(size);
}

bool WriteDictionaryFixed(const DictionaryImageSink& sink, const FixedPhraseTable& table) {
    OwnedByteRegion image;
    return table.Serialize(image) && WriteNamedDictionaryImage(sink, kFixedTable, image);
}

bool WriteDictionaryTrie(const DictionaryImageSink& sink, const DictionaryTrieStorage& trie) {
    OwnedByteRegion body, image;
    const DictionaryImageSink collect = [&](const std::uint8_t* data, std::size_t size) {
        return AppendDictionaryImageBytes(body, data, size);
    };
    return SerializeDictionaryTableImage(DictionaryTableKind::DATrie, trie.metadata, trie.nodes, image) &&
           WriteNamedDictionaryImage(collect, kDATrie, image) && WriteDictionaryFixed(collect, trie.values) &&
           WriteNamedDictionaryImage(sink, kVariableTrie, body);
}

bool WriteDictionaryPool(const DictionaryImageSink& sink, const OwnedByteRegion& metadata,
                         const OwnedByteRegion& cells) {
    OwnedByteRegion image;
    return SerializeDictionaryTableImage(DictionaryTableKind::IndexPool, metadata, cells, image) &&
           WriteAlignedDictionaryImage(sink, image);
}

bool ReadDictionaryFixed(DictionaryImageReader& reader, FixedPhraseTable& table) {
    if (!reader.Name(kFixedTable)) return false;
    return reader.Advance(table.Load(reader.Remaining()));
}

bool ReadDictionaryTrie(DictionaryImageReader& reader, DictionaryTrieStorage& trie) {
    if (!reader.Name(kVariableTrie) || !reader.Name(kDATrie)) return false;
    const auto size = LoadDictionaryTableImage(DictionaryTableKind::DATrie, reader.Remaining(),
                                             trie.metadata, trie.nodes);
    return reader.Advance(AlignDictionaryBytes(size)) && ReadDictionaryFixed(reader, trie.values);
}

bool ReadDictionaryPool(DictionaryImageReader& reader, OwnedByteRegion& metadata, OwnedByteRegion& cells) {
    const auto size = LoadDictionaryTableImage(DictionaryTableKind::IndexPool, reader.Remaining(),
                                             metadata, cells);
    return reader.Advance(AlignDictionaryBytes(size));
}
}  // namespace comeback::recovered::detail
