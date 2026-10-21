// Native token_dict_utils BFS-query preparation; Google-derived, see NOTICE.
#include "token_query.h"
#include <array>
#include <cstdint>

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
}  // namespace comeback::recovered
