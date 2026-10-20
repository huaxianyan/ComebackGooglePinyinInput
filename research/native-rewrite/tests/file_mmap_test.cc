#include "file_mmap.h"
#include "owned_byte_region.h"
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>

using namespace comeback::recovered;
namespace {
void Require(bool value, const char* action) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}
int main(int argc, char** argv) {
    Require(argc == 2, "provide a project-local synthetic mapping filename");
    {
        std::ofstream file(argv[1], std::ios::binary);
        file.write("ABC", 3);
        Require(static_cast<bool>(file), "create the three-byte synthetic file");
    }
    OwnedByteRegion mapped;
    Require(MapReadOnlyFile(argv[1], mapped) == FileMappingResult::Mapped && mapped.Size() == 3 &&
            std::memcmp(mapped.Data(), "ABC", 3) == 0,
            "map the actual file and keep its data readable after the factory returns");
    {
        std::fstream writer(argv[1], std::ios::binary | std::ios::in | std::ios::out);
        writer.seekp(1);
        writer.put('D');
        writer.flush();
        Require(static_cast<bool>(writer), "update the backing fixture through a separate actual file handle");
    }
    Require(std::memcmp(mapped.Data(), "ADC", 3) == 0,
            "MAP_SHARED observes the literal backing-file update rather than a heap read substitute");
    auto* writable = mapped.MutableData();
    Require(writable != nullptr, "obtain a writable heap copy of an unshared read-only mapping");
    writable[0] = 'X';
    Require(mapped.Resize(5) && std::memcmp(mapped.Data(), "XDC\0\0", 5) == 0,
            "mapped writes detach and growth follows the same zero-filling heap owner");
    OwnedByteRegion slice;
    {
        OwnedByteRegion parent;
        Require(MapReadOnlyFile(argv[1], parent) == FileMappingResult::Mapped,
                "map the real fixture for a surviving parent-backed slice");
        slice = parent.Slice(1, 2);
    }
    Require(slice.Size() == 2 && std::memcmp(slice.Data(), "DC", 2) == 0,
            "the slice retains the actual mapping after the parent handle leaves scope");
    writable = slice.MutableData();
    Require(writable != nullptr, "detach the retained mapped slice through the same heap COW path");
    writable[1] = 'Y';
    std::array<char, 3> file_bytes{};
    {
        std::ifstream file(argv[1], std::ios::binary);
        file.read(file_bytes.data(), file_bytes.size());
        Require(static_cast<bool>(file), "read the actual backing file after both mapped edits");
    }
    Require(std::memcmp(slice.Data(), "DY", 2) == 0 &&
            file_bytes == std::array<char, 3>{'A', 'D', 'C'},
            "mapped and slice edits keep the backing file's independent literal contents");
    Require(std::remove(argv[1]) == 0, "remove only the synthetic mapping fixture");
    std::puts("PASS: real shared mapping, retained resource ownership and readonly/parent COW");
}
