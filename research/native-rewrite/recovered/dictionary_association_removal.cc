// MutableDictionaryEditor dual-trie removal; Google-derived behavior: see NOTICE.
#include "association_editor.h"
#include "trie_values.h"

namespace comeback::recovered {
bool RemoveDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  i18n_input::engine::hmm::proto::MutableDictionaryMetaData& metadata,
                                  std::string_view forward_key,
                                  std::string_view reverse_key) {
    auto& forward_value = forward.value_buffer;
    auto& reverse_value = reverse.value_buffer;
    std::uint32_t forward_id = 0, reverse_id = 0;
    if (!ReadTrieValueByKey(forward.key_cursor, forward.side.trie, forward.side.values, forward_key, forward_id, forward_value) ||
        !ReadTrieValueByKey(reverse.key_cursor, reverse.side.trie, reverse.side.values, reverse_key, reverse_id, reverse_value)) {
        return false;
    }
    IndexRange forward_range{}, reverse_range{};
    if (!DecodeAssociationReference(forward_value.Data(), forward_value.Size(), forward_range) ||
        !RemoveAssociationRecord(forward.side.records, forward.side.metadata, forward.side.cells,
                                  reverse_id, forward_range) ||
        !DecodeAssociationReference(reverse_value.Data(), reverse_value.Size(), reverse_range) ||
        !RemoveAssociationRecord(reverse.side.records, reverse.side.metadata, reverse.side.cells,
                                  forward_id, reverse_range)) return false;
    if (!PublishAssociationRange(forward.value_editor, forward.side.trie, forward.trie_metadata, forward.trie_nodes,
                                  forward.side.values, forward_key, forward_range, forward_value)) return false;
    const bool result = PublishAssociationRange(reverse.value_editor, reverse.side.trie, reverse.trie_metadata, reverse.trie_nodes,
                                                 reverse.side.values, reverse_key, reverse_range, reverse_value);
    metadata.set_association_count(static_cast<std::int32_t>(
        static_cast<std::uint32_t>(metadata.association_count()) - 1U));
    return result;
}

}  // namespace comeback::recovered
