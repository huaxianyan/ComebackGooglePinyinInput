// Host-only integration transport for the actual C++ persistence entry.
#include "user_dictionary_file.h"
#include <string>

using namespace comeback::recovered;
int main(int argc, char** argv) {
    if (argc == 3 && std::string(argv[1]) == "uninitialized") {
        // Explicit invalid-model input: exercise actual serialization failure,
        // never replace the backend with a fake boolean or a placeholder file.
        UserDictionaryStorage empty;
        return PersistUserDictionaryFile(empty, argv[2]) ? 0 : 1;
    }
    const bool validate = argc == 3 && std::string(argv[1]) == "validate";
    if (!validate && (argc != 4 || std::string(argv[1]) != "persist")) return 2;
    UserDictionaryStorage dictionary;
    const auto loaded = LoadUserDictionaryFile(argv[2], dictionary);
    if (loaded == DictionaryFileLoadResult::MappingFailed) return 2;
    if (loaded != DictionaryFileLoadResult::Loaded) return validate ? 1 : 2;
    if (validate) return 0;
    // Use the real duplication path so a wb destination cannot truncate a live
    // mapped source, including when the transport receives the same pathname.
    UserDictionaryStorage snapshot;
    if (!DuplicateUserDictionary(dictionary, snapshot)) return 2;
    dictionary = {};
    return PersistUserDictionaryFile(snapshot, argv[3]) ? 0 : 1;
}
