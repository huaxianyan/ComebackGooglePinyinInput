// Real DirectTokenDictionary resource ranges and DFS cursor; see NOTICE.
#include "direct_token_dictionary.h"
#include "little_endian.h"
#include "token_query.h"
#include <utility>

namespace comeback::recovered {
namespace {
std::int32_t SignedBits(std::uint32_t raw) {
    const std::int64_t value = raw < 0x80000000u ? raw : std::int64_t{raw} - 0x100000000LL;
    return static_cast<std::int32_t>(value);
}
}
DirectTokenDictionary::DirectTokenDictionary(std::int32_t selector, std::int32_t language,
    bool case_sensitive, bool reversed_tokens, const FlatIntegerTableView& starts, const FlatIntegerTableView& lengths)
    : selector_(selector), language_(language), case_sensitive_(case_sensitive), reversed_tokens_(reversed_tokens),
      starts_(starts), lengths_(lengths) {}

std::shared_ptr<DirectTokenDictionary> DirectTokenDictionary::Load(const OwnedByteRegion& payload) {
    if (payload.Size() < 16) return nullptr;
    std::size_t position = 16;
    const auto starts = LoadFlatIntegerTableImage(payload, position);
    const auto lengths = LoadFlatIntegerTableImage(payload, position);
    // Normal original resources have nonempty matching ranges. This host load
    // does not claim native partial-publication/crash behavior on corrupt data.
    if (!starts || !lengths || starts->Count() == 0 || starts->Count() != lengths->Count()) return nullptr;
    const auto* metadata = payload.Data();
    // Word four is not consumed by Direct DFS, but the Manager factory reads
    // its IsUsingReversedToken getter (original 0x1b09c0).
    return std::shared_ptr<DirectTokenDictionary>(new DirectTokenDictionary(
        SignedBits(detail::ReadLittleEndian<std::uint32_t>(metadata)),
        SignedBits(detail::ReadLittleEndian<std::uint32_t>(metadata + 4)),
        detail::ReadLittleEndian<std::uint32_t>(metadata + 8) != 0,
        detail::ReadLittleEndian<std::uint32_t>(metadata + 12) != 0, *starts, *lengths));
}

bool DirectTokenDictionary::Contains(std::uint32_t codepoint) const {
    if (codepoint < starts_.At(0)) return false;
    std::uint64_t first = 0, remaining = starts_.Count();
    while (remaining != 0) {
        const auto half = remaining / 2;
        if (starts_.At(first + half) < codepoint) {
            first += half + 1;
            remaining -= half + 1;
        } else remaining = half;
    }
    if (first < starts_.Count() && starts_.At(first) == codepoint) return true;
    return codepoint - starts_.At(first - 1) < lengths_.At(first - 1);
}

bool DirectTokenDictionary::Encode(std::string_view input, bool target,
    std::uint32_t& id, std::string& canonical) {
    canonical.assign(input.data(), input.size());
    if (!target && !case_sensitive_) LowercaseTokenBytes(canonical);
    std::vector<std::string> units;
    AppendTokenQueryUnits(canonical, units);
    if (!target) for (const auto& unit : units) if (!Contains(ReadTokenQueryScalar(unit))) return false;
    std::uint32_t value = 0;
    if (units.size() == 1) value = ReadTokenQueryScalar(units.front());
    else if (!units.empty()) {
        const auto old = dynamic_counter_.fetch_add(1, std::memory_order_relaxed);
        value = static_cast<std::uint32_t>(SignedBits(old) % 0x110000) + 0xf0000u;
    }
    id = value | (static_cast<std::uint32_t>(selector_) << 28) |
         (target ? kTokenLiteralBit : 0x00800000u);
    return true;
}

DirectTokenCursor::DirectTokenCursor(std::shared_ptr<DirectTokenDictionary> dictionary)
    : dictionary_(std::move(dictionary)) {}

bool DirectTokenCursor::Push(std::int32_t selector, std::int32_t language,
    const std::string& input, bool target) {
    if (!MatchesTokenDictionary(dictionary_->selector_, dictionary_->language_, selector, language) ||
        active_ || input.empty()) return false;
    std::uint32_t id;
    std::string canonical;
    if (!dictionary_->Encode(input, target, id, canonical)) return false;
    id_ = id;
    text_ = std::move(canonical);
    if (target) query_language_ = language;
    done_ = false;
    active_ = true;
    return true;
}

bool DirectTokenCursor::Current(KeyToken& output) {
    if (Done()) return false;
    output.id = id_;
    output.auxiliary = TokenAuxiliaryFromWord((id_ & kTokenLiteralBit) != 0 ?
        query_language_ : dictionary_->language_);
    output.text = text_;
    // Original 0x1b1110 does not assign identity bit zero or one here.
    return true;
}

bool DirectTokenCursor::Pop() {
    const bool had_frame = active_;
    if (had_frame) Reset();
    return had_frame;
}
void DirectTokenCursor::Reset() {
    active_ = false;
    done_ = true;
}
}  // namespace comeback::recovered
