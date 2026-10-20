// One frozen-wire edit flow through officially generated protobuf-lite code.
#include "mutable_dictionary_metadata.pb.h"

#include <cstdio>
#include <cstdlib>
#include <string>

using i18n_input::engine::hmm::proto::MutableDictionaryMetaData;
namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}  // namespace

int main() {
    // Field 3 is absent; field 2 is explicitly zero. Unknown field 9 is retained
    // by the native parser and appended after known fields by its serializer.
    const std::string original("\x08\x06\x10\x00\x20\x01\x28\x03\x30\x02\x48\x07", 12);
    MutableDictionaryMetaData metadata;
    Require(metadata.ParseFromString(original) && metadata.forward_payload_size() == 6 &&
            metadata.has_reverse_data_size() && metadata.reverse_data_size() == 0 &&
            !metadata.has_forward_trie_omitted() && !metadata.forward_trie_omitted() &&
            metadata.key_checksum_enabled() && metadata.association_count() == 3 &&
            metadata.format_parameter() == 2,
            "loading native scalar fields distinguishes omitted values from explicit zero");
    metadata.set_forward_trie_omitted(false);
    metadata.set_association_count(4);
    std::string saved;
    const std::string edited("\x08\x06\x10\x00\x18\x00\x20\x01\x28\x04\x30\x02\x48\x07", 14);
    Require(metadata.SerializeToString(&saved) && saved == edited,
            "saving an edited association count preserves presence and unknown wire fields");
    // Native WriteInt32 uses SXTW before its varint64 writer. This checks the
    // scalar wire type, not whether a negative parameter is valid business data.
    metadata.set_format_parameter(-1);
    const std::string signed_wire(
        "\x08\x06\x10\x00\x18\x00\x20\x01\x28\x04\x30"
        "\xff\xff\xff\xff\xff\xff\xff\xff\xff\x01\x48\x07", 23);
    MutableDictionaryMetaData reloaded;
    Require(metadata.SerializeToString(&saved) && saved == signed_wire &&
            reloaded.ParseFromString(saved) && reloaded.format_parameter() == -1 &&
            reloaded.association_count() == 4,
            "signed 32-bit scalar values use the native ten-byte negative varint representation");
    std::puts("PASS: official protobuf-lite metadata edit, presence, unknown fields and signed wire values");
}
