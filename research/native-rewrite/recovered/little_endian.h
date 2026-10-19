// Shared unsigned-integer byte order operations for the recovered wire formats.
#ifndef COMEBACK_RECOVERED_LITTLE_ENDIAN_H
#define COMEBACK_RECOVERED_LITTLE_ENDIAN_H

#include <cstddef>
#include <cstdint>

namespace comeback::recovered::detail {

// Integer is an unsigned fixed-width integer type.
template <typename Integer>
constexpr Integer ReadLittleEndian(const std::uint8_t* bytes) {
    Integer value = 0;
    for (std::size_t index = 0; index < sizeof(Integer); ++index) {
        value |= Integer{bytes[index]} << (index * 8);
    }
    return value;
}

template <typename Integer>
constexpr void WriteLittleEndian(Integer value, std::uint8_t* bytes) {
    for (std::size_t index = 0; index < sizeof(Integer); ++index) {
        bytes[index] = static_cast<std::uint8_t>(value >> (index * 8));
    }
}

}  // namespace comeback::recovered::detail
#endif
