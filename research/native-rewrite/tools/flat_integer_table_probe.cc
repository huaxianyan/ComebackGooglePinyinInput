// Real read-only mapped packed-table entry point, not a dictionary mock.
#include "file_mmap.h"
#include "flat_integer_table.h"
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <limits>

using namespace comeback::recovered;
namespace {
bool Number(const char* text, std::uint64_t& value) {
    char* end;
    errno = 0;
    value = std::strtoull(text, &end, 10);
    return *text != '-' && end != text && *end == '\0' && errno == 0;
}
}
int main(int argc, char** argv) {
    if (argc != 5) {
        std::fputs("Usage: flat_integer_table_probe FILE OFFSET COUNT WIDTH\n", stderr);
        return 2;
    }
    std::uint64_t offset, count, width;
    if (!Number(argv[2], offset) || !Number(argv[3], count) || !Number(argv[4], width) ||
        count > std::numeric_limits<std::uint32_t>::max() || width > 32) {
        std::fputs("Invalid table coordinates. Supply unsigned decimal offset/count and width 0..32.\n", stderr);
        return 2;
    }
    OwnedByteRegion file;
    if (MapReadOnlyFile(argv[1], file) != FileMappingResult::Mapped) {
        std::fputs("Could not read table file. Check its path, size and read permissions.\n", stderr);
        return 1;
    }
    const std::uint64_t words = (count * width + 31) / 32;
    const std::uint64_t bytes = words * 4;
    if (offset > file.Size() || bytes > file.Size() - offset) {
        std::fputs("Declared table extends beyond the file. Check its coordinates and source file.\n", stderr);
        return 2;
    }
    const FlatIntegerTableView table(file.Slice(offset, bytes), count, width);
    for (std::uint64_t index = 0; index < table.Count(); ++index) {
        std::printf("%u\n", table.At(index));
    }
}
