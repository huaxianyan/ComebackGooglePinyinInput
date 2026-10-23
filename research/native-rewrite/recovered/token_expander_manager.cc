// Recovered 0x196874 / 0x196af0 / 0x196d30 / 0x197348; see NOTICE.
#include "token_expander_manager.h"
#include "direct_mapping_token_expander.h"
#include "token_expansion_setting.pb.h"

namespace comeback::recovered {
std::shared_ptr<TokenExpanderManager> TokenExpanderManager::Load(
    const std::string& setting, TokenModelResources& resources) {
    proto::TokenExpansionSetting parsed;
    if (!parsed.ParseFromString(setting)) return nullptr;
    auto manager = std::shared_ptr<TokenExpanderManager>(new TokenExpanderManager);
    for (const auto& id : parsed.data_id()) {
        const auto resolved = resources.Resolve(id);
        if (resolved.status == TokenModelResources::Resolution::Status::Missing) continue;
        if (resolved.status == TokenModelResources::Resolution::Status::Unsupported) return nullptr;
        const auto* model = std::get_if<std::shared_ptr<DirectMappingTokenExpander>>(resolved.model);
        if (!model) return nullptr;
        const auto category = (*model)->Category();
        if (category != 0) manager->groups_[category].push_back(*model);
    }
    return manager;
}

std::unique_ptr<TokenExpanderManager::Cursor> TokenExpanderManager::CreateCursor(
    const std::vector<std::int32_t>& categories) const {
    std::vector<std::unique_ptr<TokenExpanderCursor>> children;
    for (const auto category : categories) {
        const auto group = groups_.find(category);
        if (group == groups_.end()) continue;
        for (const auto& model : group->second)
            children.push_back(std::make_unique<DirectMappingTokenExpander::Cursor>(model));
    }
    return std::unique_ptr<Cursor>(new Cursor(std::move(children)));
}

TokenExpanderManager::Cursor::Cursor(std::vector<std::unique_ptr<TokenExpanderCursor>> children)
    : children_(std::move(children)), current_(results_.end()) {}

bool TokenExpanderManager::Cursor::Reset(const KeyToken& input) {
    results_.clear();
    results_.emplace(input, 0.0f);
    for (auto& child : children_) Apply(*child);
    current_ = results_.begin();
    return true;
}

void TokenExpanderManager::Cursor::Apply(TokenExpanderCursor& child) {
    Results previous{KeyTokenIdentityLess};
    previous.swap(results_);
    // Native creates these ONCE per apply, outside both source/result loops.
    // Partial child writes can retain text/flag left by a prior fallback.
    KeyToken expanded{};
    float score = 0.0f;
    for (const auto& source : previous) {
        if (!child.Reset(source.first)) {
            results_.emplace(source);  // Rejection keeps first, no score update.
            continue;
        }
        while (!child.Exhausted()) {
            if (child.Current(expanded, &score)) {
                const float combined = source.second + score;
                const auto inserted = results_.emplace(expanded, combined);
                if (!inserted.second && inserted.first->second < combined)
                    inserted.first->second = combined;
            }
            child.Advance();
        }
    }
}

bool TokenExpanderManager::Cursor::Current(KeyToken& output, float* score) const {
    if (Exhausted()) return false;
    output = current_->first;
    if (score) *score = current_->second;
    return true;
}

void TokenExpanderManager::Cursor::Advance() {
    if (!Exhausted()) ++current_;
}
}  // namespace comeback::recovered
