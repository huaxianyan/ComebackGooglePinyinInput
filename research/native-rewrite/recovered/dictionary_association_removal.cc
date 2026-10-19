// MutableDictionaryEditor dual-trie removal; Google-derived behavior: see NOTICE.
#include "association_editor.h"
#include "trie_values.h"

namespace comeback::recovered {
namespace {
bool Publish(AssociationEditor& editor, std::string_view key, IndexRange range,
              OwnedByteRegion& value) {
    auto& side = editor.side;
    if (range.count == 0) return side.trie.RemoveKey(editor.trie_metadata, editor.trie_nodes, key);
    auto* bytes = value.MutableData();
    return bytes != nullptr &&
           PatchAssociationValue(bytes, value.Size(), editor.has_checksum, &range, nullptr) &&
           UpdateTrieValueByKey(side.trie, side.values, key, value);
}
}  // namespace

bool RemoveDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  DictionaryEditState& state, std::string_view forward_key,
                                  std::string_view reverse_key) {
    auto& forward_value = forward.value_buffer;
    auto& reverse_value = reverse.value_buffer;
    std::uint32_t forward_id = 0, reverse_id = 0;
    if (!ReadTrieValueByKey(forward.side.trie, forward.side.values, forward_key, forward_id, forward_value) ||
        !ReadTrieValueByKey(reverse.side.trie, reverse.side.values, reverse_key, reverse_id, reverse_value)) {
        return false;
    }
    IndexRange forward_range{}, reverse_range{};
    if (!DecodeAssociationReference(forward_value.Data(), forward_value.Size(), forward_range) ||
        !RemoveAssociationRecord(forward.side.records, forward.side.metadata, forward.side.cells,
                                  reverse_id, forward_range) ||
        !DecodeAssociationReference(reverse_value.Data(), reverse_value.Size(), reverse_range) ||
        !RemoveAssociationRecord(reverse.side.records, reverse.side.metadata, reverse.side.cells,
                                  forward_id, reverse_range)) return false;
    if (!Publish(forward, forward_key, forward_range, forward_value)) return false;
    const bool result = Publish(reverse, reverse_key, reverse_range, reverse_value);
    --state.association_count;
    state.flags |= 0x10U;
    return result;
}

}  // namespace comeback::recovered
