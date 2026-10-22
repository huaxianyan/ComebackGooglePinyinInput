// Native token-query text operations and real DFS helper; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_QUERY_H
#define COMEBACK_RECOVERED_TOKEN_QUERY_H
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace comeback::recovered {
class TokenDictionaryCursor;
struct KeyToken;
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
// One complete valid UTF-8 code-point unit; shared by actual dictionary readers.
std::uint32_t ReadTokenQueryScalar(std::string_view unit);
// Native 0x1bf884 scalar encoding. Valid Unicode scalar input, no normalization
// or malformed-scalar replacement policy is claimed by this component.
std::string EncodeTokenCodepoint(std::uint32_t scalar);
}  // namespace comeback::recovered
#endif
