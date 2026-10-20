// Google-derived reconstruction; see NOTICE and dictionary-storage.md.
#include "dictionary_checksum.h"

#include <array>
#include <cstddef>

namespace comeback::recovered {

std::uint64_t CalculateDictionaryChecksum(DictionaryChecksumWidth width,
                                         std::initializer_list<std::string_view> parts) {
    // Default's 24-byte entries at 0x34ead0 (16), 0x34ec50 (32), 0x34ef50 (64).
    constexpr std::array<std::uint64_t, 3> polynomials{
        0x9f18U, 0xb9e50c1dU, 0xab0547580daac74eULL};
    const auto polynomial = polynomials[static_cast<std::size_t>(width)];
    auto state = polynomial;
    for (const auto part : parts) {
        for (const unsigned char byte : part) {
            state ^= byte;
            for (unsigned bit = 0; bit < 8; ++bit) {
                const bool low_bit = (state & 1U) != 0;
                state >>= 1;
                if (low_bit) state ^= polynomial;
            }
        }
    }
    return state;
}

}  // namespace comeback::recovered
