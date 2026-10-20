// One real DATrie save/load/edit flow with the native graph-validation gate.
#include "../recovered/datrie_view.h"
#include "../recovered/dictionary_table_image.h"
#include "../recovered/little_endian.h"
#include "../recovered/owned_byte_region.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}  // namespace

int main() {
    // Frozen native init wire map for alphabet 00 61 62. CRC64 was obtained by
    // independent GF(2) long division, not by this codec or its checksum helper.
    const std::array<std::uint8_t, 16> empty_header{
        'D', 'A', '-', 'T', 'R', 'I', 'E', 0,
        0x44, 0x78, 0xad, 0x34, 0x0f, 0x0f, 0xd8, 0x04};
    OwnedByteRegion metadata, nodes, empty_image;
    Require(InitializeDATrie(metadata, nodes, "ab", 0xff) &&
            SerializeDictionaryTableImage(DictionaryTableKind::DATrie, metadata, nodes, empty_image) &&
            empty_image.Size() == 2600 &&
            std::equal(empty_header.begin(), empty_header.end(), empty_image.Data()),
            "saving the real empty trie emits the native DA-TRIE header and independent CRC64");
    OwnedByteRegion loaded_metadata, loaded_nodes;
    Require(LoadDictionaryTableImage(DictionaryTableKind::DATrie, empty_image,
                                     loaded_metadata, loaded_nodes) == 2600,
            "loading the image checks its CRC, root, occupied parents and free chain");
    DATrieView trie(loaded_metadata.Data(), loaded_metadata.Size(),
                     loaded_nodes.MutableData(), loaded_nodes.Size());
    Require(trie.InsertValue(loaded_metadata, loaded_nodes, "ab", 0x123456),
            "adding a real key after loading grows and edits the trie");
    OwnedByteRegion edited;
    Require(SerializeDictionaryTableImage(DictionaryTableKind::DATrie, loaded_metadata, loaded_nodes, edited) &&
            edited.Size() == 4648 && loaded_nodes.Size() > 4096,
            "saving the grown trie emits active nodes rather than retained capacity");
    OwnedByteRegion verified_metadata, verified_nodes;
    Require(LoadDictionaryTableImage(DictionaryTableKind::DATrie, edited,
                                     verified_metadata, verified_nodes) == 4648,
            "the edited image passes both native graph checks when loaded again");
    DATrieView verified(verified_metadata.Data(), verified_metadata.Size(),
                         verified_nodes.MutableData(), verified_nodes.Size());
    const auto terminal = verified.FindTerminal("ab");
    std::uint32_t value = 0;
    Require(verified.ReadTerminalValue(terminal, value) && value == 0x123456,
            "the loaded key retains its published terminal value");

    // 0x1d78ac rejects a repeated parent in a path. Encode a correct CRC over
    // an invalid parent cycle so rejection must come from graph validation.
    OwnedByteRegion cyclic_nodes = verified_nodes, cyclic_image;
    detail::WriteLittleEndian(terminal, cyclic_nodes.MutableData() + terminal * 8 + 4);
    Require(SerializeDictionaryTableImage(DictionaryTableKind::DATrie,
                                           verified_metadata, cyclic_nodes, cyclic_image) &&
            LoadDictionaryTableImage(DictionaryTableKind::DATrie, cyclic_image,
                                      verified_metadata, verified_nodes) == 0,
            "a CRC-valid image with a parent cycle fails before replacing the loaded trie");
    verified = DATrieView(verified_metadata.Data(), verified_metadata.Size(),
                           verified_nodes.MutableData(), verified_nodes.Size());
    Require(verified.ReadTerminalValue(verified.FindTerminal("ab"), value) && value == 0x123456 &&
            std::equal(empty_header.begin(), empty_header.end(), empty_image.Data()),
            "the prior key and original image remain available after the invalid load");
    std::puts("PASS: DA-TRIE save/load, graph checks, real insertion, active extent and cycle rejection");
}
