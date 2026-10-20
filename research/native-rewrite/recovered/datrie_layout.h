// Shared DATrie wire dimensions; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DATRIE_LAYOUT_H
#define COMEBACK_RECOVERED_DATRIE_LAYOUT_H
#include "datrie_view.h"

namespace comeback::recovered::detail::datrie {
inline constexpr std::size_t kMetadataSize = 0x218;
inline constexpr std::size_t kNodeSize = 8;
inline constexpr std::size_t kNodeCountOffset = 0x0c;
inline constexpr std::size_t kLabelCountOffset = 0x10;
inline constexpr std::uint32_t kByteValueCount = std::tuple_size<DATrieLabels>::value;
inline constexpr std::uint32_t kMinimumNodes = kByteValueCount;
inline constexpr std::uint32_t kMaximumNodes = 0x1fffffff;
}  // namespace comeback::recovered::detail::datrie
#endif
