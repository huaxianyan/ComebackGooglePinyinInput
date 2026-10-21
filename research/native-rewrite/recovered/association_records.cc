// Google-derived reconstruction; see NOTICE and association-records.md.
#include "association_records.h"
#include "little_endian.h"

#include <cstring>

namespace comeback::recovered {

EncodedAssociationReference EncodeAssociationReference(IndexRange reference) {
    const auto word = (reference.first_index << kAssociationCountBits) | (reference.count & kMaxAssociationCount);
    EncodedAssociationReference bytes{};
    detail::WriteLittleEndian(word, bytes.data());
    return bytes;
}

bool DecodeAssociationReference(const std::uint8_t* bytes, std::size_t size,
                                IndexRange& reference) {
    if (size < sizeof(std::uint32_t)) return false;
    const auto word = detail::ReadLittleEndian<std::uint32_t>(bytes);
    reference = {word >> kAssociationCountBits, word & kMaxAssociationCount};
    return true;
}

bool PatchAssociationValue(std::uint8_t* bytes, std::size_t size, bool has_checksum,
                            const IndexRange* reference, const std::string_view* data,
                            const std::uint16_t* checksum) {
    const auto write = [&](std::size_t offset, const void* input, std::size_t count) {
        if (offset > size || count > size - offset) return false;
        if (count != 0) std::memcpy(bytes + offset, input, count);
        return true;
    };
    if (reference != nullptr) {
        const auto encoded = EncodeAssociationReference(*reference);
        if (!write(0, encoded.data(), encoded.size())) return false;
    }
    if (has_checksum && checksum != nullptr) {
        std::uint8_t encoded[sizeof(std::uint16_t)];
        detail::WriteLittleEndian(*checksum, encoded);
        if (!write(sizeof(std::uint32_t), encoded, sizeof(encoded))) return false;
    }
    const std::size_t offset = sizeof(std::uint32_t) + (has_checksum ? sizeof(std::uint16_t) : 0);
    return data == nullptr || write(offset, data->data(), data->size());
}

bool PatchAssociationRecord(AssociationRecordLayout layout, std::uint8_t* bytes,
                            std::size_t size, const std::uint32_t* first_key,
                            const std::uint32_t* second_key, const std::string_view* payload) {
    const auto write = [bytes, size](std::size_t offset, const void* data, std::size_t count) {
        if (offset > size || count > size - offset) return false;
        if (count != 0) std::memcpy(bytes + offset, data, count);
        return true;
    };
    const std::uint32_t* keys[]{first_key, second_key};
    const auto header_size = AssociationRecordHeaderSize(layout);
    const auto key_count = header_size / sizeof(std::uint32_t);
    for (std::size_t index = 0; index < key_count; ++index) {
        if (keys[index] != nullptr) {
            std::uint8_t word[sizeof(std::uint32_t)];
            detail::WriteLittleEndian(*keys[index], word);
            if (!write(index * sizeof(std::uint32_t), word, sizeof(word))) return false;
        }
    }
    return payload == nullptr ||
           write(header_size, payload->data(), payload->size());
}

}  // namespace comeback::recovered
