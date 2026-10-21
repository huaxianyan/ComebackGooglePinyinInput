// Native token_dict_utils BFS-query preparation; Google-derived, see NOTICE.
#include "token_query.h"
#include <array>

namespace comeback::recovered {
void AppendTokenQueryUnits(std::string_view input, std::vector<std::string>& output) {
    // Original 0x322050: high-nibble byte widths, also passed to string ctor.
    constexpr std::array<std::uint8_t, 16> widths{{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 3, 4}};
    for (std::size_t offset = 0; offset < input.size();) {
        const auto width = widths[static_cast<unsigned char>(input[offset]) >> 4];
        output.emplace_back(input.data() + offset, width);
        offset += width;
    }
}
void LowercaseTokenBytes(std::string& text) {
    for (auto& byte : text) {
        if (byte >= 'A' && byte <= 'Z') byte += 'a' - 'A';
    }
}
std::uint32_t ReadTokenQueryScalar(std::string_view unit) {
    const auto first = static_cast<unsigned char>(unit[0]);
    if (unit.size() == 1) return first;
    std::uint32_t scalar = first & ((std::uint32_t{1} << (7 - unit.size())) - 1);
    for (std::size_t i = 1; i < unit.size(); ++i) {
        scalar = (scalar << 6) | (static_cast<unsigned char>(unit[i]) & 0x3fu);
    }
    return scalar;
}
std::string EncodeTokenCodepoint(std::uint32_t scalar) {
    std::string text;
    if (scalar < 0x80) text.push_back(static_cast<char>(scalar));
    else {
        if (scalar < 0x800) text.push_back(static_cast<char>(0xc0 | (scalar >> 6)));
        else {
            if (scalar < 0x10000) text.push_back(static_cast<char>(0xe0 | (scalar >> 12)));
            else {
                text.push_back(static_cast<char>(0xf0 | (scalar >> 18)));
                text.push_back(static_cast<char>(0x80 | ((scalar >> 12) & 0x3f)));
            }
            text.push_back(static_cast<char>(0x80 | ((scalar >> 6) & 0x3f)));
        }
        text.push_back(static_cast<char>(0x80 | (scalar & 0x3f)));
    }
    return text;
}
}  // namespace comeback::recovered
