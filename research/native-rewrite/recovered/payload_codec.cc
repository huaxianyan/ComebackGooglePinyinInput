// Google-derived reconstruction; see NOTICE and payload-codec.md for boundaries.
#include "payload_codec.h"

#include <algorithm>

namespace comeback::recovered {
namespace {
constexpr std::size_t kHeaderSize = 4;
constexpr std::uint32_t kV10CountMask = 0x3fffffff;
constexpr std::uint32_t kV21CountMask = 0x07ffffff;
constexpr std::uint32_t kFlag31 = std::uint32_t{1} << 31;
constexpr std::uint32_t kFlag30 = std::uint32_t{1} << 30;
constexpr std::uint32_t kFlag27 = std::uint32_t{1} << 27;
constexpr unsigned kCategoryShift = 28;
constexpr std::uint32_t kCategoryMask = 3;

std::uint32_t CountMask(PayloadVersion version) {
    return version == PayloadVersion::V21 ? kV21CountMask : kV10CountMask;
}
}  // namespace

EncodedPayload EncodePayload(PayloadVersion version, const PayloadMetadata& metadata,
                             std::uint16_t day) {
    std::uint32_t word = std::min(metadata.count, CountMask(version));
    if (metadata.flag31) word |= kFlag31;
    if (metadata.flag30) word |= kFlag30;
    if (version == PayloadVersion::V21) {
        if (metadata.flag27) word |= kFlag27;
        word |= (metadata.category & kCategoryMask) << kCategoryShift;
    }
    EncodedPayload bytes{};
    for (std::size_t index = 0; index < kHeaderSize; ++index) {
        bytes[index] = static_cast<std::uint8_t>(word >> (index * 8));
    }
    bytes[kHeaderSize] = static_cast<std::uint8_t>(day);
    bytes[kHeaderSize + 1] = static_cast<std::uint8_t>(day >> 8);
    return bytes;
}

bool DecodePayload(PayloadVersion version, const std::uint8_t* bytes,
                   std::size_t size, PayloadMetadata& metadata, std::uint16_t* day) {
    if (size < (day == nullptr ? kHeaderSize : kPayloadSize)) return false;
    std::uint32_t word = 0;
    for (std::size_t index = 0; index < kHeaderSize; ++index) {
        word |= std::uint32_t{bytes[index]} << (index * 8);
    }
    const bool v21 = version == PayloadVersion::V21;
    const PayloadMetadata decoded{
        word & CountMask(version),
        (word & kFlag31) != 0,
        (word & kFlag30) != 0,
        v21 && (word & kFlag27) != 0,
        v21 ? ((word >> kCategoryShift) & kCategoryMask)
            : ((word & kFlag30) != 0 ? 0u : 2u),
    };
    if (day != nullptr) {
        *day = static_cast<std::uint16_t>(
            std::uint16_t{bytes[kHeaderSize]} |
            (std::uint16_t{bytes[kHeaderSize + 1]} << 8));
    }
    metadata = decoded;
    return true;
}

}  // namespace comeback::recovered
