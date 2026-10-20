// Shared dictionary image alignment; Google-derived behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_ALIGNMENT_H
#define COMEBACK_RECOVERED_DICTIONARY_ALIGNMENT_H

#include <cstddef>

namespace comeback::recovered::detail {
constexpr std::size_t kDictionaryAlignment = 8;
constexpr std::size_t AlignDictionaryBytes(std::size_t size) {
    const auto remainder = size % kDictionaryAlignment;
    return remainder == 0 ? size : size + kDictionaryAlignment - remainder;
}
}  // namespace comeback::recovered::detail
#endif
