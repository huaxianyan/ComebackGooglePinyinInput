// Length-prefixed dictionary byte strings; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_STRING_IMAGE_H
#define COMEBACK_RECOVERED_DICTIONARY_STRING_IMAGE_H

#include "owned_byte_region.h"
#include <cstdint>
#include <string>
#include <string_view>

namespace comeback::recovered {
// LE32 byte length, payload, then zero padding to an eight-byte section size.
// Payloads are serialized by the caller into storage independent of output,
// matching the original protobuf string temporary.
bool SerializeDictionaryStringImage(std::string_view payload, OwnedByteRegion& output);
// Returns aligned logical advancement, or zero on incomplete prefix/body.
// Native requires the body but does not require trailing padding to exist.
std::uint64_t LoadDictionaryStringImage(const OwnedByteRegion& input, std::string& payload);
}  // namespace comeback::recovered
#endif
