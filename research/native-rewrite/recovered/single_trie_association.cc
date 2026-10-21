// Native 0x1c7ff4 / 0x1c8508 / existing branch of 0x1c8e60; see NOTICE.
#include "single_trie_association.h"
#include "association_records.h"
#include "datrie_view.h"
#include "trie_values.h"
#include <cstring>

namespace comeback::recovered {
namespace {
bool FindPair(const SingleTrieMutableDictionaryStorage& dictionary,
                std::string_view first_key, std::string_view second_key,
                AssociationRecordLocation& location) {
    DATrieView trie(dictionary.trie.metadata.Data(), dictionary.trie.metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.trie.nodes.Data()), dictionary.trie.nodes.Size());
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

bool UpdateSingleTrieAssociationPayload(SingleTrieMutableDictionaryStorage& dictionary,
                                         std::string_view first_key, std::string_view second_key,
                                         std::string_view payload) {
    if (payload.size() != static_cast<std::size_t>(dictionary.metadata.forward_payload_size())) return false;
    AssociationRecordLocation location{};
    if (!FindPair(dictionary, first_key, second_key, location)) return false;
    std::uint8_t* bytes = nullptr;
    std::size_t size = 0;
    return dictionary.phrases.MutableRecord(location.record_id, bytes, size) &&
           PatchAssociationRecord(AssociationRecordLayout::KeyPair, bytes, size, nullptr, nullptr, &payload);
}
}  // namespace comeback::recovered
