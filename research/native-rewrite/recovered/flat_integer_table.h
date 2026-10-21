// Native flat_vector.h packed integers, ownership normalized; see NOTICE.
#ifndef COMEBACK_RECOVERED_FLAT_INTEGER_TABLE_H
#define COMEBACK_RECOVERED_FLAT_INTEGER_TABLE_H
#include "owned_byte_region.h"
#include <cstdint>
#include <optional>

namespace comeback::recovered {
// Immutable packed-payload snapshot using the existing shared region descriptor.
// Construction preconditions: width <= 32; payload holds complete little-endian
// 32-bit words for count*width bits. Wire headers/padding validation are upstream.
// Native zero-width arrays have count entries of zero and need no payload.
// The loader masks the shift count by 31: width 32 also has a ZERO result mask,
// despite reading 32-bit words. Do not replace this with a conventional full mask.
class FlatIntegerTableView {
public:
    FlatIntegerTableView(const OwnedByteRegion& payload, std::uint32_t count,
                         std::uint32_t width);
    std::uint32_t Count() const { return count_; }
    // Native 0x13303c checks index before decoding, including width zero. Invalid
    // indices abort; native diagnostic/stack-report machinery is not reproduced.
    std::uint32_t At(std::uint64_t index) const;
private:
    OwnedByteRegion payload_;
    std::uint32_t count_;
    std::uint32_t width_;
    std::uint32_t mask_;
};
// Counted LE32 count/width, complete words and an eight-byte block advancement.
// Ordinary non-overflow images. Failure leaves the position unchanged; native
// corrupt-image partial publication and diagnostics are outside this loader.
std::optional<FlatIntegerTableView> LoadFlatIntegerTableImage(
    const OwnedByteRegion& input, std::size_t& position);
}  // namespace comeback::recovered
#endif
