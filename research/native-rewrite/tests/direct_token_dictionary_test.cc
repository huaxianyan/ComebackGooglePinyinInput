#include "direct_token_dictionary.h"
#include "file_mmap.h"
#include <cstdio>
#include <cstdlib>

using namespace comeback::recovered;
namespace {
void Require(bool value, const char* message) {
    if (!value) { std::fprintf(stderr, "FAIL: %s\n", message); std::exit(1); }
}
std::shared_ptr<DirectTokenDictionary> Load(const char* filename) {
    OwnedByteRegion file;
    Require(MapReadOnlyFile(filename, file) == FileMappingResult::Mapped && file.Size() >= 32,
            "the original direct-token resource is readable");
    // Original extracted class envelopes occupy 32 bytes; the native owner
    // loader also receives the payload after its creator removes the envelope.
    auto result = DirectTokenDictionary::Load(file.Slice(32, file.Size() - 32));
    Require(static_cast<bool>(result), "original metadata and packed range resources load");
    return result;
}
}
int main(int argc, char** argv) {
    if (argc != 4) {
        std::fputs("Usage: direct_token_dictionary_test EN_TOKEN_FILE PINYIN_EN_FILE SHORTCUT_FILE\n", stderr);
        return 2;
    }
    auto english = Load(argv[1]);
    auto pinyin_english = Load(argv[2]);
    auto shortcuts = Load(argv[3]);
    DirectTokenCursor first(english), second(english), pinyin(pinyin_english), shortcut(shortcuts);
    KeyToken output{"old", 123, -2, true};
    Require(first.Push(-1, 0, "A", false) && !first.NextFrame() && first.Current(output),
            "a source character is immediately readable despite native NextFrame returning false");
    Require(output.text == "a" && output.id == 0x00800061u && output.auxiliary == 0 && output.identity_bit,
            "source uses original ASCII lowercase, class ID and owner language while retaining the caller identity bit");
    first.Advance();
    Require(first.Done() && !first.Push(-1, 0, "b", false) && first.Pop(),
            "advancing the result retains its frame until Pop releases it for the next query");
    Require(first.Push(-1, 0, "Ab", false) && first.Current(output) &&
            output.text == "ab" && output.id == 0x008f0000u && first.Pop(),
            "the first real multi-character source gets the original shared dynamic ID");
    Require(second.Push(-1, 26, "\xf0\x9f\x98\x80", true) && second.Current(output) &&
            output.id == 0x0101f600u && output.auxiliary == 26 && second.Pop(),
            "a supplementary target bypasses source ranges and retains the requested unknown-language tag");
    Require(second.Push(-1, 26, "\xe4\xb8\xad\xf0\x9f\x98\x80", true) && second.Current(output) &&
            output.text == "\xe4\xb8\xad\xf0\x9f\x98\x80" && output.id == 0x010f0001u && second.Pop(),
            "a second cursor shares the real dictionary counter rather than restarting synthetic IDs");
    Require(first.Push(-1, 0, "'", false) && first.Pop() &&
            !pinyin.Push(-1, 0, "'", false) && pinyin.Push(-1, 0, "a", false) && pinyin.Pop(),
            "the actual English and pinyin-English packed ranges admit different source characters");
    Require(!shortcut.Push(4, 25, "A", false) && shortcut.Push(4, 25, "a", false) && shortcut.Current(output) &&
            output.text == "a" && output.id == 0x40800061u && output.auxiliary == 25 && shortcut.Pop(),
            "the actual shortcut resource preserves case policy, selector four and language twenty-five");
    std::puts("PASS: original direct-token resources drive real source/target queries, frame reuse and shared dynamic IDs");
}
