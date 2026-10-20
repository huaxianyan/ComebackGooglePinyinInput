// Host-only integration transport for the actual C++ persistence entry.
#include "user_dictionary_file.h"
#include <cstring>
#include <fstream>
#include <iterator>
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
    std::ifstream input(argv[2], std::ios::binary);
    if (!input.is_open()) return 2;
    const std::string bytes((std::istreambuf_iterator<char>(input)), std::istreambuf_iterator<char>());
    if (input.bad()) return 2;
    OwnedByteRegion image;
    if (!image.Resize(bytes.size())) return 2;
    if (!bytes.empty()) std::memcpy(image.MutableData(), bytes.data(), bytes.size());
    UserDictionaryStorage dictionary;
    const auto loaded = LoadUserDictionaryImage(image, dictionary);
    if (loaded == 0 || loaded != image.Size()) return validate ? 1 : 2;
    if (validate) return 0;
    return PersistUserDictionaryFile(dictionary, argv[3]) ? 0 : 1;
}
