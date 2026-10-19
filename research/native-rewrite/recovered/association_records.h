// Recovered association wire operations; Google-derived logic remains under NOTICE.
#ifndef COMEBACK_RECOVERED_ASSOCIATION_RECORDS_H
#define COMEBACK_RECOVERED_ASSOCIATION_RECORDS_H

#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace comeback::recovered {

struct AssociationReference {
    std::uint32_t first_index;
    std::uint32_t count;
};

using EncodedAssociationReference = std::array<std::uint8_t, sizeof(std::uint32_t)>;

// Native packing keeps 23 index bits and nine count bits, without saturation.
EncodedAssociationReference EncodeAssociationReference(AssociationReference reference);
bool DecodeAssociationReference(const std::uint8_t* bytes, std::size_t size,
                                AssociationReference& reference);

enum class AssociationRecordLayout { TargetKey, KeyPair };

// TargetKey uses first_key only; KeyPair uses both key fields. Null field
// pointers preserve existing bytes, including a null payload pointer. A supplied
// empty payload writes zero bytes. Storage is neither resized nor cleared.
// Writes are sequential: a later failure retains earlier completed writes.
bool PatchAssociationRecord(AssociationRecordLayout layout, std::uint8_t* bytes,
                            std::size_t size, const std::uint32_t* first_key,
                            const std::uint32_t* second_key, const std::string_view* payload);

}  // namespace comeback::recovered
#endif
