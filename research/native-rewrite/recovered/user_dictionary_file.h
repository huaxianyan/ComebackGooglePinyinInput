// Native direct-file persistence boundary; Google-derived behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_FILE_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_FILE_H

#include "user_dictionary_image.h"
#include <string>

namespace comeback::recovered {
// Opens with "wb" BEFORE serialization, truncating an existing destination.
// Return value reports image writes. Native destructor flush/close results do
// not affect it. No fsync, rename, backup, crash recovery or caller lock is added.
// The caller supplies a stable snapshot and chooses a disposable/staging path.
bool PersistUserDictionaryFile(const UserDictionaryStorage& dictionary, const std::string& path);
}  // namespace comeback::recovered
#endif
