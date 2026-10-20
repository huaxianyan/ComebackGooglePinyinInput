// Native compact selection/deletion at an explicit cutoff; see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_COMPACTION_H

#include "user_dictionary_edit.h"

namespace comeback::recovered {
// Model-level 0x1a3758. Caller keeps the same ready model exclusive and both
// editors bound to it. The clock/day-minus-62 wrapper remains a separate layer.
// True means traversal completed; native per-entry deletion failures are ignored.
bool CompactUserDictionaryAtCutoff(UserDictionaryStorage& dictionary,
                                    AssociationEditor& forward, AssociationEditor& reverse,
                                    std::uint64_t limit, std::int32_t cutoff_day);
}  // namespace comeback::recovered
#endif
