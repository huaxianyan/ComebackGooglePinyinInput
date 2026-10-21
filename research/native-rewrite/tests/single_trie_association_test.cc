// Existing-only SingleTrie flow; fixture assembly is not an insertion backend.
#include "single_trie_association.h"
#include "single_trie_mutable_dictionary_init.h"
#include "association_records.h"
#include "datrie_view.h"
#include "dictionary_checksum.h"
#include "trie_values.h"
#include "user_dictionary_file.h"
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>
#include <string_view>

using namespace comeback::recovered;
using namespace std::literals;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
void SeedNativeRecordFixture(SingleTrieMutableDictionaryStorage& dictionary) {
    Require(InitializeSingleTrieUserStorage(31, dictionary), "initialize the native fixture storage");
    DATrieView trie(dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
                    dictionary.trie.nodes.MutableData(), dictionary.trie.nodes.Size());
    for (const auto key : {"a"sv, "b"sv}) {
        OwnedByteRegion value;
        Require(value.Resize(6), "prepare the real six-byte trie value");
        std::memset(value.MutableData(), 0, value.Size());
        const auto checksum = static_cast<std::uint16_t>(
            CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits16, {key}));
        Require(PatchAssociationValue(value.MutableData(), value.Size(), true, nullptr, nullptr, &checksum) &&
                InsertTrieValue(trie, dictionary.trie.metadata, dictionary.trie.nodes, dictionary.trie.values,
                                  key, value), "assemble the two fixture endpoints with existing trie primitives");
    }
    // Reacquire both IDs after all insertions: a node may have moved.
    const auto a = trie.FindTerminal("a"), b = trie.FindTerminal("b");
    Require(a != 0 && b != 0, "resolve the final fixture terminal IDs");
    IndexRange a_range{}, b_range{};
    const auto append = [&](std::uint32_t first, std::uint32_t second, std::string_view payload) {
        std::array<std::uint8_t, 14> record{};
        std::uint64_t id = 0;
        Require(PatchAssociationRecord(AssociationRecordLayout::KeyPair, record.data(), record.size(),
                                        &first, &second, &payload) &&
                dictionary.phrases.AppendRecord(record.data(), record.size(), id), "assemble a native KeyPair fixture record");
        const auto link = [&](IndexRange& range) {
            return range.count == 0
                ? CreateIndexRange(dictionary.range_metadata, dictionary.range_cells, static_cast<std::uint32_t>(id), range)
                : InsertIndexRange(dictionary.range_metadata, dictionary.range_cells, static_cast<std::uint32_t>(id),
                                     range.count, range);
        };
        Require(link(a_range) && (first == second || link(b_range)), "link the shared fixture record into its endpoint lists");
    };
    append(b, a, "\x21\x22\x23\x24\x25\x26"sv);
    append(a, a, "\x31\x32\x33\x34\x35\x36"sv);
    append(a, b, "\x11\x12\x13\x14\x15\x16"sv);
    const auto publish = [&](std::string_view key, const IndexRange& range) {
        OwnedByteRegion value;
        std::uint32_t id = 0;
        Require(ReadTrieValueByKey(trie, dictionary.trie.values, key, id, value) &&
                PatchAssociationValue(value.MutableData(), value.Size(), true, &range, nullptr) &&
                UpdateTrieValueByKey(trie, dictionary.trie.values, key, value), "publish the real packed fixture range");
    };
    publish("a", a_range);
    publish("b", b_range);
    dictionary.metadata.set_association_count(3);
}
std::string Payload(const SingleTrieMutableDictionaryStorage& dictionary,
                    std::string_view first, std::string_view second) {
    OwnedByteRegion result;
    Require(ReadSingleTrieAssociationPayload(dictionary, first, second, result), "read the existing ordered pair");
    return {reinterpret_cast<const char*>(result.Data()), result.Size()};
}
}
int main(int argc, char** argv) {
    Require(argc == 2, "provide a new project-local directory for the actual files");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> fixture;
    SeedNativeRecordFixture(fixture.dictionary);
    fixture.metadata.set_total_count(300);
    fixture.metadata.set_last_sync_time(42);
    const auto original_path = std::string(argv[1]) + "/single-original.bin";
    const auto updated_path = std::string(argv[1]) + "/single-updated.bin";
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> mapped, retained;
    Require(PersistUserDictionaryFile(fixture, original_path) &&
            LoadUserDictionaryFile(original_path, mapped) == DictionaryFileLoadResult::Loaded &&
            DuplicateUserDictionary(mapped, retained), "persist, map and retain the actual three-relation fixture");
    const auto metadata = mapped.dictionary.metadata.SerializeAsString();
    const auto replacement = "\xaa\xbb\xcc\xdd\xee\xff"sv;
    Require(UpdateSingleTrieAssociationPayload(mapped.dictionary, "a", "b", replacement) &&
            Payload(mapped.dictionary, "a", "b") == replacement &&
            Payload(mapped.dictionary, "b", "a") == "\x21\x22\x23\x24\x25\x26"sv &&
            Payload(mapped.dictionary, "a", "a") == "\x31\x32\x33\x34\x35\x36"sv &&
            mapped.dictionary.metadata.SerializeAsString() == metadata &&
            Payload(retained.dictionary, "a", "b") == "\x11\x12\x13\x14\x15\x16"sv,
            "update the ordered pair after mapping, preserving reverse/self records, counters and the retained model");
    Require(!UpdateSingleTrieAssociationPayload(mapped.dictionary, "b", "b", replacement) &&
            mapped.dictionary.phrases.RecordCount() == 3,
            "the native existing-only mode leaves a missing pair absent");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> reloaded;
    Require(PersistUserDictionaryFile(mapped, updated_path) &&
            LoadUserDictionaryFile(updated_path, reloaded) == DictionaryFileLoadResult::Loaded &&
            Payload(reloaded.dictionary, "a", "b") == replacement && reloaded.metadata.total_count() == 300 &&
            reloaded.dictionary.metadata.SerializeAsString() == metadata,
            "save the edited SingleTrie to a distinct file and reload its payload and independent counts");
    mapped = {};
    reloaded = {};
    Require(std::remove(original_path.c_str()) == 0 && std::remove(updated_path.c_str()) == 0,
            "remove only the two files created by this flow");
    std::puts("PASS: SingleTrie ordered existing payload update/map/persist/reload flow");
}
