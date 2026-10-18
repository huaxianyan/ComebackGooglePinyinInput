// Recovered behavior; Google-derived rights remain as stated in NOTICE.
#include "score_math.h"

#include <cmath>
#include <cstdint>
#include <cstring>
#include <limits>

namespace comeback::recovered {
namespace {

static_assert(sizeof(float) == sizeof(std::uint32_t) &&
              std::numeric_limits<float>::is_iec559,
              "The recovered arithmetic requires IEEE-754 binary32");

#include "score_math_tables.inc"

float FromBits(std::uint32_t bits) {
    float value;
    std::memcpy(&value, &bits, sizeof(value));
    return value;
}

std::uint32_t ToBits(float value) {
    std::uint32_t bits;
    std::memcpy(&bits, &value, sizeof(bits));
    return bits;
}

// Original 0x18c56c: the bias puts exponent and table indices into float bits.
// FMADD is fused; replacing it with a multiply followed by an add changes cells.
float FastExp(float value) {
    const float encoded = std::fma(value, FromBits(kLog2EBits), FromBits(kExpBiasBits));
    const std::uint32_t bits = ToBits(encoded);
    const std::uint32_t high = kExpMantissaBits[(bits >> 8) & 0x7fu];
    const std::uint32_t exponent = (bits & 0x7f8000u) << 8;
    const float residual = FromBits(kExpResidualBits[bits & 0xffu]);
    return residual * FromBits(high | exponent);
}

// Original 0x18c5d8: linear interpolation in log2 space, then conversion to ln.
float FastLog(float value) {
    const std::uint32_t bits = ToBits(value);
    const std::uint32_t cell = (bits >> 16) & 0x7fu;
    const float low_mantissa = static_cast<float>(bits & 0xffffu);
    const float exponent = static_cast<float>(static_cast<int>((bits >> 23) & 0xffu) - 127);
    const float base = exponent + FromBits(kLogMantissaBits[cell]);
    const float interpolated = std::fma(low_mantissa, FromBits(kLogSlopeBits[cell]), base);
    return interpolated * FromBits(kLn2Bits);
}

}  // namespace

// Original 0x18c69c. Keep the separate subtractions and float32 operations.
float AddLogScores(float left, float right) {
    const float difference = left - right;
    const float scaled = difference * FromBits(kLog2EBits);
    if (std::fabs(scaled) > FromBits(kLogAddLimitBits)) {
        return left > right ? left : right;
    }
    if (left > right) {
        const float delta = right - left;
        const float exponential = FastExp(delta);
        const float sum = exponential + 1.0f;
        const float correction = FastLog(sum);
        return left + correction;
    }
    const float exponential = FastExp(difference);
    const float sum = exponential + 1.0f;
    const float correction = FastLog(sum);
    return right + correction;
}

}  // namespace comeback::recovered
