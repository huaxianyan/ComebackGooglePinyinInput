// Fixed wire/default and raw-array framing cases, not generated expectations.
#include "dictionary_string_image.h"
#include "token_expander_metadata.pb.h"
#include <cassert>
#include <cstring>
#include <iostream>
using namespace comeback::recovered;
int main() {
    using Metadata = i18n_input::engine::hmm::proto::TokenExpanderMetaData;
    Metadata defaults;
    assert(defaults.ParseFromString(""));
    assert(defaults.expansion_type() == 0 && defaults.input_kind() == 0 &&
           defaults.auxiliary_id() == 0 && !defaults.fallback());
    const char wire[] = "\x08\x03\x10\xff\xff\xff\xff\xff\xff\xff\xff\xff\x01\x18\xac\x02\x20\x01";
    Metadata parsed;
    assert(parsed.ParseFromArray(wire, sizeof(wire) - 1));
    assert(parsed.expansion_type() == 3 && parsed.input_kind() == -1 &&
           parsed.auxiliary_id() == 300 && parsed.fallback());
    const unsigned char raw[] = {3,0,0,0,0,0,0,0, 'a','b','c',0,0,0,0,0};
    OwnedByteRegion image;
    assert(image.Resize(sizeof(raw)));
    std::memcpy(image.MutableData(), raw, sizeof(raw));
    std::size_t position = 0;
    const auto bytes = LoadDictionaryArrayImage(image, position);
    assert(bytes && position == 16 && bytes->Size() == 3);
    assert(std::memcmp(bytes->Data(), "abc", 3) == 0);
    std::cout << "expander metadata defaults, signed wildcard and raw-array framing passed\n";
}
