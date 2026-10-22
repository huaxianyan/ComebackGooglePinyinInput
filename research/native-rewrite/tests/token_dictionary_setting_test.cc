#include "token_dictionary_setting.pb.h"
#include <cstdlib>
#include <iostream>
#include <string>
using namespace i18n_input::engine::hmm::proto;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
int main() {
    // Literal native tags: repeated ID #1; options #2 containing booleans #1/#2
    // and data ID #3. Explicit false retains presence through serialization.
    const std::string wire("\x0a\x01x\x12\x07\x08\x01\x10\x00\x1a\x01y", 12);
    TokenDictionaryDataSetting setting;
    Check(setting.ParseFromString(wire) && setting.data_id_size() == 1 && setting.data_id(0) == "x" &&
          setting.iterator_options_size() == 1, "token setting lost its original wire fields");
    const auto& options = setting.iterator_options(0);
    Check(options.has_field_1() && options.field_1() && options.has_field_2() && !options.field_2() &&
          options.has_data_id() && options.data_id() == "y" && setting.SerializeAsString() == wire,
          "iterator options lost native field types or explicit-false presence");
    DictionaryIteratorOptions defaults;
    Check(!defaults.has_field_1() && !defaults.field_1() && !defaults.has_field_2() && !defaults.field_2() &&
          !defaults.has_data_id() && defaults.data_id().empty(), "iterator option defaults differ from native initialization");
    std::cout << "token setting wire fields, boolean presence and native defaults passed\n";
}
