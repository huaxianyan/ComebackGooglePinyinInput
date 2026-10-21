// Native JNI 0x112768 / accessor 0x189924 / FileStoragePersister, see NOTICE.
#include "user_dictionary_file.h"
#include "file_mmap.h"

#include <cstdio>
#include <memory>
#include <utility>

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

template <typename Backend>
DictionaryFileLoadResult LoadUserDictionaryFile(const std::string& path, UserDictionaryStorage<Backend>& output) {
    OwnedByteRegion mapped;
    const auto mapping = MapReadOnlyFile(path, mapped);
    if (mapping == FileMappingResult::EmptyFile) return DictionaryFileLoadResult::InvalidImage;
    if (mapping != FileMappingResult::Mapped) return DictionaryFileLoadResult::MappingFailed;
    UserDictionaryStorage<Backend> loaded;
    const auto consumed = LoadUserDictionaryImage(mapped, loaded);
    if (consumed == 0 || consumed != mapped.Size()) return DictionaryFileLoadResult::InvalidImage;
    output = std::move(loaded);
    return DictionaryFileLoadResult::Loaded;
}

template <typename Backend>
bool PersistUserDictionaryFile(const UserDictionaryStorage<Backend>& dictionary, const std::string& path) {
    const std::unique_ptr<std::FILE, CloseFile> file(std::fopen(path.c_str(), "wb"));
    if (!file) return false;
    return WriteUserDictionaryImage(dictionary, [&](const std::uint8_t* data, std::size_t size) {
        return std::fwrite(data, 1, size, file.get()) == size;
    });
}
template DictionaryFileLoadResult LoadUserDictionaryFile(const std::string&,
    UserDictionaryStorage<MutableDictionaryStorage>&);
template DictionaryFileLoadResult LoadUserDictionaryFile(const std::string&,
    UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&);
template bool PersistUserDictionaryFile(const UserDictionaryStorage<MutableDictionaryStorage>&, const std::string&);
template bool PersistUserDictionaryFile(const UserDictionaryStorage<SingleTrieMutableDictionaryStorage>&,
                                        const std::string&);
}  // namespace comeback::recovered
