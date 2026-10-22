#include "forward_token_dictionary.h"
#include "direct_token_dictionary.h"
#include "token_manager_cursor.h"
#include "dictionary_string_image.h"
#include "file_mmap.h"
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <utility>
using namespace comeback::recovered;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
static OwnedByteRegion OriginalPayload(const char* filename, const char* resource, const char* kind) {
    std::ifstream fixture(filename);
    std::string line, path;
    while (std::getline(fixture, line)) {
        const auto first = line.find('\t');
        if (line.substr(0, first) != resource) continue;
        path = line.substr(first + 1, line.find('\t', first + 1) - first - 1);
        break;
    }
    OwnedByteRegion image;
    Check(MapReadOnlyFile(path, image) == FileMappingResult::Mapped, "cannot map original token resource");
    std::string name;
    const auto offset = LoadDictionaryStringImage(image, name);
    Check(name == kind, "wrong original resource envelope");
    return image.Slice(offset, image.Size() - offset);
}
static void ManagerFrames(const char* fixture, const std::shared_ptr<ForwardTokenDictionaryView>& pinyin) {
    std::vector<ManagerTokenCursor::Child> children;
    auto forward = [&](const std::shared_ptr<ForwardTokenDictionaryView>& dictionary) {
        Check(static_cast<bool>(dictionary), "cannot load original Forward child");
        children.push_back({dictionary->Metadata().selector(), dictionary->Metadata().language_id(),
                            std::make_unique<ForwardTokenDictionaryView::Cursor>(dictionary)});
    };
    auto direct = [&](const char* resource) {
        auto dictionary = DirectTokenDictionary::Load(OriginalPayload(fixture, resource, "DirectTokenDictionary"));
        Check(static_cast<bool>(dictionary), "cannot load original Direct child");
        children.push_back({dictionary->Selector(), dictionary->LanguageId(),
                            std::make_unique<DirectTokenCursor>(dictionary)});
    };
    forward(pinyin);
    direct("en_tokens");
    forward(ForwardTokenDictionaryView::Load(OriginalPayload(fixture, "tokens_shuangpin_abc", "ForwardTokenDictionary")));
    direct("pinyin_english_token_v_2");
    direct("shortcuts_tokens");
    forward(ForwardTokenDictionaryView::Load(OriginalPayload(fixture, "pinyin_digits_token_v_2", "ForwardTokenDictionary")));
    std::unique_ptr<TokenDictionaryCursor> cursor = std::make_unique<ManagerTokenCursor>(std::move(children));
    KeyToken token{"previous", 0, 0, true};
    auto consume = [&](std::uint32_t id, std::int16_t language) {
        Check(!cursor->Done() && cursor->Current(token) && token.id == id && token.auxiliary == language &&
              cursor->Attribute() == 0.0f, "Manager lost the original child order, token or attribute");
        cursor->Advance();
    };
    // Original IDs and languages are literal wire-decoder rows. The two actual
    // English resources produce equal source IDs; both must reach the cache.
    Check(cursor->Push(-1, 26, "a", false) && cursor->NextFrame() && cursor->Attribute() == 0.0f,
          "cannot materialize the original children through the attribute getter");
    consume(4251648, 16);
    consume(0x00800061, 0);
    consume(2154903, 16);
    consume(0x00800061, 0);
    consume(0x40800061, 25);
    Check(cursor->Done() && cursor->NextFrame(), "cannot reevaluate the current Manager frame");
    // Materialization consumed every child, not just the first returned token.
    // Forward Next refreshes its query; native Direct Next leaves it consumed.
    consume(4251648, 16);
    consume(2154903, 16);
    Check(cursor->Done(), "frame reevaluation reactivated consumed Direct children");
    cursor->Reset();
    Check(cursor->Push(-1, 16, "hong", false) && cursor->Push(-1, 16, "z", false) && cursor->NextFrame(),
          "cannot query nested matching frames");
    consume(8446370, 16);
    Check(cursor->Done() && cursor->Pop() && cursor->Push(-1, 16, "c", false) && cursor->NextFrame(),
          "cannot replace a popped Manager branch");
    consume(8445993, 16);
    Check(cursor->Done(), "another child leaked a failed nested query");
    cursor->Reset();
    Check(cursor->Push(-1, 26, "\xe4\xb8\xad", true) && cursor->NextFrame(), "cannot enter Manager target mode");
    consume(0x01004e2d, 26);
    consume(0x41004e2d, 26);
    Check(cursor->Done() && cursor->NextFrame() && cursor->Done(),
          "target frame Next reactivated consumed child results");
    cursor->Reset();
    Check(cursor->Push(4, 25, "a", false) && cursor->NextFrame(), "cannot query a qualified original child");
    consume(0x40800061, 25);
    Check(cursor->Done(), "qualification admitted another dictionary");
    std::cout << "original Manager child qualification, lazy cache, source order, target admission and frame reuse passed\n";
}
static void SourceFrames(const std::shared_ptr<ForwardTokenDictionaryView>& dictionary) {
    ForwardTokenDictionaryView::Cursor cursor(dictionary);
    KeyToken token{"previous", 0, 0, true};
    auto current = [&](std::uint32_t id, const char* text) {
        Check(!cursor.Done() && cursor.Current(token) && token.id == id &&
              token.text == text && token.auxiliary == 16 && !token.identity_bit && cursor.Attribute() == 0.0f,
              "Forward source frame did not produce its original token");
    };
    // Literal original-manifest token IDs and UTF-8, not computed by lookup.
    // Native Next applies Push segments from the stack top: hong, z -> zhong.
    Check(cursor.Push(-1, 16, "hong", false) && cursor.Push(-1, 16, "z", false) && cursor.NextFrame(),
          "cannot apply the pending source segments");
    current(8446370, "\xee\x86\xa2");
    cursor.Advance();
    Check(cursor.Done() && cursor.NextFrame(), "cannot refresh a consumed source frame");
    current(8446370, "\xee\x86\xa2");
    Check(cursor.Pop() && cursor.Push(-1, 16, "c", false) && cursor.NextFrame(),
          "cannot replace the top pending segment");
    current(8445993, "\xee\x80\xa9");
    cursor.Reset();
    // Frozen source Push/Next protocol: a queued unknown edge fails only when
    // applied. Pop clears the synchronization flag and permits replacement.
    Check(cursor.Push(-1, 16, "!", false) && !cursor.NextFrame(), "unknown source edge was not deferred to Next");
    Check(cursor.Pop() && cursor.Push(-1, 16, "a", false) && cursor.NextFrame(),
          "cannot recover after a failed lazy query");
    current(4251648, "\xee\x80\x80");
    std::cout << "original Forward source pending frames, lazy reconciliation and token publication passed\n";
}
static void TargetFrames(const std::shared_ptr<ForwardTokenDictionaryView>& dictionary) {
    ForwardTokenDictionaryView::Cursor cursor(dictionary);
    KeyToken token{"previous", 0, 0, true};
    auto current = [&](std::uint32_t id, const char* text, std::uint16_t language) {
        Check(!cursor.Done() && cursor.Current(token) && token.id == id && token.text == text &&
              token.auxiliary == language && !token.identity_bit && cursor.Attribute() == 0.0f,
              "Forward target frame did not retain its literal token and query language");
    };
    // Literal frozen token IDs. Native target preparation uses strlen; its
    // auxiliary word retains the query language, including wildcard 26.
    Check(cursor.Push(-1, 26, std::string("\xe4\xb8\xad\0x", 5), true) && cursor.NextFrame(),
          "cannot enter a literal CJK target frame");
    current(0x01004e2d, "\xe4\xb8\xad", 26);
    cursor.Advance();
    Check(cursor.Done() && cursor.NextFrame() && cursor.Done(),
          "target Next reactivated a consumed literal frame");
    Check(cursor.Pop() && cursor.Push(-1, 16, "a", false) && cursor.NextFrame(),
          "cannot return from target to source after Pop");
    current(4251648, "\xee\x80\x80", 16);
    cursor.Reset();
    Check(cursor.Push(-1, 16, "\xf0\x9f\x98\x80", true) && cursor.NextFrame(),
          "cannot enter a supplementary-plane target after Reset");
    current(0x0101f600, "\xf0\x9f\x98\x80", 16);
    std::cout << "original Forward literal target, consumption and source/target transitions passed\n";
}
int main(int argc, char** argv) {
    Check(argc == 2 || (argc == 3 &&
              (std::string(argv[2]) == "source" || std::string(argv[2]) == "target" || std::string(argv[2]) == "manager")),
          "provide the original-resource TSV fixture and optional source, target or manager case");
    const auto dictionary = ForwardTokenDictionaryView::Load(OriginalPayload(argv[1], "pinyin_token_v_2", "ForwardTokenDictionary"));
    Check(static_cast<bool>(dictionary), "cannot load ordinary pinyin dictionary");
    if (argc == 3) {
        if (std::string(argv[2]) == "source") SourceFrames(dictionary);
        else if (std::string(argv[2]) == "target") TargetFrames(dictionary);
        else ManagerFrames(argv[1], dictionary);
        return 0;
    }
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
