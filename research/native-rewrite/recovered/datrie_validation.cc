// DATrie load-time parent/free-chain validation; Google-derived, see NOTICE.
#include "datrie_view.h"
#include "datrie_layout.h"
#include "little_endian.h"
#include "owned_byte_region.h"

#include <set>
#include <vector>

namespace comeback::recovered {

bool ValidateDATrie(const OwnedByteRegion& metadata, const OwnedByteRegion& nodes) {
    using namespace detail::datrie;
    if (metadata.Size() < kMetadataSize) return false;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(metadata.Data() + kNodeCountOffset);
    const auto labels = detail::ReadLittleEndian<std::uint32_t>(metadata.Data() + kLabelCountOffset);
    if (count < kMinimumNodes || count > kMaximumNodes || count > nodes.Size() / kNodeSize ||
        labels == 0 || labels > kByteValueCount) return false;
    const auto base = [&](std::uint32_t node) {
        return detail::ReadLittleEndian<std::uint32_t>(nodes.Data() + node * kNodeSize);
    };
    const auto check = [&](std::uint32_t node) {
        return detail::ReadLittleEndian<std::uint32_t>(
            nodes.Data() + node * kNodeSize + sizeof(std::uint32_t));
    };
    const auto positive = [](std::uint32_t word) { return static_cast<std::int32_t>(word) > 0; };
    const auto root = DATrieView::kRoot;
    if (positive(base(0)) || positive(check(0)) || !positive(base(root)) || !positive(check(root))) {
        return false;
    }
    // Native 0x1d75cc uses a bit vector and a sorted path set. Each occupied
    // component must reach the root or a previously proven parent chain.
    std::vector<bool> verified(count, false);
    std::set<std::uint32_t> path;
    for (std::uint32_t node = root + 1; node < count; ++node) {
        if ((!positive(base(node)) && !positive(check(node))) || verified[node]) continue;
        path.clear();
        path.insert(node);
        auto current = node;
        while (current != root && !verified[current]) {
            const auto parent = check(current);
            if (parent >= count || !path.insert(parent).second) return false;
            current = parent;
        }
        for (const auto member : path) verified[member] = true;
    }
    // Native 0x1d5434 checks every forward/backward free-chain relationship.
    std::uint32_t previous = 0;
    auto next = 0U - check(0);
    while (next != 0) {
        // The original first-link dereference lacks this buffer bound check.
        if (next >= count || base(next) != 0U - previous || check(previous) != 0U - next) return false;
        const auto following = 0U - check(next);
        if (following >= count) return false;
        previous = next;
        next = following;
    }
    return base(0) == 0U - previous && check(previous) == 0;
}

}  // namespace comeback::recovered
