#include "../recovered/association_records.h"
#include "../recovered/datrie_view.h"
#include "../recovered/fixed_phrase_table.h"

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
    OwnedByteRegion trie_metadata, trie_nodes;
    Require(InitializeDATrie(trie_metadata, trie_nodes, std::string_view("\x01\x02\x03\x05", 4), 0xff),
            "initializing the real owning trie and free chain");
    DATrieView trie(trie_metadata.Data(), trie_metadata.Size(), trie_nodes.MutableData(), trie_nodes.Size());
    // Loaded-image fixture: parent 4 owns terminal 20 and current node 21.
    // Current 21 owns byte edges 3/5 at 23/25, with terminals 40/42 below them.
    for (const auto node : std::array<std::uint32_t, 7>{4, 20, 21, 23, 25, 40, 42}) {
        Require(trie.UnlinkFreeNode(node), "reserving occupied fixture cells through the real free chain");
    }
    const auto row = [](auto* bytes, std::size_t offset, std::array<std::uint8_t, 8> value) {
        std::copy(value.begin(), value.end(), bytes + offset);
    };
    auto* bytes = trie_nodes.MutableData();
    row(bytes, 8, {2, 0, 0, 0, 1, 0, 0, 0});
    row(bytes, 32, {20, 0, 0, 0, 1, 0, 0, 0});
    row(bytes, 160, {0, 0, 0, 0, 4, 0, 0, 0});
    row(bytes, 168, {20, 0, 0, 0, 4, 0, 0, 0});
    row(bytes, 184, {40, 0, 0, 0, 21, 0, 0, 0});
    row(bytes, 200, {42, 0, 0, 0, 21, 0, 0, 0});
    row(bytes, 320, {4, 0, 0, 0, 23, 0, 0, 0});
    row(bytes, 336, {8, 0, 0, 0, 25, 0, 0, 0});
    const auto saved_nodes = trie_nodes;
    const auto saved_metadata = trie_metadata;

    std::array<std::uint8_t, 536> reverse_metadata{};
    reverse_metadata[12] = 32;
    std::array<std::uint8_t, 256> reverse_nodes{};
    row(reverse_nodes.data(), 8, {2, 0, 0, 0, 1, 0, 0, 0});
    row(reverse_nodes.data(), 40, {20, 0, 0, 0, 1, 0, 0, 0});
    row(reverse_nodes.data(), 160, {0, 0, 0, 0, 5, 0, 0, 0});
    row(reverse_nodes.data(), 56, {24, 0, 0, 0, 1, 0, 0, 0});
    row(reverse_nodes.data(), 192, {4, 0, 0, 0, 7, 0, 0, 0});
    DATrieView reverse_trie(reverse_metadata.data(), reverse_metadata.size(),
                            reverse_nodes.data(), reverse_nodes.size());
    FixedPhraseTable forward_records(4), reverse_records(10), forward_values(4), reverse_values(4);
    OwnedByteRegion forward_metadata, forward_cells, pool_metadata, pool_cells;
    Require(forward_records.Initialize() && reverse_records.Initialize() && forward_values.Initialize() &&
            reverse_values.Initialize() && InitializeIndexPool(forward_metadata, forward_cells) &&
            InitializeIndexPool(pool_metadata, pool_cells), "preparing the real association stores");
    IndexRange forward{}, first{}, second{};
    const std::array<std::uint8_t, 4> endpoint_a{20, 0, 0, 0}, endpoint_b{24, 0, 0, 0};
    const std::array<std::uint8_t, 10> old_reference{20, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(AppendAssociationRecord(forward_records, forward_metadata, forward_cells,
                                    endpoint_a.data(), 4, forward) &&
            AppendAssociationRecord(forward_records, forward_metadata, forward_cells,
                                    endpoint_b.data(), 4, forward) &&
            AppendAssociationRecord(reverse_records, pool_metadata, pool_cells,
                                    old_reference.data(), 10, first) &&
            AppendAssociationRecord(reverse_records, pool_metadata, pool_cells,
                                    old_reference.data(), 10, second) &&
            forward.first_index == 2 && forward.count == 2 &&
            first.first_index == 2 && first.count == 1 && second.first_index == 3 && second.count == 1,
            "building both directions through real record and index allocation");
    const std::array<std::uint8_t, 4> forward_reference{2, 4, 0, 0}, empty{0, 0, 0, 0};
    const std::array<std::uint8_t, 4> reverse_first{1, 4, 0, 0}, reverse_second{1, 6, 0, 0};
    std::uint64_t id = 0;
    Require(forward_values.AppendRecord(forward_reference.data(), 4, id) && id == 0 &&
            forward_values.AppendRecord(empty.data(), 4, id) && id == 4 &&
            forward_values.AppendRecord(empty.data(), 4, id) && id == 8 &&
            reverse_values.AppendRecord(reverse_first.data(), 4, id) && id == 0 &&
            reverse_values.AppendRecord(reverse_second.data(), 4, id) && id == 4,
            "publishing literal value references independent of the implementation");
    const AssociationSide moved{trie, forward_values, forward_metadata, forward_cells, forward_records};
    const AssociationSide opposite{reverse_trie, reverse_values, pool_metadata, pool_cells, reverse_records};
    const DATrieNodeMove notify = [&](std::uint32_t old_id, std::uint32_t new_id) {
        UpdateMovedNodeId(moved, opposite, old_id, new_id);
    };
    Require(trie.ResolveCollision(trie_metadata, trie_nodes, 21, 0, &notify) == 3 &&
            trie_nodes.Size() == 6144 && trie_metadata.Data()[13] == 2 && saved_metadata.Data()[13] == 1 &&
            trie.FindNode(std::string_view("\x02", 1)) == 4 &&
            trie.FindNode(std::string_view("\x02\x01", 2)) == 3 &&
            trie.FindNode(std::string_view("\x02\x01\x03", 3)) == 23 &&
            trie.FindNode(std::string_view("\x02\x01\x05", 3)) == 25,
            "collision growth refreshes the shared view and retargets the current node and descendant edges");
    std::uint32_t value = 0;
    Require(trie.ReadTerminalValue(2, value) && value == 0 &&
            trie.ReadTerminalValue(40, value) && value == 4 &&
            trie.ReadTerminalValue(42, value) && value == 8,
            "the moved terminal and both deeper values retain their literal offsets");
    const std::array<std::uint8_t, 16> old_rows{0, 0, 0, 0, 4, 0, 0, 0, 20, 0, 0, 0, 4, 0, 0, 0};
    Require(std::equal(old_rows.begin(), old_rows.end(), saved_nodes.Data() + 160),
            "the prior shared handle retains its original terminal and current-node rows");
    const std::array<std::uint8_t, 10> repaired{2, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    for (const auto offset : std::array<std::uint64_t, 2>{0, 10}) {
        const std::uint8_t* record = nullptr;
        std::size_t size = 0;
        Require(reverse_records.ReadRecord(offset, record, size) && size == 10 &&
                std::equal(repaired.begin(), repaired.end(), record),
                "the real notification repairs both reverse IDs and retains their payloads");
    }
    // The newly claimed zero edge still awaits the insertion caller's value.
    std::puts("PASS: collision relocation, COW/growth, current retargeting and real reverse-ID repair");
}
