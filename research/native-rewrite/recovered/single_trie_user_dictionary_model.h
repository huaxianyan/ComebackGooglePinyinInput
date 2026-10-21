// Current SingleTrie candidate publication and owned editor lifetime; see NOTICE.
#ifndef COMEBACK_RECOVERED_SINGLE_TRIE_USER_DICTIONARY_MODEL_H
#define COMEBACK_RECOVERED_SINGLE_TRIE_USER_DICTIONARY_MODEL_H

#include "single_trie_association.h"
#include "user_dictionary_image.h"
#include <memory>
#include <shared_mutex>

namespace comeback::recovered {
// Ownership reconstruction, not the original factory/virtual-handle ABI. The
// existing coordinator refers to storage at a stable address and dies before it.
// Direct mutation is exclusive; shared callers use the model-reference locks.
// Do not move/assign this model's storage separately.
struct SingleTrieUserDictionaryModel {
    // Native model-level data lock (+8), owned once per actual model. Host
    // shared_mutex preserves read/write exclusion, not the original lock ABI.
    std::shared_mutex data_mutex;
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> storage;
    SingleTrieAssociationEditor editor;
    // Native 0x1a3c9c sets +0x10 to one only after successful publication.
    std::uint8_t edit_flags = 1;

    SingleTrieUserDictionaryModel(const SingleTrieUserDictionaryModel&) = delete;
    SingleTrieUserDictionaryModel& operator=(const SingleTrieUserDictionaryModel&) = delete;
    SingleTrieUserDictionaryModel(SingleTrieUserDictionaryModel&&) = delete;
    SingleTrieUserDictionaryModel& operator=(SingleTrieUserDictionaryModel&&) = delete;
private:
    explicit SingleTrieUserDictionaryModel(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&& loaded);
    static void Publish(UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&& prepared,
        std::unique_ptr<SingleTrieUserDictionaryModel>& output);
    friend bool InitializeSingleTrieUserDictionaryModel(std::int32_t,
        std::unique_ptr<SingleTrieUserDictionaryModel>&);
    friend std::uint64_t LoadSingleTrieUserDictionaryModel(const OwnedByteRegion&,
        std::unique_ptr<SingleTrieUserDictionaryModel>&);
};

// Native 0x1a259c current SingleTrie initialization. Replaces live dictionary
// data after preparing actual editor resources; preserves outer metadata except
// explicitly present zero total/sync fields. Not an automatic load-error fallback.
bool InitializeSingleTrieUserDictionaryModel(std::int32_t token_category,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output);

// Existing image validation -> owned model and prepared editor -> publication.
// Zero leaves the old model/editor intact. Success expires references to the old
// model; returned size follows the image parser's consumed-byte contract.
// Original virtual child acquisition and allocation-failure equivalence remain
// unimplemented, rather than represented by mock handles or a ready boolean.
std::uint64_t LoadSingleTrieUserDictionaryModel(const OwnedByteRegion& input,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output);
}  // namespace comeback::recovered
#endif
