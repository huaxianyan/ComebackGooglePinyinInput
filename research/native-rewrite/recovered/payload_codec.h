// Recovered UserDictionary payload behavior from the fixed ARM64 library.
// Google-derived material keeps the rights boundary stated in NOTICE.
#ifndef COMEBACK_RECOVERED_PAYLOAD_CODEC_H
#define COMEBACK_RECOVERED_PAYLOAD_CODEC_H

#include <array>
#include <cstddef>
#include <cstdint>

namespace comeback::recovered {

enum class PayloadVersion { V10, V21 };

// Bit names describe the wire format, not unconfirmed business meanings.
struct PayloadMetadata {
    std::uint32_t count;
    bool flag31;
    bool flag30;
    bool flag27;
    std::uint32_t category;
};

inline constexpr std::size_t kPayloadSize = 6;
using EncodedPayload = std::array<std::uint8_t, kPayloadSize>;

// Produces the native little-endian value without the old buffer allocator.
EncodedPayload EncodePayload(PayloadVersion version, const PayloadMetadata& metadata,
                             std::uint16_t day);

// A null day selects the original four-byte metadata-only read. Otherwise six
// bytes are required. Outputs are assigned only after the requested read fits.
bool DecodePayload(PayloadVersion version, const std::uint8_t* bytes,
                   std::size_t size, PayloadMetadata& metadata, std::uint16_t* day);

}  // namespace comeback::recovered
#endif
