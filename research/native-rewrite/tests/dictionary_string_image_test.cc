// One outer-metadata edit flow through protobuf-lite and native byte framing.
#include "dictionary_string_image.h"
#include "user_dictionary_metadata.pb.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <string>

using comeback::recovered::LoadDictionaryStringImage;
using comeback::recovered::OwnedByteRegion;
using comeback::recovered::SerializeDictionaryStringImage;
using i18n_input::engine::hmm::proto::UserDictionaryMetaData;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}  // namespace

int main() {
    // LE32 length 11, count 150, last sync 42, bytes 00ff, unknown field 9=7,
    // followed by one padding byte. Literal bytes do not use production codecs.
    const std::string original(
        "\x0b\x00\x00\x00\x08\x96\x01\x10\x2a\x1a\x02\x00\xff\x48\x07\x00", 16);
    OwnedByteRegion input;
    Require(input.Resize(original.size()), "allocate input image");
    std::memcpy(input.MutableData(), original.data(), original.size());
    std::string wire;
    UserDictionaryMetaData metadata;
    Require(LoadDictionaryStringImage(input, wire) == 16 && metadata.ParseFromString(wire) &&
            metadata.total_count() == 150 && metadata.last_sync_time() == 42 &&
            metadata.extension_data() == std::string("\x00\xff", 2),
            "loading outer metadata preserves counters, sync time and arbitrary extension bytes");
    metadata.set_total_count(151);
    metadata.set_last_sync_time(4294967296LL);
    OwnedByteRegion saved;
    Require(metadata.SerializeToString(&wire) && SerializeDictionaryStringImage(wire, saved),
            "save edited metadata through official protobuf and the dictionary section writer");
    const std::string expected(
        "\x0f\x00\x00\x00\x08\x97\x01\x10\x80\x80\x80\x80\x10"
        "\x1a\x02\x00\xff\x48\x07\x00\x00\x00\x00\x00", 24);
    Require(saved.Size() == expected.size() &&
            std::memcmp(saved.Data(), expected.data(), expected.size()) == 0,
            "saved bytes retain unknown fields and use five zero padding bytes");
    // The native reader checks the prefix and body, then advances logically past
    // padding. A complete 19-byte prefix/body can therefore report 24 consumed.
    UserDictionaryMetaData reloaded;
    Require(LoadDictionaryStringImage(saved.Slice(0, 19), wire) == 24 &&
            reloaded.ParseFromString(wire) && reloaded.total_count() == 151 &&
            reloaded.last_sync_time() == 4294967296LL &&
            reloaded.extension_data() == std::string("\x00\xff", 2),
            "reload without trailing padding preserves the full 64-bit sync time");
    std::puts("PASS: outer protobuf metadata edit, aligned byte image and native logical advancement");
}
