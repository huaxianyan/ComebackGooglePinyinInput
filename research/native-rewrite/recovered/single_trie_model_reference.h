// Native accessor/reference then model locking, ownership normalized; see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_MODEL_REFERENCE_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_MODEL_REFERENCE_H
#include "single_trie_user_dictionary_model.h"
#include <mutex>
#include <shared_mutex>
#include <type_traits>
#include <utility>

namespace comeback::recovered {
// A real model reference, not an Android accessor/readiness/cache substitute.
// Keep this reference alive until all accesses end. Bind assigns an already
// supplied model; it does not implement DataManager lookup or reload policy.
class SingleTrieModelReference {
public:
    explicit SingleTrieModelReference(std::shared_ptr<SingleTrieUserDictionaryModel> model = {})
        : model_(std::move(model)) {}

    template<bool Write> class Access {
    public:
        Access(const Access&) = delete;
        Access& operator=(const Access&) = delete;
        Access(Access&&) = delete;
        Access& operator=(Access&&) = delete;
        explicit operator bool() const { return model_ != nullptr; }
        using Pointer = std::conditional_t<Write, SingleTrieUserDictionaryModel*,
                                          const SingleTrieUserDictionaryModel*>;
        Pointer operator->() const { return model_.get(); }
    private:
        friend class SingleTrieModelReference;
        using Lock = std::conditional_t<Write, std::unique_lock<std::shared_mutex>,
                                       std::shared_lock<std::shared_mutex>>;
        explicit Access(SingleTrieModelReference& owner)
            : reference_lock_(owner.reference_mutex_), model_(owner.model_) {
            if (model_) data_lock_ = Lock(model_->data_mutex);
        }
        // Reverse destruction: data unlock, model unpin, reference unlock.
        // No move assignment can release an outer lock before its inner lock.
        Lock reference_lock_;
        std::shared_ptr<SingleTrieUserDictionaryModel> model_;
        Lock data_lock_;
    };
    using ReadAccess = Access<false>;
    using WriteAccess = Access<true>;
    ReadAccess Read() { return ReadAccess(*this); }
    WriteAccess Write() { return WriteAccess(*this); }

    void Bind(std::shared_ptr<SingleTrieUserDictionaryModel> model) {
        std::unique_lock<std::shared_mutex> lock(reference_mutex_);
        model_ = std::move(model);
    }
private:
    std::shared_mutex reference_mutex_;
    std::shared_ptr<SingleTrieUserDictionaryModel> model_;
};
}  // namespace comeback::recovered
#endif
