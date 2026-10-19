#include "datrie_view.h"
#include "little_endian.h"
#include "owned_byte_region.h"
#include "storage_growth.h"

#include <algorithm>
#include <cstring>
#include <utility>

namespace comeback::recovered {
namespace {
constexpr std::size_t kAlphabetOffset = 0x114;
constexpr std::uint32_t kByteValueCount = std::tuple_size<DATrieLabels>::value;
constexpr std::size_t kMetadataExtent = kAlphabetOffset + kByteValueCount;
constexpr std::size_t kMetadataSize = 0x218;
constexpr std::size_t kLabelCountOffset = 0x10;
constexpr std::size_t kLabelsOffset = 0x14;
constexpr std::size_t kNodeCountOffset = 0x0c;
constexpr std::size_t kNodeSize = 8;
}  // namespace

bool DATrieView::NonPositive(std::uint32_t word) {
    return word == 0 || (word & 0x80000000U) != 0;
}

bool DATrieView::AcceptsByte(std::uint8_t byte) const {
    return byte != 0 && metadata_[kAlphabetOffset + byte] != 0;
}

bool DATrieView::AcceptsKey(std::string_view key) const {
    if (metadata_ == nullptr || metadata_size_ < kMetadataExtent) return false;
    for (const auto byte : key) {
        if (!AcceptsByte(static_cast<std::uint8_t>(byte))) return false;
    }
    return true;
}

std::uint32_t DATrieView::NodeCount() const {
    if (metadata_ == nullptr || metadata_size_ < kMetadataExtent || nodes_ == nullptr) return 0;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(metadata_ + kNodeCountOffset);
    return count <= nodes_size_ / kNodeSize ? count : 0;
}

std::uint32_t DATrieView::Base(std::uint32_t node) const {
    return detail::ReadLittleEndian<std::uint32_t>(nodes_ + node * kNodeSize);
}

std::uint32_t DATrieView::Check(std::uint32_t node) const {
    return detail::ReadLittleEndian<std::uint32_t>(nodes_ + node * kNodeSize + sizeof(std::uint32_t));
}

std::uint32_t DATrieView::FindNode(std::string_view key) const {
    const auto count = NodeCount();
    if (kRoot >= count) return 0;
    auto node = kRoot;
    for (const auto character : key) {
        const auto byte = static_cast<std::uint8_t>(character);
        // Native traversal permits byte zero as an edge, unlike key admission.
        if (byte != 0 && !AcceptsByte(byte)) return 0;
        const std::uint32_t next = Base(node) + byte;
        if (next >= count || Check(next) != node) return 0;
        node = next;
    }
    return node;
}

bool DATrieView::IsTerminal(std::uint32_t node) const {
    const auto count = NodeCount();
    if (node < 2 || node >= count) return false;
    const auto base = Base(node);
    const auto parent = Check(node);
    if (NonPositive(base) && NonPositive(parent)) return false;
    return parent < count && Base(parent) == node;
}

bool DATrieView::UpdateValue(std::string_view key, std::uint32_t value) {
    const auto node = FindNode(key);
    if (node == 0) return false;
    const auto terminal = Base(node);
    if (!IsTerminal(terminal)) return false;
    WriteBase(terminal, value);
    return true;
}

bool DATrieView::ReadTerminalValue(std::uint32_t node, std::uint32_t& value) const {
    if (!IsTerminal(node)) return false;
    value = Base(node);
    return true;
}

void DATrieView::WriteBase(std::uint32_t node, std::uint32_t value) {
    detail::WriteLittleEndian(value, nodes_ + node * kNodeSize);
}

void DATrieView::WriteCheck(std::uint32_t node, std::uint32_t value) {
    detail::WriteLittleEndian(value, nodes_ + node * kNodeSize + sizeof(std::uint32_t));
}

bool DATrieView::UnlinkFreeNode(std::uint32_t node) {
    const auto count = NodeCount();
    if (node == 0 || node >= count || !NonPositive(Base(node)) || !NonPositive(Check(node))) {
        return false;
    }
    const auto previous = 0U - Base(node);
    const auto next = 0U - Check(node);
    if (previous >= count || next >= count) return false;
    WriteCheck(previous, Check(node));
    WriteBase(next, Base(node));
    return true;
}

bool DATrieView::ReturnFreeNode(std::uint32_t node, std::uint32_t cursor) {
    const auto count = NodeCount();
    if (node < 2 || node >= count || cursor >= count) return false;
    auto next = cursor;
    do {
        if (node <= next) break;
        const auto link = Check(next);
        next = 0U - link;
        if (next >= count) return false;
        if (link == 0) break;
    } while (true);
    const auto previous_word = Base(next);
    const auto previous = 0U - previous_word;
    if (previous >= count) return false;
    WriteBase(node, previous_word);
    WriteCheck(node, 0U - next);
    WriteCheck(previous, 0U - node);
    WriteBase(next, 0U - node);
    return true;
}

std::size_t DATrieView::EnumerateChildren(std::uint32_t node, DATrieLabels& labels) const {
    const auto count = NodeCount();
    if (node >= count || (NonPositive(Base(node)) && NonPositive(Check(node)))) return 0;
    const auto label_count = detail::ReadLittleEndian<std::uint32_t>(metadata_ + kLabelCountOffset);
    if (label_count > labels.size()) return 0;
    std::size_t found = 0;
    for (std::uint32_t index = 0; index < label_count; ++index) {
        const auto label = metadata_[kLabelsOffset + index];
        const std::uint32_t child = Base(node) + label;
        if (child >= count) return found;
        if (Check(child) == node) labels[found++] = label;
    }
    return found;
}

bool InitializeDATrie(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                      std::string_view alphabet, std::uint8_t excluded_byte) {
    OwnedByteRegion prepared_metadata, prepared_nodes;
    if (!prepared_metadata.Resize(kMetadataSize)) return false;
    auto* header = prepared_metadata.MutableData();
    if (header == nullptr) return false;
    std::memset(header, 0, kMetadataSize);
    detail::WriteLittleEndian(static_cast<std::uint32_t>(excluded_byte), header + 4);
    detail::WriteLittleEndian(kByteValueCount, header + kNodeCountOffset);
    for (const auto character : alphabet) {
        header[kAlphabetOffset + static_cast<std::uint8_t>(character)] = 1;
    }
    header[kAlphabetOffset + excluded_byte] = 0;
    header[kAlphabetOffset] = 1;
    std::uint32_t label_count = 0;
    for (std::uint32_t byte = 0; byte < kByteValueCount; ++byte) {
        if (header[kAlphabetOffset + byte] != 0) {
            header[kAlphabetOffset + byte] = static_cast<std::uint8_t>(label_count);
            header[kLabelsOffset + label_count++] = static_cast<std::uint8_t>(byte);
        }
    }
    detail::WriteLittleEndian(label_count, header + kLabelCountOffset);
    if (!prepared_nodes.Resize(kByteValueCount * kNodeSize)) return false;
    auto* bytes = prepared_nodes.MutableData();
    if (bytes == nullptr) return false;
    DATrieView view(header, prepared_metadata.Size(), bytes, prepared_nodes.Size());
    for (std::uint32_t node = 0; node + 1 < kByteValueCount; ++node) {
        view.WriteCheck(node, 0U - (node + 1));
    }
    for (std::uint32_t node = 1; node < kByteValueCount; ++node) {
        view.WriteBase(node, 1U - node);
    }
    view.WriteCheck(kByteValueCount - 1, 0);
    view.WriteBase(0, 1U - kByteValueCount);
    if (!view.UnlinkFreeNode(DATrieView::kRoot)) return false;
    view.WriteBase(DATrieView::kRoot, DATrieView::kRoot);
    view.WriteCheck(DATrieView::kRoot, DATrieView::kRoot);
    metadata = std::move(prepared_metadata);
    nodes = std::move(prepared_nodes);
    return true;
}

bool GrowDATrieNodes(OwnedByteRegion& metadata, OwnedByteRegion& nodes) {
    auto* header = metadata.MutableData();
    auto* bytes = nodes.MutableData();
    DATrieView view(header, metadata.Size(), bytes, nodes.Size());
    const auto old_count = view.NodeCount();
    if (old_count < 2) return false;
    const std::uint32_t new_count = old_count + kByteValueCount;
    if (new_count <= old_count) return false;
    const auto old_tail = 0U - view.Base(0);
    if (old_tail >= old_count) return false;
    const auto capacity = nodes.Size() / kNodeSize;
    if (capacity <= new_count) {
        const auto scaled = static_cast<std::size_t>(capacity * detail::kStorageGrowthFactor);
        const auto new_capacity = std::max(scaled, capacity + 2 * kByteValueCount);
        OwnedByteRegion replacement;
        if (!replacement.Resize(new_capacity * kNodeSize)) return false;
        auto* expanded = replacement.MutableData();
        if (expanded == nullptr) return false;
        std::memset(expanded, 0xff, new_capacity * kNodeSize);
        std::memcpy(expanded, bytes, capacity * kNodeSize);
        nodes = std::move(replacement);
        bytes = nodes.MutableData();
        if (bytes == nullptr) return false;
        view = DATrieView(header, metadata.Size(), bytes, nodes.Size());
    }
    view.WriteCheck(old_tail, 0U - old_count);
    for (auto node = old_count; node + 1 < new_count; ++node) {
        view.WriteCheck(node, 0U - (node + 1));
    }
    view.WriteCheck(new_count - 1, 0);
    auto previous = old_tail;
    for (auto node = old_count; node < new_count; ++node) {
        view.WriteBase(node, 0U - previous);
        previous = node;
    }
    view.WriteBase(0, 0U - previous);
    detail::WriteLittleEndian(new_count, header + kNodeCountOffset);
    return true;
}

bool FindDATrieBase(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                    const std::uint32_t* labels, std::size_t count,
                    std::uint32_t minimum, std::uint32_t& base) {
    auto* header = metadata.MutableData();
    auto* bytes = nodes.MutableData();
    DATrieView view(header, metadata.Size(), bytes, nodes.Size());
    if (view.NodeCount() < 2) return false;
    const auto grow = [&]() {
        if (!GrowDATrieNodes(metadata, nodes)) return false;
        header = metadata.MutableData();
        bytes = nodes.MutableData();
        if (header == nullptr || bytes == nullptr) return false;
        view = DATrieView(header, metadata.Size(), bytes, nodes.Size());
        return true;
    };
    auto candidate = 0U - view.Check(0);
    while (candidate <= minimum) {
        if (candidate == 0 && !grow()) return false;
        candidate = 0U - view.Check(candidate);
    }
    const auto fits_window = [&]() {
        return candidate != 0 && view.NodeCount() - 1 > candidate + kByteValueCount - minimum;
    };
    while (!fits_window()) {
        if (!grow()) return false;
    }
    for (;;) {
        const auto proposed = candidate - minimum;
        std::size_t index = 0;
        for (; index < count; ++index) {
            // Native selection requires a negative next link, not merely the
            // broader "free node" predicate (which also permits zero links).
            if ((view.Check(proposed + labels[index]) & 0x80000000U) == 0) break;
        }
        if (index == count) {
            base = proposed;
            return true;
        }
        const auto previous = candidate;
        do {
            candidate = 0U - view.Check(previous);
            if (fits_window()) break;
            if (!grow()) return false;
        } while (true);
    }
}

}  // namespace comeback::recovered
