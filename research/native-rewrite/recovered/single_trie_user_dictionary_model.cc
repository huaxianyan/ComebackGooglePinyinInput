// Native 0x1a259c initialization / 0x1a3c9c load publication, owned in C++; NOTICE.
#include "single_trie_user_dictionary_model.h"
#include "single_trie_mutable_dictionary_init.h"
#include <utility>

namespace comeback::recovered {
SingleTrieUserDictionaryModel::SingleTrieUserDictionaryModel(
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&& loaded)
    : storage(std::move(loaded)), editor(storage.dictionary) {}

void SingleTrieUserDictionaryModel::Publish(
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&& prepared,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output) {
    std::unique_ptr<SingleTrieUserDictionaryModel> candidate(new SingleTrieUserDictionaryModel(std::move(prepared)));
    output = std::move(candidate);
}

bool InitializeSingleTrieUserDictionaryModel(std::int32_t token_category,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output) {
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> prepared;
    if (!InitializeSingleTrieUserStorage(token_category, prepared.dictionary)) return false;
    if (output) prepared.metadata = output->storage.metadata;
    prepared.metadata.set_total_count(0);
    prepared.metadata.set_last_sync_time(0);
    SingleTrieUserDictionaryModel::Publish(std::move(prepared), output);
    return true;
}

std::uint64_t LoadSingleTrieUserDictionaryModel(const OwnedByteRegion& input,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output) {
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> loaded;
    const auto consumed = LoadUserDictionaryImage(input, loaded);
    if (consumed == 0) return 0;
    SingleTrieUserDictionaryModel::Publish(std::move(loaded), output);
    return consumed;
}
}  // namespace comeback::recovered
