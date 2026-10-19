// Google-derived reconstruction; see NOTICE and fixed-phrase-table.md.
#include "fixed_phrase_table.h"
#include "storage_growth.h"

#include <algorithm>
#include <cstring>

namespace comeback::recovered {

bool FixedPhraseTable::Initialize() {
    if (record_size_ == 0) return false;
    record_count_ = 0;
    ready_ = true;
    used_size_ = 0;
    return true;
}

bool FixedPhraseTable::Contains(std::uint64_t record_id) const {
    return ready_ && record_id % record_size_ == 0 && record_id <= used_size_ &&
           record_size_ <= used_size_ - record_id;
}

bool FixedPhraseTable::ReadRecord(std::uint64_t record_id, const std::uint8_t*& data,
                                  std::size_t& size) const {
    if (!Contains(record_id)) return false;
    data = bytes_.Data() + static_cast<std::size_t>(record_id);
    size = record_size_;
    return true;
}

bool FixedPhraseTable::MutableRecord(std::uint64_t record_id, std::uint8_t*& data,
                                     std::size_t& size) {
    if (!Contains(record_id)) return false;
    auto* storage = bytes_.MutableData();
    // The native getter does not check this allocation result before adding the
    // offset. Expose failure instead of publishing an invalid pointer.
    if (storage == nullptr) return false;
    data = storage + static_cast<std::size_t>(record_id);
    size = record_size_;
    return true;
}

bool FixedPhraseTable::AppendRecord(const std::uint8_t* data, std::size_t size,
                                    std::uint64_t& record_id) {
    if (!ready_ || data == nullptr || size != record_size_) return false;
    const auto required = used_size_ + record_size_;
    if (bytes_.Size() < required) {
        // Native UCVTF/FCVTZU use unsigned binary64 conversion and truncation.
        const auto scaled = static_cast<std::size_t>(
            static_cast<double>(bytes_.Size()) * detail::kStorageGrowthFactor);
        if (!bytes_.Resize(std::max(scaled, required))) return false;
    }
    auto* storage = bytes_.MutableData();
    if (storage == nullptr) return false;
    std::memcpy(storage + used_size_, data, size);
    ++record_count_;
    used_size_ += record_size_;
    record_id = used_size_ - record_size_;
    return true;
}

std::uint32_t FixedPhraseTable::RecordCount() const {
    return ready_ ? record_count_ : 0;
}

void FixedPhraseTable::Clear() {
    if (!ready_) return;
    // Native zeroing skips a null mutable result, but still resets count/usage.
    // Descriptor-allocation exceptions propagate before those metadata writes.
    auto* storage = bytes_.MutableData();
    if (storage != nullptr) std::memset(storage, 0, bytes_.Size());
    record_count_ = 0;
    used_size_ = 0;
}

}  // namespace comeback::recovered
