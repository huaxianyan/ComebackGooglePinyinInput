// Native dictionary CRC configurations; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_CHECKSUM_H
#define COMEBACK_RECOVERED_DICTIONARY_CHECKSUM_H

#include <cstdint>
#include <initializer_list>
#include <string_view>

namespace comeback::recovered {

enum class DictionaryChecksumWidth { Bits16, Bits32, Bits64 };

// Reflected CRC, polynomial as the initial state, no final XOR. Parts extend
// one state in order, matching table metadata followed by active bytes. Only
// these dictionary configurations are recovered, not the complete CRC ABI.
std::uint64_t CalculateDictionaryChecksum(DictionaryChecksumWidth width,
                                         std::initializer_list<std::string_view> parts);

}  // namespace comeback::recovered
#endif
