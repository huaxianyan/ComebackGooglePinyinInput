// Native token-query text operations and real DFS helper; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_QUERY_H
#define COMEBACK_RECOVERED_TOKEN_QUERY_H
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace comeback::recovered {
class TokenDictionaryCursor;
class TokenDictionaryManager;
struct KeyToken;
struct GeneratedLearningKey;
// Native 0x1bf8dc. Append complete UTF-8 code-point byte strings to existing
// output. Input is already prepared, complete valid UTF-8 and must not alias
// output storage. This is neither Unicode normalization nor a UTF-8 validator;
// malformed/truncated bytes are outside the domain. No grapheme/UTF-16 split.
void AppendTokenQueryUnits(std::string_view input, std::vector<std::string>& output);
// Native 0x2d16c8 and its captured 256-byte map: only ASCII A..Z change.
// This is distinct from the code-point reversal at 0x1bf63c.
void LowercaseTokenBytes(std::string& text);
// Native 0x1bf63c on input already passing native interchange validation.
// Preserves each code point's original bytes, not grapheme order or case-folding.
// Native invalid/non-interchange repair is NOT implemented by this projection.
std::string ReverseTokenQueryUnits(std::string_view input);
// Native 0x195a68 using a real ordinary DFS cursor; no BFS fallback or logging
// of input text. If reverse_text, the above interchange-valid precondition holds.
// Push/Next/Current return values are not extra failure gates. Success requires
// Pop (fatal protocol failure otherwise); a miss resets the cursor.
bool LookupTokenQuery(TokenDictionaryCursor* cursor, const std::string& input,
                      bool reverse_text, std::int32_t language, bool is_source, KeyToken* output);
// Ordinary-Manager projection of 0x19550c and the callers' slot-15 flag read.
// Languages correspond one-for-one to input; count fits the native int32 loop.
// Input is interchange-valid UTF-8. Resize preserves old entries, initializes
// newly added tokens, then writes in reverse source order. A miss retains the
// written prefix and untouched remainder. Actual callers pass nonnull output;
// generic null-DFS/BFS dispatch and in-place reconfiguration are not supplied.
bool ConvertSourceTokens(const TokenDictionaryManager& manager,
                         const std::vector<std::string>& input,
                         const std::vector<std::int32_t>& languages, std::vector<KeyToken>& output);
// Native 0x18ccb0 validation + 0x18db08 no-expansion caller, projected into
// the existing GeneratedLearningKey consumer type. Returns zero or one key.
// Text and native int32 count domain remain as in ConvertSourceTokens.
// Native scale/flag/category are observed values, not expansion substitutes.
// Token identities and the original all-true marker vector are outside that
// consumed projection; no fabricated empty vector or alternate key type.
std::vector<GeneratedLearningKey> GenerateUnexpandedLearningKeys(
    const TokenDictionaryManager& manager, const std::vector<std::string>& input,
    const std::vector<std::int32_t>& languages);
// One complete valid UTF-8 code-point unit; shared by actual dictionary readers.
std::uint32_t ReadTokenQueryScalar(std::string_view unit);
// Native 0x1bf884 scalar encoding. Valid Unicode scalar input, no normalization
// or malformed-scalar replacement policy is claimed by this component.
std::string EncodeTokenCodepoint(std::uint32_t scalar);
}  // namespace comeback::recovered
#endif
