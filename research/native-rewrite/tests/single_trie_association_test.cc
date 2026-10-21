// One real SingleTrie create/update/relocate/delete/map/persist/reload flow.
#include "single_trie_association.h"
#include "single_trie_mutable_dictionary_init.h"
#include "datrie_view.h"
#include "trie_values.h"
#include "user_dictionary_file.h"
#include "user_dictionary_edit.h"
#include "user_dictionary_learning.h"
#include "user_dictionary_compaction.h"
#include "dictionary_association_iteration.h"
#include "single_trie_user_dictionary_model.h"
#include "file_mmap.h"
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
    std::vector<DictionaryAssociationEntry> initial_entries;
    Require(SnapshotDictionaryAssociations(user.dictionary, initial_entries) && initial_entries.size() == 4 &&
            initial_entries[0].forward_key == "a" && initial_entries[0].reverse_key == "a" &&
            initial_entries[1].forward_key == "a" && initial_entries[1].reverse_key == "b" &&
            initial_entries[2].forward_key == "b" && initial_entries[2].reverse_key == "b" &&
            initial_entries[3].forward_key == "b" && initial_entries[3].reverse_key == "a" &&
            initial_entries[0].payload == EncodedPayload({49, 50, 51, 52, 53, 54}) &&
            initial_entries[1].payload == EncodedPayload({17, 18, 19, 20, 21, 22}),
            "snapshot emits ordered/self pairs once in trie and pool order, skipping second-endpoint references");
    user.metadata.set_total_count(300);
    user.metadata.set_last_sync_time(42);
    const auto original_path = std::string(argv[1]) + "/single-original.bin";
    const auto updated_path = std::string(argv[1]) + "/single-updated.bin";
    const auto deleted_path = std::string(argv[1]) + "/single-deleted.bin";
    const auto policy_path = std::string(argv[1]) + "/single-policy.bin";
    const auto learned_path = std::string(argv[1]) + "/single-learned.bin";
    const auto compacted_path = std::string(argv[1]) + "/single-compacted.bin";
    const auto owned_path = std::string(argv[1]) + "/single-owned.bin";
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
    const auto shared_before = Terminal(mapped.dictionary, "a");
    const auto reverse_before = Terminal(mapped.dictionary, "b");
    std::vector<std::uint32_t> before_direct;
    for (int i = 0; i < 96; ++i) before_direct.push_back(Terminal(mapped.dictionary, "a" + std::to_string(i)));
    OwnedByteRegion empty_value;
    Require(empty_value.Resize(6), "prepare a literal empty association value for direct lower-editor insertion");
    auto* empty_bytes = empty_value.MutableData();
    Require(empty_bytes != nullptr, "obtain the fixture value bytes");
    for (unsigned i = 0; i < 6; ++i) empty_bytes[i] = 0;
    DATrieView direct(mapped.dictionary.trie.metadata.Data(), mapped.dictionary.trie.metadata.Size(),
        const_cast<std::uint8_t*>(mapped.dictionary.trie.nodes.Data()), mapped.dictionary.trie.nodes.Size());
    for (unsigned byte = 128; byte < 192; ++byte) {
        std::string key = "a";
        key.push_back(static_cast<char>(byte));
        Require(InsertTrieValue(direct, mapped.dictionary.trie.metadata, mapped.dictionary.trie.nodes,
                    mapped.dictionary.trie.values, key, empty_value, nullptr, &editor.node_moved),
                "use the editor-owned callback during direct lower-trie insertion between association operations");
    }
    bool direct_moved = Terminal(mapped.dictionary, "a") != shared_before ||
                        Terminal(mapped.dictionary, "b") != reverse_before;
    for (int i = 0; i < 96; ++i) {
        direct_moved = direct_moved || Terminal(mapped.dictionary, "a" + std::to_string(i)) != before_direct[i];
    }
    Require(direct_moved, "direct lower-trie insertion actually relocates an endpoint belonging to existing relations");
    Require(Payload(mapped.dictionary, "a", "a") == self && Payload(mapped.dictionary, "a", "b") == replacement &&
            Payload(mapped.dictionary, "b", "a") == reverse,
            "the persistent callback repairs real moved shared endpoints through a freshly rebound live view");
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
    SingleTrieAssociationEditor deletion{reloaded.dictionary};
    OwnedByteRegion missing;
    Require(RemoveSingleTrieAssociation(deletion, "a", "b") &&
            !ReadSingleTrieAssociationPayload(reloaded.dictionary, "a", "b", missing) &&
            Payload(reloaded.dictionary, "b", "a") == reverse && Payload(reloaded.dictionary, "a", "a") == self &&
            reloaded.dictionary.metadata.association_count() == 196 &&
            !RemoveSingleTrieAssociation(deletion, "a", "b") && reloaded.dictionary.metadata.association_count() == 196,
            "remove only the ordered relation and retain the reverse/self pairs when deleting it again fails");
    Require(RemoveSingleTrieAssociation(deletion, "b", "b") &&
            Payload(reloaded.dictionary, "b", "a") == reverse &&
            RemoveSingleTrieAssociation(deletion, "b", "a") && Terminal(reloaded.dictionary, "b") == 0 &&
            Payload(reloaded.dictionary, "a", "a") == self,
            "remove a self-pair once, then prune its endpoint after its last directed relation is removed");
    Require(RemoveSingleTrieAssociation(deletion, "a95", "a") &&
            Payload(reloaded.dictionary, "a95", "a95") == self &&
            RemoveSingleTrieAssociation(deletion, "a95", "a95") && Terminal(reloaded.dictionary, "a95") == 0 &&
            reloaded.dictionary.metadata.association_count() == 192 && reloaded.dictionary.phrases.RecordCount() == 197 &&
            Payload(retained.dictionary, "a", "b") == forward,
            "delete the final self-list and preserve allocated records and the retained model");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> final;
    Require(PersistUserDictionaryFile(reloaded, deleted_path) &&
            LoadUserDictionaryFile(deleted_path, final) == DictionaryFileLoadResult::Loaded &&
            final.dictionary.metadata.association_count() == 192 && final.dictionary.phrases.RecordCount() == 197 &&
            Terminal(final.dictionary, "b") == 0 && Terminal(final.dictionary, "a95") == 0 &&
            Payload(final.dictionary, "a94", "a") == reverse && final.metadata.total_count() == 300 &&
            final.metadata.last_sync_time() == 42,
            "reload the physically deleted model with remaining relations and independent outer metadata");
    SingleTrieAssociationEditor policy{final.dictionary};
    const auto prepare = [&](std::string_view key, std::string_view payload) {
        Require(ModifySingleTrieAssociation(policy, key, "a", &payload, AssociationEditMode::ExistingOnly),
                "set literal current payload flags and weight through the real existing editor");
    };
    prepare("a94", "\x07\0\0\x58\x01\0"sv);
    Require(RemoveUserDictionaryAssociation(final, "a94", "a", true, policy), "retain the user-model deleted marker");
    const auto marker = Payload(final.dictionary, "a94", "a");
    Require(marker.size() == 6 && marker.substr(0, 4) == "\0\0\0\xd8"sv &&
            final.metadata.total_count() == 293 && final.dictionary.metadata.association_count() == 192 &&
            !RemoveUserDictionaryAssociation(final, "a94", "a", true, policy) &&
            Payload(final.dictionary, "a94", "a") == marker && final.metadata.total_count() == 293,
            "mark count zero, set flag31, preserve flag30/flag27/category and subtract seven only once");
    Require(RemoveUserDictionaryAssociation(final, "a94", "a", false, policy) &&
            final.metadata.total_count() == 293 && final.dictionary.metadata.association_count() == 191,
            "physically remove an existing zero-count marker without a second weight deduction");
    prepare("a93", "\x09\0\0\x60\x01\0"sv);
    Require(RemoveUserDictionaryAssociation(final, "a93", "a", true, policy) &&
            Payload(final.dictionary, "a93", "a").substr(0, 4) == "\0\0\0\xe0"sv &&
            final.metadata.total_count() == 293 && final.dictionary.metadata.association_count() == 191,
            "category two retains its marker and skips the outer weight adjustment");
    prepare("a92", "\x0b\0\0\0\x01\0"sv);
    Require(RemoveUserDictionaryAssociation(final, "a92", "a", false, policy) &&
            final.metadata.total_count() == 282, "physical user-model deletion subtracts the original weight eleven");
    prepare("a91", "\x09\0\0\x60\x01\0"sv);
    Require(RemoveUserDictionaryAssociation(final, "a91", "a", false, policy) &&
            final.metadata.total_count() == 282 && final.dictionary.metadata.association_count() == 189 &&
            final.dictionary.phrases.RecordCount() == 197,
            "category two also skips weight adjustment during physical deletion");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> policy_loaded;
    Require(PersistUserDictionaryFile(final, policy_path) &&
            LoadUserDictionaryFile(policy_path, policy_loaded) == DictionaryFileLoadResult::Loaded &&
            Payload(policy_loaded.dictionary, "a93", "a") == Payload(final.dictionary, "a93", "a") &&
            !ReadSingleTrieAssociationPayload(policy_loaded.dictionary, "a94", "a", missing) &&
            policy_loaded.metadata.total_count() == 282 && policy_loaded.metadata.last_sync_time() == 42 &&
            policy_loaded.dictionary.metadata.association_count() == 189,
            "reload the kept marker, physical deletions and separately accumulated user weight");
    SingleTrieAssociationEditor learning{policy_loaded.dictionary};
    Require(AddUserDictionaryCount(policy_loaded, "learn", "a", 5, true, true, 1, 1, learning) &&
            Payload(policy_loaded.dictionary, "learn", "a").substr(0, 4) == "\x05\0\0\xd8"sv &&
            policy_loaded.metadata.total_count() == 287 && policy_loaded.dictionary.metadata.association_count() == 190,
            "learn a missing pair through the fallback insertion with literal flags and weight five");
    Require(AddUserDictionaryCount(policy_loaded, "learn", "a", 3, false, false, 1, 1, learning) &&
            Payload(policy_loaded.dictionary, "learn", "a").substr(0, 4) == "\x08\0\0\xd0"sv &&
            policy_loaded.metadata.total_count() == 290,
            "accumulate three on an existing pair, preserve old flag30 and replace flag27");
    const auto unchanged = Payload(policy_loaded.dictionary, "learn", "a");
    Require(UpdateExistingUserDictionaryCount(policy_loaded, "learn", "a", 8, false, true, 1, learning) &&
            AddUserDictionaryCount(policy_loaded, "learn", "a", 4, false, true, 3, 1, learning) &&
            Payload(policy_loaded.dictionary, "learn", "a") == unchanged && policy_loaded.metadata.total_count() == 290,
            "same count/category and lower-priority requests succeed without refreshing flags or day");
    Require(EnsureUserDictionaryCount(policy_loaded, "promote", "a", 4, false, false, false, 0, 2, learning) &&
            !AddUserDictionaryCount(policy_loaded, "promote", "a", 2, false, false, 0, 2, learning) &&
            policy_loaded.metadata.total_count() == 294 &&
            Payload(policy_loaded.dictionary, "promote", "a").substr(0, 4) == "\x04\0\0\0"sv,
            "raw state byte two permits Ensure but not Add's low-bit gate");
    Require(AddUserDictionaryCount(policy_loaded, "promote", "a", 2, true, true, 1, 1, learning) &&
            Payload(policy_loaded.dictionary, "promote", "a").substr(0, 4) == "\x06\0\0\x88"sv &&
            policy_loaded.metadata.total_count() == 296,
            "the category-zero/request-one exception accumulates while retaining effective category zero");
    Require(AddUserDictionaryCount(policy_loaded, "a93", "a", 5, false, false, 2, 1, learning) &&
            Payload(policy_loaded.dictionary, "a93", "a").substr(0, 4) == "\x01\0\0\xe0"sv &&
            policy_loaded.metadata.total_count() == 296 &&
            AddUserDictionaryCount(policy_loaded, "a93", "a", 4, false, true, 0, 1, learning) &&
            Payload(policy_loaded.dictionary, "a93", "a").substr(0, 4) == "\x04\0\0\xc8"sv &&
            policy_loaded.metadata.total_count() == 300,
            "category two collapses to one without weight, then contributes only the replacement count on transition");
    Require(UpdateExistingUserDictionaryCount(policy_loaded, "learn", "a", 2147483647, true, false, 1, learning) &&
            Payload(policy_loaded.dictionary, "learn", "a").substr(0, 4) == "\0\0\0\xd0"sv &&
            policy_loaded.metadata.total_count() == 292,
            "native 32-bit addition wraps negative before clamping to zero and subtracting the old eight");
    Require(EnsureUserDictionaryCount(policy_loaded, "learn", "a", 536870912, true, true, false, 1, 1, learning) &&
            Payload(policy_loaded.dictionary, "learn", "a").substr(0, 4) == "\xff\xff\xff\xd7"sv &&
            policy_loaded.metadata.total_count() == 536871204,
            "codec saturation preserves native accounting of the pre-encoding count");
    Require(EnsureUserDictionaryCount(policy_loaded, "promote", "a", 0, false, false, false, 0, 1, learning) &&
            !ReadSingleTrieAssociationPayload(policy_loaded.dictionary, "promote", "a", missing) &&
            policy_loaded.metadata.total_count() == 536871198 &&
            policy_loaded.dictionary.metadata.association_count() == 190 && policy_loaded.dictionary.phrases.RecordCount() == 199 &&
            Payload(final.dictionary, "a93", "a").substr(0, 4) == "\0\0\0\xe0"sv && final.metadata.total_count() == 282,
            "Ensure zero physically removes the pair while retaining the mapped model's prior marker and weight");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> learned;
    Require(PersistUserDictionaryFile(policy_loaded, learned_path) &&
            LoadUserDictionaryFile(learned_path, learned) == DictionaryFileLoadResult::Loaded &&
            Payload(learned.dictionary, "learn", "a") == Payload(policy_loaded.dictionary, "learn", "a") &&
            Payload(learned.dictionary, "a93", "a").substr(0, 4) == "\x04\0\0\xc8"sv &&
            learned.metadata.total_count() == 536871198 && learned.metadata.last_sync_time() == 42 &&
            learned.dictionary.metadata.association_count() == 190,
            "persist and reload learned bytes independently from the native outer accumulator");
    auto compact_source = retained;
    compact_source.metadata.set_total_count(151);
    SingleTrieAssociationEditor compact_editor{compact_source.dictionary};
    const auto marker_payload = "\0\0\0\x80\x04\0"sv;
    const auto heavy = "\x96\0\0\0\x01\0"sv;
    const auto inactive = "\0\0\0\0\x05\0"sv;
    const auto light = "\x01\0\0\0\x03\0"sv;
    Require(ModifySingleTrieAssociation(compact_editor, "a", "a", &marker_payload, AssociationEditMode::ExistingOnly) &&
            ModifySingleTrieAssociation(compact_editor, "a", "b", &heavy, AssociationEditMode::ExistingOnly) &&
            ModifySingleTrieAssociation(compact_editor, "b", "b", &inactive, AssociationEditMode::ExistingOnly) &&
            ModifySingleTrieAssociation(compact_editor, "b", "a", &light, AssociationEditMode::ExistingOnly) &&
            CompactUserDictionaryAtCutoff(compact_source, 3, 2, compact_editor) &&
            compact_source.dictionary.metadata.association_count() == 2 && compact_source.metadata.total_count() == 1 &&
            compact_source.dictionary.phrases.RecordCount() == 4 &&
            Payload(compact_source.dictionary, "a", "a") == marker_payload &&
            Payload(compact_source.dictionary, "b", "a") == light &&
            !ReadSingleTrieAssociationPayload(compact_source.dictionary, "a", "b", missing) &&
            !ReadSingleTrieAssociationPayload(compact_source.dictionary, "b", "b", missing) &&
            Payload(retained.dictionary, "a", "a") == self && Payload(retained.dictionary, "a", "b") == forward,
            "compact shared records once, keeping the newer marker/light pair and removing old weight plus inactive self");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> compacted;
    Require(PersistUserDictionaryFile(compact_source, compacted_path) &&
            LoadUserDictionaryFile(compacted_path, compacted) == DictionaryFileLoadResult::Loaded &&
            Payload(compacted.dictionary, "a", "a") == marker_payload && Payload(compacted.dictionary, "b", "a") == light &&
            compacted.metadata.total_count() == 1 && compacted.dictionary.metadata.association_count() == 2,
            "persist and reload the actual selected marker and directed relationship");
    SingleTrieAssociationEditor clock_compact{compacted.dictionary};
    Require(CompactUserDictionary(compacted, 3, clock_compact) && compacted.metadata.total_count() == 0 &&
            compacted.dictionary.metadata.association_count() == 0 && compacted.dictionary.phrases.RecordCount() == 4 &&
            Terminal(compacted.dictionary, "a") == 0 && Terminal(compacted.dictionary, "b") == 0 &&
            PersistUserDictionaryFile(compacted, compacted_path),
            "real-clock compact expires the 1970 entries, removes empty endpoints and persists the empty model");
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> empty_compacted;
    std::vector<DictionaryAssociationEntry> empty_entries;
    Require(LoadUserDictionaryFile(compacted_path, empty_compacted) == DictionaryFileLoadResult::Loaded &&
            SnapshotDictionaryAssociations(empty_compacted.dictionary, empty_entries) && empty_entries.empty() &&
            empty_compacted.metadata.total_count() == 0 && empty_compacted.metadata.last_sync_time() == 42,
            "reload the empty live traversal despite retained fixed-table records");
    OwnedByteRegion owner_chunk;
    std::unique_ptr<SingleTrieUserDictionaryModel> active;
    Require(MapReadOnlyFile(original_path, owner_chunk) == FileMappingResult::Mapped &&
            LoadSingleTrieUserDictionaryModel(owner_chunk, active) == owner_chunk.Size() &&
            active->edit_flags == 1 && active->editor.record_buffer.Size() == 14 &&
            active->editor.first_value.Size() == 6 && active->editor.second_value.Size() == 6,
            "publish mapped storage together with its native-sized persistent editor scratch");
    const auto owner_weight = "\x05\0\0\0\x01\0"sv;
    Require(ModifySingleTrieAssociation(active->editor, "a", "b", &owner_weight, AssociationEditMode::ExistingOnly),
            "edit through the coordinator bound to owned storage");
    active->storage.metadata.set_total_count(5);
    Require(AddUserDictionaryCount(active->storage, "a", "b", 2, false, false, 0, active->edit_flags, active->editor) &&
            Payload(active->storage.dictionary, "a", "b").substr(0, 4) == "\x07\0\0\x80"sv &&
            active->storage.metadata.total_count() == 7, "reuse the same owned editor for the next count operation");
    auto retained_owner = active->storage;
    auto* previous_model = active.get();
    auto header_only = owner_chunk.Slice(0, 16);
    Require(LoadSingleTrieUserDictionaryModel(header_only, active) == 0 && active.get() == previous_model &&
            active->storage.metadata.total_count() == 7 &&
            Payload(active->storage.dictionary, "a", "b").substr(0, 4) == "\x07\0\0\x80"sv,
            "failed candidate loading preserves the previously published model and usable editor");
    header_only = {};
    owner_chunk = {};
    Require(MapReadOnlyFile(updated_path, owner_chunk) == FileMappingResult::Mapped &&
            LoadSingleTrieUserDictionaryModel(owner_chunk, active) == owner_chunk.Size() &&
            active->storage.dictionary.metadata.association_count() == 197 && active->storage.metadata.total_count() == 300,
            "replace the live model with another validated image and a newly bound editor");
    owner_chunk = {};
    Require(AddUserDictionaryCount(active->storage, "owned", "a", 3, false, false, 0,
                                   active->edit_flags, active->editor) &&
            active->storage.metadata.total_count() == 303 &&
            active->storage.dictionary.metadata.association_count() == 198 &&
            PersistUserDictionaryFile(active->storage, owned_path),
            "mutate the replacement model after releasing its input mapping handle and persist it");
    active.reset();
    Require(retained_owner.metadata.total_count() == 7 &&
            Payload(retained_owner.dictionary, "a", "b").substr(0, 4) == "\x07\0\0\x80"sv &&
            MapReadOnlyFile(owned_path, owner_chunk) == FileMappingResult::Mapped &&
            LoadSingleTrieUserDictionaryModel(owner_chunk, active) == owner_chunk.Size() &&
            Payload(active->storage.dictionary, "owned", "a").substr(0, 4) == "\x03\0\0\x80"sv &&
            active->storage.metadata.total_count() == 303 && active->storage.metadata.last_sync_time() == 42,
            "retained data survives model destruction, and the persisted replacement acquires its own editor on reload");
    owner_chunk = {};
    active.reset();
    mapped = {};
    reloaded = {};
    final = {};
    policy_loaded = {};
    learned = {};
    compacted = {};
    empty_compacted = {};
    Require(std::remove(original_path.c_str()) == 0 && std::remove(updated_path.c_str()) == 0 &&
            std::remove(deleted_path.c_str()) == 0 && std::remove(policy_path.c_str()) == 0 &&
            std::remove(learned_path.c_str()) == 0 && std::remove(compacted_path.c_str()) == 0 &&
            std::remove(owned_path.c_str()) == 0, "remove only the seven files created by this flow");
    std::puts("PASS: SingleTrie real CRUD/learning/compact/model ownership/map/persist/reload flow");
}
