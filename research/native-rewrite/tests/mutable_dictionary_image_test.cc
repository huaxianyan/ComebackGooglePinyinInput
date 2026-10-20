// One real create/save/load/edit flow for the current six-submodel container.
#include "mutable_dictionary_image.h"
#include "user_dictionary_image.h"
#include "user_dictionary_file.h"
#include "payload_codec.h"
#include "association_editor.h"
#include "trie_values.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <iterator>
#include <string>
#include <string_view>
#include <utility>

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

int main(int argc, char** argv) {
    Require(argc == 2, "provide a newly created project-local directory for real file tests");
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
    {
        Editors final(reloaded);
        Require(Payload(final.fs, final.rs, "a", "b") == replacement &&
                Payload(final.fs, final.rs, "b", "a") == payload,
                "the second generation and the retained dictionary expose both expected payloads");
    }

    UserDictionaryStorage user;
    user.dictionary = std::move(reloaded);
    const auto outer = "\x08\x96\x01\x10\x2a\x1a\x02\0\xff\x48\x07"sv;
    Require(user.metadata.ParseFromArray(outer.data(), outer.size()), "load literal outer metadata");
    const auto weight150 = "\x96\0\0\0\x01\0"sv;
    const auto weight1 = "\x01\0\0\0\x02\0"sv;
    {
        Editors edit(user.dictionary);
        Require(RemoveDictionaryAssociation(edit.forward, edit.reverse, user.dictionary.metadata, "b", "a") &&
                ModifyDictionaryAssociation(edit.forward, edit.reverse, user.dictionary.metadata,
                    "a", "b", &weight150, nullptr, AssociationEditMode::ExistingOnly),
                "prepare one relation with a real six-byte current payload for the user-file flow");
    }
    OwnedByteRegion user_first;
    Require(SerializeUserDictionaryImage(user, user_first) &&
            At(user_first, 0, "\x96\xa4\xcb\xa7\0\0\0\0\x03\0\0\0\x01\0\0\0"sv) &&
            At(user_first, 16, "\x0b\0\0\0\x08\x96\x01\x10\x2a\x1a\x02\0\xff\x48\x07\0"sv) &&
            At(user_first, 32, "\x0e\0\0\0"sv),
            "complete file bytes have the literal current header and outer/inner protobuf boundaries");
    UserDictionaryStorage user_loaded;
    Require(DuplicateUserDictionary(user, user_loaded) &&
            user_loaded.metadata.SerializeAsString() == outer &&
            user_loaded.dictionary.metadata.association_count() == 1,
            "duplicate through the real memory-image factory path, preserving both independent counts");
    {
        Editors edit(user_loaded.dictionary);
        const auto stored = Payload(edit.fs, edit.rs, "a", "b");
        PayloadMetadata decoded{};
        std::uint16_t day = 0;
        Require(DecodePayload(PayloadVersion::V21,
                    reinterpret_cast<const std::uint8_t*>(stored.data()), stored.size(), decoded, &day) &&
                decoded.count == 150 && day == 1 &&
                ModifyDictionaryAssociation(edit.forward, edit.reverse, user_loaded.dictionary.metadata,
                    "b", "a", &weight1, &extra, AssociationEditMode::CreateOrUpdate),
                "read the real current payload and add another relation after loading the full image");
    }
    // Outer learning accumulation remains the caller's explicit metadata edit;
    // the low-level association coordinator does not invent that higher layer.
    user_loaded.metadata.set_total_count(151);
    user_loaded.metadata.set_last_sync_time(4294967296LL);
    OwnedByteRegion unchanged_source;
    Require(SerializeUserDictionaryImage(user, unchanged_source) &&
            unchanged_source.Size() == user_first.Size() &&
            std::memcmp(unchanged_source.Data(), user_first.Data(), user_first.Size()) == 0,
            "editing the duplicate leaves the original complete dictionary byte-for-byte unchanged");
    OwnedByteRegion user_second;
    UserDictionaryStorage user_final;
    Require(SerializeUserDictionaryImage(user_loaded, user_second) &&
            LoadUserDictionaryImage(user_second, user_final) == user_second.Size() &&
            user_final.metadata.total_count() == 151 && user_final.metadata.last_sync_time() == 4294967296LL &&
            user_final.metadata.extension_data() == std::string("\0\xff", 2) &&
            user_final.dictionary.metadata.association_count() == 2,
            "save and load a second complete image with outer metadata and both relations");

    // Native 0x1a2b38 compares bytes consumed with 0x1c6994's canonical size.
    // Four redundant known count fields add eight bytes to the inner protobuf
    // frame; all table bytes and CRCs remain intact, but its canonical size shrinks.
    std::string expanded(reinterpret_cast<const char*>(user_first.Data()), 32);
    expanded.append("\x16\0\0\0", 4);
    expanded.append(reinterpret_cast<const char*>(user_first.Data() + 36), 14);
    expanded.append("\x28\x01\x28\x01\x28\x01\x28\x01", 8);
    expanded.append(reinterpret_cast<const char*>(user_first.Data() + 50), user_first.Size() - 50);
    OwnedByteRegion noncanonical;
    Require(noncanonical.Resize(expanded.size()), "allocate the frozen size-mismatch fixture");
    std::memcpy(noncanonical.MutableData(), expanded.data(), expanded.size());
    Require(LoadUserDictionaryImage(noncanonical, user_final) == 0 &&
            user_final.metadata.total_count() == 151 && user_final.dictionary.metadata.association_count() == 2,
            "native canonical-size mismatch keeps the previously loaded complete user dictionary");
    user_loaded.dictionary.metadata.set_forward_payload_size(5);
    OwnedByteRegion wrong_payload;
    Require(SerializeUserDictionaryImage(user_loaded, wrong_payload) &&
            LoadUserDictionaryImage(wrong_payload, user_final) == 0 && user_final.metadata.total_count() == 151,
            "the native user-file payload-width check rejects a non-six-byte declaration before publication");
    Editors checked(user_final.dictionary);
    Require(Payload(checked.fs, checked.rs, "a", "b") == weight150 &&
            Payload(checked.fs, checked.rs, "b", "a") == weight1,
            "both expected payloads remain readable after failed user-file loads");
    const std::string file_path = std::string(argv[1]) + "/dictionary.bin";
    const auto read_file = [&]() {
        std::ifstream stream(file_path, std::ios::binary);
        Require(stream.is_open(), "open the actual persisted file for reading");
        const std::string bytes((std::istreambuf_iterator<char>(stream)), std::istreambuf_iterator<char>());
        Require(!stream.bad(), "read the actual persisted file without an I/O error");
        return bytes;
    };
    Require(PersistUserDictionaryFile(user_final, file_path), "persist a real current dictionary file");
    const auto first_file = read_file();
    Require(first_file.size() == user_second.Size() &&
            std::memcmp(first_file.data(), user_second.Data(), first_file.size()) == 0,
            "file and memory sinks emit identical complete bytes through the shared writer");
    OwnedByteRegion disk_image;
    Require(disk_image.Resize(first_file.size()), "allocate the file-read image");
    std::memcpy(disk_image.MutableData(), first_file.data(), first_file.size());
    UserDictionaryStorage disk_loaded;
    Require(LoadUserDictionaryImage(disk_image, disk_loaded) == disk_image.Size(),
            "load the actual on-disk dictionary through the complete image reader");
    {
        Editors disk_edit(disk_loaded.dictionary);
        Require(RemoveDictionaryAssociation(disk_edit.forward, disk_edit.reverse,
                    disk_loaded.dictionary.metadata, "b", "a"),
                "edit the dictionary read from the real file");
    }
    disk_loaded.metadata.set_total_count(150);
    disk_loaded.metadata.set_last_sync_time(7);
    OwnedByteRegion expected_file;
    Require(SerializeUserDictionaryImage(disk_loaded, expected_file) &&
            expected_file.Size() < first_file.size() && PersistUserDictionaryFile(disk_loaded, file_path),
            "overwrite the original file with a shorter edited generation");
    const auto overwritten = read_file();
    Require(overwritten.size() == expected_file.Size() &&
            std::memcmp(overwritten.data(), expected_file.Data(), overwritten.size()) == 0,
            "wb replacement leaves exactly the shorter image without the old tail");
    Require(!PersistUserDictionaryFile(disk_loaded, argv[1]) && read_file() == overwritten,
            "an actual directory-open failure returns false and leaves the saved file readable");
    // Actual images for the Java/C++ persistence integration consumer. The
    // caller removes these two named artifacts after that consumer finishes.
    const auto export_image = [&](const char* name, const std::string& bytes) {
        std::ofstream stream(std::string(argv[1]) + "/" + name, std::ios::binary);
        stream.write(bytes.data(), bytes.size());
        stream.close();
        Require(!stream.fail(), "export an already verified image for the cross-runtime consumer");
    };
    export_image("generation1.bin", first_file);
    export_image("generation2.bin", overwritten);
    Require(std::remove(file_path.c_str()) == 0, "remove only this test's temporary dictionary file");
    std::puts("PASS: complete image editing, native validation and real file persist/read/edit/overwrite");
}
