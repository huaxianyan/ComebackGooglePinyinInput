// Complete current-format UserDictionary image; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_IMAGE_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_IMAGE_H

#include "mutable_dictionary_image.h"
#include "single_trie_mutable_dictionary_image.h"
#include "user_dictionary_metadata.pb.h"

namespace comeback::recovered {
// Backend is selected by the caller's concrete model, as in the native factory.
// Supported backends: MutableDictionaryStorage, SingleTrieMutableDictionaryStorage.
// No default backend or file-content detection is supplied.
template <typename Backend>
struct UserDictionaryStorage {
    i18n_input::engine::hmm::proto::UserDictionaryMetaData metadata;
    Backend dictionary;
};

// One current header and outer protobuf protocol for both actual backends.
// Low-level graph edits do not update the separate outer frequency accumulator.
template <typename Backend>
bool WriteUserDictionaryImage(const UserDictionaryStorage<Backend>& dictionary, const DictionaryImageSink& sink);
template <typename Backend>
bool SerializeUserDictionaryImage(const UserDictionaryStorage<Backend>& dictionary, OwnedByteRegion& output);
// Native duplication serializes into a memory chunk and loads a fresh model;
// it is not a shallow storage copy. Accessor locks/readiness are a higher layer.
template <typename Backend>
bool DuplicateUserDictionary(const UserDictionaryStorage<Backend>& source, UserDictionaryStorage<Backend>& output);
// Current major only; preserves old output on failure. Returns consumed bytes,
// not necessarily full input size. Native payload/serialized-size checks apply.
template <typename Backend>
std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion& input, UserDictionaryStorage<Backend>& output);
}  // namespace comeback::recovered
#endif
