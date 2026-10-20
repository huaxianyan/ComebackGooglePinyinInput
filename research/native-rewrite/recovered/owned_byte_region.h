// Recovered heap-region ownership; Google-derived behavior remains under NOTICE.
#ifndef COMEBACK_RECOVERED_OWNED_BYTE_REGION_H
#define COMEBACK_RECOVERED_OWNED_BYTE_REGION_H

#include <cstddef>
#include <cstdint>
#include <memory>
#include <string>

namespace comeback::recovered {
enum class FileMappingResult;

// Heap regions, real read-only file mappings and parent-backed slices, without
// the old object ABI. Copies share one descriptor. Writes separate shared,
// sliced or read-only mapped bytes using the same heap/COW implementation.
// Other providers and rounded-capacity resizing are outside this component.
class OwnedByteRegion {
public:
    std::size_t Size() const;
    const std::uint8_t* Data() const;
    // Reacquire mutable pointers after sharing/resizing. Byte-storage allocation
    // failure reports false/null; descriptor allocation uses C++ exceptions.
    std::uint8_t* MutableData();
    bool Resize(std::size_t size);
    OwnedByteRegion Slice(std::size_t offset, std::size_t size) const;

private:
    friend FileMappingResult MapReadOnlyFile(const std::string&, OwnedByteRegion&);
    // Only the actual file-map factory supplies this resource lifetime token.
    static OwnedByteRegion FromReadOnlyOwner(std::shared_ptr<const void> owner,
                                             const std::uint8_t* data, std::size_t size);
    struct State;
    static std::shared_ptr<State> Clone(const std::shared_ptr<State>& source);
    std::shared_ptr<State> state_;
};

}  // namespace comeback::recovered
#endif
