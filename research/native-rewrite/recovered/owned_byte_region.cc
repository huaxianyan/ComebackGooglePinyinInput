// Google-derived reconstruction; see NOTICE and owned-byte-region.md.
#include "owned_byte_region.h"

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <utility>

namespace comeback::recovered {

struct OwnedByteRegion::State {
    State() = default;
    State(const State&) = delete;
    State& operator=(const State&) = delete;
    ~State() { Reset(); }

    void Reset() {
        if (parent) parent.reset();
        else if (!read_only_owner) std::free(data);
        read_only_owner.reset();
        data = nullptr;
        size = 0;
    }

    bool Detach(std::size_t new_size) {
        auto* replacement = static_cast<std::uint8_t*>(std::malloc(new_size));
        if (replacement == nullptr) return false;
        const auto copied = std::min(size, new_size);
        if (copied != 0) std::memcpy(replacement, data, copied);
        if (new_size > size) std::memset(replacement + size, 0, new_size - size);
        Reset();
        data = replacement;
        size = new_size;
        return true;
    }

    bool Resize(std::size_t new_size, bool clear_growth) {
        if (new_size == size) return true;
        if (new_size == 0) {
            Reset();
            return true;
        }
        if (parent || read_only_owner) return Detach(new_size);
        auto* replacement = static_cast<std::uint8_t*>(std::realloc(data, new_size));
        if (replacement == nullptr) return false;
        if (clear_growth && new_size > size) {
            std::memset(replacement + size, 0, new_size - size);
        }
        data = replacement;
        size = new_size;
        return true;
    }

    std::shared_ptr<State> parent;
    std::shared_ptr<const void> read_only_owner;
    std::uint8_t* data = nullptr;
    std::size_t size = 0;
};

OwnedByteRegion OwnedByteRegion::FromReadOnlyOwner(std::shared_ptr<const void> owner,
                                                   const std::uint8_t* data, std::size_t size) {
    OwnedByteRegion result;
    result.state_ = std::make_shared<State>();
    result.state_->read_only_owner = std::move(owner);
    result.state_->data = const_cast<std::uint8_t*>(data);
    result.state_->size = size;
    return result;
}

std::shared_ptr<OwnedByteRegion::State> OwnedByteRegion::Clone(
    const std::shared_ptr<State>& source) {
    auto replacement = std::make_shared<State>();
    if (!replacement->Resize(source->size, false)) return {};
    if (source->size != 0) std::memcpy(replacement->data, source->data, source->size);
    return replacement;
}

std::size_t OwnedByteRegion::Size() const {
    return state_ ? state_->size : 0;
}

const std::uint8_t* OwnedByteRegion::Data() const {
    return state_ ? state_->data : nullptr;
}

std::uint8_t* OwnedByteRegion::MutableData() {
    if (!state_) return nullptr;
    if (!state_.unique()) {
        auto replacement = Clone(state_);
        if (!replacement) return nullptr;
        state_ = std::move(replacement);
    }
    if ((state_->parent || state_->read_only_owner) && !state_->Detach(state_->size)) return nullptr;
    return state_->data;
}

bool OwnedByteRegion::Resize(std::size_t size) {
    if (state_ && state_.unique()) return state_->Resize(size, true);
    auto replacement = state_ ? Clone(state_) : std::make_shared<State>();
    if (!replacement || !replacement->Resize(size, true)) return false;
    state_ = std::move(replacement);
    return true;
}

OwnedByteRegion OwnedByteRegion::Slice(std::size_t offset, std::size_t size) const {
    OwnedByteRegion result;
    if (!state_ || size == 0 || offset > state_->size || size > state_->size - offset) return result;
    result.state_ = std::make_shared<State>();
    result.state_->parent = state_;
    result.state_->data = state_->data + offset;
    result.state_->size = size;
    return result;
}

}  // namespace comeback::recovered
