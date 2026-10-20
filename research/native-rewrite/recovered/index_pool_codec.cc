// Native P-TABLE memory codec; Google-derived, see NOTICE and index-pool.md.
#include "index_pool.h"
#include "index_pool_layout.h"
#include "dictionary_checksum.h"
#include "little_endian.h"
#include "owned_byte_region.h"

#include <cstring>
#include <limits>

namespace comeback::recovered {
namespace {
using detail::index_pool::kCellSize;
using detail::index_pool::kMetadataSize;
constexpr char kSignature[] = "P-TABLE";
constexpr std::size_t kMetadataOffset = sizeof(kSignature) + sizeof(std::uint64_t);
constexpr std::size_t kCellsOffset = kMetadataOffset + kMetadataSize;

std::uint64_t PoolChecksum(const std::uint8_t* metadata, const std::uint8_t* cells,
                           std::size_t active_bytes) {
    return CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits64,
        {{reinterpret_cast<const char*>(metadata), kMetadataSize},
         {reinterpret_cast<const char*>(cells), active_bytes}});
}
}  // namespace

bool SerializeIndexPool(const OwnedByteRegion& metadata, const OwnedByteRegion& cells,
                         OwnedByteRegion& output) {
    if (metadata.Size() < kMetadataSize) return false;
    const auto active_bytes = static_cast<std::size_t>(
        detail::ReadLittleEndian<std::uint32_t>(metadata.Data() + kCellSize)) * kCellSize;
    if (active_bytes > cells.Size() || !output.Resize(kCellsOffset + active_bytes)) return false;
    auto* data = output.MutableData();
    if (data == nullptr) return false;
    std::memcpy(data, kSignature, sizeof(kSignature));
    detail::WriteLittleEndian(PoolChecksum(metadata.Data(), cells.Data(), active_bytes),
                               data + sizeof(kSignature));
    std::memcpy(data + kMetadataOffset, metadata.Data(), kMetadataSize);
    if (active_bytes != 0) std::memcpy(data + kCellsOffset, cells.Data(), active_bytes);
    return true;
}

std::uint32_t LoadIndexPool(const OwnedByteRegion& input, OwnedByteRegion& metadata,
                            OwnedByteRegion& cells) {
    if (input.Size() < kCellsOffset ||
        std::memcmp(input.Data(), kSignature, sizeof(kSignature)) != 0) return 0;
    auto header = input.Slice(kMetadataOffset, kMetadataSize);
    const auto active_bytes = static_cast<std::size_t>(
        detail::ReadLittleEndian<std::uint32_t>(header.Data() + kCellSize)) * kCellSize;
    const auto total = kCellsOffset + active_bytes;
    // Native narrows the consumed size and slice length to signed 32-bit.
    // Keep its valid positive domain, not overflow-driven out-of-bounds reads.
    if (total > input.Size() || total > static_cast<std::size_t>(
            std::numeric_limits<std::int32_t>::max())) return 0;
    auto data = input.Slice(kCellsOffset, active_bytes);
    if (PoolChecksum(header.Data(), data.Data(), active_bytes) !=
        detail::ReadLittleEndian<std::uint64_t>(input.Data() + sizeof(kSignature))) return 0;
    metadata = header;
    cells = data;
    // The native loader installs both regions before requesting writable data,
    // ignores a null allocation result, and returns the consumed frame length.
    cells.MutableData();
    return static_cast<std::uint32_t>(total);
}

}  // namespace comeback::recovered
