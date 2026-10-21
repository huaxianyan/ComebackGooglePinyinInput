#include "key_expansion.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>

using namespace comeback::recovered;
namespace {
void Require(bool value, const char* message) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", message); std::exit(1); }
}
std::uint32_t Bits(float value) {
    std::uint32_t result;
    std::memcpy(&result, &value, sizeof(result));
    return result;
}
}
int main() {
    const KeyToken source{"source", 0x12345678u, -3, true};
    std::vector<ScoredKeyToken> collected{{{"different spelling", 0x12345678u, -3, true}, -4.0f, 0x7a}};
    Require(!CollectedExpansionResult(collected, source, false) &&
            CollectedExpansionResult(collected, source, true) &&
            collected.size() == 1 && collected.front().token.text == "different spelling",
            "a singleton with the source identity stays present even when its collection result is false");
    const KeyToken different[]{
        {"source", 0x12345679u, -3, true},
        {"source", 0x12345678u, -2, true},
        {"source", 0x12345678u, -3, false}};
    for (const auto& token : different) {
        collected.front().token = token;
        Require(CollectedExpansionResult(collected, source, false),
                "each differing identity component makes the singleton expansion distinct from its source");
    }
    collected.front().token = source;
    collected.push_back({source, -8.0f, 0});
    Require(CollectedExpansionResult(collected, source, false),
            "collection checks the entire existing output rather than deduplicating its matching identities");

    std::vector<ScoredKeyToken> normalized{
        {{"discard", 99, 3, false}, -128.0f, 0xa1},
        {{"b", 8, -1, true}, 0.0f, 0x21},
        {{"a", 7, -2, false}, 0.0f, 0xe3}};
    NormalizeAndPruneExpansions(normalized);
    // Native far-distance branch drops -128 from the sum; two zero scores
    // combine to literal ln(2), so both retained normalized words are -ln(2).
    Require(normalized.size() == 2 &&
            normalized[0].token.text == "b" && normalized[0].token.id == 8 &&
            normalized[0].token.auxiliary == -1 && normalized[0].token.identity_bit &&
            normalized[0].marker == 0x21 && Bits(normalized[0].score) == 0xbf317218u &&
            normalized[1].token.text == "a" && normalized[1].token.id == 7 &&
            normalized[1].token.auxiliary == -2 && !normalized[1].token.identity_bit &&
            normalized[1].marker == 0xe3 && Bits(normalized[1].score) == 0xbf317218u,
            "native normalization removes the weak expansion and retains source order, full identities and opaque markers");
    std::vector<ScoredKeyToken> above{{source, 0.0f, 1}, {{"near", 11, 4, false}, -2.19f, 2}};
    std::vector<ScoredKeyToken> below{{source, 0.0f, 1}, {{"near", 12, 4, false}, -2.20f, 2}};
    NormalizeAndPruneExpansions(above);
    NormalizeAndPruneExpansions(below);
    Require(above.size() == 2 && above[1].token.id == 11 &&
            below.size() == 1 && below[0].token.id == 0x12345678u,
            "two literal near-cutoff inputs retain or remove the second expansion at the original threshold");
    std::puts("PASS: key-token identity, whole collection result and native score normalization/stable pruning");
}
