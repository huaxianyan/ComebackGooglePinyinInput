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
    // Independent sparse wire fixture: root=1, paths a=99 and ab=103;
    // terminal cells 5 and 7 hold fixed-store offsets 0 and 6.
    std::array<std::uint8_t, 532> metadata{};
    metadata[12] = 128;
    metadata[0x175] = 1;  // a
    metadata[0x176] = 1;  // b
    metadata[0x213] = 1;  // unsigned byte ff
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
    std::puts("PASS: byte admission, prefix traversal and existing DATrie terminal updates");
}
