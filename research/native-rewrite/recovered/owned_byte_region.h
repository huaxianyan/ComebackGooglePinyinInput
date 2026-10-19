// Recovered heap-region ownership; Google-derived behavior remains under NOTICE.
#ifndef COMEBACK_RECOVERED_OWNED_BYTE_REGION_H
#define COMEBACK_RECOVERED_OWNED_BYTE_REGION_H

#include <cstddef>
#include <cstdint>
#include <memory>

namespace comeback::recovered {

// Heap-backed regions and parent-backed slices, without the old object ABI.
// Copies share descriptors. Mutating access separates shared or sliced bytes.
// External providers and rounded-capacity resizing are outside this component.
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
    struct State;
    static std::shared_ptr<State> Clone(const std::shared_ptr<State>& source);
    std::shared_ptr<State> state_;
};

}  // namespace comeback::recovered
#endif
