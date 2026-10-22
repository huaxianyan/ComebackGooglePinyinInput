// Ordinary Forward source/target frames; Google-derived, see NOTICE.
#include "forward_token_dictionary.h"
#include <utility>

namespace comeback::recovered {
ForwardTokenDictionaryView::Cursor::Cursor(
    std::shared_ptr<const ForwardTokenDictionaryView> dictionary)
    : dictionary_(std::move(dictionary)), exact_(dictionary_) {}

bool ForwardTokenDictionaryView::Cursor::Push(std::int32_t selector,
    std::int32_t language, const std::string& input, bool target) {
    if (!MatchesTokenDictionary(dictionary_->Metadata().selector(),
            dictionary_->Metadata().language_id(), selector, language)) return false;
    if (target && !dictionary_->Metadata().target_uses_source()) {
        if (!pending_.empty()) return false;
        pending_.emplace_back(input.c_str());
        query_language_ = language;
        position_ = 0;
        target_mode_ = true;
        return true;
    }
    if (synchronized_ || (!pending_.empty() && target_mode_)) return false;
    pending_.push_back(dictionary_->PrepareSource(input));
    return true;
}

bool ForwardTokenDictionaryView::Cursor::NextFrame() {
    if (pending_.empty() || target_mode_) return true;
    synchronized_ = true;
    std::size_t common = 0;
    while (common < pending_.size() && common < applied_.size() &&
           pending_[pending_.size() - 1 - common] == applied_[common]) ++common;
    while (applied_.size() > common) {
        if (!exact_.Pop()) return false;
        applied_.pop_back();
    }
    // Collection consumed the child's current result. Even an identical pending
    // query pops and reapplies its final segment, as in original 0x1b62f8.
    if (common == pending_.size()) {
        if (!exact_.Pop()) return false;
        applied_.pop_back();
        --common;
    }
    for (; common < pending_.size(); ++common) {
        const auto& input = pending_[pending_.size() - 1 - common];
        if (!exact_.Push(input)) return false;
        applied_.push_back(input);
    }
    has_record_ = exact_.HasCurrent();
    if (has_record_) {
        row_ = static_cast<std::uint16_t>(exact_.Current().id());
        length_ = static_cast<std::uint16_t>(exact_.Current().length());
        exact_.Advance();
    }
    position_ = 0;
    return true;
}

bool ForwardTokenDictionaryView::Cursor::Done() const {
    if (target_mode_) return position_ != 0;
    return position_ >= kDefaultResultLimit ||
        static_cast<std::size_t>(position_) >= static_cast<std::size_t>(has_record_);
}

bool ForwardTokenDictionaryView::Cursor::Current(KeyToken& output) {
    if (Done()) return false;
    if (target_mode_) return dictionary_->ReadLiteralTarget(pending_.front(), query_language_, output);
    dictionary_->ReadSourceToken(row_, length_, output);
    return true;
}

float ForwardTokenDictionaryView::Cursor::Attribute() {
    if (target_mode_ || !dictionary_->Metadata().length_penalty()) return 0.0f;
    // Original 0x1b43bc returns S0. Literal words: bdd7c741 / c0135d8e.
    return dictionary_->Table(ForwardTokenColumn::Meta).At(row_) == length_
        ? -0.10536051541566849f : -2.3025851249694824f;
}

bool ForwardTokenDictionaryView::Cursor::Pop() {
    position_ = kDefaultResultLimit;
    has_record_ = false;
    synchronized_ = false;
    target_mode_ = false;
    if (pending_.empty()) return false;
    pending_.pop_back();
    return true;
}

void ForwardTokenDictionaryView::Cursor::Reset() {
    pending_.clear();
    position_ = kDefaultResultLimit;
    has_record_ = false;
    synchronized_ = false;
    target_mode_ = false;
    // Applied strings and child frames are reconciled by the next NextFrame.
}
}  // namespace comeback::recovered
