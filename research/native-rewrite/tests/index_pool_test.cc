// Independent literal pool images. This tests metadata operations, not an allocator.
#include "../recovered/association_records.h"

#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;

namespace {
void Require(bool condition, const char* operation) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", operation);
        std::exit(1);
    }
}
}  // namespace

int main() {
    // The active count is separate from the data cells. Fourteen cells of
    // capacity, twelve active; the two-cell sentinel stores head and tail.
    const std::array<std::uint8_t, 8> metadata{0, 0, 0, 0, 0x0c, 0, 0, 0};
    std::array<std::uint8_t, 56> bytes{
        0x02, 0, 0, 0,  0, 0, 0, 0,
        0, 0, 0, 0,     0, 0, 0, 0,
        0, 0, 0, 0,     0, 0, 0, 0,
        0x05, 0, 0, 0x80,
        0, 0, 0, 0,     0, 0, 0, 0,
        0x22, 0, 0, 0x80,  0x33, 0, 0, 0x80,  0x44, 0, 0, 0x80,
        0, 0, 0, 0,     0, 0, 0, 0,
    };
    IndexPoolView pool(metadata.data(), metadata.size(), bytes.data(), bytes.size());
    Require(pool.LinkFreeRanges({0, 2}, {2, 4}) &&
            pool.LinkFreeRanges({2, 4}, {7, 2}) &&
            pool.LinkFreeRanges({7, 2}, {11, 1}) &&
            pool.LinkFreeRanges({11, 1}, {0, 2}),
            "linking cleared extents through the sentinel");
    Require(pool.WriteRecordId(6, 0x12345678), "writing a tagged record ID");
    const std::array<std::uint8_t, 56> expected{
        0x0a, 0, 0, 0,  0x0b, 0, 0, 0,
        0x1f, 0, 0, 0,  0, 0, 0, 0,
        0x04, 0, 0, 0,  0, 0, 0, 0,
        0x78, 0x56, 0x34, 0x92,
        0x2e, 0, 0, 0,  0x02, 0, 0, 0,
        0x22, 0, 0, 0x80,  0x33, 0, 0, 0x80,  0x01, 0, 0, 0,
        0, 0, 0, 0,     0, 0, 0, 0,
    };
    Require(bytes == expected, "writing the native run headers, backlink and occupied cell");

    IndexRange range{};
    Require(pool.ReadNextFreeRange(0, range) && range.first_index == 2 && range.count == 4,
            "reading an extended-length free node");
    Require(pool.ReadNextFreeRange(2, range) && range.first_index == 7 && range.count == 2,
            "reading a two-cell free node");
    Require(pool.ReadNextFreeRange(7, range) && range.first_index == 11 && range.count == 1,
            "reading a one-cell free node");
    Require(pool.ReadNextFreeRange(11, range) && range.first_index == 0 && range.count == 2,
            "following the final free node to the two-cell sentinel");

    const std::array<std::uint8_t, 4> association_bytes{0x01, 0x0c, 0, 0};
    std::uint32_t value = 0;
    Require(DecodeAssociationReference(association_bytes.data(), association_bytes.size(), range) &&
            range.first_index == 6 && range.count == 1 &&
            pool.ReadRecordId(range.first_index, value) && value == 0x12345678,
            "resolving a stored association reference through the real pool view");

    // Native checked-read protocol distinguishes a free active cell from an
    // inactive position, even when the latter has allocated backing capacity.
    Require(!pool.ReadRecordId(2, value) && value == 0xffffffff,
            "a free cell reports the native missing-record value");
    value = 0x55;
    Require(!pool.ReadRecordId(12, value) && value == 0x55,
            "an inactive position preserves output despite spare capacity");
    std::puts("PASS: pool node layouts, tagged IDs, free links and association resolution");
}
