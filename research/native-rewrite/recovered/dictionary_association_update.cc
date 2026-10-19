// Existing-only MutableDictionaryEditor update (mode 2); see NOTICE.
#include "association_editor.h"
#include "trie_values.h"

namespace comeback::recovered {

bool UpdateDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  std::string_view forward_key, std::string_view reverse_key,
                                  const std::string_view* payload,
                                  const std::string_view* reverse_data) {
    OwnedByteRegion forward_value, reverse_value;
    std::uint32_t forward_id = 0, reverse_id = 0;
    if (!ReadTrieValueByKey(forward.side.trie, forward.side.values, forward_key, forward_id, forward_value) ||
        !ReadTrieValueByKey(reverse.side.trie, reverse.side.values, reverse_key, reverse_id, reverse_value)) {
        return false;
    }
    IndexRange forward_range{}, reverse_range{};
    if (!DecodeAssociationReference(forward_value.Data(), forward_value.Size(), forward_range) ||
        !DecodeAssociationReference(reverse_value.Data(), reverse_value.Size(), reverse_range) ||
        !UpdateAssociationRecord(forward.side, forward_range, reverse_id, nullptr, payload) ||
        !UpdateAssociationRecord(reverse.side, reverse_range, forward_id, nullptr, nullptr)) return false;
    if (reverse_data != nullptr) {
        auto* bytes = reverse_value.MutableData();
        if (bytes == nullptr || !PatchAssociationValue(bytes, reverse_value.Size(), reverse.has_checksum,
                                                       nullptr, reverse_data)) return false;
    }
    return UpdateTrieValueByKey(reverse.side.trie, reverse.side.values, reverse_key, reverse_value);
}

}  // namespace comeback::recovered
