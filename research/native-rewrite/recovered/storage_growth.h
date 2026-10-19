// Shared native storage growth coefficient; Google-derived behavior: see NOTICE.
#ifndef COMEBACK_RECOVERED_STORAGE_GROWTH_H
#define COMEBACK_RECOVERED_STORAGE_GROWTH_H

namespace comeback::recovered::detail {
inline constexpr double kStorageGrowthFactor = 1.25;
}  // namespace comeback::recovered::detail
#endif
