// Native 0x1a2228 / 0x1a2b38 / 0x1a3c9c; Google-derived, see NOTICE.
#include "user_dictionary_image.h"
#include "dictionary_alignment.h"
#include "dictionary_header.h"
#include "dictionary_string_image.h"

#include <string>
#include <utility>

namespace comeback::recovered {
bool WriteUserDictionaryImage(const UserDictionaryStorage& dictionary, const DictionaryImageSink& sink) {
    const auto header = EncodeDictionaryHeader();
    std::string metadata;
    OwnedByteRegion section;
    return dictionary.metadata.SerializeToString(&metadata) &&
           SerializeDictionaryStringImage(metadata, section) && sink(header.data(), header.size()) &&
           sink(section.Data(), section.Size()) && WriteMutableDictionaryImage(dictionary.dictionary, sink);
}

bool SerializeUserDictionaryImage(const UserDictionaryStorage& dictionary, OwnedByteRegion& output) {
    OwnedByteRegion image;
    if (!WriteUserDictionaryImage(dictionary, [&](const std::uint8_t* data, std::size_t size) {
            return AppendDictionaryImageBytes(image, data, size);
        })) return false;
    output = std::move(image);
    return true;
}

bool DuplicateUserDictionary(const UserDictionaryStorage& source, UserDictionaryStorage& output) {
    OwnedByteRegion chunk;
    return SerializeUserDictionaryImage(source, chunk) && LoadUserDictionaryImage(chunk, output) != 0;
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
    // Count the same writer rather than allocating a full canonical container.
    // Subtable codecs still allocate images and calculate CRCs: this is not the
    // native allocation-free 0x1c6994 size calculation.
    std::uint64_t canonical_size = 0;
    if (!WriteMutableDictionaryImage(loaded.dictionary, [&](const std::uint8_t*, std::size_t size) {
            canonical_size += size;
            return true;
        }) || canonical_size != body_size ||
        loaded.dictionary.metadata.forward_payload_size() != static_cast<std::int32_t>(kPayloadSize)) return 0;
    output = std::move(loaded);
    return body_offset + detail::AlignDictionaryBytes(body_size);
}
}  // namespace comeback::recovered
