// Native 0x1c8e60 / 0x1c8928 composition; Google-derived, see NOTICE.
#include "single_trie_association.h"
#include "datrie_view.h"
#include "dictionary_checksum.h"
#include "little_endian.h"
#include "trie_values.h"
#include <cstring>

namespace comeback::recovered {
SingleTrieAssociationEditor::SingleTrieAssociationEditor(SingleTrieMutableDictionaryStorage& storage)
    : dictionary(storage) {
    record_buffer.Resize(static_cast<std::size_t>(dictionary.metadata.forward_payload_size()) +
                          AssociationRecordHeaderSize(AssociationRecordLayout::KeyPair));
    first_value.Resize(kSingleTrieValueSize);
    second_value.Resize(kSingleTrieValueSize);
}
namespace {
DATrieView Trie(const SingleTrieMutableDictionaryStorage& dictionary) {
    return {dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.trie.nodes.Data()), dictionary.trie.nodes.Size()};
}
bool FindPair(const SingleTrieMutableDictionaryStorage& dictionary,
                std::string_view first_key, std::string_view second_key,
                AssociationRecordLocation& location) {
    auto trie = Trie(dictionary);
    if (!trie.AcceptsKey(first_key) || !trie.AcceptsKey(second_key)) return false;
    std::uint32_t first_id = 0, second_id = 0;
    OwnedByteRegion first_value, second_value;
    if (!ReadTrieValueByKey(trie, dictionary.trie.values, first_key, first_id, first_value)) return false;
    if (first_key == second_key) second_id = first_id;
    else if (!ReadTrieValueByKey(trie, dictionary.trie.values, second_key, second_id, second_value)) return false;
    IndexRange reference{};
    if (!DecodeAssociationReference(first_value.Data(), first_value.Size(), reference)) return false;
    const IndexPoolView pool(dictionary.range_metadata.Data(), dictionary.range_metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.range_cells.Data()), dictionary.range_cells.Size());
    return FindAssociationRecord(dictionary.phrases, pool, reference, first_id, location, &second_id);
}
void RepairMoved(SingleTrieMutableDictionaryStorage& dictionary, const DATrieView& trie,
                   std::uint32_t old_id, std::uint32_t new_id) {
    if (old_id == new_id) return;
    OwnedByteRegion value;
    IndexRange range{};
    if (!ReadTrieValueByNodeId(trie, dictionary.trie.values, new_id, value) ||
        !DecodeAssociationReference(value.Data(), value.Size(), range)) return;
    const IndexPoolView pool(dictionary.range_metadata.Data(), dictionary.range_metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.range_cells.Data()), dictionary.range_cells.Size());
    for (std::uint32_t position = 0; position < range.count; ++position) {
        const std::uint8_t* bytes = nullptr;
        std::size_t size = 0;
        std::uint32_t record_id = 0;
        if (!ReadAssociationRecordAt(dictionary.phrases, pool, range.first_index + position,
                                      bytes, size, &record_id) ||
            size < AssociationRecordHeaderSize(AssociationRecordLayout::KeyPair)) return;
        const auto* first = detail::ReadLittleEndian<std::uint32_t>(bytes) == old_id ? &new_id : nullptr;
        const auto* second = detail::ReadLittleEndian<std::uint32_t>(bytes + sizeof(std::uint32_t)) == old_id
            ? &new_id : nullptr;
        if (!UpdateAssociationRecordById(dictionary.phrases, record_id, AssociationRecordLayout::KeyPair,
                                          first, second, nullptr)) return;
    }
}
bool ResolveKey(SingleTrieMutableDictionaryStorage& dictionary, DATrieView& trie,
                  std::string_view key, AssociationEditMode mode, bool checksum_enabled,
                  std::uint32_t& id, OwnedByteRegion& value, const DATrieNodeMove& notify) {
    if (ReadTrieValueByKey(trie, dictionary.trie.values, key, id, value)) return true;
    if (mode != AssociationEditMode::CreateOrUpdate || !value.Resize(dictionary.trie.values.RecordSize())) return false;
    auto* bytes = value.MutableData();
    if (bytes == nullptr) return false;
    std::memset(bytes, 0, value.Size());
    if (checksum_enabled) {
        const auto checksum = static_cast<std::uint16_t>(
            CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits16, {key}));
        // Original resolver ignores the checksum patch status before insertion.
        PatchAssociationValue(bytes, value.Size(), true, nullptr, nullptr, &checksum);
    }
    return InsertTrieValue(trie, dictionary.trie.metadata, dictionary.trie.nodes, dictionary.trie.values,
                             key, value, &id, &notify);
}
}

bool ReadSingleTrieAssociationPayload(const SingleTrieMutableDictionaryStorage& dictionary,
                                       std::string_view first_key, std::string_view second_key,
                                       OwnedByteRegion& output) {
    AssociationRecordLocation location{};
    const std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    constexpr auto header = AssociationRecordHeaderSize(AssociationRecordLayout::KeyPair);
    if (!FindPair(dictionary, first_key, second_key, location) ||
        !dictionary.phrases.ReadRecord(location.record_id, bytes, size) || !output.Resize(size - header)) return false;
    if (size != header) {
        auto* writable = output.MutableData();
        if (writable == nullptr) return false;
        std::memcpy(writable, bytes + header, size - header);
    }
    return true;
}

bool ModifySingleTrieAssociation(SingleTrieAssociationEditor& editor,
                                   std::string_view first_key, std::string_view second_key,
                                   const std::string_view* payload, AssociationEditMode mode) {
    auto& dictionary = editor.dictionary;
    auto trie = Trie(dictionary);
    if ((payload != nullptr && payload->size() != static_cast<std::size_t>(dictionary.metadata.forward_payload_size())) ||
        !trie.AcceptsKey(first_key) || !trie.AcceptsKey(second_key) ||
        !editor.record_buffer.Resize(dictionary.phrases.RecordSize()) ||
        !editor.first_value.Resize(dictionary.trie.values.RecordSize()) ||
        !editor.second_value.Resize(dictionary.trie.values.RecordSize())) return false;
    const DATrieNodeMove notify = [&](std::uint32_t old_id, std::uint32_t new_id) {
        RepairMoved(dictionary, trie, old_id, new_id);
    };
    const bool self = first_key == second_key;
    const bool first_checksum = dictionary.metadata.forward_trie_omitted();
    const bool second_checksum = dictionary.metadata.key_checksum_enabled();
    std::uint32_t first_id = 0, second_id = 0;
    if (!ResolveKey(dictionary, trie, first_key, mode, first_checksum || (self && second_checksum),
                      first_id, editor.first_value, notify)) return false;
    second_id = first_id;
    if (!self && !ResolveKey(dictionary, trie, second_key, mode, second_checksum,
                              second_id, editor.second_value, notify)) return false;
    IndexRange first_range{}, second_range{};
    if (!DecodeAssociationReference(editor.first_value.Data(), editor.first_value.Size(), first_range) ||
        (!self && !DecodeAssociationReference(editor.second_value.Data(), editor.second_value.Size(), second_range))) {
        return false;
    }
    const IndexPoolView pool(dictionary.range_metadata.Data(), dictionary.range_metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.range_cells.Data()), dictionary.range_cells.Size());
    AssociationRecordLocation location{};
    if (FindAssociationRecord(dictionary.phrases, pool, first_range, first_id, location, &second_id) &&
        UpdateAssociationRecordById(dictionary.phrases, location.record_id, AssociationRecordLayout::KeyPair,
                                     nullptr, nullptr, payload)) return true;
    if (mode != AssociationEditMode::CreateOrUpdate) return false;
    const auto append = [&]() {
        if (first_range.count >= kMaxAssociationCount || (!self && second_range.count >= kMaxAssociationCount)) return false;
        auto* bytes = editor.record_buffer.MutableData();
        std::uint64_t record_id = 0;
        if (bytes == nullptr || !PatchAssociationRecord(AssociationRecordLayout::KeyPair, bytes,
                editor.record_buffer.Size(), &first_id, &second_id, payload) ||
            !dictionary.phrases.AppendRecord(editor.record_buffer.Data(), editor.record_buffer.Size(), record_id) ||
            !LinkAssociationRecordId(dictionary.range_metadata, dictionary.range_cells,
                                      static_cast<std::uint32_t>(record_id), first_range) ||
            (!self && !LinkAssociationRecordId(dictionary.range_metadata, dictionary.range_cells,
                                               static_cast<std::uint32_t>(record_id), second_range))) return false;
        auto* first = editor.first_value.MutableData();
        if (first == nullptr || !PatchAssociationValue(first, editor.first_value.Size(), true, &first_range, nullptr)) return false;
        if (!self) {
            auto* second = editor.second_value.MutableData();
            if (second == nullptr || !PatchAssociationValue(second, editor.second_value.Size(), true, &second_range, nullptr)) return false;
        }
        // Keep the original locally resolved IDs across the second insertion;
        // node notification repairs stored records, not these local variables.
        if (!UpdateTrieValueByKey(trie, dictionary.trie.values, first_key, editor.first_value) ||
            (!self && !UpdateTrieValueByKey(trie, dictionary.trie.values, second_key, editor.second_value))) return false;
        dictionary.metadata.set_association_count(static_cast<std::int32_t>(
            static_cast<std::uint32_t>(dictionary.metadata.association_count()) + 1U));
        return true;
    };
    if (append()) return true;
    // Distinct-key failures have no equivalent empty-key cleanup in 0x1c8e60.
    if (self && first_range.count == 0) trie.RemoveKey(dictionary.trie.metadata, dictionary.trie.nodes, first_key);
    return false;
}
bool RemoveSingleTrieAssociation(SingleTrieAssociationEditor& editor,
                                   std::string_view first_key, std::string_view second_key) {
    auto& dictionary = editor.dictionary;
    auto trie = Trie(dictionary);
    const bool self = first_key == second_key;
    std::uint32_t first_id = 0, second_id = 0;
    if (!ReadTrieValueByKey(trie, dictionary.trie.values, first_key, first_id, editor.first_value)) return false;
    second_id = first_id;
    if (!self && !ReadTrieValueByKey(trie, dictionary.trie.values, second_key, second_id, editor.second_value)) return false;
    IndexRange first_range{}, second_range{};
    if (!DecodeAssociationReference(editor.first_value.Data(), editor.first_value.Size(), first_range) ||
        (!self && !DecodeAssociationReference(editor.second_value.Data(), editor.second_value.Size(), second_range)) ||
        !RemoveAssociationRecord(dictionary.phrases, dictionary.range_metadata, dictionary.range_cells,
                                   first_id, first_range, &second_id) ||
        (!self && !RemoveAssociationRecord(dictionary.phrases, dictionary.range_metadata, dictionary.range_cells,
                                            first_id, second_range, &second_id))) return false;
    if (!PublishAssociationRange(trie, dictionary.trie.metadata, dictionary.trie.nodes, dictionary.trie.values,
                                  first_key, first_range, editor.first_value) ||
        (!self && !PublishAssociationRange(trie, dictionary.trie.metadata, dictionary.trie.nodes, dictionary.trie.values,
                                             second_key, second_range, editor.second_value))) return false;
    dictionary.metadata.set_association_count(static_cast<std::int32_t>(
        static_cast<std::uint32_t>(dictionary.metadata.association_count()) - 1U));
    return true;
}
}  // namespace comeback::recovered
