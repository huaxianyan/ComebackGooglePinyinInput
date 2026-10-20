// Complete current-format UserDictionary image; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_USER_DICTIONARY_IMAGE_H
#define COMEBACK_RECOVERED_USER_DICTIONARY_IMAGE_H

#include "mutable_dictionary_image.h"
#include "user_dictionary_metadata.pb.h"

namespace comeback::recovered {
struct UserDictionaryStorage {
    i18n_input::engine::hmm::proto::UserDictionaryMetaData metadata;
    MutableDictionaryStorage dictionary;
};

// Native current header, outer protobuf section, then aligned mutable dictionary.
// Low-level graph edits do not update the separate outer frequency accumulator.
bool WriteUserDictionaryImage(const UserDictionaryStorage& dictionary, const DictionaryImageSink& sink);
bool SerializeUserDictionaryImage(const UserDictionaryStorage& dictionary, OwnedByteRegion& output);
// Native duplication serializes into a memory chunk and loads a fresh model;
// it is not a shallow storage copy. Accessor locks/readiness are a higher layer.
bool DuplicateUserDictionary(const UserDictionaryStorage& source, UserDictionaryStorage& output);
// Current major only; preserves old output on failure. Returns consumed bytes,
// not necessarily the full input size, as in the native chunk-loading entry.
// The native six-byte payload and header-aware serialized-size checks apply.
std::uint64_t LoadUserDictionaryImage(const OwnedByteRegion& input, UserDictionaryStorage& output);
}  // namespace comeback::recovered
#endif
