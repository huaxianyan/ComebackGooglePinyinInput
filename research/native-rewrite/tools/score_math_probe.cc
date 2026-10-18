// Host-side entry point for the recovered scalar component; not an IME stub.
#include "../recovered/score_math.h"

#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>

namespace {
bool ParseScore(const char* text, float& value) {
    char* end;
    value = std::strtof(text, &end);
    return end != text && *end == '\0' && std::isfinite(value);
}
}  // namespace

int main(int argc, char** argv) {
    if (argc != 3) {
        std::fprintf(stderr, "Usage: score_math_probe LEFT_LOG_SCORE RIGHT_LOG_SCORE\n");
        return 2;
    }
    float left, right;
    if (!ParseScore(argv[1], left) || !ParseScore(argv[2], right)) {
        std::fprintf(stderr, "Invalid log score. Pass two finite numbers.\n");
        return 2;
    }
    const float result = comeback::recovered::AddLogScores(left, right);
    std::uint32_t bits;
    std::memcpy(&bits, &result, sizeof(bits));
    std::printf("%08x\n", bits);
    return 0;
}
