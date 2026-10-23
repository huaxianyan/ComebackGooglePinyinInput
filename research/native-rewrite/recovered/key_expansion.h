// Native key-generator token semantics and expansion scores; see NOTICE.
#ifndef COMEBACK_RECOVERED_KEY_EXPANSION_H
#define COMEBACK_RECOVERED_KEY_EXPANSION_H
#include <cstdint>
#include <string>
#include <vector>

namespace comeback::recovered {
// Semantic fields read from the native 0x20-byte token. Not its ABI layout;
// unused flag bits/padding are absent. The auxiliary word remains unnamed and
// is signed in native ordering; neither token ID nor text substitutes for it.
// Known-field defaults match native vector growth at 0x195270; unused bits
// and padding remain outside this projection. Explicit aggregate values override.
inline constexpr std::int32_t kUnknownTokenLanguage = 26;
struct KeyToken {
    std::string text;
    std::uint32_t id = 0;
    std::int16_t auxiliary = kUnknownTokenLanguage;
    bool identity_bit = false;
};
inline constexpr std::uint32_t kTokenLiteralBit = 0x01000000u;
inline constexpr std::uint32_t kTokenCodepointMask = 0x001fffffu;
constexpr std::int16_t TokenAuxiliaryFromWord(std::int32_t value) {
    const auto low = static_cast<std::uint16_t>(value);
    return static_cast<std::int16_t>(low < 0x8000u ? low : std::int32_t{low} - 0x10000);
}
struct ScoredKeyToken {
    KeyToken token;
    float score;
    std::uint8_t marker;
};

// Native 0x18c620: compare low 48 identity bits and flag bit zero, not text.
bool SameKeyTokenIdentity(const KeyToken& left, const KeyToken& right);

// Post-iteration decision from 0x18d07c, not an iterator/provider substitute.
// A real nonnull iterator has finished; results are the entire existing output,
// including prior entries. The native null-iterator path is outside this helper.
// False may leave a nonempty singleton result with the source identity.
bool CollectedExpansionResult(const std::vector<ScoredKeyToken>& results,
    const KeyToken& source, bool accept_single_identity);

// Native 0x18d424: finite scores and an int32-sized sequence, original binary32 AddLogScores,
// subtraction, then stable compaction at the native cutoff. Retained token
// identities, strings and opaque marker bytes stay paired with their scores.
// Normal rounding, no fast-math; allocation/OOM and ABI equality are not claimed.
void NormalizeAndPruneExpansions(std::vector<ScoredKeyToken>& results);
}  // namespace comeback::recovered
#endif
