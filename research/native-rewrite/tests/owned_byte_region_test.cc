// Literal byte expectations; exercise ownership through the real region API.
#include "../recovered/owned_byte_region.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>

using comeback::recovered::OwnedByteRegion;

namespace {
void Require(bool condition, const char* operation) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", operation);
        std::exit(1);
    }
}

template <std::size_t Size>
void RequireBytes(const OwnedByteRegion& region, const std::array<std::uint8_t, Size>& expected,
                  const char* operation) {
    Require(region.Size() == Size && region.Data() != nullptr &&
            std::equal(expected.begin(), expected.end(), region.Data()), operation);
}
}  // namespace

int main() {
    OwnedByteRegion root;
    Require(root.Resize(4), "creating an owned region");
    auto* writable = root.MutableData();
    Require(writable != nullptr, "obtaining writable initial bytes");
    const std::array<std::uint8_t, 4> initial{0x10, 0x20, 0x30, 0x40};
    std::copy(initial.begin(), initial.end(), writable);

    auto alias = root;
    auto slice = root.Slice(1, 2);
    auto nested = slice.Slice(1, 1);
    writable = alias.MutableData();
    Require(writable != nullptr, "editing a shared copy");
    writable[0] = 0xa0;
    RequireBytes(root, initial, "editing a copy preserves the original bytes");
    RequireBytes(alias, std::array<std::uint8_t, 4>{0xa0, 0x20, 0x30, 0x40},
                 "the edited copy exposes its new byte");

    writable = slice.MutableData();
    Require(writable != nullptr, "editing a slice retained by another slice");
    writable[0] = 0xb0;
    RequireBytes(slice, std::array<std::uint8_t, 2>{0xb0, 0x30},
                 "the edited slice exposes only its logical region");
    auto unique_slice = root.Slice(2, 2);
    writable = unique_slice.MutableData();
    Require(writable != nullptr, "editing a unique parent-backed slice");
    writable[0] = 0xc0;
    RequireBytes(unique_slice, std::array<std::uint8_t, 2>{0xc0, 0x40},
                 "a unique slice separates its bytes when edited");

    Require(root.Resize(7), "growing the original while nested slices retain its old storage");
    RequireBytes(root, std::array<std::uint8_t, 7>{0x10, 0x20, 0x30, 0x40, 0, 0, 0},
                 "growth preserves the original prefix and clears added bytes");
    Require(root.Resize(2) && root.Resize(5), "shrinking and regrowing an owned region");
    RequireBytes(root, std::array<std::uint8_t, 5>{0x10, 0x20, 0, 0, 0},
                 "regrowth clears the discarded suffix instead of restoring old bytes");

    auto resized_slice = alias.Slice(1, 2);
    Require(resized_slice.Resize(4), "growing a parent-backed slice");
    RequireBytes(resized_slice, std::array<std::uint8_t, 4>{0x20, 0x30, 0, 0},
                 "slice growth copies its own prefix and clears its extension");
    const auto retained_alias = alias;
    Require(alias.Resize(0) && alias.Size() == 0 && alias.Data() == nullptr,
            "clearing one shared handle exposes an empty region");
    RequireBytes(retained_alias, std::array<std::uint8_t, 4>{0xa0, 0x20, 0x30, 0x40},
                 "the retained handle keeps its bytes after the other handle is cleared");

    root = OwnedByteRegion{};
    slice = OwnedByteRegion{};
    RequireBytes(nested, std::array<std::uint8_t, 1>{0x30},
                 "a nested slice retains bytes after its parent handles are replaced");
    const auto empty = retained_alias.Slice(retained_alias.Size(), 0);
    Require(empty.Size() == 0 && empty.Data() == nullptr,
            "a zero-length slice at the region end returns an empty region");
    std::puts("PASS: shared copies, slice lifetime, writable separation and exact resize bytes");
}
