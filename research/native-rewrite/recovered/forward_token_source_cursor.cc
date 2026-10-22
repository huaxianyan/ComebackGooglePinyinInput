// Ordinary Forward source frames; Google-derived, see NOTICE.
#include "forward_token_dictionary.h"
#include <utility>

namespace comeback::recovered {
ForwardTokenDictionaryView::SourceCursor::SourceCursor(
    std::shared_ptr<const ForwardTokenDictionaryView> dictionary)
    : dictionary_(std::move(dictionary)), exact_(dictionary_) {}

bool ForwardTokenDictionaryView::SourceCursor::Push(std::int32_t selector,
    std::int32_t language, const std::string& input) {
    if (!MatchesTokenDictionary(dictionary_->Metadata().selector(),
            dictionary_->Metadata().language_id(), selector, language) || synchronized_) return false;
    pending_.push_back(dictionary_->PrepareSource(input));
    return true;
}

bool ForwardTokenDictionaryView::SourceCursor::NextFrame() {
    if (pending_.empty()) return true;
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

bool ForwardTokenDictionaryView::SourceCursor::Done() const {
    return position_ >= kDefaultResultLimit ||
        static_cast<std::size_t>(position_) >= static_cast<std::size_t>(has_record_);
}

bool ForwardTokenDictionaryView::SourceCursor::Current(KeyToken& output) const {
    if (Done()) return false;
    dictionary_->ReadSourceToken(row_, length_, output);
    return true;
}

bool ForwardTokenDictionaryView::SourceCursor::Pop() {
    position_ = kDefaultResultLimit;
    has_record_ = false;
    synchronized_ = false;
    if (pending_.empty()) return false;
    pending_.pop_back();
    return true;
}

void ForwardTokenDictionaryView::SourceCursor::Reset() {
    pending_.clear();
    position_ = kDefaultResultLimit;
    has_record_ = false;
    synchronized_ = false;
    // Applied strings and child frames are reconciled by the next NextFrame.
}
}  // namespace comeback::recovered
