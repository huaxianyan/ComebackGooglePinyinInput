#include "dictionary_compaction.h"
#include <array>
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;
namespace {
void Require(bool value, const char* action) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
struct Payload {
    EncodedPayload wire{};
    PayloadMetadata metadata{};
    std::uint16_t day = 0;
};
Payload Read(const std::array<std::uint8_t, 6>& literal) {
    Payload result;
    result.wire = literal;
    Require(DecodePayload(PayloadVersion::V21, literal.data(), literal.size(), result.metadata, &result.day),
            "decode a literal wire payload for the compaction decisions");
    return result;
}
bool Before(const Payload& left, const Payload& right) {
    return DictionaryCompactionPrecedes(left.metadata, left.day, right.metadata, right.day);
}
}
int main() {
    const auto recent = Read({1, 0, 0, 0, 100, 0});
    const auto older = Read({100, 0, 0, 0, 99, 0});
    const auto flagged = Read({1, 0, 0, 0x40, 100, 0});
    const auto higher = Read({2, 0, 0, 0x40, 100, 0});
    const auto zeroFlag31 = Read({0, 0, 0, 0x80, 100, 0});
    const auto inactive = Read({0, 0, 0, 0x78, 0xff, 0xff});
    Require(Before(recent, older) && Before(flagged, recent) && Before(higher, flagged),
            "recent day, then flag30, then count determine the original precedence");
    Require(Before(zeroFlag31, inactive) && !Before(inactive, recent) && !Before(inactive, inactive),
            "flag31 admits a zero-count payload while the original inactive class compares equal");
    Require(IsDictionaryCompactionCandidate(recent.metadata, recent.day, 100) &&
            !IsDictionaryCompactionCandidate(older.metadata, older.day, 100) &&
            IsDictionaryCompactionCandidate(zeroFlag31.metadata, zeroFlag31.day, 100) &&
            !IsDictionaryCompactionCandidate(inactive.metadata, inactive.day, 100),
            "the inclusive cutoff admits recent active payloads and excludes old or inactive ones");
    const auto plan = PlanDictionaryCompaction(
        {older.wire, recent.wire, flagged.wire, higher.wire, zeroFlag31.wire, inactive.wire}, 6, 3, 100);
    Require(plan.changed && plan.keep_count == 2 &&
            plan.order == std::vector<std::size_t>({3, 2, 0, 1, 4, 5}),
            "the original heap retains the preferred prefix and preserves its actual deletion suffix order");
    const auto tied = PlanDictionaryCompaction({recent.wire, recent.wire, recent.wire}, 3, 3, 100);
    Require(tied.keep_count == 2 && tied.order == std::vector<std::size_t>({1, 0, 2}),
            "equal payloads preserve native heap tie behavior rather than a new stable or lexical order");
    const auto unchanged = PlanDictionaryCompaction({recent.wire}, 1, 2, 100);
    Require(!unchanged.changed && unchanged.keep_count == 1 &&
            unchanged.order == std::vector<std::size_t>({0}),
            "a current dictionary already inside its bound keeps its original entry order");
    std::puts("PASS: compaction precedence, cutoff and exact native heap selection plan");
}
