#include "forward_token_dictionary.h"
#include "token_dictionary_manager.h"
#include "token_query.h"
#include "token_dictionary_setting.pb.h"
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
static OwnedByteRegion OriginalImage(const char* filename, const std::string& resource) {
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
    return image;
}
static void ManagerFrames(const char* fixture) {
    TokenDictionaryResources::Bundles bundles;
    std::ifstream rows(fixture);
    std::string line;
    while (std::getline(rows, line)) {
        if (line.rfind("@blob:", 0) != 0) continue;
        const auto key = line.substr(0, line.find('\t'));
        const auto slash = key.find('/');
        bundles[key.substr(6, slash - 6)].emplace(key.substr(slash + 1), OriginalImage(fixture, key));
    }
    std::vector<std::string> schemes;
    for (const auto* name : {"en_data_scheme", "data_scheme", "gesture_data_scheme"}) {
        const auto image = OriginalImage(fixture, std::string("@scheme:") + name);
        schemes.emplace_back(reinterpret_cast<const char*>(image.Data()), image.Size());
    }
    const auto resources = TokenDictionaryResources::Load(schemes, bundles);
    Check(static_cast<bool>(resources), "cannot register the original three built-in data schemes");
    const auto original = OriginalImage(fixture, "@token_setting");
    i18n_input::engine::hmm::proto::TokenDictionaryDataSetting setting;
    Check(setting.ParseFromArray(original.Data(), original.Size()) && setting.data_id_size() == 1 &&
          setting.data_id(0) == "zh_t_i0_pinyin_android_token_dictionary", "wrong original token setting slice");
    // Explicit test selections, not a claim about the app's preference defaults.
    // Actual IDs are registered by C++ from original data scheme bytes, not
    // decoded Python fixture records or a caller-made data-ID mapping.
    setting.add_data_id("shortcuts_token_dictionary");
    setting.add_data_id("en_t_i0_und_android_token_dictionary");
    setting.add_data_id("zh_t_i0_shuangpin_abc_android_token_dictionary");
    setting.add_data_id("zh_t_i0_pinyin_android_digits_token_dictionary");
    setting.add_data_id("zh_t_i0_pinyin_android_english_token_dictionary");
    // Frozen 0x1948d0 protocol: an absent ID does not discard valid selections.
    setting.add_data_id("missing-research-token-dictionary");
    const auto wire = setting.SerializeAsString();
    const auto manager = TokenDictionaryManager::Load(wire, *resources);
    Check(static_cast<bool>(manager), "cannot activate original registered dictionary IDs");
    auto cursor = manager->CreateDfsCursor();
    KeyToken token{"previous", 0, 0, true};
    auto consume = [&](std::uint32_t id, std::int16_t language) {
        Check(!cursor->Done() && cursor->Current(token) && token.id == id && token.auxiliary == language &&
              cursor->Attribute() == 0.0f, "Manager lost the original child order, token or attribute");
        cursor->Advance();
    };
    // Original IDs/languages are literal rows. Native pair order is English,
    // pinyin, digits, shortcuts, not the setting-list order or resource names.
    Check(cursor->Push(-1, 26, "a", false) && cursor->NextFrame() && cursor->Attribute() == 0.0f,
          "cannot materialize the original children through the attribute getter");
    consume(0x00800061, 0);
    consume(4251648, 16);
    consume(0x40800061, 25);
    Check(cursor->Done() && cursor->NextFrame(), "cannot reevaluate the current Manager frame");
    // Materialization consumed every child, not just the first returned token.
    // Forward Next refreshes its query; native Direct Next leaves it consumed.
    consume(4251648, 16);
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
    cursor->Reset();
    Check(LookupTokenQuery(cursor.get(), "a", false, 26, true, &token) && token.id == 0x00800061 &&
          token.auxiliary == 0, "ordinary source helper lost native Manager order");
    Check(LookupTokenQuery(cursor.get(), "gnohz", true, 16, true, &token) && token.id == 8446370 &&
          token.text == "\xee\x86\xa2", "reversed source lookup did not use the original pinyin graph");
    // Frozen 0x195a68 miss path: preserve output, Reset, then allow another query.
    Check(!LookupTokenQuery(cursor.get(), "!", false, 16, true, &token) && token.id == 8446370 &&
          token.text == "\xee\x86\xa2", "missing source query overwrote the previous token");
    Check(LookupTokenQuery(cursor.get(), "\xe4\xb8\xad", true, 26, false, &token) &&
          token.id == 0x01004e2d && token.auxiliary == 26, "target helper lost Unicode reversal or query language");
    // Native optional-output lookup still Pushes: Direct allocates its dynamic
    // ID while encoding, even without Current. Later IDs retain that mutation.
    Check(LookupTokenQuery(cursor.get(), "Ab", false, 0, true, nullptr), "presence-only source lookup failed");
    Check(cursor->Push(0, 0, "'", false) && cursor->NextFrame(), "the first English model was replaced by its same-key successor");
    consume(0x00800027, 0);
    cursor->Reset();
    Check(cursor->Push(0, 0, "Ab", false) && cursor->NextFrame(), "cannot query a multi-character source");
    consume(0x008f0001, 0);
    const auto reloaded = TokenDictionaryManager::Load(wire, *resources);
    Check(static_cast<bool>(reloaded), "cannot resolve the same setting through the resource cache");
    auto second = reloaded->CreateDfsCursor();
    Check(second->Push(0, 0, "Cd", false) && second->NextFrame() && second->Current(token) && token.id == 0x008f0002,
          "ID-cache reuse lost the model counter across Managers");
    const auto empty = TokenDictionaryManager::Load("", *resources);
    Check(static_cast<bool>(empty), "cannot activate the native empty dictionary set");
    auto empty_cursor = empty->CreateDfsCursor();
    Check(static_cast<bool>(empty_cursor) && empty_cursor->Done(), "empty DFS factory did not retain its real Manager object");
    std::cout << "original bundle-to-Manager lookup, prepared source/target, miss recovery and optional output passed\n";
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
    if (argc == 3 && std::string(argv[2]) == "manager") { ManagerFrames(argv[1]); return 0; }
    const auto image = OriginalImage(argv[1], "pinyin_token_v_2");
    std::string kind;
    const auto offset = LoadDictionaryStringImage(image, kind);
    Check(kind == "ForwardTokenDictionary", "wrong original Forward resource envelope");
    const auto dictionary = ForwardTokenDictionaryView::Load(image.Slice(offset, image.Size() - offset));
    Check(static_cast<bool>(dictionary), "cannot load ordinary pinyin dictionary");
    if (argc == 3) {
        if (std::string(argv[2]) == "source") SourceFrames(dictionary);
        else TargetFrames(dictionary);
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
