// Length-prefixed dictionary byte strings; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_STRING_IMAGE_H
#define COMEBACK_RECOVERED_DICTIONARY_STRING_IMAGE_H

#include "owned_byte_region.h"
#include <cstdint>
#include <optional>
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
// Native raw-array framing (0x1f6030), distinct from packed FlatVector tables:
// LE64 byte size, byte payload, eight-byte advancement. Ordinary complete images;
// preserves raw words, including bit 31. Failure leaves position unchanged.
std::optional<OwnedByteRegion> LoadDictionaryArrayImage(
    const OwnedByteRegion& input, std::size_t& position);
}  // namespace comeback::recovered
#endif
