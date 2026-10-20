// Native 0x1a0ce0, including signed truncation and time failure input; see NOTICE.
#include "dictionary_day.h"
#include <ctime>

namespace comeback::recovered {
std::int64_t DictionaryDayFromUnixSeconds(std::int64_t seconds) {
    return seconds / 86400;
}
std::int64_t CurrentDictionaryDay() {
    return DictionaryDayFromUnixSeconds(static_cast<std::int64_t>(std::time(nullptr)));
}
}  // namespace comeback::recovered
