// MutableDictionaryEditor modes 1/2; Google-derived behavior: see NOTICE.
#include "association_editor.h"
#include "dictionary_checksum.h"
#include "trie_values.h"

#include <cstring>

namespace comeback::recovered {
namespace {
bool ResolveKey(AssociationEditor& editor, std::string_view key, AssociationEditMode mode,
                  std::uint32_t& terminal, const DATrieNodeMove& notify) {
    auto& side = editor.side;
    auto& value = editor.value_buffer;
    if (ReadTrieValueByKey(editor.key_cursor, side.trie, side.values, key, terminal, value)) return true;
    if (mode != AssociationEditMode::CreateOrUpdate || !value.Resize(side.values.RecordSize())) {
        return false;
    }
    auto* bytes = value.MutableData();
    if (bytes == nullptr) return false;
    std::memset(bytes, 0, value.Size());
    if (editor.has_checksum) {
        const auto checksum = static_cast<std::uint16_t>(
            CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits16, {key}));
        // 0x1c45cc does not branch on this patch's result before insertion.
        PatchAssociationValue(bytes, value.Size(), true, nullptr, nullptr, &checksum);
    }
    return InsertTrieValue(side.trie, editor.trie_metadata, editor.trie_nodes, side.values,
                             key, value, &terminal, &notify);
}

bool AppendSide(AssociationEditor& editor, std::string_view key, std::uint32_t target,
                  const std::string_view* payload, const std::string_view* data, IndexRange& range) {
    auto& side = editor.side;
    auto& record = editor.record_buffer;
    auto& value = editor.value_buffer;
    if (!record.Resize(side.records.RecordSize())) return false;
    auto* bytes = record.MutableData();
    if (bytes == nullptr ||
        !PatchAssociationRecord(AssociationRecordLayout::TargetKey, bytes, record.Size(),
                                  &target, nullptr, payload) ||
        !AppendAssociationRecord(side.records, side.metadata, side.cells,
                                   record.Data(), record.Size(), range)) return false;
    bytes = value.MutableData();
    return bytes != nullptr &&
           PatchAssociationValue(bytes, value.Size(), editor.has_checksum, &range, data) &&
           UpdateTrieValueByKey(side.trie, side.values, key, value);
}
}  // namespace

bool ModifyDictionaryAssociation(AssociationEditor& forward, AssociationEditor& reverse,
                                  i18n_input::engine::hmm::proto::MutableDictionaryMetaData& metadata,
                                  std::string_view forward_key, std::string_view reverse_key,
                                  const std::string_view* payload,
                                  const std::string_view* reverse_data, AssociationEditMode mode) {
    const DATrieNodeMove forward_move = [&](std::uint32_t old_id, std::uint32_t new_id) {
        UpdateMovedNodeId(forward.side, reverse.side, old_id, new_id);
    };
    const DATrieNodeMove reverse_move = [&](std::uint32_t old_id, std::uint32_t new_id) {
        UpdateMovedNodeId(reverse.side, forward.side, old_id, new_id);
    };
    std::uint32_t forward_id = 0, reverse_id = 0;
    if (!ResolveKey(forward, forward_key, mode, forward_id, forward_move) ||
        !ResolveKey(reverse, reverse_key, mode, reverse_id, reverse_move)) return false;
    auto& forward_value = forward.value_buffer;
    auto& reverse_value = reverse.value_buffer;
    IndexRange forward_range{}, reverse_range{};
    if (!DecodeAssociationReference(forward_value.Data(), forward_value.Size(), forward_range) ||
        !DecodeAssociationReference(reverse_value.Data(), reverse_value.Size(), reverse_range)) return false;
    if (UpdateAssociationRecord(forward.side, forward_range, reverse_id, nullptr, payload) &&
        UpdateAssociationRecord(reverse.side, reverse_range, forward_id, nullptr, nullptr)) {
        if (reverse_data != nullptr) {
            auto* bytes = reverse_value.MutableData();
            if (bytes == nullptr || !PatchAssociationValue(bytes, reverse_value.Size(), reverse.has_checksum,
                                                           nullptr, reverse_data)) return false;
        }
        return UpdateTrieValueByKey(reverse.side.trie, reverse.side.values, reverse_key, reverse_value);
    }
    if (mode != AssociationEditMode::CreateOrUpdate) return false;
    if (forward_range.count < kMaxAssociationCount && reverse_range.count < kMaxAssociationCount &&
        AppendSide(forward, forward_key, reverse_id, payload, nullptr, forward_range) &&
        AppendSide(reverse, reverse_key, forward_id, nullptr, reverse_data, reverse_range)) {
        metadata.set_association_count(static_cast<std::int32_t>(
            static_cast<std::uint32_t>(metadata.association_count()) + 1U));
        return true;
    }
    // The native cleanup tests the current ranges, including successful appends,
    // not a "created key" flag. Ignore deletion status and retain prior mutations.
    if (forward_range.count == 0) {
        forward.side.trie.RemoveKey(forward.trie_metadata, forward.trie_nodes, forward_key);
    }
    if (reverse_range.count == 0) {
        reverse.side.trie.RemoveKey(reverse.trie_metadata, reverse.trie_nodes, reverse_key);
    }
    return false;
}

}  // namespace comeback::recovered
