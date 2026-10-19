#include "trie_values.h"
#include "little_endian.h"

#include <cstring>

namespace comeback::recovered {
namespace {
constexpr auto kReferenceSize = sizeof(std::uint32_t);
}  // namespace

bool AppendTrieValue(FixedPhraseTable& records, const OwnedByteRegion& value,
                     OwnedByteRegion& reference) {
    std::uint64_t record_id = 0;
    if (!records.AppendRecord(value.Data(), value.Size(), record_id)) return false;
    if (reference.Size() != kReferenceSize && !reference.Resize(kReferenceSize)) return false;
    auto* bytes = reference.MutableData();
    if (bytes == nullptr) return false;
    detail::WriteLittleEndian(static_cast<std::uint32_t>(record_id), bytes);
    return true;
}

bool UpdateTrieValue(FixedPhraseTable& records, const OwnedByteRegion& reference,
                     const OwnedByteRegion& value) {
    if (reference.Size() != kReferenceSize) return false;
    const auto record_id = detail::ReadLittleEndian<std::uint32_t>(reference.Data());
    std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    if (!records.MutableRecord(record_id, bytes, size) || value.Size() != size) return false;
    std::memcpy(bytes, value.Data(), size);
    return true;
}

}  // namespace comeback::recovered
