// Native forward-key/pool cursors and user-model entry read; see NOTICE.
#include "dictionary_association_iteration.h"
#include "association_records.h"
#include "datrie_view.h"
#include "little_endian.h"
#include "trie_values.h"
#include <algorithm>
#include <type_traits>
#include <utility>

namespace comeback::recovered {
template <typename Backend>
bool SnapshotDictionaryAssociations(const Backend& dictionary,
                                     std::vector<DictionaryAssociationEntry>& output) {
    const auto snapshot = [&](const DictionaryTrieStorage& first_storage, const DictionaryTrieStorage& second_storage,
                              const OwnedByteRegion& pool_metadata, const OwnedByteRegion& pool_cells,
                              const FixedPhraseTable& records, AssociationRecordLayout layout) {
        const auto view = [](const DictionaryTrieStorage& storage) {
            return DATrieView(storage.metadata.Data(), storage.metadata.Size(),
                              const_cast<std::uint8_t*>(storage.nodes.Data()), storage.nodes.Size());
        };
        const auto first = view(first_storage);
        const auto second = view(second_storage);
        const auto root = first.FindNode("");
        if (root == 0 || (&first_storage != &second_storage && second.FindNode("") == 0)) return false;
        const IndexPoolView pool(pool_metadata.Data(), pool_metadata.Size(),
            const_cast<std::uint8_t*>(pool_cells.Data()), pool_cells.Size());
        std::vector<DictionaryAssociationEntry> entries;
        // Checked native reads retain the previous borrowed output on failure.
        const std::uint8_t* record = nullptr;
        std::size_t record_size = 0;
        const auto header_size = AssociationRecordHeaderSize(layout);
        for (auto terminal = first.FirstTerminal(root); terminal != 0;
             terminal = first.NextTerminal("", terminal)) {
            OwnedByteRegion value;
            IndexRange range{};
            if (!ReadTrieValueByNodeId(first, first_storage.values, terminal, value) ||
                !DecodeAssociationReference(value.Data(), value.Size(), range)) continue;
            // SingleTrie refresh skips empty ranges; six-model refresh reads
            // the first slot before next() tests the range, as before.
            if (layout == AssociationRecordLayout::KeyPair && range.count == 0) continue;
            std::uint32_t position = 0;
            do {
                ReadAssociationRecordAt(records, pool, range.first_index + position, record, record_size);
                if (record != nullptr && record_size >= header_size + kPayloadSize &&
                    (layout != AssociationRecordLayout::KeyPair ||
                     detail::ReadLittleEndian<std::uint32_t>(record) == terminal)) {
                    DictionaryAssociationEntry entry;
                    const auto target = detail::ReadLittleEndian<std::uint32_t>(
                        record + header_size - sizeof(std::uint32_t));
                    if (first.ReadTerminalKey(terminal, entry.forward_key) &&
                        second.ReadTerminalKey(target, entry.reverse_key)) {
                        std::copy_n(record + header_size, kPayloadSize, entry.payload.begin());
                        entries.push_back(std::move(entry));
                    }
                }
                ++position;
            } while (position < range.count);
        }
        output = std::move(entries);
        return true;
    };
    if constexpr (std::is_same_v<Backend, SingleTrieMutableDictionaryStorage>) {
        return snapshot(dictionary.trie, dictionary.trie, dictionary.range_metadata, dictionary.range_cells,
                         dictionary.phrases, AssociationRecordLayout::KeyPair);
    } else {
        return snapshot(dictionary.forward, dictionary.reverse, dictionary.forward_pool_metadata,
                         dictionary.forward_pool_cells, dictionary.forward_records, AssociationRecordLayout::TargetKey);
    }
}
template bool SnapshotDictionaryAssociations(const MutableDictionaryStorage&, std::vector<DictionaryAssociationEntry>&);
template bool SnapshotDictionaryAssociations(const SingleTrieMutableDictionaryStorage&, std::vector<DictionaryAssociationEntry>&);
}  // namespace comeback::recovered
