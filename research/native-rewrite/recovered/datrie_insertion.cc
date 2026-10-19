// Complete DATrie byte-key insertion; Google-derived behavior: see NOTICE.
#include "datrie_view.h"
#include "little_endian.h"
#include "owned_byte_region.h"

namespace comeback::recovered {
namespace {
constexpr std::size_t kKeyCountOffset = 8;
}  // namespace

bool DATrieView::InsertValue(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                             std::string_view key, std::uint32_t value,
                             std::uint32_t* terminal, const DATrieNodeMove* notify) {
    // Admission reads only metadata, before requesting native writable access.
    const DATrieView admission(metadata.Data(), metadata.Size(), nullptr, 0);
    if (key.empty() || !admission.AcceptsKey(key) || !Rebind(metadata, nodes)) return false;
    auto current = kRoot;
    bool created = false;
    for (std::size_t position = 0; position <= key.size(); ++position) {
        const auto byte = position < key.size() ? static_cast<std::uint8_t>(key[position])
                                               : std::uint8_t{0};
        std::uint32_t next = Base(current) + byte;
        while (next >= NodeCount()) {
            if (!GrowDATrieNodes(metadata, nodes) || !Rebind(metadata, nodes)) return false;
        }
        if (Check(next) != current) {
            created = true;
            current = ResolveCollision(metadata, nodes, current, byte, notify);
            if (current == 0) return false;
            next = Base(current) + byte;
            if (position < key.size()) {
                const auto following = position + 1 < key.size()
                    ? static_cast<std::uint8_t>(key[position + 1]) : std::uint8_t{0};
                std::uint32_t base = 0;
                if (!FindDATrieBase(metadata, nodes, nullptr, 0, following, base) ||
                    !Rebind(metadata, nodes)) return false;
                WriteBase(next, base);
            }
        }
        current = next;
    }
    if (terminal != nullptr) *terminal = current;
    if (created) {
        auto* header = metadata.MutableData();
        if (header == nullptr) return false;
        const auto count = detail::ReadLittleEndian<std::uint32_t>(header + kKeyCountOffset);
        detail::WriteLittleEndian(count + 1U, header + kKeyCountOffset);
    }
    WriteBase(current, value);
    return true;
}

}  // namespace comeback::recovered
