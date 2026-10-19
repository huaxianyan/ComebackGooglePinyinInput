#include "datrie_view.h"
#include "little_endian.h"

namespace comeback::recovered {
namespace {
constexpr std::size_t kAlphabetOffset = 0x114;
constexpr std::size_t kMetadataExtent = kAlphabetOffset + 256;
constexpr std::size_t kNodeCountOffset = 0x0c;
constexpr std::size_t kNodeSize = 8;
constexpr std::uint32_t kRoot = 1;

bool NonPositive(std::uint32_t word) {
    return word == 0 || (word & 0x80000000U) != 0;
}
}  // namespace

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
    detail::WriteLittleEndian(value, nodes_ + terminal * kNodeSize);
    return true;
}

}  // namespace comeback::recovered
