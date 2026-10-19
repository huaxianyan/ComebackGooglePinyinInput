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
void ExpectRecord(const FixedPhraseTable& table, std::uint64_t id,
                  std::array<std::uint8_t, 10> expected) {
    const std::uint8_t* data = nullptr;
    std::size_t size = 0;
    Require(table.ReadRecord(id, data, size) && size == 10 &&
            std::equal(expected.begin(), expected.end(), data),
            "the real reverse record has the expected key and retained payload");
}
}  // namespace

int main() {
    // Independent terminal-ID fixtures: new IDs 10/12 resolve the same forward
    // value; opposite IDs 20/24 resolve distinct reverse references at offsets 0/4.
    std::array<std::uint8_t, 536> metadata{};
    metadata[12] = 32;
    std::array<std::uint8_t, 256> moved_nodes{}, opposite_nodes{};
    const auto row = [](auto& nodes, std::size_t offset, std::array<std::uint8_t, 8> bytes) {
        std::copy(bytes.begin(), bytes.end(), nodes.begin() + offset);
    };
    row(moved_nodes, 8, {2, 0, 0, 0, 1, 0, 0, 0});
    row(moved_nodes, 24, {10, 0, 0, 0, 1, 0, 0, 0});
    row(moved_nodes, 80, {0, 0, 0, 0, 3, 0, 0, 0});
    row(moved_nodes, 32, {12, 0, 0, 0, 1, 0, 0, 0});
    row(moved_nodes, 96, {0, 0, 0, 0, 4, 0, 0, 0});
    row(opposite_nodes, 8, {2, 0, 0, 0, 1, 0, 0, 0});
    row(opposite_nodes, 40, {20, 0, 0, 0, 1, 0, 0, 0});
    row(opposite_nodes, 160, {0, 0, 0, 0, 5, 0, 0, 0});
    row(opposite_nodes, 56, {24, 0, 0, 0, 1, 0, 0, 0});
    row(opposite_nodes, 192, {4, 0, 0, 0, 7, 0, 0, 0});
    DATrieView moved_trie(metadata.data(), metadata.size(), moved_nodes.data(), moved_nodes.size());
    DATrieView opposite_trie(metadata.data(), metadata.size(), opposite_nodes.data(), opposite_nodes.size());
    FixedPhraseTable moved_records(4), opposite_records(10), moved_values(4), opposite_values(4);
    OwnedByteRegion moved_metadata, moved_cells, opposite_metadata, opposite_cells;
    Require(moved_records.Initialize() && opposite_records.Initialize() && moved_values.Initialize() &&
            opposite_values.Initialize() && InitializeIndexPool(moved_metadata, moved_cells) &&
            InitializeIndexPool(opposite_metadata, opposite_cells), "initializing both concrete storage sides");
    IndexRange forward{}, reverse_first{}, reverse_second{};
    const std::array<std::uint8_t, 4> target_first{20, 0, 0, 0}, target_second{24, 0, 0, 0};
    Require(AppendAssociationRecord(moved_records, moved_metadata, moved_cells,
                                    target_first.data(), target_first.size(), forward) &&
            AppendAssociationRecord(moved_records, moved_metadata, moved_cells,
                                    target_second.data(), target_second.size(), forward) &&
            forward.first_index == 2 && forward.count == 2, "building the forward list through real append");
    std::array<std::uint8_t, 10> reverse_record{99, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(AppendAssociationRecord(opposite_records, opposite_metadata, opposite_cells,
                                    reverse_record.data(), reverse_record.size(), reverse_first),
            "adding an unrelated record before the reverse match");
    const std::uint32_t old_id = 6;
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, reverse_record.data(),
                                   reverse_record.size(), &old_id, nullptr, nullptr) &&
            AppendAssociationRecord(opposite_records, opposite_metadata, opposite_cells,
                                    reverse_record.data(), reverse_record.size(), reverse_first) &&
            AppendAssociationRecord(opposite_records, opposite_metadata, opposite_cells,
                                    reverse_record.data(), reverse_record.size(), reverse_second) &&
            reverse_first.first_index == 2 && reverse_first.count == 2 &&
            reverse_second.first_index == 4 && reverse_second.count == 1,
            "building both real reverse lists with independent expected ranges");
    const std::array<std::uint8_t, 4> first_reference{2, 4, 0, 0}, second_reference{1, 8, 0, 0};
    std::uint64_t id = 0;
    Require(moved_values.AppendRecord(first_reference.data(), 4, id) && id == 0 &&
            opposite_values.AppendRecord(first_reference.data(), 4, id) && id == 0 &&
            opposite_values.AppendRecord(second_reference.data(), 4, id) && id == 4,
            "storing literal association references in the real trie value tables");
    const AssociationSide moved{moved_trie, moved_values, moved_metadata, moved_cells, moved_records};
    const AssociationSide opposite{opposite_trie, opposite_values, opposite_metadata, opposite_cells,
                                   opposite_records};
    UpdateMovedNodeId(moved, opposite, 6, 10);
    ExpectRecord(opposite_records, 10, {10, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a});
    ExpectRecord(opposite_records, 20, {10, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a});
    ExpectRecord(opposite_records, 0, {99, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a});

    // Native receiver aborts when a later reverse endpoint is missing. Use real
    // storage mutation and lookup failure, not a callback fake or fault injection.
    std::uint8_t* writable = nullptr;
    std::size_t size = 0;
    const std::uint32_t missing_endpoint = 25;
    Require(moved_records.MutableRecord(4, writable, size) &&
            PatchAssociationRecord(AssociationRecordLayout::TargetKey, writable, size,
                                   &missing_endpoint, nullptr, nullptr), "preparing the missing later endpoint");
    UpdateMovedNodeId(moved, opposite, 10, 12);
    ExpectRecord(opposite_records, 10, {12, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a});
    ExpectRecord(opposite_records, 20, {10, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a});
    Require(opposite_records.RecordCount() == 3, "repair retains existing records rather than appending replacements");
    std::puts("PASS: terminal-ID lookup, real reverse-reference repair and native partial failure");
}
