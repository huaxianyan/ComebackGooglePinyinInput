// Native flat integer word/straddling-word access; Google-derived, see NOTICE.
#include "flat_integer_table.h"
#include "little_endian.h"
#include "dictionary_alignment.h"
#include <cstdlib>
#include <limits>

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
std::optional<FlatIntegerTableView> LoadFlatIntegerTableImage(
    const OwnedByteRegion& input, std::size_t& position) {
    if (position > input.Size() || input.Size() - position < 8) return std::nullopt;
    const auto* header = input.Data() + position;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(header);
    const auto width = detail::ReadLittleEndian<std::uint32_t>(header + 4);
    const auto bits = std::uint64_t{count} * width;
    if (width > 32 || bits > std::numeric_limits<std::uint32_t>::max()) return std::nullopt;
    const auto bytes = ((bits + 31) / 32) * 4;
    const auto block = detail::AlignDictionaryBytes(8 + bytes);
    if (block > input.Size() - position) return std::nullopt;
    FlatIntegerTableView table(input.Slice(position + 8, bytes), count, width);
    position += block;
    return table;
}
}  // namespace comeback::recovered
