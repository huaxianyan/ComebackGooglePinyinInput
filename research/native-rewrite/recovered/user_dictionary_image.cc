// Native 0x1a2228 / 0x1a2b38 / 0x1a3c9c; Google-derived, see NOTICE.
#include "user_dictionary_image.h"
#include "dictionary_alignment.h"
#include "dictionary_header.h"
#include "dictionary_string_image.h"

#include <cstring>
#include <string>
#include <utility>

namespace comeback::recovered {
bool SerializeUserDictionaryImage(const UserDictionaryStorage& dictionary, OwnedByteRegion& output) {
    const auto header = EncodeDictionaryHeader();
    std::string metadata;
    OwnedByteRegion section, body;
    if (!dictionary.metadata.SerializeToString(&metadata) ||
        !SerializeDictionaryStringImage(metadata, section) ||
        !SerializeMutableDictionary(dictionary.dictionary, body)) return false;
    const auto body_offset = header.size() + section.Size();
    const auto aligned_body = detail::AlignDictionaryBytes(body.Size());
    OwnedByteRegion image;
    if (!image.Resize(body_offset + aligned_body)) return false;
    auto* bytes = image.MutableData();
    if (bytes == nullptr) return false;
    std::memcpy(bytes, header.data(), header.size());
    std::memcpy(bytes + header.size(), section.Data(), section.Size());
    std::memcpy(bytes + body_offset, body.Data(), body.Size());
    std::memset(bytes + body_offset + body.Size(), 0, aligned_body - body.Size());
    output = std::move(image);
    return true;
}

std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion& input, UserDictionaryStorage& output) {
    DictionaryHeader header{};
    if (!DecodeDictionaryHeader(input.Data(), input.Size(), header) ||
        header.major != kCurrentDictionaryMajor) return 0;
    UserDictionaryStorage loaded;
    std::string metadata;
    const auto section_size = LoadDictionaryStringImage(
        input.Slice(kDictionaryHeaderSize, input.Size() - kDictionaryHeaderSize), metadata);
    if (section_size == 0 || section_size > input.Size() - kDictionaryHeaderSize ||
        !loaded.metadata.ParseFromString(metadata)) return 0;
    const auto body_offset = kDictionaryHeaderSize + section_size;
    const auto body_size = LoadMutableDictionary(input.Slice(body_offset, input.Size() - body_offset),
                                                  loaded.dictionary);
    if (body_size == 0 || detail::AlignDictionaryBytes(body_size) > input.Size() - body_offset) return 0;
    // Native 0x1c6994 computes the header-aware serialized size. Reuse the one
    // encoding definition to check it; this currently allocates a canonical
    // body rather than using the native allocation-free size calculation.
    OwnedByteRegion canonical;
    if (!SerializeMutableDictionary(loaded.dictionary, canonical) || canonical.Size() != body_size ||
        loaded.dictionary.metadata.forward_payload_size() != static_cast<std::int32_t>(kPayloadSize)) return 0;
    output = std::move(loaded);
    return body_offset + detail::AlignDictionaryBytes(body_size);
}
}  // namespace comeback::recovered
