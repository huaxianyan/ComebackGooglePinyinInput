// Google-derived reconstruction; see NOTICE and dictionary-storage.md.
#include "dictionary_checksum.h"

namespace comeback::recovered {

std::uint32_t CalculateDictionaryChecksum(std::string_view bytes,
                                         DictionaryChecksumWidth width) {
    // Default's 24-byte entries at 0x34ead0 (16) and 0x34ec50 (32).
    const std::uint32_t polynomial = width == DictionaryChecksumWidth::Bits16
                                        ? 0x9f18U : 0xb9e50c1dU;
    std::uint32_t state = polynomial;
    for (const unsigned char byte : bytes) {
        state ^= byte;
        for (unsigned bit = 0; bit < 8; ++bit) {
            const bool low_bit = (state & 1U) != 0;
            state >>= 1;
            if (low_bit) state ^= polynomial;
        }
    }
    return state;
}

}  // namespace comeback::recovered
