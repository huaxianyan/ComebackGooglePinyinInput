#include "bundle_data_scheme.pb.h"
#include <cstdlib>
#include <iostream>
#include <string>
using namespace comeback::recovered::proto;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
int main() {
    // Native tags: entry #1, library #2, version #4. Entry tags #1..#4
    // encode type=4, id="i", storage=2, blob="b", independently of the loader.
    const std::string wire("\x0a\x0a\x08\x04\x12\x01i\x18\x02\x22\x01" "b\x12\x01L\x20\x01", 17);
    BundleDataScheme scheme;
    Check(scheme.ParseFromString(wire) && scheme.data_size() == 1 && scheme.bundle_library() == "L" &&
          scheme.has_format_version() && scheme.format_version() == 1, "bundle scheme lost native wire fields");
    const auto& entry = scheme.data(0);
    Check(entry.data_type() == 4 && entry.data_id() == "i" && entry.storage_type() == 2 && entry.blob_name() == "b" &&
          scheme.SerializeAsString() == wire, "bundle data definition differs from the frozen native wire");
    BundleDataScheme absent;
    Check(!absent.has_format_version(), "absent scheme version became an explicit value");
    std::cout << "bundle registration wire fields and version presence passed\n";
}
