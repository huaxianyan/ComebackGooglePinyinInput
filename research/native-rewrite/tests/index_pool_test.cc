// Independent literal pool images. Exercises fixed-storage reuse, not growth.
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
void ExerciseRangeReuse() {
    const std::array<std::uint8_t, 8> metadata{0, 0, 0, 0, 0x10, 0, 0, 0};
    std::array<std::uint8_t, 64> bytes{
        0x0a, 0, 0, 0,     0x0e, 0, 0, 0,
        0x1a, 0, 0, 0,     0, 0, 0, 0,
        0x11, 0, 0, 0x80,  0x22, 0, 0, 0x80,
        0x29, 0, 0, 0,     0x33, 0, 0, 0x80,
        0x44, 0, 0, 0x80,  0x55, 0, 0, 0x80,
        0x3a, 0, 0, 0,     0x06, 0, 0, 0,
        0x66, 0, 0, 0x80,  0x77, 0, 0, 0x80,
        0x02, 0, 0, 0,     0x0a, 0, 0, 0,
    };
    IndexPoolView pool(metadata.data(), metadata.size(), bytes.data(), bytes.size());
    IndexRange range{};
    Require(pool.FindFreeRange(3, range) && range.first_index == 0 && range.count == 0,
            "a fragmented valid pool reports that a larger backing store is needed");

    range = {4, 2};
    Require(pool.ReleaseRange(range) && range.first_index == 2 && range.count == 5,
            "returning a range joins its left and single-cell right neighbors");
    Require(pool.FindFreeRange(2, range) && range.first_index == 2 && range.count == 5,
            "first-fit search chooses the earliest suitable free range");
    const std::uint32_t first_ids[]{0x101, 0x102};
    Require(pool.ClaimFreeRange(range, first_ids, 2) &&
            range.first_index == 2 && range.count == 2,
            "claiming two cells splits the original five-cell free range");
    const std::array<std::uint8_t, 64> expected_split{
        0x12, 0, 0, 0,     0x0e, 0, 0, 0,
        0x01, 0x01, 0, 0x80,  0x02, 0x01, 0, 0x80,
        0x2b, 0, 0, 0,     0, 0, 0, 0,
        0x03, 0, 0, 0,     0x33, 0, 0, 0x80,
        0x44, 0, 0, 0x80,  0x55, 0, 0, 0x80,
        0x3a, 0, 0, 0,     0x04, 0, 0, 0,
        0x66, 0, 0, 0x80,  0x77, 0, 0, 0x80,
        0x02, 0, 0, 0,     0x0a, 0, 0, 0,
    };
    Require(bytes == expected_split, "splitting retains the old length and writes a three-cell remainder");

    const std::uint32_t second_ids[]{0x201, 0x202};
    Require(pool.FindFreeRange(2, range) && range.first_index == 4 && range.count == 3 &&
            pool.ClaimFreeRange(range, second_ids, 2),
            "reusing the remainder leaves one free cell");
    const std::uint32_t third_ids[]{0x301, 0x302};
    Require(pool.FindFreeRange(2, range) && range.first_index == 10 && range.count == 2 &&
            pool.ClaimFreeRange(range, third_ids, 2),
            "skipping the small fragment and consuming an exact-fit range");
    const std::uint32_t last_id = 0x401;
    Require(pool.FindFreeRange(1, range) && range.first_index == 6 && range.count == 1 &&
            pool.ClaimFreeRange(range, &last_id, 1),
            "claiming a one-cell range finds its predecessor through the list");
    const std::array<std::uint8_t, 64> expected_claimed{
        0x3a, 0, 0, 0,     0x0e, 0, 0, 0,
        0x01, 0x01, 0, 0x80,  0x02, 0x01, 0, 0x80,
        0x01, 0x02, 0, 0x80,  0x02, 0x02, 0, 0x80,
        0x01, 0x04, 0, 0x80,  0x33, 0, 0, 0x80,
        0x44, 0, 0, 0x80,  0x55, 0, 0, 0x80,
        0x01, 0x03, 0, 0x80,  0x02, 0x03, 0, 0x80,
        0x66, 0, 0, 0x80,  0x77, 0, 0, 0x80,
        0x02, 0, 0, 0,     0, 0, 0, 0,
    };
    range = {8, 1};
    Require(pool.ReleaseRange(range) && range.first_index == 8 && range.count == 1,
            "returning an isolated cell inserts it in address order");
    range = {7, 1};
    Require(pool.ReleaseRange(range) && range.first_index == 7 && range.count == 2,
            "returning the left neighbor joins a right-only free cell");
    range = {9, 1};
    Require(pool.ReleaseRange(range) && range.first_index == 7 && range.count == 3,
            "returning the right neighbor joins a left-only free range");
    const std::uint32_t restored_ids[]{0x33, 0x44, 0x55};
    Require(pool.FindFreeRange(3, range) && range.first_index == 7 && range.count == 3 &&
            pool.ClaimFreeRange(range, restored_ids, 3),
            "reusing the newly coalesced range");
    Require(bytes == expected_claimed, "exact-fit reuse updates the head, backlinks and record cells");
    range = {2, 12};
    Require(pool.ReleaseRange(range) && range.first_index == 2 && range.count == 14,
            "returning the occupied prefix joins the remaining right-hand free range");
    const std::array<std::uint8_t, 64> expected_released{
        0x0a, 0, 0, 0,  0x02, 0, 0, 0,
        0x03, 0, 0, 0,  0, 0, 0, 0,
        0x0e, 0, 0, 0,
    };
    Require(bytes == expected_released, "release clears merged cells and restores the free-list tail");
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
    ExerciseRangeReuse();
    std::puts("PASS: pool layouts, association resolution, first-fit reuse, split and coalescing");
}
