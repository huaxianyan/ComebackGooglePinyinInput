// Fixed bytes deduced from the original ARM64 bit fields and memcpy operations.
// This host test does not execute the original library or claim engine equivalence.
#include "../recovered/payload_codec.h"

#include <cstdio>
#include <cstdlib>

using comeback::recovered::DecodePayload;
using comeback::recovered::EncodePayload;
using comeback::recovered::PayloadMetadata;
using comeback::recovered::PayloadVersion;

namespace {
void Require(bool condition, const char* operation) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", operation);
        std::exit(1);
    }
}

bool Same(const PayloadMetadata& left, const PayloadMetadata& right) {
    return left.count == right.count && left.flag31 == right.flag31 &&
           left.flag30 == right.flag30 && left.flag27 == right.flag27 &&
           left.category == right.category;
}

struct Fixture {
    PayloadVersion version;
    PayloadMetadata input;
    std::uint16_t day;
    std::array<std::uint8_t, 6> bytes;
    PayloadMetadata decoded;
};
}  // namespace

int main() {
    // Expectations are literals, not calculated with the recovered codec.
    const Fixture fixtures[]{
        {PayloadVersion::V21, {0x01234567, true, false, true, 2}, 0x4a2b,
         {0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a},
         {0x01234567, true, false, true, 2}},
        {PayloadVersion::V21, {0xffffffff, false, true, false, 3}, 0xfffe,
         {0xff, 0xff, 0xff, 0x77, 0xfe, 0xff},
         {0x07ffffff, false, true, false, 3}},
        {PayloadVersion::V10, {0x01234567, true, false, true, 1}, 0x4a2b,
         {0x67, 0x45, 0x23, 0x81, 0x2b, 0x4a},
         {0x01234567, true, false, false, 2}},
        {PayloadVersion::V10, {0xffffffff, false, true, true, 3}, 0x0001,
         {0xff, 0xff, 0xff, 0x7f, 0x01, 0x00},
         {0x3fffffff, false, true, false, 0}},
    };
    for (const auto& fixture : fixtures) {
        Require(EncodePayload(fixture.version, fixture.input, fixture.day) == fixture.bytes,
                "encoding matches the fixed six-byte fixture");
        PayloadMetadata metadata{};
        std::uint16_t day = 0;
        Require(DecodePayload(fixture.version, fixture.bytes.data(), fixture.bytes.size(),
                              metadata, &day), "reading a full payload");
        Require(Same(metadata, fixture.decoded) && day == fixture.day,
                "decoded fields match independently specified values");
    }

    // Native decoders skip the date read when its output pointer is null.
    const auto& fixture = fixtures[0];
    PayloadMetadata metadata{};
    Require(DecodePayload(fixture.version, fixture.bytes.data(), 4, metadata, nullptr),
            "reading only the metadata prefix");
    Require(Same(metadata, fixture.decoded), "metadata prefix exposes its fields");
    // Frozen ABI: the failed second read branches before metadata assignments.
    metadata = {7, false, true, false, 1};
    const auto previous = metadata;
    std::uint16_t day = 0x1234;
    Require(!DecodePayload(fixture.version, fixture.bytes.data(), 4, metadata, &day),
            "requesting a date also requires its two bytes");
    Require(Same(metadata, previous) && day == 0x1234,
            "an incomplete requested value leaves outputs at their prior values");
    std::puts("PASS: V10/V21 fixed bytes, saturation, flags, date and metadata-only reads");
}
