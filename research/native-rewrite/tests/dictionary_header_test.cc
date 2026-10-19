// Header CRC fixtures use independent GF(2) polynomial long division, not the
// recovered checksum implementation. They are static anchors, not ARM execution.
#include "../recovered/dictionary_header.h"

#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;

namespace {
void Require(bool condition, const char* operation) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", operation);
        std::exit(1);
    }
}

struct Fixture {
    std::array<std::uint8_t, 16> bytes;
    std::uint32_t major;
    std::uint32_t minor;
    PayloadVersion version;
    std::array<std::uint8_t, 6> payload;
};
}  // namespace

int main() {
    const Fixture fixtures[]{
        {{0x87, 0x87, 0xf8, 0x99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
         0, 0, PayloadVersion::V10, {0x67, 0x45, 0x23, 0x81, 0x2b, 0x4a}},
        {{0xb2, 0x90, 0xc3, 0xd9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
         1, 0, PayloadVersion::V10, {0x67, 0x45, 0x23, 0x81, 0x2b, 0x4a}},
        {{0xed, 0xa9, 0x8e, 0x19, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0},
         2, 0, PayloadVersion::V21, {0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a}},
        {{0x96, 0xa4, 0xcb, 0xa7, 0, 0, 0, 0, 3, 0, 0, 0, 1, 0, 0, 0},
         3, 1, PayloadVersion::V21, {0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a}},
    };
    const PayloadMetadata value{0x01234567, true, false, true, 2};
    for (const auto& fixture : fixtures) {
        DictionaryHeader header{};
        Require(DecodeDictionaryHeader(fixture.bytes.data(), fixture.bytes.size(), header),
                "reading a supported header with its native CRC");
        Require(header.major == fixture.major && header.minor == fixture.minor,
                "exposing the stored version fields");
        Require(header.payload_version() == fixture.version,
                "choosing the payload layout from the header");
        Require(EncodePayload(header.payload_version(), value, 0x4a2b) == fixture.payload,
                "header selection produces the expected legacy or current payload bytes");
    }
    Require(EncodeDictionaryHeader() == fixtures[3].bytes,
            "writing the native current 3.1 header");

    // The file's frozen checksum protocol rejects a damaged prefix before use.
    auto damaged = fixtures[3].bytes;
    damaged[0] ^= 1;
    DictionaryHeader header{1, 7};
    Require(!DecodeDictionaryHeader(damaged.data(), damaged.size(), header),
            "a damaged header is reported instead of selecting its format");
    Require(header.major == 1 && header.minor == 7,
            "a failed header check preserves the previous output");
    std::puts("PASS: supported headers, native CRC, payload selection and current header bytes");
}
