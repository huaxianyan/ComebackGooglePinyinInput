// Literal wire fixtures, independent of the recovered packing implementation.
#include "../recovered/association_records.h"
#include "../recovered/payload_codec.h"

#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;

namespace {
void Require(bool condition, const char* operation) {
    if (!condition) {
        std::fprintf(stderr, "FAIL: %s\n", operation);
        std::exit(1);
    }
}
}  // namespace

int main() {
    const std::array<std::uint8_t, 4> reference_bytes{0x55, 0xad, 0x68, 0x24};
    Require(EncodeAssociationReference({0x123456, 0x155}) == reference_bytes,
            "packing the association list index and count");
    AssociationReference reference{};
    Require(DecodeAssociationReference(reference_bytes.data(), reference_bytes.size(), reference),
            "reading the association list reference");
    Require(reference.first_index == 0x123456 && reference.count == 0x155,
            "exposing the pool index and list length");

    const auto payload_bytes = EncodePayload(
        PayloadVersion::V21, {0x01234567, true, false, true, 2}, 0x4a2b);
    const std::string_view payload(reinterpret_cast<const char*>(payload_bytes.data()),
                                   payload_bytes.size());
    const std::uint32_t first_key = 0x01020304;
    const std::uint32_t second_key = 0xa0b0c0d0;
    std::array<std::uint8_t, 10> target{};
    const std::array<std::uint8_t, 10> expected_target{
        0x04, 0x03, 0x02, 0x01, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, target.data(), target.size(),
                                   &first_key, nullptr, &payload) && target == expected_target,
            "writing a target-key record with the encoded learning payload");

    std::array<std::uint8_t, 14> pair{};
    const std::array<std::uint8_t, 14> expected_pair{
        0x04, 0x03, 0x02, 0x01, 0xd0, 0xc0, 0xb0, 0xa0,
        0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(PatchAssociationRecord(AssociationRecordLayout::KeyPair, pair.data(), pair.size(),
                                   &first_key, &second_key, &payload) && pair == expected_pair,
            "writing a two-key record with the same payload");

    const std::string_view replacement_payload("\x00\x01", 2);
    const std::array<std::uint8_t, 14> expected_payload_update{
        0x04, 0x03, 0x02, 0x01, 0xd0, 0xc0, 0xb0, 0xa0,
        0x00, 0x01, 0x23, 0xa9, 0x2b, 0x4a};
    Require(PatchAssociationRecord(AssociationRecordLayout::KeyPair, pair.data(), pair.size(),
                                   nullptr, nullptr, &replacement_payload) &&
            pair == expected_payload_update,
            "replacing payload bytes preserves keys and the remaining stored bytes");

    const std::uint32_t replacement_key = 0x11223344;
    const std::array<std::uint8_t, 10> expected_key_update{
        0x44, 0x33, 0x22, 0x11, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    Require(PatchAssociationRecord(AssociationRecordLayout::TargetKey, target.data(), target.size(),
                                   &replacement_key, nullptr, nullptr) &&
            target == expected_key_update,
            "replacing a key preserves an omitted payload");

    // Frozen native writer contract: failure after a successful field write
    // reports failure but retains that completed write; it is not a transaction.
    std::array<std::uint8_t, 5> short_record{0xee, 0xee, 0xee, 0xee, 0xee};
    const std::array<std::uint8_t, 5> expected_partial{0x04, 0x03, 0x02, 0x01, 0xee};
    Require(!PatchAssociationRecord(AssociationRecordLayout::TargetKey,
                                    short_record.data(), short_record.size(),
                                    &first_key, nullptr, &payload) && short_record == expected_partial,
            "a payload capacity failure retains the completed key write");
    std::puts("PASS: association references, both record layouts and in-place field updates");
}
