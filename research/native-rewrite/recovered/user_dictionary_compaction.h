// Native compact selection/deletion at an explicit cutoff; see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H

#include "user_dictionary_edit.h"

namespace comeback::recovered {
// Pure 32-bit SUB from 0x1a39d8, shared with the real-clock wrapper.
std::int32_t DictionaryCompactionCutoff(std::int64_t day);
// Original real time(NULL) day source, then the native cutoff and model compact.
template <typename Backend, typename... Editors>
bool CompactUserDictionary(UserDictionaryStorage<Backend>& dictionary,
                            std::uint64_t limit, Editors&... editors);
// Model-level 0x1a3758. Caller keeps the same ready model exclusive with either
// two six-model editors or one SingleTrie editor bound to it. AtCutoff exposes
// the actual internal entry, not a clock fake.
// True means traversal completed; native per-entry deletion failures are ignored.
template <typename Backend, typename... Editors>
bool CompactUserDictionaryAtCutoff(UserDictionaryStorage<Backend>& dictionary,
                                    std::uint64_t limit, std::int32_t cutoff_day, Editors&... editors);
}  // namespace comeback::recovered
#endif
