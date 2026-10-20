// One real fixed-table save/load/edit flow, including native final-pad handling.
#include "../recovered/fixed_phrase_table.h"

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
    const std::array<std::uint8_t, 6> first{0x10, 0x11, 0x12, 0x13, 0x14, 0x15};
    const std::array<std::uint8_t, 6> second{0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5};
    const std::array<std::uint8_t, 6> third{0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5};
    const std::array<std::uint8_t, 24> original{
        2, 0, 0, 0, 6, 0, 0, 0,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15,
        0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0, 0, 0, 0};
    const std::array<std::uint8_t, 32> edited{
        3, 0, 0, 0, 6, 0, 0, 0,
        0x10, 0x11, 0x12, 0x13, 0x14, 0x15,
        0x77, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5,
        0xb0, 0xb1, 0xb2, 0xb3, 0xb4, 0xb5, 0, 0, 0, 0, 0, 0};
    FixedPhraseTable source(6);
    std::uint64_t id = 0;
    OwnedByteRegion image;
    Require(source.Initialize() && source.AppendRecord(first.data(), first.size(), id) &&
            source.AppendRecord(second.data(), second.size(), id) &&
            source.Serialize(image) && image.Size() == original.size() &&
            std::equal(original.begin(), original.end(), image.Data()),
            "saving two six-byte records emits the count, width, body and zero alignment padding");

    // 0x1f5ec4 advances the cursor after checking the body, not the final pad.
    const auto unpadded = image.Slice(0, 20);
    FixedPhraseTable loaded(99);
    const std::uint8_t* record = nullptr;
    std::size_t size = 0;
    Require(loaded.Load(unpadded) == 24 && loaded.RecordCount() == 2 && loaded.RecordSize() == 6 &&
            loaded.ReadRecord(6, record, size) && size == 6 &&
            std::equal(second.begin(), second.end(), record),
            "loading restores the image width and advances logically past omitted final padding");
    std::uint8_t* writable = nullptr;
    Require(loaded.MutableRecord(6, writable, size), "editing the second loaded record");
    writable[0] = 0x77;
    Require(loaded.AppendRecord(third.data(), third.size(), id) && id == 12,
            "appending continues at the next byte-offset record ID after loading");
    OwnedByteRegion saved;
    Require(loaded.Serialize(saved) && saved.Size() == edited.size() &&
            std::equal(edited.begin(), edited.end(), saved.Data()) &&
            std::equal(original.begin(), original.end(), image.Data()),
            "saving the edit and append emits the new image while retaining the original parent bytes");

    // Native 0x1f5e3c requires every body byte before installing a slice.
    const auto truncated = image.Slice(0, 19);
    Require(loaded.Load(truncated) == 0 && loaded.RecordCount() == 3 && loaded.RecordSize() == 6 &&
            loaded.ReadRecord(6, record, size) && record[0] == 0x77,
            "a truncated record body leaves the already edited table available");
    std::puts("PASS: fixed-table save, width restoration, final-pad handling, edit and append");
}
