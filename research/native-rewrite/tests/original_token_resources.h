// Shared actual-blob/DataScheme fixture entry, not an artificial data-ID map.
#ifndef COMEBACK_TEST_ORIGINAL_TOKEN_RESOURCES_H
#define COMEBACK_TEST_ORIGINAL_TOKEN_RESOURCES_H
#include "token_model_resources.h"
#include "file_mmap.h"
#include <fstream>
#include <stdexcept>
namespace comeback::recovered::test {
inline OwnedByteRegion OriginalImage(const char* filename, const std::string& resource) {
    std::ifstream fixture(filename);
    std::string line, path;
    while (std::getline(fixture, line)) {
        const auto first = line.find('\t');
        if (line.substr(0, first) != resource) continue;
        path = line.substr(first + 1, line.find('\t', first + 1) - first - 1);
        break;
    }
    OwnedByteRegion image;
    if (MapReadOnlyFile(path, image) != FileMappingResult::Mapped)
        throw std::runtime_error("cannot map original token resource");
    return image;
}
inline std::shared_ptr<TokenModelResources> OriginalTokenResources(const char* fixture) {
    TokenModelResources::Bundles bundles;
    std::ifstream rows(fixture);
    std::string line;
    while (std::getline(rows, line)) {
        if (line.rfind("@blob:", 0) != 0) continue;
        const auto key = line.substr(0, line.find('\t'));
        const auto slash = key.find('/');
        bundles[key.substr(6, slash - 6)].emplace(key.substr(slash + 1), OriginalImage(fixture, key));
    }
    std::vector<std::string> schemes;
    for (const auto* name : {"en_data_scheme", "data_scheme", "gesture_data_scheme"}) {
        const auto image = OriginalImage(fixture, std::string("@scheme:") + name);
        schemes.emplace_back(reinterpret_cast<const char*>(image.Data()), image.Size());
    }
    auto resources = TokenModelResources::Load(schemes, bundles);
    if (!resources) throw std::runtime_error("cannot register original built-in data schemes");
    return resources;
}
}  // namespace comeback::recovered::test
#endif
