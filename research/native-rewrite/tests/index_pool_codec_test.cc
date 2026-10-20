// One real save/reload/edit flow for the frozen P-TABLE container protocol.
#include "../recovered/index_pool.h"
#include "../recovered/owned_byte_region.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}  // namespace

int main() {
    // CRC literals come from independent GF(2) polynomial long division, not
    // the production CRC loop. The pool words follow the documented wire map.
    const std::array<std::uint8_t, 40> original{
        'P', '-', 'T', 'A', 'B', 'L', 'E', 0,
        0x95, 0xd6, 0x92, 0x0b, 0x18, 0xd4, 0x33, 0x22,
        0, 0, 0, 0, 4, 0, 0, 0,
        0x0e, 0, 0, 0, 3, 0, 0, 0,
        0x56, 0x34, 0x12, 0x80, 1, 0, 0, 0};
    const std::array<std::uint8_t, 40> edited{
        'P', '-', 'T', 'A', 'B', 'L', 'E', 0,
        0x33, 0x0f, 0x95, 0x47, 0xd3, 0xa9, 0x9b, 0xa4,
        0, 0, 0, 0, 4, 0, 0, 0,
        0x0e, 0, 0, 0, 3, 0, 0, 0,
        0x21, 0x43, 0x65, 0x87, 1, 0, 0, 0};
    OwnedByteRegion metadata, cells, encoded;
    IndexRange range{};
    Require(InitializeIndexPool(metadata, cells) &&
            CreateIndexRange(metadata, cells, 0x123456, range) && cells.Size() > 16 &&
            SerializeIndexPool(metadata, cells, encoded) && encoded.Size() == original.size() &&
            std::equal(original.begin(), original.end(), encoded.Data()),
            "saving an allocated pool emits CRC64, metadata and active cells rather than spare capacity");
    Require(encoded.Resize(43), "adding a following frame prefix to the input stream");
    encoded.MutableData()[40] = 0xaa;
    OwnedByteRegion loaded_metadata, loaded_cells;
    std::uint32_t record_id = 0;
    Require(LoadIndexPool(encoded, loaded_metadata, loaded_cells) == 40 &&
            loaded_metadata.Size() == 8 && loaded_cells.Size() == 16,
            "loading consumes only the first complete pool frame");
    IndexPoolView loaded(loaded_metadata.Data(), loaded_metadata.Size(),
                          loaded_cells.MutableData(), loaded_cells.Size());
    Require(loaded.ReadRecordId(2, record_id) && record_id == 0x123456 &&
            loaded.WriteRecordId(2, 0x07654321),
            "reading and editing a record after loading the real pool");
    OwnedByteRegion saved;
    Require(SerializeIndexPool(loaded_metadata, loaded_cells, saved) && saved.Size() == edited.size() &&
            std::equal(edited.begin(), edited.end(), saved.Data()) &&
            std::equal(original.begin(), original.end(), encoded.Data()),
            "saving the edit updates the CRC64 and keeps the source image unchanged");

    // Native CRC validation precedes installing either decoded region.
    OwnedByteRegion damaged = encoded;
    damaged.MutableData()[32] ^= 1;
    Require(LoadIndexPool(damaged, loaded_metadata, loaded_cells) == 0,
            "a damaged record fails the stored CRC64 before replacing the loaded pool");
    loaded = IndexPoolView(loaded_metadata.Data(), loaded_metadata.Size(),
                            loaded_cells.MutableData(), loaded_cells.Size());
    Require(loaded.ReadRecordId(2, record_id) && record_id == 0x07654321,
            "the already edited pool remains available after a damaged file is rejected");
    std::puts("PASS: save, reload, edit and validate P-TABLE bytes with CRC64");
}
