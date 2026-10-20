// Actual mode-zero file mapping; Google-derived behavior, see NOTICE.
#ifndef COMEBACK_RECOVERED_FILE_MMAP_H
#define COMEBACK_RECOVERED_FILE_MMAP_H

#include <string>
namespace comeback::recovered {
class OwnedByteRegion;
// Existing nonempty file, representable as the native positive int32 length.
// O_RDONLY + PROT_READ + MAP_SHARED. Failure preserves output. Mapping and fd
// remain owned by the common region descriptor; writable access detaches.
// Larger lengths and allocator replacement hooks are not restored here.
bool MapReadOnlyFile(const std::string& filename, OwnedByteRegion& output);
}  // namespace comeback::recovered
#endif
