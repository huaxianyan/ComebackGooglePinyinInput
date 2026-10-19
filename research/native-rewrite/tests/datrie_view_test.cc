#include "../recovered/datrie_view.h"
#include "../recovered/trie_values.h"
#include "../recovered/little_endian.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>

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
    OwnedByteRegion initialized_metadata, initialized_nodes;
    Require(InitializeDATrie(initialized_metadata, initialized_nodes,
                            std::string_view("ba\xff" "b", 4), 0xff),
            "initializing the real trie with an unordered, repeated alphabet and excluded byte");
    std::array<std::uint8_t, 536> expected_metadata{};
    expected_metadata[4] = 0xff;
    expected_metadata[13] = 1;
    expected_metadata[16] = 3;
    expected_metadata[21] = 0x61;
    expected_metadata[22] = 0x62;
    expected_metadata[0x175] = 1;
    expected_metadata[0x176] = 2;
    const std::array<std::uint8_t, 16> expected_root{
        1, 0xff, 0xff, 0xff, 0xfe, 0xff, 0xff, 0xff,
        1, 0, 0, 0, 1, 0, 0, 0};
    Require(initialized_metadata.Size() == 536 && initialized_nodes.Size() == 2048 &&
            std::equal(expected_metadata.begin(), expected_metadata.end(), initialized_metadata.Data()) &&
            std::equal(expected_root.begin(), expected_root.end(), initialized_nodes.Data()),
            "initialization publishes the literal sorted alphabet, free sentinel and reserved root");
    DATrieView initialized(initialized_metadata.Data(), initialized_metadata.Size(),
                           initialized_nodes.MutableData(), initialized_nodes.Size());
    DATrieLabels children{};
    Require(initialized.EnumerateChildren(1, children) == 1 && children[0] == 0,
            "the initial reserved root participates in zero-label enumeration");
    Require(initialized.UnlinkFreeNode(4) && initialized.ReturnFreeNode(4, 2),
            "returning a detached cell locates its ordered neighbors from the preceding cursor");
    const std::array<std::uint8_t, 24> expected_neighbors{
        0xfe, 0xff, 0xff, 0xff, 0xfc, 0xff, 0xff, 0xff,
        0xfd, 0xff, 0xff, 0xff, 0xfb, 0xff, 0xff, 0xff,
        0xfc, 0xff, 0xff, 0xff, 0xfa, 0xff, 0xff, 0xff};
    Require(std::equal(expected_neighbors.begin(), expected_neighbors.end(), initialized_nodes.Data() + 24),
            "returning the interior cell restores the literal bidirectional chain links");

    // Independent sparse wire fixture: root=1, paths a=99 and ab=103;
    // terminal cells 5 and 7 hold fixed-store offsets 0 and 6.
    std::array<std::uint8_t, 532> metadata{};
    metadata[12] = 128;
    metadata[16] = 4;
    metadata[21] = 0x61;
    metadata[22] = 0x62;
    metadata[23] = 0xff;
    metadata[0x175] = 1;  // a
    metadata[0x176] = 2;  // b
    metadata[0x213] = 3;  // unsigned byte ff
    std::array<std::uint8_t, 1024> nodes{};
    const auto put = [&](std::size_t offset, std::array<std::uint8_t, 8> row) {
        std::copy(row.begin(), row.end(), nodes.begin() + offset);
    };
    put(8, {2, 0, 0, 0, 0, 0, 0, 0});
    put(792, {5, 0, 0, 0, 1, 0, 0, 0});
    put(40, {0, 0, 0, 0, 99, 0, 0, 0});
    put(824, {7, 0, 0, 0, 99, 0, 0, 0});
    put(56, {6, 0, 0, 0, 103, 0, 0, 0});
    DATrieView trie(metadata.data(), metadata.size(), nodes.data(), nodes.size());
    Require(trie.AcceptsKey("a") && trie.AcceptsKey("ab") && trie.AcceptsKey("b") &&
            trie.AcceptsKey(std::string_view("\xff", 1)) &&
            !trie.AcceptsKey(std::string_view("a\0", 2)),
            "key admission uses the frozen byte alphabet and excludes its zero terminator");
    Require(trie.EnumerateChildren(99, children) == 2 && children[0] == 0 && children[1] == 98 &&
            trie.EnumerateChildren(103, children) == 1 && children[0] == 0,
            "child enumeration retains the terminal label and the byte edge in metadata order");
    Require(trie.FindNode("a") == 99 && trie.FindNode("ab") == 103 && trie.FindNode("") == 1,
            "root traversal locates a key and its longer prefix-sharing key");

    FixedPhraseTable records(6);
    OwnedByteRegion value, reference;
    const std::array<std::uint8_t, 6> first{1, 2, 3, 4, 5, 6};
    Require(records.Initialize() && value.Resize(6), "initializing the real value-record store");
    std::memcpy(value.MutableData(), first.data(), first.size());
    Require(AppendTrieValue(records, value, reference) && AppendTrieValue(records, value, reference),
            "storing the two records referenced by the independent trie fixture");
    const std::array<std::uint8_t, 6> replacement{9, 8, 7, 6, 5, 4};
    std::memcpy(value.MutableData(), replacement.data(), replacement.size());
    Require(AppendTrieValue(records, value, reference) && trie.UpdateValue("ab", 12),
            "publishing a new record offset at an existing key's terminal cell");
    const std::array<std::uint8_t, 8> expected_terminal{12, 0, 0, 0, 103, 0, 0, 0};
    const std::array<std::uint8_t, 8> expected_prefix{0, 0, 0, 0, 99, 0, 0, 0};
    Require(std::equal(expected_terminal.begin(), expected_terminal.end(), nodes.begin() + 56) &&
            std::equal(expected_prefix.begin(), expected_prefix.end(), nodes.begin() + 40),
            "the terminal reference changes while the shorter key retains its zero-offset value");
    const auto record_id = detail::ReadLittleEndian<std::uint32_t>(nodes.data() + 56);
    const std::uint8_t* data = nullptr;
    std::size_t size = 0;
    Require(records.ReadRecord(record_id, data, size) && size == 6 &&
            std::equal(replacement.begin(), replacement.end(), data),
            "resolving the updated terminal bytes retrieves the newly stored value");
    Require(trie.FindNode("b") == 0 && !trie.UpdateValue("b", 0) && metadata[12] == 128,
            "existing-only update leaves an admitted but missing key absent");
    std::puts("PASS: DATrie initialization, ordered return, child enumeration and existing value updates");
}
