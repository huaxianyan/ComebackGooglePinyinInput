// Shared index-pool wire dimensions; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_INDEX_POOL_LAYOUT_H
#define COMEBACK_RECOVERED_INDEX_POOL_LAYOUT_H

#include <cstddef>
#include <cstdint>

namespace comeback::recovered::detail::index_pool {
inline constexpr std::size_t kCellSize = sizeof(std::uint32_t);
inline constexpr std::size_t kMetadataSize = 2 * kCellSize;
}  // namespace comeback::recovered::detail::index_pool
#endif
