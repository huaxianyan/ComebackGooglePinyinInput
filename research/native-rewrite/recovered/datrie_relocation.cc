// DATrie child relocation and collision selection; Google-derived: see NOTICE.
#include "datrie_view.h"
#include "owned_byte_region.h"

#include <vector>

namespace comeback::recovered {

std::uint32_t DATrieView::RelocateChildren(std::uint32_t current, std::uint32_t parent,
                                          std::uint32_t base, const std::uint32_t* labels,
                                          std::size_t count, const DATrieNodeMove* notify) {
    const auto node_count = NodeCount();
    if (current == 0 || current >= node_count || parent == 0 || parent >= node_count ||
        count > DATrieLabels{}.size()) return 0;
    std::vector<std::uint32_t> saved(count, 0);
    std::uint32_t cursor = 0;
    std::uint32_t relocated = current;
    std::uint32_t old_terminal = 0;
    for (std::size_t index = 0; index < count; ++index) {
        const auto label = labels[index];
        const std::uint32_t destination = base + label;
        const std::uint32_t old = Base(parent) + label;
        if (old >= node_count || destination >= node_count) return 0;
        if (destination == cursor) cursor = 0U - Base(cursor);
        if (!UnlinkFreeNode(destination)) return 0;
        WriteCheck(destination, parent);
        saved[index] = Base(old);
        if (label > 0 && !NonPositive(saved[index])) {
            DATrieLabels grandchildren;
            const auto child_count = EnumerateChildren(old, grandchildren);
            for (std::size_t child = 0; child < child_count; ++child) {
                WriteCheck(saved[index] + grandchildren[child], destination);
            }
            if (old == current) relocated = destination;
        }
        if (old == kRoot) {
            WriteCheck(kRoot, kRoot);
        } else {
            if (!ReturnFreeNode(old, cursor)) return 0;
            cursor = old;
        }
        if (label == 0) old_terminal = old;
    }
    WriteBase(parent, base);
    for (std::size_t index = 0; index < count; ++index) {
        WriteBase(base + labels[index], saved[index]);
        if (old_terminal != 0 && labels[index] == 0 && notify != nullptr) {
            (*notify)(old_terminal, base);
        }
    }
    return relocated;
}

std::uint32_t DATrieView::ResolveCollision(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                                          std::uint32_t current, std::uint8_t byte,
                                          const DATrieNodeMove* notify) {
    const auto refresh = [&]() {
        auto* header = metadata.MutableData();
        auto* bytes = nodes.MutableData();
        *this = DATrieView(header, metadata.Size(), bytes, nodes.Size());
        return NodeCount() > kRoot;
    };
    if (!refresh() || current == 0 || current >= NodeCount()) return 0;
    std::uint32_t destination = Base(current) + byte;
    if (destination >= NodeCount()) return 0;
    const auto owner = Check(destination);
    if (!NonPositive(owner)) {
        if (owner >= NodeCount()) return 0;
        DATrieLabels own_labels, other_labels;
        const auto own_count = EnumerateChildren(current, own_labels);
        const auto other_count = EnumerateChildren(owner, other_labels);
        std::uint32_t base = 0;
        if (owner == kRoot || (current != kRoot && own_count + 1 < other_count)) {
            if (!FindDATrieBase(metadata, nodes, own_labels.data(), own_count, byte, base) ||
                !refresh()) return 0;
            current = RelocateChildren(current, current, base, own_labels.data(), own_count, notify);
            if (current == 0) return 0;
            destination = base + byte;
        } else {
            if (other_count == 0 ||
                !FindDATrieBase(metadata, nodes, other_labels.data(), other_count - 1,
                                 other_labels[other_count - 1], base) || !refresh()) return 0;
            current = RelocateChildren(current, owner, base, other_labels.data(), other_count, notify);
            if (current == 0) return 0;
            destination = Base(current) + byte;
        }
    }
    if (destination >= NodeCount()) return 0;
    if (NonPositive(Check(destination)) && !UnlinkFreeNode(destination)) return 0;
    WriteCheck(destination, current);
    return current;
}

}  // namespace comeback::recovered
