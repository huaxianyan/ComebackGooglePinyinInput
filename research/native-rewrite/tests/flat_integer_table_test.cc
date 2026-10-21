#include "flat_integer_table.h"
#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <initializer_list>

using namespace comeback::recovered;
namespace {
OwnedByteRegion Bytes(std::initializer_list<std::uint8_t> bytes) {
    OwnedByteRegion result;
    if (!result.Resize(bytes.size())) std::abort();
    std::copy(bytes.begin(), bytes.end(), result.MutableData());
    return result;
}
bool Values(const FlatIntegerTableView& table, std::initializer_list<std::uint32_t> expected) {
    if (table.Count() != expected.size()) return false;
    std::uint64_t index = 0;
    for (const auto value : expected) if (table.At(index++) != value) return false;
    return true;
}
}
int main() {
    const FlatIntegerTableView zero(OwnedByteRegion{}, 4, 0);
    const FlatIntegerTableView one(Bytes({0x16, 0, 0, 0}), 5, 1);
    // Twelve literal three-bit values span the 32-bit boundary at index ten.
    const FlatIntegerTableView three(Bytes({0x88, 0xc6, 0xfa, 0x88, 0x06, 0, 0, 0}), 12, 3);
    const FlatIntegerTableView full(Bytes({0x78, 0x56, 0x34, 0x12, 0xff, 0xff, 0xff, 0xff}), 2, 32);
    if (!Values(zero, {0, 0, 0, 0}) || !Values(one, {0, 1, 1, 0, 1}) ||
        !Values(three, {0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3}) ||
        !Values(full, {0, 0})) {
        std::fputs("FAIL: literal flat-integer words, zero width and cross-word values\n", stderr);
        return 1;
    }
    std::puts("PASS: literal native flat-integer values at widths zero, one, three and thirty-two");
}
