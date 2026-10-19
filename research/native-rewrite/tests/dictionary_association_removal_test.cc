#include "../recovered/association_editor.h"
#include "../recovered/trie_values.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <initializer_list>

using namespace comeback::recovered;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
OwnedByteRegion Region(std::initializer_list<std::uint8_t> bytes) {
    OwnedByteRegion value;
    Require(value.Resize(bytes.size()), "allocating literal fixture bytes");
    std::copy(bytes.begin(), bytes.end(), value.MutableData());
    return value;
}
}

int main() {
    OwnedByteRegion fm, fn, fp, fc, rm, rn, rp, rc;
    FixedPhraseTable fv(6), rv(8), fr(10), rr(4);
    Require(InitializeDATrie(fm, fn, "ab", 0xff) && InitializeDATrie(rm, rn, "xy", 0xff) &&
            InitializeIndexPool(fp, fc) && InitializeIndexPool(rp, rc) &&
            fv.Initialize() && rv.Initialize() && fr.Initialize() && rr.Initialize(),
            "initializing both actual trie, value, pool and record backends");
    DATrieView ft(fm.Data(), fm.Size(), fn.MutableData(), fn.Size());
    DATrieView rt(rm.Data(), rm.Size(), rn.MutableData(), rn.Size());
    AssociationSide fs{ft, fv, fp, fc, fr}, rs{rt, rv, rp, rc, rr};
    AssociationEditor forward{fs, fm, fn, true}, reverse{rs, rm, rn, true};
    const auto fa = Region({2, 4, 0, 0, 0x34, 0x12});
    const auto fb = Region({1, 8, 0, 0, 0x34, 0x12});
    const auto rx = Region({1, 4, 0, 0, 0x78, 0x56, 0x9a, 0xbc});
    const auto ry = Region({2, 6, 0, 0, 0x78, 0x56, 0x9a, 0xbc});
    std::uint32_t a = 0, b = 0, x = 0, y = 0;
    Require(InsertTrieValue(ft, fm, fn, fv, "a", fa, &a) && a == 2 &&
            InsertTrieValue(ft, fm, fn, fv, "b", fb, &b) && b == 3 &&
            InsertTrieValue(rt, rm, rn, rv, "x", rx, &x) && x == 2 &&
            InsertTrieValue(rt, rm, rn, rv, "y", ry, &y) && y == 3,
            "creating real keys for the independent a-x, a-y and b-y graph");
    const std::array<std::uint8_t, 10> to_x{2, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    const std::array<std::uint8_t, 10> to_y{3, 0, 0, 0, 0x67, 0x45, 0x23, 0xa9, 0x2b, 0x4a};
    const std::array<std::uint8_t, 4> to_a{2, 0, 0, 0}, to_b{3, 0, 0, 0};
    IndexRange la{}, lb{}, lx{}, ly{};
    Require(AppendAssociationRecord(fr, fp, fc, to_x.data(), to_x.size(), la) &&
            AppendAssociationRecord(fr, fp, fc, to_y.data(), to_y.size(), la) &&
            AppendAssociationRecord(fr, fp, fc, to_y.data(), to_y.size(), lb) &&
            AppendAssociationRecord(rr, rp, rc, to_a.data(), to_a.size(), lx) &&
            AppendAssociationRecord(rr, rp, rc, to_a.data(), to_a.size(), ly) &&
            AppendAssociationRecord(rr, rp, rc, to_b.data(), to_b.size(), ly),
            "building both directions through actual record and list appends");
    DictionaryEditState state{3, 0x80};
    OwnedByteRegion value;
    const std::uint8_t* record = nullptr;
    std::size_t size = 0;
    const std::string_view payload("\x11\x22\x33\x44\x55\x66", 6);
    const std::string_view extra("\xde\xf0", 2);
    const std::array<std::uint8_t, 10> updated{2, 0, 0, 0, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66};
    const std::array<std::uint8_t, 8> updated_x{1, 4, 0, 0, 0x78, 0x56, 0xde, 0xf0};
    Require(ModifyDictionaryAssociation(forward, reverse, state, "a", "x", &payload, &extra,
                                         AssociationEditMode::ExistingOnly) &&
            fr.ReadRecord(0, record, size) && size == 10 &&
            std::equal(updated.begin(), updated.end(), record) &&
            ReadTrieValueByNodeId(rt, rv, 2, value) && value.Size() == 8 &&
            std::equal(updated_x.begin(), updated_x.end(), value.Data()) &&
            fv.RecordCount() == 2 && rv.RecordCount() == 2 && fr.RecordCount() == 3 &&
            rr.RecordCount() == 3 && state.association_count == 3 && state.flags == 0x80,
            "updating a-x changes its payload and reverse data while preserving checksums and counts");
    const std::array<std::uint8_t, 6> remaining_a{1, 4, 0, 0, 0x34, 0x12};
    Require(RemoveDictionaryAssociation(forward, reverse, state, "a", "x") &&
            state.association_count == 2 && state.flags == 0x90 && rt.FindTerminal("x") == 0 &&
            ft.FindTerminal("a") == 2 && ReadTrieValueByNodeId(ft, fv, 2, value) && value.Size() == 6 &&
            std::equal(remaining_a.begin(), remaining_a.end(), value.Data()),
            "removing a-x republishes a's remaining range, retains its suffix and deletes empty x");
    Require(RemoveDictionaryAssociation(forward, reverse, state, "b", "y") &&
            state.association_count == 1 && state.flags == 0x90 && ft.FindTerminal("b") == 0 &&
            rt.FindTerminal("y") == 3 && ReadTrieValueByNodeId(rt, rv, 3, value) && value.Size() == 8,
            "removing b-y deletes empty b and republishes y's remaining reverse list");
    const std::array<std::uint8_t, 4> suffix{0x78, 0x56, 0x9a, 0xbc};
    IndexRange remaining{};
    const IndexPoolView pool(rp.Data(), rp.Size(), rc.MutableData(), rc.Size());
    std::uint32_t id = 0;
    Require(std::equal(suffix.begin(), suffix.end(), value.Data() + 4) &&
            DecodeAssociationReference(value.Data(), value.Size(), remaining) && remaining.count == 1 &&
            pool.ReadRecordId(remaining.first_index, id) && id == 4 && rr.ReadRecord(id, record, size) &&
            size == 4 && std::equal(to_a.begin(), to_a.end(), record),
            "the republished reverse list reaches the actual a record and retains all trailing bytes");
    Require(RemoveDictionaryAssociation(forward, reverse, state, "a", "y") &&
            state.association_count == 0 && state.flags == 0x90 && fm.Data()[8] == 0 && rm.Data()[8] == 0 &&
            fv.RecordCount() == 2 && rv.RecordCount() == 2 && fr.RecordCount() == 3 && rr.RecordCount() == 3,
            "removing the last pair deletes both keys while retaining appended records");

    // An actual one-sided relation models the frozen missing-counterpart failure
    // boundary. No injected allocator, mock callback or fabricated return value.
    const auto one_way = Region({1, 4, 0, 0, 0x34, 0x12});
    const auto empty = Region({0, 0, 0, 0, 0x78, 0x56, 0x9a, 0xbc});
    IndexRange one{};
    Require(InsertTrieValue(ft, fm, fn, fv, "a", one_way, &a) && a == 2 &&
            InsertTrieValue(rt, rm, rn, rv, "x", empty, &x) && x == 2 &&
            AppendAssociationRecord(fr, fp, fc, to_x.data(), to_x.size(), one),
            "preparing a real forward record with an existing but empty reverse key");
    state = {1, 0x80};
    const std::string_view partial_payload("\xaa\xbb\xcc\xdd\xee\xff", 6);
    const std::array<std::uint8_t, 10> partial{2, 0, 0, 0, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff};
    Require(!ModifyDictionaryAssociation(forward, reverse, state, "a", "x", &partial_payload, &extra,
                                          AssociationEditMode::ExistingOnly) &&
            fr.ReadRecord(30, record, size) && size == 10 &&
            std::equal(partial.begin(), partial.end(), record) &&
            ReadTrieValueByNodeId(rt, rv, 2, value) && value.Size() == 8 &&
            std::equal(empty.Data(), empty.Data() + empty.Size(), value.Data()) &&
            fv.RecordCount() == 3 && rv.RecordCount() == 3 && fr.RecordCount() == 4 &&
            rr.RecordCount() == 3 && state.association_count == 1 && state.flags == 0x80,
            "a missing reverse record retains the forward payload update without creating a counterpart");
    const bool removed = RemoveDictionaryAssociation(forward, reverse, state, "a", "x");
    const IndexPoolView changed(fp.Data(), fp.Size(), fc.MutableData(), fc.Size());
    id = 0;
    Require(!removed &&
            state.association_count == 1 && state.flags == 0x80 &&
            ft.FindTerminal("a") == 2 && rt.FindTerminal("x") == 2 &&
            ReadTrieValueByNodeId(ft, fv, 2, value) && value.Size() == 6 &&
            std::equal(remaining_a.begin(), remaining_a.end(), value.Data()) &&
            !changed.ReadRecordId(2, id) && id == 0xffffffffU,
            "a missing reverse record retains the first pool deletion without publishing keys or state");
    std::puts("PASS: dual-trie existing updates, removal, reference publication, key deletion and partial failures");
}
