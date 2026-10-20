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
    OwnedByteRegion metadata, cells;
    IndexRange range{};
    Require(InitializeIndexPool(metadata, cells), "initializing the association list pool");
    key = 0x55667788;
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, record.data(), record.size(),
                                   &key, nullptr, nullptr) &&
            AppendAssociationRecord(table, metadata, cells, record.data(), record.size(), range) &&
            range.first_index == 2 && range.count == 1 && table.RecordCount() == 6,
            "appending the sixth record creates the association list through the real coordinator");
    IndexPoolView pool(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
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
    stored_id = 0;
    Require(ReadAssociationRecordAt(table, pool, range.first_index, read, size, &stored_id) &&
            stored_id == 50 && size == 10 &&
            std::equal(expected_record.begin(), expected_record.end(), read),
            "the real association reader publishes its pool-resolved ID and exact record bytes");

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

    Require(AppendAssociationRecord(table, metadata, cells, record.data(), record.size(), range) &&
            range.first_index == 2 && range.count == 2 && table.RecordCount() == 7,
            "appending to the list reclaims and expands its range in place");
    IndexRange blocker{};
    Require(CreateIndexRange(metadata, cells, 20, blocker) && blocker.first_index == 4,
            "creating a separate list immediately after the existing range");
    Require(InsertIndexRange(metadata, cells, 0, 1, range) &&
            range.first_index == 5 && range.count == 3,
            "inserting in the middle relocates a list blocked by another occupied range");
    pool = IndexPoolView(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
    const std::array<std::uint32_t, 3> expected_ids{50, 0, 60};
    for (std::size_t index = 0; index < expected_ids.size(); ++index) {
        Require(pool.ReadRecordId(range.first_index + static_cast<std::uint32_t>(index), stored_id) &&
                stored_id == expected_ids[index],
                "the relocated list retains the requested record-ID order");
    }
    Require(pool.ReadRecordId(blocker.first_index, stored_id) && stored_id == 20 &&
            EncodeAssociationReference(range) == std::array<std::uint8_t, 4>{3, 0x0a, 0, 0},
            "relocation preserves the other list and publishes the new association reference");
    Require(RemoveAssociationRecord(table, metadata, cells, 0x11223344, range) &&
            range.first_index == 5 && range.count == 2,
            "removing a middle key shifts the suffix left and returns the last slot");
    pool = IndexPoolView(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
    Require(pool.ReadRecordId(5, stored_id) && stored_id == 50 &&
            pool.ReadRecordId(6, stored_id) && stored_id == 60 && pool.ReleaseRange(blocker),
            "the remaining IDs stay ordered while the separate list is explicitly released");
    Require(RemoveAssociationRecord(table, metadata, cells, 0x55667788, range) &&
            range.first_index == 6 && range.count == 1,
            "a larger left free neighbor selects prefix shifting and advances the reference");
    pool = IndexPoolView(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
    Require(pool.ReadRecordId(6, stored_id) && stored_id == 50,
            "prefix shifting retains the first record at the new list start");
    Require(RemoveAssociationRecord(table, metadata, cells, 0xdeadbeef, range) &&
            range.first_index == 6 && range.count == 0 && table.RecordCount() == 7 &&
            table.ReadRecord(50, read, size) && size == 10 &&
            std::equal(expected_edit.begin(), expected_edit.end(), read),
            "removing the last association preserves its old start and stored record bytes");
    pool = IndexPoolView(metadata.Data(), metadata.Size(), cells.MutableData(), cells.Size());
    IndexRange reclaimed{};
    Require(pool.ReadFreeRange(2, reclaimed) && reclaimed.first_index == 2 && reclaimed.count == 6,
            "deleting all associations coalesces their pool slots into the full free extent");

    // Frozen native order: record append precedes the pool's reserved-index
    // validation. This uses an actual failing destination, not fault injection.
    IndexRange invalid{1, 1};
    Require(!AppendAssociationRecord(table, metadata, cells, record.data(), record.size(), invalid) &&
            invalid.first_index == 1 && invalid.count == 1 && table.RecordCount() == 8 &&
            table.ReadRecord(70, read, size) && size == 10 &&
            std::equal(expected_record.begin(), expected_record.end(), read),
            "a failed reserved-slot link retains the already appended record and old reference");

    // Higher-level dictionary clearing must also retire its pool references.
    // This flow stops using the old reference before clearing the record table.
    table.Clear();
    Require(table.RecordCount() == 0 && table.AppendRecord(record.data(), record.size(), record_id) &&
            record_id == 0 && table.RecordCount() == 1,
            "clearing the table restarts appends at byte offset zero while remaining initialized");
    std::puts("PASS: association append, relocation, directional removal, singleton and partial failure");
}
