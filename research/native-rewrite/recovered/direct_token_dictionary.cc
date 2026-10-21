// Real DirectTokenDictionary resource ranges and DFS cursor; see NOTICE.
#include "direct_token_dictionary.h"
#include "dictionary_alignment.h"
#include "little_endian.h"
#include "token_query.h"
#include <cstring>
#include <limits>
#include <optional>
#include <utility>

namespace comeback::recovered {
namespace {
constexpr std::uint32_t kDirectTargetBit = 0x01000000u;
std::int32_t SignedBits(std::uint32_t raw) {
    const std::int64_t value = raw < 0x80000000u ? raw : std::int64_t{raw} - 0x100000000LL;
    return static_cast<std::int32_t>(value);
}
std::optional<FlatIntegerTableView> ReadArray(const OwnedByteRegion& payload, std::size_t& position) {
    if (position > payload.Size() || payload.Size() - position < 8) return std::nullopt;
    const auto* header = payload.Data() + position;
    const auto count = detail::ReadLittleEndian<std::uint32_t>(header);
    const auto width = detail::ReadLittleEndian<std::uint32_t>(header + 4);
    const auto bits = std::uint64_t{count} * width;
    if (width > 32 || bits > std::numeric_limits<std::uint32_t>::max()) return std::nullopt;
    const auto bytes = ((bits + 31) / 32) * 4;
    const auto block = detail::AlignDictionaryBytes(8 + bytes);
    if (block > payload.Size() - position) return std::nullopt;
    FlatIntegerTableView table(payload.Slice(position + 8, bytes), count, width);
    position += block;
    return table;
}
std::uint32_t UnitScalar(const std::string& unit) {
    const auto first = static_cast<unsigned char>(unit[0]);
    if (unit.size() == 1) return first;
    std::uint32_t scalar = first & ((std::uint32_t{1} << (7 - unit.size())) - 1);
    for (std::size_t i = 1; i < unit.size(); ++i) {
        scalar = (scalar << 6) | (static_cast<unsigned char>(unit[i]) & 0x3fu);
    }
    return scalar;
}
}
DirectTokenDictionary::DirectTokenDictionary(std::int32_t selector, std::int32_t language,
    bool case_sensitive, const FlatIntegerTableView& starts, const FlatIntegerTableView& lengths)
    : selector_(selector), language_(language), case_sensitive_(case_sensitive),
      starts_(starts), lengths_(lengths) {}

std::shared_ptr<DirectTokenDictionary> DirectTokenDictionary::Load(const OwnedByteRegion& payload) {
    if (payload.Size() < 16) return nullptr;
    std::size_t position = 16;
    const auto starts = ReadArray(payload, position);
    const auto lengths = ReadArray(payload, position);
    // Normal original resources have nonempty matching ranges. This host load
    // does not claim native partial-publication/crash behavior on corrupt data.
    if (!starts || !lengths || starts->Count() == 0 || starts->Count() != lengths->Count()) return nullptr;
    const auto* metadata = payload.Data();
    // DFS does not consume metadata word four. Its original bytes remain
    // owned via the table slices; no replacement/default value is synthesized.
    return std::shared_ptr<DirectTokenDictionary>(new DirectTokenDictionary(
        SignedBits(detail::ReadLittleEndian<std::uint32_t>(metadata)),
        SignedBits(detail::ReadLittleEndian<std::uint32_t>(metadata + 4)),
        detail::ReadLittleEndian<std::uint32_t>(metadata + 8) != 0, *starts, *lengths));
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
    if (!target) for (const auto& unit : units) if (!Contains(UnitScalar(unit))) return false;
    std::uint32_t value = 0;
    if (units.size() == 1) value = UnitScalar(units.front());
    else if (!units.empty()) {
        const auto old = dynamic_counter_.fetch_add(1, std::memory_order_relaxed);
        value = static_cast<std::uint32_t>(SignedBits(old) % 0x110000) + 0xf0000u;
    }
    id = value | (static_cast<std::uint32_t>(selector_) << 28) |
         (target ? kDirectTargetBit : 0x00800000u);
    return true;
}

DirectTokenCursor::DirectTokenCursor(std::shared_ptr<DirectTokenDictionary> dictionary)
    : dictionary_(std::move(dictionary)) {}

bool DirectTokenCursor::Push(std::int32_t selector, std::int32_t language,
    std::string_view input, bool target) {
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

bool DirectTokenCursor::Current(KeyToken& output) const {
    if (Done()) return false;
    output.id = id_;
    const auto language = static_cast<std::uint16_t>((id_ & kDirectTargetBit) != 0 ?
        query_language_ : dictionary_->language_);
    std::memcpy(&output.auxiliary, &language, sizeof(language));
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
