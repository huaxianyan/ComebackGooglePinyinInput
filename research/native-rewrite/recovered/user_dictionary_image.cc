// Native 0x1a2228 / 0x1a2b38 / 0x1a3c9c; Google-derived, see NOTICE.
#include "user_dictionary_image.h"
#include "dictionary_alignment.h"
#include "dictionary_header.h"
#include "dictionary_string_image.h"

#include <string>
#include <utility>

namespace comeback::recovered {
namespace {
template <typename Backend> struct BackendCodec;
template <> struct BackendCodec<MutableDictionaryStorage> {
    static constexpr auto write = &WriteMutableDictionaryImage;
    static constexpr auto load = &LoadMutableDictionary;
};
template <> struct BackendCodec<SingleTrieMutableDictionaryStorage> {
    static constexpr auto write = &WriteSingleTrieMutableDictionaryImage;
    static constexpr auto load = &LoadSingleTrieMutableDictionary;
};
}

template <typename Backend>
bool WriteUserDictionaryImage(const UserDictionaryStorage<Backend>& dictionary, const DictionaryImageSink& sink) {
    const auto header = EncodeDictionaryHeader();
    std::string metadata;
    OwnedByteRegion section;
    return dictionary.metadata.SerializeToString(&metadata) &&
           SerializeDictionaryStringImage(metadata, section) && sink(header.data(), header.size()) &&
           sink(section.Data(), section.Size()) && BackendCodec<Backend>::write(dictionary.dictionary, sink);
}

template <typename Backend>
bool SerializeUserDictionaryImage(const UserDictionaryStorage<Backend>& dictionary, OwnedByteRegion& output) {
    OwnedByteRegion image;
    if (!WriteUserDictionaryImage(dictionary, [&](const std::uint8_t* data, std::size_t size) {
            return AppendDictionaryImageBytes(image, data, size);
        })) return false;
    output = std::move(image);
    return true;
}

template <typename Backend>
bool DuplicateUserDictionary(const UserDictionaryStorage<Backend>& source, UserDictionaryStorage<Backend>& output) {
    OwnedByteRegion chunk;
    return SerializeUserDictionaryImage(source, chunk) && LoadUserDictionaryImage(chunk, output) != 0;
}

template <typename Backend>
std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion& input, UserDictionaryStorage<Backend>& output) {
    DictionaryHeader header{};
    if (!DecodeDictionaryHeader(input.Data(), input.Size(), header) ||
        header.major != kCurrentDictionaryMajor) return 0;
    UserDictionaryStorage<Backend> loaded;
    std::string metadata;
    const auto section_size = LoadDictionaryStringImage(
        input.Slice(kDictionaryHeaderSize, input.Size() - kDictionaryHeaderSize), metadata);
    if (section_size == 0 || section_size > input.Size() - kDictionaryHeaderSize ||
        !loaded.metadata.ParseFromString(metadata)) return 0;
    const auto body_offset = kDictionaryHeaderSize + section_size;
    const auto body_size = BackendCodec<Backend>::load(input.Slice(body_offset, input.Size() - body_offset),
                                                       loaded.dictionary);
    if (body_size == 0 || detail::AlignDictionaryBytes(body_size) > input.Size() - body_offset) return 0;
    // Count the same writer rather than allocating a full canonical container.
    // Subtable codecs still allocate images and calculate CRCs: this is not the
    // native direct serialized-size calculation.
    std::uint64_t canonical_size = 0;
    if (!BackendCodec<Backend>::write(loaded.dictionary, [&](const std::uint8_t*, std::size_t size) {
            canonical_size += size;
            return true;
        }) || canonical_size != body_size ||
        loaded.dictionary.metadata.forward_payload_size() != static_cast<std::int32_t>(kPayloadSize)) return 0;
    output = std::move(loaded);
    return body_offset + detail::AlignDictionaryBytes(body_size);
}

template bool WriteUserDictionaryImage(const UserDictionaryStorage<MutableDictionaryStorage>&,
                                       const DictionaryImageSink&);
template bool WriteUserDictionaryImage(const UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
                                       const DictionaryImageSink&);
template bool SerializeUserDictionaryImage(const UserDictionaryStorage<MutableDictionaryStorage>&, OwnedByteRegion&);
template bool SerializeUserDictionaryImage(const UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
                                           OwnedByteRegion&);
template bool DuplicateUserDictionary(const UserDictionaryStorage<MutableDictionaryStorage>&,
                                      UserDictionaryStorage<MutableDictionaryStorage>&);
template bool DuplicateUserDictionary(const UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
                                      UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&);
template std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion&,
                                              UserDictionaryStorage<MutableDictionaryStorage>&);
template std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion&,
                                              UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&);
}  // namespace comeback::recovered
