// Google-derived list/storage coordination; see NOTICE and association-records.md.
#include "association_records.h"
#include "fixed_phrase_table.h"
#include "little_endian.h"
#include "trie_values.h"
#include <cstring>

namespace comeback::recovered {

bool AppendAssociationRecord(FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, const std::uint8_t* data,
                              std::size_t size, IndexRange& reference) {
    std::uint64_t record_id = 0;
    if (!records.AppendRecord(data, size, record_id)) return false;
    // The native caller narrows the returned offset before writing a pool ID.
    const auto value = static_cast<std::uint32_t>(record_id);
    return LinkAssociationRecordId(metadata, cells, value, reference);
}

bool LinkAssociationRecordId(OwnedByteRegion& metadata, OwnedByteRegion& cells,
                              std::uint32_t record_id, IndexRange& reference) {
    return reference.count == 0 ? CreateIndexRange(metadata, cells, record_id, reference)
                               : InsertIndexRange(metadata, cells, record_id, reference.count, reference);
}

bool ReadAssociationRecordAt(const FixedPhraseTable& records, const IndexPoolView& pool,
                              std::uint32_t index, const std::uint8_t*& data,
                              std::size_t& size, std::uint32_t* record_id) {
    std::uint32_t resolved = 0;
    if (!pool.ReadRecordId(index, resolved)) return false;
    if (record_id != nullptr) *record_id = resolved;
    return records.ReadRecord(resolved, data, size);
}

bool FindAssociationRecord(const FixedPhraseTable& records, const IndexPoolView& pool,
                            IndexRange reference, std::uint32_t key,
                            AssociationRecordLocation& location, const std::uint32_t* second_key) {
    const auto header_size = AssociationRecordHeaderSize(second_key == nullptr
        ? AssociationRecordLayout::TargetKey : AssociationRecordLayout::KeyPair);
    for (std::uint32_t position = 0; position < reference.count; ++position) {
        std::uint32_t record_id = 0;
        const std::uint8_t* data = nullptr;
        std::size_t size = 0;
        if (!ReadAssociationRecordAt(records, pool, reference.first_index + position,
                                      data, size, &record_id)) return false;
        if (size >= header_size && detail::ReadLittleEndian<std::uint32_t>(data) == key &&
            (second_key == nullptr || detail::ReadLittleEndian<std::uint32_t>(data + sizeof(std::uint32_t)) ==
                                       *second_key)) {
            location = {position, record_id};
            return true;
        }
    }
    return false;
}

bool ReadDictionaryAssociationPayload(const AssociationSide& forward, const AssociationSide& reverse,
                                       std::string_view forward_key, std::string_view reverse_key,
                                       OwnedByteRegion& output) {
    const auto first = forward.trie.FindTerminal(forward_key);
    const auto second = reverse.trie.FindTerminal(reverse_key);
    if (first == 0 || second == 0) return false;
    OwnedByteRegion value;
    IndexRange reference{};
    if (!ReadTrieValueByNodeId(forward.trie, forward.values, first, value) ||
        !DecodeAssociationReference(value.Data(), value.Size(), reference)) return false;
    const IndexPoolView pool(forward.metadata.Data(), forward.metadata.Size(),
        const_cast<std::uint8_t*>(forward.cells.Data()), forward.cells.Size());
    AssociationRecordLocation location{};
    const std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    constexpr auto key_size = sizeof(std::uint32_t);
    if (!FindAssociationRecord(forward.records, pool, reference, second, location) ||
        !forward.records.ReadRecord(location.record_id, bytes, size) || size < key_size ||
        !output.Resize(size - key_size)) return false;
    if (size != key_size) {
        auto* writable = output.MutableData();
        if (writable == nullptr) return false;
        std::memcpy(writable, bytes + key_size, size - key_size);
    }
    return true;
}

bool UpdateAssociationRecord(const AssociationSide& side, IndexRange reference,
                               std::uint32_t target, const std::uint32_t* new_target,
                               const std::string_view* payload) {
    // Lookup must not detach the pool just to read it.
    const IndexPoolView pool(side.metadata.Data(), side.metadata.Size(),
                             const_cast<std::uint8_t*>(side.cells.Data()), side.cells.Size());
    AssociationRecordLocation location{};
    if (!FindAssociationRecord(side.records, pool, reference, target, location)) return false;
    return UpdateAssociationRecordById(side.records, location.record_id,
        AssociationRecordLayout::TargetKey, new_target, nullptr, payload);
}

bool UpdateAssociationRecordById(FixedPhraseTable& records, std::uint32_t record_id,
                                  AssociationRecordLayout layout, const std::uint32_t* first_key,
                                  const std::uint32_t* second_key, const std::string_view* payload) {
    if (first_key == nullptr && second_key == nullptr && payload == nullptr) return true;
    std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    return records.MutableRecord(record_id, bytes, size) &&
           PatchAssociationRecord(layout, bytes, size, first_key, second_key, payload);
}

bool RemoveAssociationRecord(const FixedPhraseTable& records, OwnedByteRegion& metadata,
                              OwnedByteRegion& cells, std::uint32_t key, IndexRange& reference) {
    auto* bytes = cells.MutableData();
    if (bytes == nullptr) return false;
    IndexPoolView view(metadata.Data(), metadata.Size(), bytes, cells.Size());
    AssociationRecordLocation location{};
    return FindAssociationRecord(records, view, reference, key, location) &&
           view.EraseRecordId(location.position, reference);
}

}  // namespace comeback::recovered
