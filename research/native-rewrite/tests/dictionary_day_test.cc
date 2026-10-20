#include "dictionary_day.h"
#include "user_dictionary_compaction.h"
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;
namespace {
void Require(bool value, const char* action) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}
int main() {
    Require(DictionaryDayFromUnixSeconds(0) == 0 &&
            DictionaryDayFromUnixSeconds(86399) == 0 &&
            DictionaryDayFromUnixSeconds(86400) == 1 &&
            DictionaryDayFromUnixSeconds(172800) == 2,
            "the native wall-clock day changes at literal Unix 86400-second boundaries");
    Require(DictionaryDayFromUnixSeconds(-1) == 0,
            "the actual time failure sentinel follows native signed truncation rather than a fallback");
    Require(DictionaryCompactionCutoff(63) == 1 && DictionaryCompactionCutoff(62) == 0 &&
            DictionaryCompactionCutoff(0) == -62,
            "the native compaction wrapper subtracts sixty-two days before selection");
    std::puts("PASS: literal native Unix-day and compaction-cutoff decisions");
}
