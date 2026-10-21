// One native empty-initialize/full-file/duplicate/overwrite flow.
#include "single_trie_mutable_dictionary_init.h"
#include "datrie_view.h"
#include "user_dictionary_file.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <utility>
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
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> user;
    user.dictionary = std::move(dictionary);
    user.metadata.set_total_count(0);
    user.metadata.set_last_sync_time(0);
    OwnedByteRegion full;
    Require(SerializeUserDictionaryImage(user, full) && full.Size() == 2784 &&
            At(full, 0, "\x96\xa4\xcb\xa7\0\0\0\0\x03\0\0\0\x01\0\0\0"sv) &&
            At(full, 16, "\x04\0\0\0\x08\0\x10\0"sv) && At(full, 24, "\x0a\0\0\0"sv),
            "the shared full-file writer places SingleTrie behind the original header and outer metadata");
    const auto path = std::string(argv[1]) + "/native-empty-single.bin";
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> loaded;
    Require(PersistUserDictionaryFile(user, path) &&
            LoadUserDictionaryFile(path, loaded) == DictionaryFileLoadResult::Loaded &&
            loaded.dictionary.metadata.SerializeAsString() == metadata &&
            loaded.dictionary.trie.values.RecordSize() == 6 && loaded.dictionary.phrases.RecordSize() == 14,
            "persist and map the complete SingleTrie user file through the shared actual entry");
    {
        DATrieView trie(loaded.dictionary.trie.metadata.Data(), loaded.dictionary.trie.metadata.Size(),
            const_cast<std::uint8_t*>(loaded.dictionary.trie.nodes.Data()), loaded.dictionary.trie.nodes.Size());
        Require(trie.AcceptsKey("\x01\x7f\x80\xff"sv) && trie.FindTerminal("a") == 0,
                "the full-file model retains the initialized nonzero alphabet and empty trie");
    }
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> snapshot;
    Require(DuplicateUserDictionary(loaded, snapshot), "duplicate SingleTrie through the same full image protocol");
    loaded = {};
    snapshot.metadata.set_last_sync_time(75);
    snapshot.metadata.set_extension_data("snapshot\0", 9);
    Require(PersistUserDictionaryFile(snapshot, path) &&
            LoadUserDictionaryFile(path, loaded) == DictionaryFileLoadResult::Loaded &&
            loaded.metadata.last_sync_time() == 75 && loaded.metadata.extension_data() == std::string("snapshot\0", 9) &&
            user.metadata.last_sync_time() == 0 && !user.metadata.has_extension_data(),
            "the independent duplicate persists changed outer metadata with its SingleTrie body");
    loaded = {};
    Require(PersistUserDictionaryFile(user, path) &&
            LoadUserDictionaryFile(path, loaded) == DictionaryFileLoadResult::Loaded &&
            loaded.metadata.last_sync_time() == 0 && !loaded.metadata.has_extension_data(),
            "overwrite the longer snapshot with the original shorter file and load to exact EOF");
    loaded = {};
    Require(std::remove(path.c_str()) == 0, "remove only the user file created by this flow");
    std::puts("PASS: SingleTrie empty initialize/full-file/map/duplicate/shorter overwrite flow");
}
