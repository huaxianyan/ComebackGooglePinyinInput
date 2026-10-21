// Native 0x1a3c9c candidate boundary with reconstructed C++ ownership; see NOTICE.
#include "single_trie_user_dictionary_model.h"
#include <utility>

namespace comeback::recovered {
SingleTrieUserDictionaryModel::SingleTrieUserDictionaryModel(
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&& loaded)
    : storage(std::move(loaded)), editor(storage.dictionary) {}

std::uint64_t LoadSingleTrieUserDictionaryModel(const OwnedByteRegion& input,
    std::unique_ptr<SingleTrieUserDictionaryModel>& output) {
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage> loaded;
    const auto consumed = LoadUserDictionaryImage(input, loaded);
    if (consumed == 0) return 0;
    std::unique_ptr<SingleTrieUserDictionaryModel> candidate(new SingleTrieUserDictionaryModel(std::move(loaded)));
    output = std::move(candidate);
    return consumed;
}
}  // namespace comeback::recovered
