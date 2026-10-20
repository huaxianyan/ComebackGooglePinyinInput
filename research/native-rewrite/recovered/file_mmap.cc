// Native mode-zero 0x1f59f4/0x1fa038, normalized resource ownership; see NOTICE.
#include "file_mmap.h"
#include "owned_byte_region.h"
#include <cstdint>
#include <limits>
#include <memory>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <utility>

namespace comeback::recovered {
namespace {
struct ReadOnlyMapping {
    // One C++ resource owner closes once, including failed initialization.
    // The native failure path's repeated close is deliberately not replayed.
    ~ReadOnlyMapping() {
        if (data != MAP_FAILED) ::munmap(data, size);
        if (fd != -1) ::close(fd);
    }
    int fd = -1;
    void* data = MAP_FAILED;
    std::size_t size = 0;
};
}
FileMappingResult MapReadOnlyFile(const std::string& filename, OwnedByteRegion& output) {
    if (filename.empty() || ::access(filename.c_str(), F_OK) != 0) return FileMappingResult::Failed;
    auto mapping = std::make_shared<ReadOnlyMapping>();
    mapping->fd = ::open(filename.c_str(), O_RDONLY);
    if (mapping->fd == -1) return FileMappingResult::Failed;
    struct stat status{};
    if (::fstat(mapping->fd, &status) != 0) return FileMappingResult::Failed;
    if (status.st_size == 0) return FileMappingResult::EmptyFile;
    if (status.st_size < 0 || status.st_size > std::numeric_limits<std::int32_t>::max())
        return FileMappingResult::Failed;
    // Native narrows through signed int32. Larger files are explicitly outside
    // this implementation, rather than mapping one length and exposing another.
    mapping->size = static_cast<std::size_t>(status.st_size);
    mapping->data = ::mmap(nullptr, mapping->size, PROT_READ, MAP_SHARED, mapping->fd, 0);
    if (mapping->data == MAP_FAILED) return FileMappingResult::Failed;
    auto region = OwnedByteRegion::FromReadOnlyOwner(mapping,
        static_cast<const std::uint8_t*>(mapping->data), mapping->size);
    output = std::move(region);
    return FileMappingResult::Mapped;
}
}  // namespace comeback::recovered
