#include "forward_token_dictionary.h"
#include "dictionary_string_image.h"
#include "file_mmap.h"
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_map>
using namespace comeback::recovered;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
int main(int argc, char** argv) {
    Check(argc == 2, "provide the original-resource TSV fixture");
    std::ifstream fixture(argv[1]);
    Check(fixture.good(), "cannot open original-resource fixture");
    std::unordered_map<std::string, std::shared_ptr<ForwardTokenDictionaryView>> dictionaries;
    std::string line;
    std::size_t keys = 0;
    while (std::getline(fixture, line)) {
        std::vector<std::string> fields;
        std::istringstream stream(line);
        std::string field;
        while (std::getline(stream, field, '\t')) fields.push_back(field);
        Check(fields.size() == 12, "invalid resource-fixture row");
        const auto selector = std::stoi(fields[2]);
        const auto language = std::stoi(fields[3]);
        const auto index = std::stoul(fields[5]);
        auto& dictionary = dictionaries[fields[0]];
        const bool first = !dictionary;
        if (first) {
            OwnedByteRegion image;
            Check(MapReadOnlyFile(fields[1], image) == FileMappingResult::Mapped, "cannot map original resource");
            std::string class_name;
            const auto offset = LoadDictionaryStringImage(image, class_name);
            Check(class_name == "ForwardTokenDictionary" && offset <= image.Size(), "wrong resource envelope");
            dictionary = ForwardTokenDictionaryView::Load(image.Slice(offset, image.Size() - offset));
            Check(static_cast<bool>(dictionary), "ordinary original Forward resource did not load");
            Check(dictionary->Metadata().selector() == selector && dictionary->Metadata().language_id() == language &&
                  dictionary->PrefixScores().Size() == std::stoul(fields[4]), "resource metadata or prefix extent changed");
            // Column binding is new here; old flat integer arithmetic was already
            // checked separately. One physical row per resource checks the roles.
            const auto& scores = dictionary->Table(ForwardTokenColumn::Score);
            Check(fields[8] == "-" ? scores.Count() == 0 : scores.At(index) == std::stoul(fields[8]),
                  "native score column shifted across an empty header");
            Check(dictionary->Table(ForwardTokenColumn::Meta).At(index) == std::stoul(fields[9]) &&
                  dictionary->Table(ForwardTokenColumn::Code).At(index) == std::stoul(fields[10]) &&
                  dictionary->Table(ForwardTokenColumn::NodeId).At(index) == std::stoul(fields[11]),
                  "native meta/code/node column binding changed");
        }
        KeyToken token{"previous", 0, 0, true};
        Check(dictionary->ReadExactSource(fields[6], selector, language, token) &&
              token.id == std::stoul(fields[7]), "original Marisa key did not resolve its stored token ID");
        if (first) Check(token.auxiliary == language, "source token did not retain the dictionary language");
        ++keys;
    }
    Check(dictionaries.size() == 8 && keys != 0, "fixture did not cover the eight original ordinary resources");
    const auto pinyin = dictionaries.at("pinyin_token_v_2");
    KeyToken token{"previous", 0, 0, true};
    Check(pinyin->ReadExactSource("a", -1, 16, token) && token.text == "\xee\x80\x80" && !token.identity_bit,
          "pinyin source did not fill native code-point text and length identity");
    Check(pinyin->ReadExactSource(std::string("a\0b", 3), -1, 16, token) && token.text == "\xee\x80\x80",
          "case-sensitive source did not retain the native C-string copy");
    const auto microsoft = dictionaries.at("tokens_shuangpin_ms");
    Check(microsoft->ReadExactSource("jt", -1, 16, token) && token.text == "\xee\x82\x98" &&
          microsoft->ReadExactSource("jv", -1, 16, token) && token.text == "\xee\x82\x98",
          "double-pinyin aliases did not fill their shared native text");
    const auto digits = dictionaries.at("pinyin_digits_token_v_2");
    Check(digits->ReadExactSource("0", -1, 300, token) && token.text == "0" && !token.identity_bit,
          "digit source used the old shifted metadata column");
    Check(pinyin->ReadTarget("\xf0\x9f\x98\x80", -1, 26, token) && token.id == 0x0101f600u &&
          token.auxiliary == 26 && !token.identity_bit,
          "literal Forward target did not keep its code point and requested language");
    std::cout << "original Forward resources=" << dictionaries.size() << " exact source keys=" << keys << '\n';
}
