// Recovered UserDictionary file header; Google-derived logic remains under NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_HEADER_H
#define COMEBACK_RECOVERED_DICTIONARY_HEADER_H

#include "payload_codec.h"

namespace comeback::recovered {

struct DictionaryHeader {
    std::uint32_t major;
    std::uint32_t minor;

    PayloadVersion payload_version() const;
};

inline constexpr std::uint32_t kCurrentDictionaryMajor = 3;
inline constexpr std::uint32_t kCurrentDictionaryMinor = 1;
inline constexpr std::size_t kDictionaryHeaderSize = 16;
using EncodedDictionaryHeader = std::array<std::uint8_t, kDictionaryHeaderSize>;

// The native writer emits the current format, not a requested legacy format.
EncodedDictionaryHeader EncodeDictionaryHeader();

// Reads the prefix of a complete dictionary, checking its CRC and supported major.
// A failed read leaves the output unchanged. This does not parse metadata or tries.
bool DecodeDictionaryHeader(const std::uint8_t* bytes, std::size_t size,
                            DictionaryHeader& header);

}  // namespace comeback::recovered
#endif
