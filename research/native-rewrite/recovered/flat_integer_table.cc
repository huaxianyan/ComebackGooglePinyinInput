// Native flat integer word/straddling-word access; Google-derived, see NOTICE.
#include "flat_integer_table.h"
#include "little_endian.h"
#include <cstdlib>

namespace comeback::recovered {
FlatIntegerTableView::FlatIntegerTableView(const OwnedByteRegion& payload,
    std::uint32_t count, std::uint32_t width)
    : payload_(payload), count_(count), width_(width),
      mask_((std::uint32_t{1} << (width & 31u)) - 1) {}

std::uint32_t FlatIntegerTableView::At(std::uint64_t index) const {
    if (index >= count_) std::abort();
    if (width_ == 0) return 0;
    const std::uint64_t bit = index * width_;
    const unsigned shift = bit & 31u;
    const auto* word = payload_.Data() + (bit >> 5) * 4;
    std::uint32_t value = detail::ReadLittleEndian<std::uint32_t>(word) >> shift;
    if (shift + width_ > 32) {
        value |= detail::ReadLittleEndian<std::uint32_t>(word + 4) << (32 - shift);
    }
    return value & mask_;
}
}  // namespace comeback::recovered
