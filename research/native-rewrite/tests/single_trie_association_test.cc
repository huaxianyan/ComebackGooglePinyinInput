// One real SingleTrie create/update/relocate/map/persist/reload flow.
#include "single_trie_association.h"
#include "single_trie_mutable_dictionary_init.h"
#include "datrie_view.h"
#include "trie_values.h"
#include "user_dictionary_file.h"
#include <cstdio>
#include <cstdlib>
#include <string>
#include <string_view>
#include <vector>

using namespace comeback::recovered;
using namespace std::literals;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
std::string Payload(const SingleTrieMutableDictionaryStorage& dictionary,
                    std::string_view first, std::string_view second) {
    OwnedByteRegion result;
    Require(ReadSingleTrieAssociationPayload(dictionary, first, second, result), "read the existing ordered pair");
    return {reinterpret_cast<const char*>(result.Data()), result.Size()};
}
std::uint32_t Terminal(const SingleTrieMutableDictionaryStorage& dictionary, std::string_view key) {
    DATrieView trie(dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.trie.nodes.Data()), dictionary.trie.nodes.Size());
    return trie.FindTerminal(key);
}
}
int main(int argc, char** argv) {
    Require(argc == 2, "provide a new project-local directory for the actual files");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> user;
    Require(InitializeSingleTrieUserStorage(31, user.dictionary), "initialize the native empty user storage");
    const auto self = "\x31\x32\x33\x34\x35\x36"sv;
    const auto reverse = "\x21\x22\x23\x24\x25\x26"sv;
    const auto forward = "\x11\x12\x13\x14\x15\x16"sv;
    SingleTrieAssociationEditor initial{user.dictionary};
    Require(ModifySingleTrieAssociation(initial, "a", "a", &self, AssociationEditMode::CreateOrUpdate) &&
            ModifySingleTrieAssociation(initial, "b", "b", &self, AssociationEditMode::CreateOrUpdate) &&
            ModifySingleTrieAssociation(initial, "b", "a", &reverse, AssociationEditMode::CreateOrUpdate) &&
            ModifySingleTrieAssociation(initial, "a", "b", &forward, AssociationEditMode::CreateOrUpdate) &&
            user.dictionary.phrases.RecordCount() == 4 && user.dictionary.metadata.association_count() == 4,
            "create self and directed pairs through the real coordinator, one shared record per relation");
    user.metadata.set_total_count(300);
    user.metadata.set_last_sync_time(42);
    const auto original_path = std::string(argv[1]) + "/single-original.bin";
    const auto updated_path = std::string(argv[1]) + "/single-updated.bin";
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> mapped, retained;
    Require(PersistUserDictionaryFile(user, original_path) &&
            LoadUserDictionaryFile(original_path, mapped) == DictionaryFileLoadResult::Loaded &&
            DuplicateUserDictionary(mapped, retained), "persist, map and retain the real newly created relations");
    SingleTrieAssociationEditor editor{mapped.dictionary};
    const auto metadata = mapped.dictionary.metadata.SerializeAsString();
    const auto replacement = "\xaa\xbb\xcc\xdd\xee\xff"sv;
    Require(ModifySingleTrieAssociation(editor, "a", "b", &replacement, AssociationEditMode::ExistingOnly) &&
            Payload(mapped.dictionary, "a", "b") == replacement && Payload(mapped.dictionary, "b", "a") == reverse &&
            Payload(mapped.dictionary, "a", "a") == self && mapped.dictionary.metadata.SerializeAsString() == metadata &&
            Payload(retained.dictionary, "a", "b") == forward,
            "update the mapped ordered pair, preserving reverse/self records, counters and the retained model");
    Require(!ModifySingleTrieAssociation(editor, "missing", "missing", &replacement, AssociationEditMode::ExistingOnly) &&
            mapped.dictionary.phrases.RecordCount() == 4, "existing-only mode leaves a missing key and relation absent");
    std::vector<std::uint32_t> original_ids;
    for (int i = 0; i < 96; ++i) {
        const auto key = "a" + std::to_string(i);
        Require(ModifySingleTrieAssociation(editor, key, key, &self, AssociationEditMode::CreateOrUpdate) &&
                ModifySingleTrieAssociation(editor, key, "a", &reverse, AssociationEditMode::CreateOrUpdate),
                "append real self and shared endpoint records while growing the trie");
        original_ids.push_back(Terminal(mapped.dictionary, key));
    }
    bool moved = false;
    for (int i = 0; i < 96; ++i) {
        const auto key = "a" + std::to_string(i);
        moved = moved || Terminal(mapped.dictionary, key) != original_ids[i];
        Require(Payload(mapped.dictionary, key, key) == self && Payload(mapped.dictionary, key, "a") == reverse,
                "moved terminal IDs retain both self fields and directed endpoint references");
    }
    Require(moved && ModifySingleTrieAssociation(editor, "z", "a", nullptr, AssociationEditMode::CreateOrUpdate) &&
            Payload(mapped.dictionary, "z", "a") == reverse &&
            mapped.dictionary.phrases.RecordCount() == 197 && mapped.dictionary.metadata.association_count() == 197,
            "actual relocation occurred and an omitted append payload retains the previous scratch bytes");
    OwnedByteRegion value;
    std::uint32_t terminal = 0;
    DATrieView trie(mapped.dictionary.trie.metadata.Data(), mapped.dictionary.trie.metadata.Size(),
        const_cast<std::uint8_t*>(mapped.dictionary.trie.nodes.Data()), mapped.dictionary.trie.nodes.Size());
    Require(ReadTrieValueByKey(trie, mapped.dictionary.trie.values, "z", terminal, value) &&
            value.Size() == 6 && value.Data()[4] == 0 && value.Data()[5] == 0,
            "the native first-endpoint flag leaves the newly created checksum bytes zero");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> reloaded;
    Require(PersistUserDictionaryFile(mapped, updated_path) &&
            LoadUserDictionaryFile(updated_path, reloaded) == DictionaryFileLoadResult::Loaded &&
            Payload(reloaded.dictionary, "a", "b") == replacement && Payload(reloaded.dictionary, "b", "a") == reverse &&
            Payload(reloaded.dictionary, "a95", "a") == reverse && reloaded.metadata.total_count() == 300 &&
            reloaded.dictionary.metadata.association_count() == 197 && retained.dictionary.metadata.association_count() == 4,
            "reload the created and repaired records with independent inner and outer counts");
    mapped = {};
    reloaded = {};
    Require(std::remove(original_path.c_str()) == 0 && std::remove(updated_path.c_str()) == 0,
            "remove only the two files created by this flow");
    std::puts("PASS: SingleTrie real create/update/relocate/map/persist/reload flow");
}
