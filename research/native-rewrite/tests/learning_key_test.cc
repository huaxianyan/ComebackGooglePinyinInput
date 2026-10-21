#include "learning_key.h"
#include <cstdio>
#include <cstdlib>
#include <limits>
#include <string_view>

using namespace comeback::recovered;
using namespace std::string_view_literals;
namespace {
void Require(bool value, const char* message) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", message); std::exit(1); }
}
}
int main() {
    const GeneratedLearningKey key{{"ab", "", std::string("c\0d", 3)}, 1.0f, false, 0};
    std::string encoded = "old content";
    SerializeLearningKey(key, true, encoded);
    Require(encoded == "abc\0d"sv, "source-order encoding replaces output and preserves complete binary token strings");
    SerializeLearningKey(key, false, encoded);
    Require(encoded == "c\0dab"sv, "reverse encoding reverses token order, not the bytes inside each token");
    Require(ScaleLearningCount(16777219, 0.5f) == 8388610,
            "int32 conversion rounds to binary32 before multiplication and truncation");
    Require(ScaleLearningCount(2147483647, 1.0f) == 2147483647,
            "FCVTZS saturates the rounded positive overflow instead of using an undefined C++ conversion");
    Require(ScaleLearningCount(7, std::numeric_limits<float>::infinity()) == 2147483647 &&
            ScaleLearningCount(7, -std::numeric_limits<float>::infinity()) == 1 &&
            ScaleLearningCount(7, std::numeric_limits<float>::quiet_NaN()) == 1,
            "ARM64 infinity and NaN conversions retain the native final minimum-one result");
    std::puts("PASS: literal token-string encodings and ARM64 binary32 learning-count conversion");
}
