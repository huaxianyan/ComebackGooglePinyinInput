// One real native empty-configuration initialize/write/map/load flow.
#include "single_trie_mutable_dictionary_init.h"
#include "datrie_view.h"
#include "file_mmap.h"
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
}
int main(int argc, char** argv) {
    Require(argc == 2, "provide a new project-local directory for the empty dictionary file");
    SingleTrieMutableDictionaryStorage dictionary;
    Require(InitializeSingleTrieUserStorage(31, dictionary), "initialize the native empty user storage");
    const auto metadata = "\x08\x06\x10\0\x18\0\x20\x01\x30\x1f"sv;
    Require(dictionary.metadata.SerializeAsString() == metadata &&
            dictionary.trie.values.RecordSize() == 6 && dictionary.trie.values.RecordCount() == 0 &&
            dictionary.phrases.RecordSize() == 14 && dictionary.phrases.RecordCount() == 0,
            "preserve the original empty widths, count presence and caller token category");
    OwnedByteRegion image;
    Require(WriteSingleTrieMutableDictionaryImage(dictionary,
        [&](const std::uint8_t* data, std::size_t size) {
            return AppendDictionaryImageBytes(image, data, size);
        }), "serialize the native empty three-component configuration");
    Require(image.Size() == 2760 && At(image, 0, "\x0a\0\0\0"sv) && At(image, 4, metadata) &&
            At(image, 16, "\x17\0\0\0" "VariableValueLengthTrie"sv) &&
            At(image, 2688, "\0\0\0\0\x06\0\0\0"sv) && At(image, 2696, "P-TABLE\0"sv) &&
            At(image, 2728, "\x10\0\0\0" "FixedPhraseTable"sv) &&
            At(image, 2752, "\0\0\0\0\x0e\0\0\0"sv),
            "write the independently frozen native empty widths and three-model offsets");
    const auto path = std::string(argv[1]) + "/native-empty-single.bin";
    {
        std::ofstream file(path, std::ios::binary | std::ios::trunc);
        file.write(reinterpret_cast<const char*>(image.Data()), image.Size());
        file.close();
        Require(!file.fail(), "write the initialized storage to a real file");
    }
    OwnedByteRegion mapped;
    SingleTrieMutableDictionaryStorage loaded;
    Require(MapReadOnlyFile(path, mapped) == FileMappingResult::Mapped &&
            LoadSingleTrieMutableDictionary(mapped, loaded) == 2760 &&
            loaded.metadata.SerializeAsString() == metadata && loaded.trie.values.RecordSize() == 6 &&
            loaded.phrases.RecordSize() == 14, "map and reload the actual native empty configuration");
    DATrieView trie(loaded.trie.metadata.Data(), loaded.trie.metadata.Size(),
                    const_cast<std::uint8_t*>(loaded.trie.nodes.Data()), loaded.trie.nodes.Size());
    Require(trie.AcceptsKey("\x01\x7f\x80\xff"sv) && trie.FindTerminal("a") == 0,
            "the initialized full nonzero alphabet is readable and has no entries");
    loaded = {};
    mapped = {};
    Require(std::remove(path.c_str()) == 0, "remove only the initialized file created by this flow");
    std::puts("PASS: native SingleTrie empty initialization/write/map/load flow");
}
