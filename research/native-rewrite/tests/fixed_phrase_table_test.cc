// Exercise actual payload, record, pool and storage APIs with literal expectations.
#include "../recovered/association_records.h"
#include "../recovered/fixed_phrase_table.h"
#include "../recovered/payload_codec.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <string_view>

using namespace comeback::recovered;

namespace {
void Require(bool condition, const char* action) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", action);
        std::exit(1);
    }
}
}  // namespace

int main() {
    FixedPhraseTable table(10);
    Require(table.Initialize(), "initializing ten-byte association record storage");
    const auto payload = EncodePayload(PayloadVersion::V21,
                                      {0x1234567, true, false, true, 2}, 0x4a2b);
    const std::string_view payload_view(reinterpret_cast<const char*>(payload.data()), payload.size());
    std::uint32_t key = 0x11223344;
    std::array<std::uint8_t, 10> record{};
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, record.data(), record.size(),
                                   &key, nullptr, &payload_view),
            "building a real key-and-payload record before append");
    std::uint64_t record_id = 0xffff;
    for (const auto expected_id : std::array<std::uint64_t, 5>{0, 10, 20, 30, 40}) {
        Require(table.AppendRecord(record.data(), record.size(), record_id) && record_id == expected_id,
                "appending fixed records returns successive byte-offset IDs");
    }
    key = 0x55667788;
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, record.data(), record.size(),
                                   &key, nullptr, nullptr) &&
            table.AppendRecord(record.data(), record.size(), record_id) &&
            record_id == 50 && table.RecordCount() == 6,
            "appending the sixth distinct record preserves the byte-offset protocol across growth");

    OwnedByteRegion metadata, cells;
    IndexRange range{};
    Require(InitializeIndexPool(metadata, cells) && AllocateIndexRange(metadata, cells, 1, range),
            "allocating a real pool slot for the stored record ID");
    IndexPoolView pool(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
    Require(pool.WriteRecordId(range.first_index, static_cast<std::uint32_t>(record_id)),
            "linking the record offset into the allocated association slot");
    const auto reference = EncodeAssociationReference(range);
    Require(reference == std::array<std::uint8_t, 4>{1, 4, 0, 0},
            "encoding the single-record association reference");
    std::uint32_t stored_id = 0;
    Require(DecodeAssociationReference(reference.data(), reference.size(), range) && range.count == 1 &&
            pool.ReadRecordId(range.first_index, stored_id) && stored_id == 50,
            "resolving the association through its pool slot retrieves the byte offset");
    const std::uint8_t* read = nullptr;
    std::size_t size = 0;
    const std::array<std::uint8_t, 10> expected_record{
        0x88, 0x77, 0x66, 0x55, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(table.ReadRecord(stored_id, read, size) && size == 10 &&
            std::equal(expected_record.begin(), expected_record.end(), read),
            "reading the resolved byte offset returns its exact key and payload");

    std::uint8_t* writable = nullptr;
    key = 0xdeadbeef;
    const std::string_view short_payload("\x09\x08\x07", 3);
    Require(table.MutableRecord(stored_id, writable, size) &&
            PatchAssociationRecord(AssociationRecordLayout::TargetKey, writable, size,
                                   &key, nullptr, &short_payload),
            "editing the resolved record through the real mutable storage view");
    const std::array<std::uint8_t, 10> expected_edit{
        0xef, 0xbe, 0xad, 0xde, 9, 8, 7, 0xa9, 0x2b, 0x4a};
    Require(table.ReadRecord(stored_id, read, size) && size == 10 &&
            std::equal(expected_edit.begin(), expected_edit.end(), read),
            "the edit changes the selected key and preserves the short payload tail");
    const std::array<std::uint8_t, 10> expected_first{
        0x44, 0x33, 0x22, 0x11, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(table.ReadRecord(0, read, size) && size == 10 &&
            std::equal(expected_first.begin(), expected_first.end(), read),
            "editing the sixth record retains the first record's original bytes");

    // Higher-level dictionary clearing must also retire its pool references.
    // This flow stops using the old reference before clearing the record table.
    table.Clear();
    Require(table.RecordCount() == 0 && table.AppendRecord(record.data(), record.size(), record_id) &&
            record_id == 0 && table.RecordCount() == 1,
            "clearing the table restarts appends at byte offset zero while remaining initialized");
    std::puts("PASS: fixed records, byte-offset IDs, pool resolution and real association edits");
}
