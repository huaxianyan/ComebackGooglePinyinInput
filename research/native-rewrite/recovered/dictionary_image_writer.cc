#include "dictionary_image_writer.h"
#include "dictionary_alignment.h"
#include "dictionary_string_image.h"

#include <array>
#include <cstring>

namespace comeback::recovered {
bool AppendDictionaryImageBytes(OwnedByteRegion& output, const std::uint8_t* bytes, std::size_t size) {
    if (size == 0) return true;
    const auto start = output.Size();
    if (!output.Resize(start + size)) return false;
    auto* writable = output.MutableData();
    if (writable == nullptr) return false;
    std::memcpy(writable + start, bytes, size);
    return true;
}

bool WriteAlignedDictionaryImage(const DictionaryImageSink& sink, const OwnedByteRegion& image) {
    static constexpr std::array<std::uint8_t, detail::kDictionaryAlignment> padding{};
    return sink(image.Data(), image.Size()) &&
           sink(padding.data(), detail::AlignDictionaryBytes(image.Size()) - image.Size());
}

bool WriteNamedDictionaryImage(const DictionaryImageSink& sink, std::string_view name,
                               const OwnedByteRegion& image) {
    OwnedByteRegion tag;
    return SerializeDictionaryStringImage(name, tag) && sink(tag.Data(), tag.Size()) &&
           WriteAlignedDictionaryImage(sink, image);
}
}  // namespace comeback::recovered
