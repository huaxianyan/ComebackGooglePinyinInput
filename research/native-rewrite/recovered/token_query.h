// Native BFS token-query text units, not a lookup/provider facade; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_QUERY_H
#define COMEBACK_RECOVERED_TOKEN_QUERY_H
#include <string>
#include <string_view>
#include <vector>

namespace comeback::recovered {
// Native 0x1bf8dc. Append complete UTF-8 code-point byte strings to existing
// output. Input is already prepared, complete valid UTF-8 and must not alias
// output storage. This is neither Unicode normalization nor a UTF-8 validator;
// malformed/truncated bytes are outside the domain. No grapheme/UTF-16 split.
void AppendTokenQueryUnits(std::string_view input, std::vector<std::string>& output);
}  // namespace comeback::recovered
#endif
