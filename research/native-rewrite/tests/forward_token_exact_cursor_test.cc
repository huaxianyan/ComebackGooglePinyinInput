#include "forward_token_dictionary.h"
#include "dictionary_string_image.h"
#include "file_mmap.h"
#include <cstdlib>
#include <fstream>
#include <iostream>
using namespace comeback::recovered;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
int main(int argc, char** argv) {
    Check(argc == 2, "provide the original-resource TSV fixture");
    std::ifstream fixture(argv[1]);
    std::string line, path;
    while (std::getline(fixture, line)) {
        const auto first = line.find('\t');
        if (line.substr(0, first) != "pinyin_token_v_2") continue;
        path = line.substr(first + 1, line.find('\t', first + 1) - first - 1);
        break;
    }
    OwnedByteRegion image;
    Check(MapReadOnlyFile(path, image) == FileMappingResult::Mapped, "cannot map original pinyin resource");
    std::string name;
    const auto offset = LoadDictionaryStringImage(image, name);
    Check(name == "ForwardTokenDictionary", "wrong original resource envelope");
    const auto dictionary = ForwardTokenDictionaryView::Load(image.Slice(offset, image.Size() - offset));
    Check(static_cast<bool>(dictionary), "cannot load ordinary pinyin dictionary");
    ForwardTokenDictionaryView::ExactCursor cursor(dictionary);
    // Expected IDs are literal original-manifest rows, not computed by lookup.
    auto current = [&](const char* key, std::size_t id) {
        Check(cursor.HasCurrent(), "completed segmented query has no current key");
        const auto& result = cursor.Current();
        Check(std::string(result.ptr(), result.length()) == key && result.id() == id,
              "segmented query did not retain its full key and original ID");
    };
    Check(cursor.Push("<unused_") && !cursor.HasCurrent() && cursor.Depth() == 1,
          "compressed prefix did not remain available for the next segment");
    Check(cursor.Push("token>"), "cannot finish original compressed key");
    current("<unused_token>", 0);
    Check(cursor.Pop() && !cursor.HasCurrent() && cursor.Depth() == 1,
          "pop did not return to the saved prefix");
    // Frozen native Push protocol (0x1dbd58): failed input is rolled back,
    // keeps no current result, and does not add a frame.
    Check(!cursor.Push("x") && !cursor.HasCurrent() && cursor.Depth() == 1,
          "failed suffix changed the saved input frame");
    Check(cursor.Push("token>"), "cannot continue after a failed suffix");
    current("<unused_token>", 0);
    cursor.Reset();
    Check(cursor.Depth() == 0 && !cursor.HasCurrent(), "reset left a readable query frame");
    Check(cursor.Push("z") && cursor.Push("hong"), "cannot enter segmented pinyin key");
    current("zhong", 474);
    Check(cursor.Pop() && !cursor.HasCurrent(), "pop exposed an unevaluated parent result");
    Check(cursor.Push("hang"), "cannot select another branch after pop");
    current("zhang", 509);
    std::cout << "segmented original Marisa query, failed-suffix recovery and branch change passed\n";
}
