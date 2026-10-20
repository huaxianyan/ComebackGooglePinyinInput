// Shared native table-image envelope; Google-derived, see NOTICE.
#include "dictionary_table_image.h"
#include "dictionary_checksum.h"
#include "index_pool_layout.h"
#include "datrie_layout.h"
#include "little_endian.h"
#include "owned_byte_region.h"

#include <array>
#include <cstring>
#include <limits>
#include <string_view>

namespace comeback::recovered {
namespace {
struct TableLayout {
    std::string_view signature;
    std::size_t metadata_size;
    std::size_t count_offset;
    std::size_t element_size;
    std::uint32_t minimum_count;
    std::uint32_t maximum_count;
};
constexpr std::size_t kSignatureSize = 8;
constexpr std::array<TableLayout, 2> kLayouts{{
    {{"P-TABLE", kSignatureSize}, detail::index_pool::kMetadataSize, detail::index_pool::kCellSize,
     detail::index_pool::kCellSize, 0, std::numeric_limits<std::uint32_t>::max()},
    {{"DA-TRIE", kSignatureSize}, detail::datrie::kMetadataSize, detail::datrie::kNodeCountOffset,
     detail::datrie::kNodeSize, detail::datrie::kMinimumNodes, detail::datrie::kMaximumNodes},
}};
constexpr std::size_t kMetadataOffset = kSignatureSize + sizeof(std::uint64_t);

bool ActiveByteSize(const TableLayout& layout, const OwnedByteRegion& metadata, std::size_t& bytes) {
    if (metadata.Size() < layout.metadata_size) return false;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(metadata.Data() + layout.count_offset);
    if (count < layout.minimum_count || count > layout.maximum_count) return false;
    bytes = static_cast<std::size_t>(count) * layout.element_size;
    return true;
}
std::uint64_t TableChecksum(const TableLayout& layout, const OwnedByteRegion& metadata,
                            const OwnedByteRegion& data, std::size_t active_bytes) {
    return CalculateDictionaryChecksum(DictionaryChecksumWidth::Bits64,
        {{reinterpret_cast<const char*>(metadata.Data()), layout.metadata_size},
         {reinterpret_cast<const char*>(data.Data()), active_bytes}});
}
}  // namespace

bool SerializeDictionaryTableImage(DictionaryTableKind kind, const OwnedByteRegion& metadata,
                                    const OwnedByteRegion& data, OwnedByteRegion& output) {
    const auto& layout = kLayouts[static_cast<std::size_t>(kind)];
    std::size_t active_bytes = 0;
    if (!ActiveByteSize(layout, metadata, active_bytes) || active_bytes > data.Size() ||
        !output.Resize(kMetadataOffset + layout.metadata_size + active_bytes)) return false;
    auto* bytes = output.MutableData();
    if (bytes == nullptr) return false;
    std::memcpy(bytes, layout.signature.data(), kSignatureSize);
    detail::WriteLittleEndian(TableChecksum(layout, metadata, data, active_bytes), bytes + kSignatureSize);
    std::memcpy(bytes + kMetadataOffset, metadata.Data(), layout.metadata_size);
    if (active_bytes != 0) {
        std::memcpy(bytes + kMetadataOffset + layout.metadata_size, data.Data(), active_bytes);
    }
    return true;
}

std::uint64_t LoadDictionaryTableImage(DictionaryTableKind kind, const OwnedByteRegion& input,
                                       OwnedByteRegion& metadata, OwnedByteRegion& data) {
    const auto& layout = kLayouts[static_cast<std::size_t>(kind)];
    const auto data_offset = kMetadataOffset + layout.metadata_size;
    if (input.Size() < data_offset ||
        std::memcmp(input.Data(), layout.signature.data(), kSignatureSize) != 0) return 0;
    auto header = input.Slice(kMetadataOffset, layout.metadata_size);
    std::size_t active_bytes = 0;
    if (!ActiveByteSize(layout, header, active_bytes)) return 0;
    const auto total = data_offset + active_bytes;
    if (total > input.Size()) return 0;
    // P-TABLE narrows its slice/consumed length to signed 32-bit; DA-TRIE uses
    // a 64-bit total and separately limits the node count in its layout.
    if (kind == DictionaryTableKind::IndexPool && total > static_cast<std::size_t>(
            std::numeric_limits<std::int32_t>::max())) return 0;
    auto body = input.Slice(data_offset, active_bytes);
    if (TableChecksum(layout, header, body, active_bytes) !=
        detail::ReadLittleEndian<std::uint64_t>(input.Data() + kSignatureSize)) return 0;
    if (kind == DictionaryTableKind::DATrie && !ValidateDATrie(header, body)) return 0;
    metadata = header;
    data = body;
    if (kind == DictionaryTableKind::IndexPool) {
        // Native installs both regions before requesting writable cells and
        // ignores a null allocation result. DATrie keeps its borrowed slice.
        data.MutableData();
    }
    return total;
}

}  // namespace comeback::recovered
