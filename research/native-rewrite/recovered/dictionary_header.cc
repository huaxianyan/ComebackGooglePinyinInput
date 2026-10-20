// Google-derived reconstruction; see NOTICE and dictionary-storage.md.
#include "dictionary_header.h"
#include "dictionary_checksum.h"
#include "little_endian.h"

namespace comeback::recovered {
namespace {
constexpr std::uint32_t kCurrentMajor = 3;
constexpr std::uint32_t kCurrentMinor = 1;
constexpr std::uint32_t kV21Major = 2;
constexpr std::size_t kMajorOffset = sizeof(std::uint64_t);
constexpr std::size_t kMinorOffset = kMajorOffset + sizeof(std::uint32_t);
constexpr std::size_t kVersionSize = kDictionaryHeaderSize - kMajorOffset;
}  // namespace

PayloadVersion DictionaryHeader::payload_version() const {
    return major < kV21Major ? PayloadVersion::V10 : PayloadVersion::V21;
}

EncodedDictionaryHeader EncodeDictionaryHeader() {
    EncodedDictionaryHeader bytes{};
    detail::WriteLittleEndian(kCurrentMajor, bytes.data() + kMajorOffset);
    detail::WriteLittleEndian(kCurrentMinor, bytes.data() + kMinorOffset);
    detail::WriteLittleEndian<std::uint64_t>(
        CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits32,
            {{reinterpret_cast<const char*>(bytes.data() + kMajorOffset), kVersionSize}}), bytes.data());
    return bytes;
}

bool DecodeDictionaryHeader(const std::uint8_t* bytes, std::size_t size,
                            DictionaryHeader& header) {
    if (size < kDictionaryHeaderSize) return false;
    const auto major = detail::ReadLittleEndian<std::uint32_t>(bytes + kMajorOffset);
    if (major > kCurrentMajor ||
        detail::ReadLittleEndian<std::uint64_t>(bytes) != CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits32,
            {{reinterpret_cast<const char*>(bytes + kMajorOffset), kVersionSize}})) {
        return false;
    }
    header = {major, detail::ReadLittleEndian<std::uint32_t>(bytes + kMinorOffset)};
    return true;
}

}  // namespace comeback::recovered
