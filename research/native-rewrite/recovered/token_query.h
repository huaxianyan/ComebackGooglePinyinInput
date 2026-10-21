// Native BFS token-query text units, not a lookup/provider facade; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_QUERY_H
#define COMEBACK_RECOVERED_TOKEN_QUERY_H
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

namespace comeback::recovered {
// Native 0x1bf8dc. Append complete UTF-8 code-point byte strings to existing
// output. Input is already prepared, complete valid UTF-8 and must not alias
// output storage. This is neither Unicode normalization nor a UTF-8 validator;
// malformed/truncated bytes are outside the domain. No grapheme/UTF-16 split.
void AppendTokenQueryUnits(std::string_view input, std::vector<std::string>& output);
// Native 0x2d16c8 and its captured 256-byte map: only ASCII A..Z change.
// This is distinct from the still-unrecovered Unicode preparation at 0x1bf63c.
void LowercaseTokenBytes(std::string& text);
// One complete valid UTF-8 code-point unit; shared by actual dictionary readers.
std::uint32_t ReadTokenQueryScalar(std::string_view unit);
// Native 0x1bf884 scalar encoding. Valid Unicode scalar input, no normalization
// or malformed-scalar replacement policy is claimed by this component.
std::string EncodeTokenCodepoint(std::uint32_t scalar);
}  // namespace comeback::recovered
#endif
