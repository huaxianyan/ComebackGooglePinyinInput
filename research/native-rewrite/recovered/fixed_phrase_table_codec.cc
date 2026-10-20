// Native fixed-record memory image; Google-derived, see NOTICE.
#include "fixed_phrase_table.h"
#include "little_endian.h"

#include <cstring>

namespace comeback::recovered {
namespace {
constexpr std::size_t kHeaderSize = 2 * sizeof(std::uint32_t);
constexpr std::size_t kAlignment = 8;

std::size_t AlignedBodySize(std::size_t size) {
    const auto remainder = size % kAlignment;
    return remainder == 0 ? size : size + kAlignment - remainder;
}
}  // namespace

bool FixedPhraseTable::Serialize(OwnedByteRegion& output) const {
    if (!ready_) return false;
    const auto aligned_size = AlignedBodySize(used_size_);
    if (!output.Resize(kHeaderSize + aligned_size)) return false;
    auto* data = output.MutableData();
    if (data == nullptr) return false;
    detail::WriteLittleEndian(record_count_, data);
    detail::WriteLittleEndian(record_size_, data + sizeof(record_count_));
    if (used_size_ != 0) std::memcpy(data + kHeaderSize, bytes_.Data(), used_size_);
    std::memset(data + kHeaderSize + used_size_, 0, aligned_size - used_size_);
    return true;
}

std::uint64_t FixedPhraseTable::Load(const OwnedByteRegion& input) {
    if (input.Size() < kHeaderSize) return 0;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(input.Data());
    const auto width = detail::ReadLittleEndian<std::uint32_t>(input.Data() + sizeof(count));
    // Positive record widths are the recovered heap backend's valid domain.
    // Do not admit a zero divisor into the C++ record-offset operations.
    if (width == 0) return 0;
    // Native MUL W1 preserves the 32-bit product; metadata and used bytes are
    // separate fields, not recomputed from the capacity of the parent image.
    const std::uint32_t used = count * width;
    if (used > input.Size() - kHeaderSize) return 0;
    auto bytes = input.Slice(kHeaderSize, used);
    record_count_ = count;
    record_size_ = width;
    bytes_ = bytes;
    used_size_ = used;
    ready_ = true;
    // Native 0x1f5ec4 advances past padding without requiring it to be present.
    return kHeaderSize + AlignedBodySize(used_size_);
}

}  // namespace comeback::recovered
