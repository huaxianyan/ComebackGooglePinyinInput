#include "../recovered/datrie_view.h"
#include "../recovered/owned_byte_region.h"

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
template <std::size_t Size>
bool EqualsAt(const OwnedByteRegion& region, std::size_t offset,
              const std::array<std::uint8_t, Size>& expected) {
    return offset + Size <= region.Size() &&
           std::equal(expected.begin(), expected.end(), region.Data() + offset);
}
}  // namespace

int main() {
    // Independent initialized wire image: terminal 2 occupied, only cell 3 free.
    std::array<std::uint8_t, 532> header{};
    header[12] = 4;
    const std::array<std::uint8_t, 32> initial{
        0xfd, 0xff, 0xff, 0xff, 0xfd, 0xff, 0xff, 0xff,
        2, 0, 0, 0, 1, 0, 0, 0,
        6, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0};
    OwnedByteRegion metadata, nodes;
    Require(metadata.Resize(532) && nodes.Resize(32), "preparing the real owning regions");
    std::memcpy(metadata.MutableData(), header.data(), header.size());
    std::memcpy(nodes.MutableData(), initial.data(), initial.size());
    const auto saved_metadata = metadata;
    const auto saved_nodes = nodes;
    Require(GrowDATrieNodes(metadata, nodes) && nodes.Size() == 4128 &&
            EqualsAt(metadata, 12, std::array<std::uint8_t, 4>{4, 1, 0, 0}) &&
            EqualsAt(saved_nodes, 0, initial) && EqualsAt(saved_metadata, 0, header),
            "growth activates 256 cells, preserves old handles and allocates the native capacity");
    const std::array<std::uint32_t, 2> labels{0, 255};
    std::uint32_t base = 0;
    Require(FindDATrieBase(metadata, nodes, labels.data(), labels.size(), 1, base) && base == 3 &&
            nodes.Size() == 8224 &&
            EqualsAt(metadata, 12, std::array<std::uint8_t, 4>{4, 2, 0, 0}),
            "base search skips the occupied candidate and grows at the exact capacity boundary");
    Require(EqualsAt(nodes, 0, std::array<std::uint8_t, 8>{
                0xfd, 0xfd, 0xff, 0xff, 0xfd, 0xff, 0xff, 0xff}) &&
            EqualsAt(nodes, 4120, std::array<std::uint8_t, 8>{
                0xfe, 0xfd, 0xff, 0xff, 0, 0, 0, 0}) &&
            std::all_of(nodes.Data() + 4128, nodes.Data() + nodes.Size(),
                        [](std::uint8_t byte) { return byte == 0xff; }),
            "the expanded chain has the literal head, tail and unused capacity fill");
    DATrieView view(metadata.Data(), metadata.Size(), nodes.MutableData(), nodes.Size());
    Require(view.UnlinkFreeNode(3) &&
            EqualsAt(nodes, 4, std::array<std::uint8_t, 4>{0xfc, 0xff, 0xff, 0xff}) &&
            EqualsAt(nodes, 32, std::array<std::uint8_t, 4>{0, 0, 0, 0}) &&
            EqualsAt(nodes, 24, std::array<std::uint8_t, 8>{
                0, 0, 0, 0, 0xfc, 0xff, 0xff, 0xff}) &&
            EqualsAt(nodes, 16, std::array<std::uint8_t, 8>{6, 0, 0, 0, 1, 0, 0, 0}),
            "unlinking the head rewires neighbors while retaining its own words and occupied data");
    // Native insertion must assign occupied fields after unlinking. This test
    // stops at that primitive boundary instead of inventing an insertion path.
    std::puts("PASS: DATrie growth, free-base search, exact capacity boundary and chain unlink");
}
