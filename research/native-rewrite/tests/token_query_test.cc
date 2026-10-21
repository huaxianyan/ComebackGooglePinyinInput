#include "token_query.h"
#include <cstdio>

using namespace comeback::recovered;
using namespace std::string_view_literals;
int main() {
    const auto input = "A\0" "\xe4\xb8\xad" "\xf0\x9f\x98\x80" "e\xcc\x81"sv;
    std::vector<std::string> units{"prior"};
    AppendTokenQueryUnits(input, units);
    const std::vector<std::string> expected{
        "prior", "A", std::string(1, '\0'), "\xe4\xb8\xad", "\xf0\x9f\x98\x80", "e", "\xcc\x81"};
    if (units != expected) {
        std::fputs("FAIL: query units must append complete UTF8 code points, preserving NUL and separating combining marks\n", stderr);
        return 1;
    }
    std::puts("PASS: literal BFS query units append all UTF8 widths with NUL, supplementary and combining code points");
}
