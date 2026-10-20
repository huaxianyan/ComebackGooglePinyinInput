// Shared memory/file image sink; Google-derived wire behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_IMAGE_WRITER_H
#define COMEBACK_RECOVERED_DICTIONARY_IMAGE_WRITER_H

#include "owned_byte_region.h"
#include <functional>
#include <string_view>

namespace comeback::recovered {
using DictionaryImageSink = std::function<bool(const std::uint8_t*, std::size_t)>;
bool AppendDictionaryImageBytes(OwnedByteRegion& output, const std::uint8_t* bytes, std::size_t size);
bool WriteAlignedDictionaryImage(const DictionaryImageSink& sink, const OwnedByteRegion& image);
bool WriteNamedDictionaryImage(const DictionaryImageSink& sink, std::string_view name,
                               const OwnedByteRegion& image);
}  // namespace comeback::recovered
#endif
