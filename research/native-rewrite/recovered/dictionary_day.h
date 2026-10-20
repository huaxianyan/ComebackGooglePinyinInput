// Native time(NULL)/86400 day source; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_DAY_H
#define COMEBACK_RECOVERED_DICTIONARY_DAY_H

#include <cstdint>
namespace comeback::recovered {
std::int64_t DictionaryDayFromUnixSeconds(std::int64_t seconds);
std::int64_t CurrentDictionaryDay();
}  // namespace comeback::recovered
#endif
