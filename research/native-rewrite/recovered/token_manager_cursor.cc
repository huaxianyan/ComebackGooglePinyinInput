// Recovered Manager DFS composition, not fabricated child results; see NOTICE.
#include "token_manager_cursor.h"
#include "token_manager_selection.h"
#include <utility>

namespace comeback::recovered {
ManagerTokenCursor::ManagerTokenCursor(std::vector<Child> children)
    : children_(std::move(children)), frames_(1) {
    for (std::size_t i = 0; i < children_.size(); ++i) frames_.front().push_back(i);
}

void ManagerTokenCursor::ClearCache() {
    cache_index_ = 0;
    cache_ready_ = false;
    cache_.clear();
}

bool ManagerTokenCursor::ChildrenDone() const {
    return frames_.size() <= 1 || static_cast<std::size_t>(child_index_) == frames_.back().size();
}

void ManagerTokenCursor::SkipDoneChildren() {
    while (!ChildrenDone() && children_[frames_.back()[child_index_]].cursor->Done()) ++child_index_;
}

bool ManagerTokenCursor::Push(std::int32_t selector, std::int32_t language,
    const std::string& input, bool target) {
    is_source_ = !target;
    ClearCache();
    if (children_.empty()) return false;
    std::vector<std::size_t> matched;
    for (const auto index : frames_.back()) {
        auto& child = children_[index];
        if (MatchesTokenDictionary(child.selector, child.language, selector, language) &&
            child.cursor->Push(selector, language, input, target)) matched.push_back(index);
    }
    if (matched.empty()) return false;
    frames_.push_back(std::move(matched));
    child_index_ = 0;
    SkipDoneChildren();
    return true;
}

bool ManagerTokenCursor::NextFrame() {
    ClearCache();
    if (frames_.size() <= 1 || children_.empty()) return false;
    for (const auto index : frames_.back()) children_[index].cursor->NextFrame();
    child_index_ = 0;
    SkipDoneChildren();
    return true;
}

bool ManagerTokenCursor::Pop() {
    ClearCache();
    if (frames_.size() <= 1) return false;
    for (const auto index : frames_.back()) children_[index].cursor->Pop();
    frames_.pop_back();
    if (frames_.size() > 1) {
        child_index_ = 0;
        SkipDoneChildren();
    }
    return true;
}

void ManagerTokenCursor::Reset() {
    for (const auto index : frames_.front()) children_[index].cursor->Reset();
    frames_.resize(1);
    ClearCache();
}

bool ManagerTokenCursor::Done() const {
    if (!cache_ready_) return ChildrenDone();
    return static_cast<std::size_t>(cache_index_) >= cache_.size();
}

void ManagerTokenCursor::Materialize() {
    ManagerTokenAdmission admission(is_source_);
    // The original temporary is initialized once per pass. In particular Direct
    // Current retains the identity bit from the preceding successful child.
    KeyToken token{"", 0, kUnknownTokenLanguage, false};
    while (!ChildrenDone()) {
        auto& child = *children_[frames_.back()[child_index_]].cursor;
        if (child.Current(token) && admission.Include(token)) cache_.push_back({token, child.Attribute()});
        child.Advance();
        SkipDoneChildren();
    }
    cache_ready_ = true;
}

bool ManagerTokenCursor::Current(KeyToken& output) {
    if (Done()) return false;
    if (!cache_ready_) Materialize();
    output = cache_[cache_index_].token;
    return true;
}

float ManagerTokenCursor::Attribute() {
    if (!cache_ready_) Materialize();
    return static_cast<std::size_t>(cache_index_) < cache_.size() ? cache_[cache_index_].attribute : 0.0f;
}

void ManagerTokenCursor::Advance() {
    if (!cache_ready_) Materialize();
    ++cache_index_;
}
}  // namespace comeback::recovered
