// DATrie key removal and ancestor pruning; Google-derived behavior: see NOTICE.
#include "datrie_view.h"
#include "little_endian.h"
#include "owned_byte_region.h"

#include <vector>

namespace comeback::recovered {

bool DATrieView::RemoveKey(OwnedByteRegion& metadata, OwnedByteRegion& nodes, std::string_view key) {
    if (key.empty() || NodeCount() <= kRoot) return false;
    std::vector<std::uint32_t> parents;
    auto current = kRoot;
    for (std::size_t position = 0; position <= key.size(); ++position) {
        const auto byte = position < key.size() ? static_cast<std::uint8_t>(key[position])
                                               : std::uint8_t{0};
        const std::uint32_t next = Base(current) + byte;
        if (next >= NodeCount() || Check(next) != current) return false;
        parents.push_back(current);
        current = next;
    }
    // Native lookup, including the parent stack, completes before either region
    // requests writable access. Existing borrowed views retain the old image.
    if (!Rebind(metadata, nodes) || !ReturnFreeNode(current)) return false;
    auto* header = metadata.MutableData();
    if (header == nullptr) return false;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(header + kKeyCountOffset);
    detail::WriteLittleEndian(count - 1U, header + kKeyCountOffset);
    DATrieLabels labels;
    while (!parents.empty()) {
        const auto parent = parents.back();
        if (EnumerateChildren(parent, labels) != 0 || parent == kRoot) break;
        if (!ReturnFreeNode(parent)) return false;
        parents.pop_back();
    }
    return true;
}

}  // namespace comeback::recovered
