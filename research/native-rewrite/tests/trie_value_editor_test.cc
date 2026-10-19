#include "../recovered/association_records.h"
#include "../recovered/trie_values.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;

namespace {
void Require(bool condition, const char* action) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", action);
        std::exit(1);
    }
}
}  // namespace

int main() {
    OwnedByteRegion metadata, nodes, value, pool_metadata, cells;
    FixedPhraseTable values(4), records(10);
    Require(InitializeDATrie(metadata, nodes, "ab", 0xff) && values.Initialize() && records.Initialize() &&
            InitializeIndexPool(pool_metadata, cells) && value.Resize(4), "preparing the real trie and storage");
    DATrieView trie(metadata.Data(), metadata.Size(), nodes.MutableData(), nodes.Size());
    std::uint32_t terminal = 0;
    Require(InsertTrieValue(trie, metadata, nodes, values, "a", value, &terminal) && terminal == 2 &&
            values.RecordCount() == 1 && metadata.Data()[8] == 1,
            "creating a key appends its value and publishes the real terminal ID");
    IndexRange reference{};
    const std::array<std::uint8_t, 10> first{9, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    const std::array<std::uint8_t, 10> second{10, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(AppendAssociationRecord(records, pool_metadata, cells, first.data(), first.size(), reference),
            "creating the first real association list");
    auto encoded = EncodeAssociationReference(reference);
    std::copy(encoded.begin(), encoded.end(), value.MutableData());
    terminal = 77;
    Require(InsertTrieValue(trie, metadata, nodes, values, "a", value, &terminal) && terminal == 77 &&
            values.RecordCount() == 1, "publishing a list updates the existing value without republishing its ID");
    Require(AppendAssociationRecord(records, pool_metadata, cells, second.data(), second.size(), reference),
            "extending the real association list");
    encoded = EncodeAssociationReference(reference);
    std::copy(encoded.begin(), encoded.end(), value.MutableData());
    Require(InsertTrieValue(trie, metadata, nodes, values, "a", value, &terminal) && terminal == 77 &&
            values.RecordCount() == 1 && metadata.Data()[8] == 1 && trie.FindTerminal("a") == 2,
            "republishing the longer list retains the value record and key count");
    OwnedByteRegion published;
    IndexRange read_back{};
    const std::array<std::uint8_t, 4> expected{2, 4, 0, 0};
    Require(ReadTrieValueByNodeId(trie, values, 2, published) && published.Size() == 4 &&
            std::equal(expected.begin(), expected.end(), published.Data()) &&
            DecodeAssociationReference(published.Data(), published.Size(), read_back) &&
            read_back.first_index == 2 && read_back.count == 2,
            "reading by terminal reaches the literal published association range");
    const IndexPoolView pool(pool_metadata.Data(), pool_metadata.Size(), cells.MutableData(), cells.Size());
    std::uint32_t record_id = 0;
    const std::uint8_t* record = nullptr;
    std::size_t size = 0;
    Require(pool.ReadRecordId(2, record_id) && record_id == 0 &&
            records.ReadRecord(record_id, record, size) && size == 10 &&
            std::equal(first.begin(), first.end(), record) &&
            pool.ReadRecordId(3, record_id) && record_id == 10 &&
            records.ReadRecord(record_id, record, size) && size == 10 &&
            std::equal(second.begin(), second.end(), record),
            "the published list resolves both actual records with their retained payloads");
    // Native EditorImpl appends before core key admission. A genuinely excluded
    // byte leaves the appended value, rather than using an allocation fake.
    terminal = 55;
    Require(!InsertTrieValue(trie, metadata, nodes, values, "z", value, &terminal) && terminal == 55 &&
            values.RecordCount() == 2 && metadata.Data()[8] == 1 && trie.FindTerminal("z") == 0 &&
            values.ReadRecord(4, record, size) && size == 4 &&
            std::equal(expected.begin(), expected.end(), record),
            "an excluded key retains the value appended before native admission failed");
    std::puts("PASS: fixed-store trie editing, actual association publication and retained failed append");
}
