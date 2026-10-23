// Recovered 0x19c93c..0x19d670 DirectMapping child path; see NOTICE.
#include "direct_mapping_token_expander.h"
#include "dictionary_string_image.h"
#include "little_endian.h"
#include "token_manager_selection.h"

namespace comeback::recovered {
DirectMappingTokenExpander::DirectMappingTokenExpander(const Metadata& metadata,
    const FlatIntegerTableView& keys, const FlatIntegerTableView& positions,
    const OwnedByteRegion& targets, const OwnedByteRegion& scores)
    : metadata_(metadata), keys_(keys), positions_(positions), targets_(targets), scores_(scores) {
    // Native default quantizer 0x1d1e50 -> 0x1d1d80, separate binary32 operations.
    const float step = 20.0f / 255.0f;
    for (std::size_t code = 0; code < score_table_.size(); ++code)
        score_table_[code] = step * static_cast<float>(code);
}

std::shared_ptr<DirectMappingTokenExpander> DirectMappingTokenExpander::Load(
    const OwnedByteRegion& payload) {
    std::string wire;
    const auto advance = LoadDictionaryStringImage(payload, wire);
    if (advance == 0 || advance > payload.Size()) return nullptr;
    Metadata metadata;
    if (!metadata.ParseFromString(wire)) return nullptr;
    std::size_t position = advance;
    const auto keys = LoadFlatIntegerTableImage(payload, position);
    const auto positions = LoadFlatIntegerTableImage(payload, position);
    const auto targets = LoadDictionaryArrayImage(payload, position);
    const auto scores = LoadDictionaryArrayImage(payload, position);
    // Supported ordinary images; these checks do not emulate corrupt native IO.
    if (!keys || !positions || !targets || !scores || keys->Count() != positions->Count() ||
        targets->Size() % 4 != 0 || targets->Size() / 4 != scores->Size()) return nullptr;
    return std::shared_ptr<DirectMappingTokenExpander>(new DirectMappingTokenExpander(
        metadata, *keys, *positions, *targets, *scores));
}

std::uint32_t DirectMappingTokenExpander::Target(std::uint64_t position) const {
    return detail::ReadLittleEndian<std::uint32_t>(targets_.Data() + position * 4);
}

bool DirectMappingTokenExpander::Lookup(std::uint32_t id, std::uint64_t& position,
    std::uint32_t& count) const {
    const auto query = id & kTokenCodepointMask;
    std::uint32_t first = 0, remaining = keys_.Count();
    while (remaining != 0) {
        const auto half = remaining / 2;
        if (keys_.At(first + half) < query) {
            first += half + 1;
            remaining -= half + 1;
        } else remaining = half;
    }
    if (first == keys_.Count()) return false;
    std::uint32_t resolved;
    if (keys_.At(first) == query) resolved = positions_.At(first);
    else {
        if (first == 0) return false;
        resolved = positions_.At(first - 1) + query - keys_.At(first - 1);
        if (resolved >= positions_.At(first)) return false;
    }
    // Native resolve/read use raw arrays, not FlatVector's width-32 mask.
    if (resolved >= targets_.Size() / 4) return false;
    position = resolved;
    const auto word = Target(position);
    count = 1;
    if ((word & 0x80000000u) != 0) {
        count = scores_.Data()[position];
        position = word & 0x7fffffffu;
    }
    return true;
}

bool DirectMappingTokenExpander::Cursor::Reset(const KeyToken& input) {
    fallback_pending_ = false;
    const auto& metadata = expander_->metadata_;
    if (!MatchesTokenDictionary(metadata.input_kind(), metadata.auxiliary_id(),
        static_cast<std::int32_t>(TokenKindFromId(input.id)), input.auxiliary)) return false;
    if (!expander_->Lookup(input.id, position_, remaining_)) {
        remaining_ = 0;
        if (metadata.fallback()) {
            fallback_ = input;
            fallback_pending_ = true;
        }
    }
    return true;
}

bool DirectMappingTokenExpander::Cursor::Current(KeyToken& output, float* score) const {
    if (Exhausted()) return false;
    if (fallback_pending_) {
        output = fallback_;
        if (score) *score = 0.0f;
        return true;
    }
    if (position_ >= expander_->targets_.Size() / 4) return false;
    if (score) *score = -expander_->score_table_[expander_->scores_.Data()[position_]];
    output.id = expander_->Target(position_);
    output.auxiliary = TokenAuxiliaryFromWord(expander_->metadata_.auxiliary_id());
    return true;
}

void DirectMappingTokenExpander::Cursor::Advance() {
    fallback_pending_ = false;
    if (Exhausted()) return;
    --remaining_;
    ++position_;
}
}  // namespace comeback::recovered
