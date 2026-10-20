// Native 0x1f5d80 / 0x1f6158 framing; Google-derived behavior, see NOTICE.
#include "dictionary_string_image.h"
#include "dictionary_alignment.h"
#include "little_endian.h"

#include <cstring>

namespace comeback::recovered {
namespace {
constexpr std::size_t kLengthSize = sizeof(std::uint32_t);
}  // namespace

bool SerializeDictionaryStringImage(std::string_view payload, OwnedByteRegion& output) {
    const auto body_end = kLengthSize + payload.size();
    const auto aligned_end = detail::AlignDictionaryBytes(body_end);
    if (!output.Resize(aligned_end)) return false;
    auto* data = output.MutableData();
    if (data == nullptr) return false;
    // Native narrows the prefix to W1 but writes the full X1-sized payload.
    detail::WriteLittleEndian(static_cast<std::uint32_t>(payload.size()), data);
    if (!payload.empty()) std::memcpy(data + kLengthSize, payload.data(), payload.size());
    std::memset(data + body_end, 0, aligned_end - body_end);
    return true;
}

std::uint64_t LoadDictionaryStringImage(const OwnedByteRegion& input, std::string& payload) {
    if (input.Size() < kLengthSize) return 0;
    const auto length = detail::ReadLittleEndian<std::uint32_t>(input.Data());
    if (length > input.Size() - kLengthSize) return 0;
    payload.assign(reinterpret_cast<const char*>(input.Data() + kLengthSize), length);
    return detail::AlignDictionaryBytes(kLengthSize + length);
}
}  // namespace comeback::recovered
