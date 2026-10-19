// MutableDictionaryEditor dual-trie removal; Google-derived behavior: see NOTICE.
#include "association_editor.h"
#include "trie_values.h"

#include <algorithm>

namespace comeback::recovered {
namespace {
bool ReadExisting(const AssociationSide& side, std::string_view key,
                   std::uint32_t& terminal, OwnedByteRegion& value) {
    terminal = side.trie.FindTerminal(key);
    return terminal != 0 && ReadTrieValueByNodeId(side.trie, side.values, terminal, value);
}

bool Publish(AssociationEditor& editor, std::string_view key, IndexRange range,
              OwnedByteRegion& value) {
    auto& side = editor.side;
    if (range.count == 0) return side.trie.RemoveKey(editor.trie_metadata, editor.trie_nodes, key);
    const auto encoded = EncodeAssociationReference(range);
    if (value.Size() < encoded.size()) return false;
    auto* bytes = value.MutableData();
    if (bytes == nullptr) return false;
    // Native 0x1c4348 with null optional fields patches only the reference;
    // the existing optional checksum and trailing value bytes remain intact.
    std::copy(encoded.begin(), encoded.end(), bytes);
    return UpdateTrieValueByKey(side.trie, side.values, key, value);
}
}  // namespace

bool RemoveDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  DictionaryEditState& state, std::string_view forward_key,
                                  std::string_view reverse_key) {
    OwnedByteRegion forward_value, reverse_value;
    std::uint32_t forward_id = 0, reverse_id = 0;
    if (!ReadExisting(forward.side, forward_key, forward_id, forward_value) ||
        !ReadExisting(reverse.side, reverse_key, reverse_id, reverse_value)) return false;
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
