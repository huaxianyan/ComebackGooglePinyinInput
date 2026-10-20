// Native JNI 0x112768 / accessor 0x189924 / FileStoragePersister, see NOTICE.
#include "user_dictionary_file.h"

#include <cstdio>
#include <memory>

namespace comeback::recovered {
namespace {
struct CloseFile {
    void operator()(std::FILE* file) const {
        // Native 0x1fa39c destructor: fflush then fclose, ignoring both results.
        std::fflush(file);
        std::fclose(file);
    }
};
}  // namespace

bool PersistUserDictionaryFile(const UserDictionaryStorage& dictionary, const std::string& path) {
    const std::unique_ptr<std::FILE, CloseFile> file(std::fopen(path.c_str(), "wb"));
    if (!file) return false;
    return WriteUserDictionaryImage(dictionary, [&](const std::uint8_t* data, std::size_t size) {
        return std::fwrite(data, 1, size, file.get()) == size;
    });
}
}  // namespace comeback::recovered
