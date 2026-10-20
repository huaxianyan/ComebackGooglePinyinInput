// Frozen DictionaryPropertyProto wire cases from native 0x1f35a8/0x18bbcc.
#include "dictionary_property.h"

#include <cstdio>
#include <cstdlib>
#include <string_view>

using namespace comeback::recovered;
using namespace std::literals;
using i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto;
using i18n_input::engine::hmm::proto::UserDictionaryMetaData;

namespace {
void Require(bool condition, const char* action) {
    if (!condition) { std::fprintf(stderr, "FAIL: %s\n", action); std::exit(1); }
}
}

int main() {
    DictionaryPropertyProto fallback;
    Require(fallback.flag_1() && !fallback.has_flag_1() && fallback.SerializeAsString().empty(),
            "the native default value is true while field presence remains unset");
    UserDictionaryMetaData metadata;
    const auto stored = "\x08\0\x10\x07"sv;
    metadata.set_extension_data(stored.data(), stored.size());
    auto selected = ResolveDictionaryProperty(metadata, fallback);
    Require(selected.has_flag_1() && !selected.flag_1() && selected.SerializeAsString() == stored,
            "valid stored properties override the fallback and retain the unknown field");

    const auto engine = "\x08\x01\x10\x05"sv;
    Require(fallback.ParseFromArray(engine.data(), engine.size()), "supply an explicit engine fallback");
    const auto partial = "\x08\0\x80"sv;
    metadata.set_extension_data(partial.data(), partial.size());
    selected = ResolveDictionaryProperty(metadata, fallback);
    Require(selected.has_flag_1() && selected.flag_1() && selected.SerializeAsString() == engine,
            "a truncated stored property selects the complete engine fallback");
    metadata.set_extension_data("");
    selected = ResolveDictionaryProperty(metadata, fallback);
    Require(selected.SerializeAsString() == engine,
            "empty stored properties select the supplied fallback with its unknown field");
    std::puts("PASS: stored dictionary property selection, presence and engine fallback");
}
