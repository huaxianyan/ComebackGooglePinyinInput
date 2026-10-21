// One real three-submodel map/read/rewrite flow, not native factory defaults.
#include "single_trie_mutable_dictionary_image.h"
#include "file_mmap.h"
#include "index_pool.h"
#include "trie_values.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <string>
#include <string_view>

using namespace comeback::recovered;
using namespace std::literals;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
bool At(const OwnedByteRegion& image, std::size_t offset, std::string_view expected) {
    return offset <= image.Size() && expected.size() <= image.Size() - offset &&
           std::memcmp(image.Data() + offset, expected.data(), expected.size()) == 0;
}
OwnedByteRegion Image(const SingleTrieMutableDictionaryStorage& dictionary) {
    OwnedByteRegion result;
    Require(WriteSingleTrieMutableDictionaryImage(dictionary,
        [&](const std::uint8_t* data, std::size_t size) {
            return AppendDictionaryImageBytes(result, data, size);
        }), "serialize the actual three native submodels");
    return result;
}
void WriteFile(const std::string& path, const OwnedByteRegion& image) {
    std::ofstream file(path, std::ios::binary | std::ios::trunc);
    file.write(reinterpret_cast<const char*>(image.Data()), image.Size());
    file.close();
    Require(!file.fail(), "write the real project-local image file");
}
std::string Payload(const SingleTrieMutableDictionaryStorage& dictionary) {
    // Only const lookup methods use these views over mapped bytes.
    DATrieView trie(dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
                    const_cast<std::uint8_t*>(dictionary.trie.nodes.Data()), dictionary.trie.nodes.Size());
    OwnedByteRegion range;
    std::uint32_t terminal = 0;
    Require(ReadTrieValueByKey(trie, dictionary.trie.values, "a", terminal, range) &&
            range.Size() == 8 && At(range, 0, "\x02\0\0\0\x01\0\0\0"sv),
            "read the stored fixture range through the actual trie");
    IndexPoolView pool(dictionary.range_metadata.Data(), dictionary.range_metadata.Size(),
                       const_cast<std::uint8_t*>(dictionary.range_cells.Data()), dictionary.range_cells.Size());
    std::uint32_t id = 99;
    const std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    Require(pool.ReadRecordId(2, id) && id == 0 && dictionary.phrases.ReadRecord(id, bytes, size),
            "resolve the fixture range through the actual pool and phrase table");
    return {reinterpret_cast<const char*>(bytes), size};
}
}

int main(int argc, char** argv) {
    Require(argc == 2, "provide a new project-local directory for mapping tests");
    SingleTrieMutableDictionaryStorage dictionary;
    // Explicit fixture configuration, not recovered native initialization defaults.
    const auto metadata = "\x08\x06\x10\0\x18\0\x20\0\x28\0\x30\x01\x48\x07"sv;
    Require(dictionary.metadata.ParseFromArray(metadata.data(), metadata.size()), "load literal metadata");
    dictionary.trie.values = FixedPhraseTable(8);
    dictionary.phrases = FixedPhraseTable(6);
    Require(InitializeDATrie(dictionary.trie.metadata, dictionary.trie.nodes, "ab", 0xff) &&
            dictionary.trie.values.Initialize() && dictionary.phrases.Initialize() &&
            InitializeIndexPool(dictionary.range_metadata, dictionary.range_cells),
            "initialize the explicit fixture with existing real primitives");
    const auto empty = Image(dictionary);
    // Literal three-model layout, independent of production size/tag helpers.
    Require(empty.Size() == 2768 && At(empty, 0, "\x0e\0\0\0"sv) && At(empty, 4, metadata) &&
            At(empty, 24, "\x17\0\0\0" "VariableValueLengthTrie"sv) &&
            At(empty, 56, "\x06\0\0\0" "DATrie"sv) &&
            At(empty, 2704, "P-TABLE\0"sv) &&
            At(empty, 2736, "\x10\0\0\0" "FixedPhraseTable"sv) &&
            At(empty, 2760, "\0\0\0\0\x06\0\0\0"sv),
            "write the native metadata/trie/range/phrase order at literal offsets");

    const auto payload = "\x11\x22\x33\x44\x55\x66"sv;
    std::uint64_t id = 99;
    Require(dictionary.phrases.AppendRecord(reinterpret_cast<const std::uint8_t*>(payload.data()),
                                           payload.size(), id) && id == 0,
            "append the explicit fixture payload");
    IndexRange indices{};
    Require(CreateIndexRange(dictionary.range_metadata, dictionary.range_cells, 0, indices),
            "create the fixture's actual pool entry");
    OwnedByteRegion range;
    Require(range.Resize(8), "allocate the explicit fixture range");
    std::memcpy(range.MutableData(), "\x02\0\0\0\x01\0\0\0", 8);
    {
        DATrieView trie(dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
                        dictionary.trie.nodes.MutableData(), dictionary.trie.nodes.Size());
        Require(InsertTrieValue(trie, dictionary.trie.metadata, dictionary.trie.nodes,
                                dictionary.trie.values, "a", range), "insert the fixture's actual trie key");
    }
    dictionary.metadata.set_association_count(1);
    const auto first = Image(dictionary);
    const auto path = std::string(argv[1]) + "/single-trie.bin";
    WriteFile(path, first);
    OwnedByteRegion mapped;
    SingleTrieMutableDictionaryStorage loaded;
    Require(MapReadOnlyFile(path, mapped) == FileMappingResult::Mapped &&
            LoadSingleTrieMutableDictionary(mapped, loaded) == first.Size() && Payload(loaded) == payload &&
            loaded.metadata.SerializeAsString() ==
                "\x08\x06\x10\0\x18\0\x20\0\x28\x01\x30\x01\x48\x07"sv,
            "map and load all three models with metadata presence and unknown fields");
    const auto replacement = "\xaa\xbb\xcc\xdd\xee\xff"sv;
    std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    Require(loaded.phrases.MutableRecord(0, bytes, size) && size == 6,
            "obtain a fresh writable phrase record from the loaded model");
    std::memcpy(bytes, replacement.data(), size);
    const auto second = Image(loaded);
    // Frozen native parse/publish boundary: a missing phrase payload is an error.
    Require(LoadSingleTrieMutableDictionary(second.Slice(0, second.Size() - 3), loaded) == 0 &&
            Payload(loaded) == replacement, "an incomplete phrase payload retains the previous model");
    loaded = {};
    mapped = {};
    WriteFile(path, second);
    Require(MapReadOnlyFile(path, mapped) == FileMappingResult::Mapped &&
            LoadSingleTrieMutableDictionary(mapped, loaded) == second.Size() && Payload(loaded) == replacement,
            "rewrite the file and read the changed payload through the real lookup chain");
    loaded = {};
    mapped = {};
    Require(std::remove(path.c_str()) == 0, "remove only the file created by this flow");
    std::puts("PASS: SingleTrie three-model map/read/rewrite flow");
}
