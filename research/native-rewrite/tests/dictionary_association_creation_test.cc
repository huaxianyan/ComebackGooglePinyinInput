// One real dual-trie edit flow, including the native nine-bit list boundary.
#include "../recovered/association_editor.h"
#include "../recovered/trie_values.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <string>

using namespace comeback::recovered;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
void CheckEdge(const AssociationSide& source, const AssociationSide& opposite,
                 std::string_view key, std::string_view target, std::string_view payload) {
    OwnedByteRegion value;
    std::uint32_t terminal = 0;
    IndexRange range{};
    AssociationRecordLocation location{};
    const IndexPoolView pool(source.metadata.Data(), source.metadata.Size(),
                              source.cells.MutableData(), source.cells.Size());
    const std::uint8_t* record = nullptr;
    std::size_t size = 0;
    Require(ReadTrieValueByKey(source.trie, source.values, key, terminal, value) &&
            DecodeAssociationReference(value.Data(), value.Size(), range) &&
            FindAssociationRecord(source.records, pool, range, opposite.trie.FindTerminal(target), location) &&
            source.records.ReadRecord(location.record_id, record, size) && size == 4 + payload.size() &&
            std::equal(payload.begin(), payload.end(), reinterpret_cast<const char*>(record + 4)),
            "published lists reach the current opposite terminal and retain the supplied payload");
}
}  // namespace

int main() {
    OwnedByteRegion fm, fn, fp, fc, rm, rn, rp, rc;
    FixedPhraseTable fv(6), rv(8), fr(10), rr(4);
    const std::string_view alphabet = "0123456789abcdefghijklmnopqrstuvwxyz";
    Require(InitializeDATrie(fm, fn, alphabet, 0xff) && InitializeDATrie(rm, rn, alphabet, 0xff) &&
            InitializeIndexPool(fp, fc) && InitializeIndexPool(rp, rc) &&
            fv.Initialize() && rv.Initialize() && fr.Initialize() && rr.Initialize(),
            "initializing real storage for a dual-trie dictionary");
    DATrieView ft(fm.Data(), fm.Size(), fn.MutableData(), fn.Size());
    DATrieView rt(rm.Data(), rm.Size(), rn.MutableData(), rn.Size());
    AssociationSide fs{ft, fv, fp, fc, fr}, rs{rt, rv, rp, rc, rr};
    AssociationEditor forward{fs, fm, fn, true}, reverse{rs, rm, rn, true};
    i18n_input::engine::hmm::proto::MutableDictionaryMetaData state;
    state.set_key_checksum_enabled(true);
    const std::string_view payload("\x11\x22\x33\x44\x55\x66", 6);
    const std::string_view extra("\xde\xf0", 2);
    Require(ModifyDictionaryAssociation(forward, reverse, state, "a", "x", &payload, &extra,
                                         AssociationEditMode::CreateOrUpdate) &&
            ModifyDictionaryAssociation(forward, reverse, state, "a", "y", nullptr, &extra,
                                         AssociationEditMode::CreateOrUpdate) &&
            ModifyDictionaryAssociation(forward, reverse, state, "b", "y", &payload, &extra,
                                         AssociationEditMode::CreateOrUpdate) &&
            state.association_count() == 3 && state.has_association_count() &&
            state.key_checksum_enabled() &&
            fv.RecordCount() == 2 && rv.RecordCount() == 2 &&
            fr.RecordCount() == 3 && rr.RecordCount() == 3,
            "adding a-x, a-y and b-y creates both keys and both published association lists");
    CheckEdge(fs, rs, "a", "x", payload);
    CheckEdge(fs, rs, "a", "y", payload);  // Omitted payload retains directional scratch.
    CheckEdge(rs, fs, "y", "b", {});
    OwnedByteRegion value;
    std::uint32_t terminal = 0;
    const std::array<std::uint8_t, 2> a_crc{0xc4, 0xd8};
    const std::array<std::uint8_t, 4> x_tail{0xd5, 0x68, 0xde, 0xf0};
    Require(ReadTrieValueByKey(ft, fv, "a", terminal, value) && value.Size() == 6 &&
            std::equal(a_crc.begin(), a_crc.end(), value.Data() + 4) &&
            ReadTrieValueByKey(rt, rv, "x", terminal, value) && value.Size() == 8 &&
            std::equal(x_tail.begin(), x_tail.end(), value.Data() + 4),
            "new keys publish independent CRC16 fixtures and reverse trailing data");

    const std::string_view replacement("\xaa\xbb\xcc\xdd\xee\xff", 6);
    Require(ModifyDictionaryAssociation(forward, reverse, state, "a", "x", &replacement, nullptr,
                                         AssociationEditMode::CreateOrUpdate) &&
            state.association_count() == 3 && fr.RecordCount() == 3 && rr.RecordCount() == 3,
            "adding an existing pair updates it without counting another association");
    CheckEdge(fs, rs, "a", "x", replacement);

    // 0x1c57d4/0x1c57e0 freeze the 511-entry bound. Build it through actual
    // edits rather than inventing a failing backend or writing a fake count.
    for (unsigned index = 0; index < 510; ++index) {
        const auto key = std::string("k") + std::to_string(index);
        Require(ModifyDictionaryAssociation(forward, reverse, state, key, "x", &payload, nullptr,
                                             AssociationEditMode::CreateOrUpdate),
                "adding another real key to x's reverse list");
    }
    CheckEdge(fs, rs, "a", "x", replacement);
    CheckEdge(fs, rs, "a", "y", payload);
    CheckEdge(rs, fs, "x", "k509", {});
    IndexRange full{};
    Require(ReadTrieValueByKey(rt, rv, "x", terminal, value) &&
            DecodeAssociationReference(value.Data(), value.Size(), full) && full.count == 511 &&
            state.association_count() == 513,
            "the published reverse list contains 511 real entries after trie growth and relocation");
    const std::array<std::uint8_t, 4> expected_key_count{0x00, 0x02, 0x00, 0x00};
    Require(!ModifyDictionaryAssociation(forward, reverse, state, "overflow", "x", &payload, nullptr,
                                          AssociationEditMode::CreateOrUpdate) &&
            ft.FindTerminal("overflow") == 0 && rt.FindTerminal("x") != 0 &&
            std::equal(expected_key_count.begin(), expected_key_count.end(), fm.Data() + 8) &&
            state.association_count() == 513 && state.key_checksum_enabled() &&
            fv.RecordCount() == 513 && rv.RecordCount() == 2 &&
            fr.RecordCount() == 513 && rr.RecordCount() == 513,
            "a full reverse list cleans the new empty endpoint while retaining native value records");
    CheckEdge(fs, rs, "a", "x", replacement);
    CheckEdge(rs, fs, "x", "k509", {});
    std::puts("PASS: dual-trie creation, CRCs, scratch reuse, existing update, relocation and full-list cleanup");
}
