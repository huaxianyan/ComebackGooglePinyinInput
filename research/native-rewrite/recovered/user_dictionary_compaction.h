// Native compact selection/deletion at an explicit cutoff; see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H

#include "user_dictionary_edit.h"

namespace comeback::recovered {
// Pure 32-bit SUB from 0x1a39d8, shared with the real-clock wrapper.
std::int32_t DictionaryCompactionCutoff(std::int64_t day);
// Original real time(NULL) day source, then the native cutoff and model compact.
bool CompactUserDictionary(UserDictionaryStorage& dictionary,
                            AssociationEditor& forward, AssociationEditor& reverse,
                            std::uint64_t limit);
// Model-level 0x1a3758. Caller keeps the same ready model exclusive and both
// editors bound to it. AtCutoff exposes the actual internal entry, not a clock fake.
// True means traversal completed; native per-entry deletion failures are ignored.
bool CompactUserDictionaryAtCutoff(UserDictionaryStorage& dictionary,
                                    AssociationEditor& forward, AssociationEditor& reverse,
                                    std::uint64_t limit, std::int32_t cutoff_day);
}  // namespace comeback::recovered
#endif
