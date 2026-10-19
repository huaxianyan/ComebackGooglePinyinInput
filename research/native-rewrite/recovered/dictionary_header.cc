// Google-derived reconstruction; see NOTICE and dictionary-storage.md.
#include "dictionary_header.h"
#include "little_endian.h"

namespace comeback::recovered {
namespace {
constexpr std::uint32_t kCurrentMajor = 3;
constexpr std::uint32_t kCurrentMinor = 1;
constexpr std::uint32_t kV21Major = 2;
constexpr std::size_t kMajorOffset = sizeof(std::uint64_t);
constexpr std::size_t kMinorOffset = kMajorOffset + sizeof(std::uint32_t);
constexpr std::size_t kVersionSize = kDictionaryHeaderSize - kMajorOffset;
// Native Default(32, 0) uses this reflected polynomial as both polynomial and
// empty state. The header extends exactly eight bytes, with no final XOR.
constexpr std::uint32_t kHeaderPolynomial = 0xb9e50c1d;

std::uint32_t HeaderChecksum(const std::uint8_t* version_bytes) {
    std::uint32_t state = kHeaderPolynomial;
    for (std::size_t index = 0; index < kVersionSize; ++index) {
        state ^= version_bytes[index];
        for (unsigned bit = 0; bit < 8; ++bit) {
            const bool low_bit = (state & 1u) != 0;
            state >>= 1;
            if (low_bit) state ^= kHeaderPolynomial;
        }
    }
    return state;
}
}  // namespace

PayloadVersion DictionaryHeader::payload_version() const {
    return major < kV21Major ? PayloadVersion::V10 : PayloadVersion::V21;
}

EncodedDictionaryHeader EncodeDictionaryHeader() {
    EncodedDictionaryHeader bytes{};
    detail::WriteLittleEndian(kCurrentMajor, bytes.data() + kMajorOffset);
    detail::WriteLittleEndian(kCurrentMinor, bytes.data() + kMinorOffset);
    detail::WriteLittleEndian<std::uint64_t>(HeaderChecksum(bytes.data() + kMajorOffset),
                                           bytes.data());
    return bytes;
}

bool DecodeDictionaryHeader(const std::uint8_t* bytes, std::size_t size,
                            DictionaryHeader& header) {
    if (size < kDictionaryHeaderSize) return false;
    const auto major = detail::ReadLittleEndian<std::uint32_t>(bytes + kMajorOffset);
    if (major > kCurrentMajor ||
        detail::ReadLittleEndian<std::uint64_t>(bytes) != HeaderChecksum(bytes + kMajorOffset)) {
        return false;
    }
    header = {major, detail::ReadLittleEndian<std::uint32_t>(bytes + kMinorOffset)};
    return true;
}

}  // namespace comeback::recovered
