#include "token_query.h"
#include <cstdio>
using namespace comeback::recovered;
int main() {
    // Native-interchange-valid literals: ASCII case is preserved, the combining
    // mark precedes its base after reversal, supplementary bytes stay together.
    const std::string input = "A\xe4\xb8\xad\xf0\x9f\x98\x80" "e\xcc\x81";
    const std::string expected = "\xcc\x81" "e\xf0\x9f\x98\x80\xe4\xb8\xad" "A";
    if (ReverseTokenQueryUnits(input) != expected || !ReverseTokenQueryUnits("").empty()) {
        std::fputs("FAIL: prepared query reversal differs from literal code-point order\n", stderr);
        return 1;
    }
    std::puts("interchange-valid query reversal preserves UTF8 units, case and empty input");
}
