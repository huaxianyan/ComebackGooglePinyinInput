// Native direct-file persistence boundary; Google-derived behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_FILE_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_FILE_H

#include "user_dictionary_image.h"
#include <string>

namespace comeback::recovered {
// Maps an existing whole file through the common read-only owner, then uses
// the current-format image parser. The host file consumer requires exact EOF;
// a stream image may instead report a shorter consumed length. Failure keeps
// output unchanged. Loaded subtables retain the mapping after this call.
// Same size/hook limits as MapReadOnlyFile; caller supplies stable file contents.
// Distinguish file access from invalid image for the existing host transport.
enum class DictionaryFileLoadResult { Loaded, MappingFailed, InvalidImage };
template <typename Backend>
DictionaryFileLoadResult LoadUserDictionaryFile(const std::string& path, UserDictionaryStorage<Backend>& output);
// Opens with "wb" BEFORE serialization, truncating an existing destination.
// Return value reports image writes. Native destructor flush/close results do
// not affect it. No fsync, rename, backup, crash recovery or caller lock is added.
// The caller supplies a stable snapshot and chooses a disposable/staging path.
template <typename Backend>
bool PersistUserDictionaryFile(const UserDictionaryStorage<Backend>& dictionary, const std::string& path);
}  // namespace comeback::recovered
#endif
