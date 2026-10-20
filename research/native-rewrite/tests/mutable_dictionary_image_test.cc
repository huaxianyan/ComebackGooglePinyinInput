// One real create/save/load/edit flow for the current six-submodel container.
#include "mutable_dictionary_image.h"
#include "association_editor.h"
#include "trie_values.h"

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
bool At(const OwnedByteRegion& image, std::size_t offset, std::string_view expected) {
    return offset <= image.Size() && expected.size() <= image.Size() - offset &&
           std::memcmp(image.Data() + offset, expected.data(), expected.size()) == 0;
}

struct Editors {
    explicit Editors(MutableDictionaryStorage& d)
        : ft(d.forward.metadata.Data(), d.forward.metadata.Size(),
             d.forward.nodes.MutableData(), d.forward.nodes.Size()),
          rt(d.reverse.metadata.Data(), d.reverse.metadata.Size(),
             d.reverse.nodes.MutableData(), d.reverse.nodes.Size()),
          fs{ft, d.forward.values, d.forward_pool_metadata, d.forward_pool_cells, d.forward_records},
          rs{rt, d.reverse.values, d.reverse_pool_metadata, d.reverse_pool_cells, d.reverse_records},
          forward{fs, d.forward.metadata, d.forward.nodes, d.metadata.key_checksum_enabled()},
          reverse{rs, d.reverse.metadata, d.reverse.nodes, d.metadata.key_checksum_enabled()} {}
    DATrieView ft, rt;
    AssociationSide fs, rs;
    AssociationEditor forward, reverse;
};

std::string Payload(const AssociationSide& source, const AssociationSide& opposite,
                    std::string_view key, std::string_view target) {
    OwnedByteRegion value;
    std::uint32_t terminal = 0;
    IndexRange range{};
    AssociationRecordLocation location{};
    const IndexPoolView pool(source.metadata.Data(), source.metadata.Size(),
                             source.cells.MutableData(), source.cells.Size());
    const std::uint8_t* record = nullptr;
    std::size_t size = 0;
    Require(ReadTrieValueByKey(source.trie, source.values, key, terminal, value) &&
            DecodeAssociationReference(value.Data(), value.Size(), range) &&
            FindAssociationRecord(source.records, pool, range, opposite.trie.FindTerminal(target), location) &&
            source.records.ReadRecord(location.record_id, record, size) && size >= 4,
            "reading a relation through loaded trie, value table, pool and phrase records");
    return std::string(reinterpret_cast<const char*>(record + 4), size - 4);
}
}  // namespace

int main() {
    MutableDictionaryStorage dictionary;
    // Frozen tags 1,2,3,4,6 and unknown tag 9; count is initially absent.
    const auto metadata = "\x08\x06\x10\x02\x18\0\x20\x01\x30\x01\x48\x07"sv;
    Require(dictionary.metadata.ParseFromArray(metadata.data(), metadata.size()), "load literal metadata");
    dictionary.forward.values = FixedPhraseTable(6);
    dictionary.reverse.values = FixedPhraseTable(8);
    dictionary.forward_records = FixedPhraseTable(10);
    dictionary.reverse_records = FixedPhraseTable(4);
    Require(InitializeDATrie(dictionary.forward.metadata, dictionary.forward.nodes, "ab", 0xff) &&
            InitializeDATrie(dictionary.reverse.metadata, dictionary.reverse.nodes, "ab", 0xff) &&
            InitializeIndexPool(dictionary.forward_pool_metadata, dictionary.forward_pool_cells) &&
            InitializeIndexPool(dictionary.reverse_pool_metadata, dictionary.reverse_pool_cells) &&
            dictionary.forward.values.Initialize() && dictionary.reverse.values.Initialize() &&
            dictionary.forward_records.Initialize() && dictionary.reverse_records.Initialize(),
            "initialize all six real dictionary submodels");
    OwnedByteRegion empty;
    Require(SerializeMutableDictionary(dictionary, empty), "save the initialized empty container");
    // Independent frozen layout: metadata=16, each named trie=2680, each pool=32,
    // each named empty phrase table=32. No production size/tag helper computes expectations.
    const auto variable = "\x17\0\0\0" "VariableValueLengthTrie" "\0\0\0\0\0"sv;
    const auto datrie = "\x06\0\0\0" "DATrie" "\0\0\0\0\0\0"sv;
    const auto fixed = "\x10\0\0\0" "FixedPhraseTable" "\0\0\0\0"sv;
    const auto da_header = "DA-TRIE\0\x44\x78\xad\x34\x0f\x0f\xd8\x04"sv;
    Require(empty.Size() == 5504 && At(empty, 0, "\x0c\0\0\0"sv) && At(empty, 4, metadata) &&
            At(empty, 16, variable) && At(empty, 48, datrie) && At(empty, 64, da_header) &&
            At(empty, 2664, fixed) && At(empty, 2688, "\0\0\0\0\x06\0\0\0"sv) &&
            At(empty, 2696, variable) && At(empty, 2728, datrie) && At(empty, 2744, da_header) &&
            At(empty, 5344, fixed) && At(empty, 5368, "\0\0\0\0\x08\0\0\0"sv) &&
            At(empty, 5376, "P-TABLE\0"sv) && At(empty, 5408, "P-TABLE\0"sv) &&
            At(empty, 5440, fixed) && At(empty, 5464, "\0\0\0\0\x0a\0\0\0"sv) &&
            At(empty, 5472, fixed) && At(empty, 5496, "\0\0\0\0\x04\0\0\0"sv),
            "the empty image has the native named/nested tags, six-model order and literal offsets");
    const auto payload = "\x11\x22\x33\x44\x55\x66"sv;
    const auto extra = "\xde\xf0"sv;
    {
        Editors editors(dictionary);
        Require(ModifyDictionaryAssociation(editors.forward, editors.reverse, dictionary.metadata,
                    "a", "b", &payload, &extra, AssociationEditMode::CreateOrUpdate),
                "create a real bidirectional relation before persistence");
    }
    OwnedByteRegion first;
    Require(SerializeMutableDictionary(dictionary, first), "save all edited submodels");
    const std::string original(reinterpret_cast<const char*>(first.Data()), first.Size());
    MutableDictionaryStorage loaded;
    Require(LoadMutableDictionary(first, loaded) == first.Size() &&
            loaded.metadata.SerializeAsString() ==
                "\x08\x06\x10\x02\x18\0\x20\x01\x28\x01\x30\x01\x48\x07"sv,
            "reload preserves count presence, configuration and unknown protobuf fields");
    const auto replacement = "\xaa\xbb\xcc\xdd\xee\xff"sv;
    {
        Editors editors(loaded);  // Rebuild all borrowed views after loading/COW.
        Require(Payload(editors.fs, editors.rs, "a", "b") == payload &&
                Payload(editors.rs, editors.fs, "b", "a").empty() &&
                ModifyDictionaryAssociation(editors.forward, editors.reverse, loaded.metadata,
                    "a", "b", &replacement, nullptr, AssociationEditMode::ExistingOnly) &&
                ModifyDictionaryAssociation(editors.forward, editors.reverse, loaded.metadata,
                    "b", "a", &payload, &extra, AssociationEditMode::CreateOrUpdate),
                "read both directions, update the existing payload and add a second relation after load");
    }
    OwnedByteRegion second;
    MutableDictionaryStorage reloaded;
    Require(SerializeMutableDictionary(loaded, second) &&
            LoadMutableDictionary(second, reloaded) == second.Size() &&
            reloaded.metadata.association_count() == 2 &&
            original.size() == first.Size() && std::memcmp(original.data(), first.Data(), first.Size()) == 0,
            "save the second generation while keeping the source image unchanged");
    Require(LoadMutableDictionary(second.Slice(0, second.Size() - 1), reloaded) == 0 &&
            reloaded.metadata.association_count() == 2,
            "an incomplete last submodel keeps the previously loaded dictionary, matching native publication");
    Editors final(reloaded);
    Require(Payload(final.fs, final.rs, "a", "b") == replacement &&
            Payload(final.fs, final.rs, "b", "a") == payload,
            "the second generation and the retained dictionary expose both expected payloads");
    std::puts("PASS: six-model mutable dictionary layout, real edit/save/load/edit and failed-load retention");
}
