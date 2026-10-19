// Native Default(16, 0) and Default(32, 0); Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_CHECKSUM_H
#define COMEBACK_RECOVERED_DICTIONARY_CHECKSUM_H

#include <cstdint>
#include <string_view>

namespace comeback::recovered {

enum class DictionaryChecksumWidth { Bits16, Bits32 };

// Reflected CRC, polynomial as the initial state, no final XOR. Only the two
// dictionary configurations are recovered; this is not the complete CRC ABI.
std::uint32_t CalculateDictionaryChecksum(std::string_view bytes,
                                         DictionaryChecksumWidth width);

}  // namespace comeback::recovered
#endif
