#include "../recovered/trie_values.h"

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
bool ReferenceEquals(const OwnedByteRegion& reference, std::array<std::uint8_t, 4> expected) {
    return reference.Size() == 4 && std::equal(expected.begin(), expected.end(), reference.Data());
}
}  // namespace

int main() {
    FixedPhraseTable records(6);
    OwnedByteRegion value, reference;
    const std::array<std::uint8_t, 6> original{0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(records.Initialize() && value.Resize(6), "initializing the actual fixed value store");
    std::memcpy(value.MutableData(), original.data(), original.size());
    Require(AppendTrieValue(records, value, reference) && ReferenceEquals(reference, {0, 0, 0, 0}),
            "appending the first trie value publishes a valid zero-offset reference");
    Require(AppendTrieValue(records, value, reference) && ReferenceEquals(reference, {6, 0, 0, 0}),
            "appending the second value publishes a byte offset rather than a record ordinal");
    const auto saved_reference = reference;
    Require(AppendTrieValue(records, value, reference) && ReferenceEquals(reference, {12, 0, 0, 0}) &&
            ReferenceEquals(saved_reference, {6, 0, 0, 0}),
            "publishing a new reference retains a separately held earlier reference");
    const std::array<std::uint8_t, 6> replacement{1, 0, 0, 0, 0x22, 0x11};
    std::memcpy(value.MutableData(), replacement.data(), replacement.size());
    Require(UpdateTrieValue(records, saved_reference, value),
            "updating an existing value resolves its saved reference through the real store");
    const std::uint8_t* data = nullptr;
    std::size_t size = 0;
    Require(records.ReadRecord(6, data, size) && size == 6 &&
            std::equal(replacement.begin(), replacement.end(), data) && records.RecordCount() == 3,
            "the referenced value changes in place while the stored record quantity stays three");
    OwnedByteRegion short_reference;
    Require(short_reference.Resize(3) && !UpdateTrieValue(records, short_reference, value),
            "a three-byte reference fails the frozen four-byte trie protocol");
    Require(records.ReadRecord(0, data, size) && size == 6 &&
            std::equal(original.begin(), original.end(), data),
            "updating the second value retains the first value's literal bytes");
    std::puts("PASS: trie value offsets, shared reference publication and real fixed-store updates");
}
