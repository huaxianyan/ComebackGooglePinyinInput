// 0x1c60e0/0x1c6190 association cursor and 0x1a112c entry reader; see NOTICE.
#include "dictionary_association_iteration.h"
#include "association_records.h"
#include "datrie_view.h"
#include "little_endian.h"
#include "trie_values.h"
#include <algorithm>
#include <utility>

namespace comeback::recovered {
bool SnapshotDictionaryAssociations(const MutableDictionaryStorage& dictionary,
                                     std::vector<DictionaryAssociationEntry>& output) {
    const auto view = [](const DictionaryTrieStorage& storage) {
        return DATrieView(storage.metadata.Data(), storage.metadata.Size(),
                          const_cast<std::uint8_t*>(storage.nodes.Data()), storage.nodes.Size());
    };
    const auto forward = view(dictionary.forward);
    const auto reverse = view(dictionary.reverse);
    const auto root = forward.FindNode("");
    if (root == 0 || reverse.FindNode("") == 0) return false;
    const IndexPoolView pool(dictionary.forward_pool_metadata.Data(), dictionary.forward_pool_metadata.Size(),
        const_cast<std::uint8_t*>(dictionary.forward_pool_cells.Data()), dictionary.forward_pool_cells.Size());
    std::vector<DictionaryAssociationEntry> entries;
    // Native record outputs persist across advances; a failed checked read
    // does not clear a previously borrowed view. Do not invent an error reset.
    const std::uint8_t* record = nullptr;
    std::size_t record_size = 0;
    for (auto terminal = forward.FirstTerminal(root); terminal != 0;
         terminal = forward.NextTerminal("", terminal)) {
        OwnedByteRegion value;
        IndexRange range{};
        if (!ReadTrieValueByNodeId(forward, dictionary.forward.values, terminal, value) ||
            !DecodeAssociationReference(value.Data(), value.Size(), range)) continue;
        std::uint32_t position = 0;
        // Native refresh reads the first record before next() tests the range.
        do {
            ReadAssociationRecordAt(dictionary.forward_records, pool, range.first_index + position,
                                     record, record_size);
            constexpr auto key_size = sizeof(std::uint32_t);
            if (record != nullptr && record_size >= key_size + kPayloadSize) {
                DictionaryAssociationEntry entry;
                const auto target = detail::ReadLittleEndian<std::uint32_t>(record);
                if (forward.ReadTerminalKey(terminal, entry.forward_key) &&
                    reverse.ReadTerminalKey(target, entry.reverse_key)) {
                    std::copy_n(record + key_size, kPayloadSize, entry.payload.begin());
                    entries.push_back(std::move(entry));
                }
            }
            ++position;
        } while (position < range.count);
    }
    output = std::move(entries);
    return true;
}
}  // namespace comeback::recovered
