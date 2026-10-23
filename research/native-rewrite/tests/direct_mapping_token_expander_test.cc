// One actual-resource child-cursor E2E. Fixed oracles from ARM64/static blobs;
// this does not execute the original ARM library or resolve target text.
#include "direct_mapping_token_expander.h"
#include "dictionary_string_image.h"
#include "file_mmap.h"
#include <cassert>
#include <cstring>
#include <iostream>
using namespace comeback::recovered;
namespace {
std::uint32_t Bits(float value) {
    std::uint32_t word;
    std::memcpy(&word, &value, sizeof(word));
    return word;
}
std::shared_ptr<DirectMappingTokenExpander> Load(const char* path) {
    OwnedByteRegion image;
    assert(MapReadOnlyFile(path, image) == FileMappingResult::Mapped);
    std::string name;
    const auto offset = LoadDictionaryStringImage(image, name);
    assert(name == "DirectMappingTokenExpander" && offset < image.Size());
    auto model = DirectMappingTokenExpander::Load(image.Slice(offset, image.Size() - offset));
    assert(model && model->Category() == 3);
    return model;
}
void CheckEnglish(const char* path) {
    DirectMappingTokenExpander::Cursor cursor(Load(path));
    KeyToken input{"A", 0x01000041u, 0, false};
    KeyToken output{"caller text", 7, 9, true};
    float score = 99.0f;
    assert(cursor.Reset(input) && cursor.Current(output, &score));
    assert(output.id == 0x00800061u && output.auxiliary == 0);
    // Native mapped current writes neither text nor flag; later Manager fills text.
    assert(output.text == "caller text" && output.identity_bit && Bits(score) == 0x80000000u);
    cursor.Advance();
    assert(cursor.Exhausted());
    input = {"a", 0x01000061u, 0, false};
    assert(cursor.Reset(input) && cursor.Current(output));  // Native optional score.
    assert(output.id == 0x00800061u);
    input = {"[", 0x0100005bu, 26, true};
    assert(cursor.Reset(input) && cursor.Current(output, &score));
    assert(output.text == "[" && output.id == 0x0100005bu &&
           output.auxiliary == 26 && output.identity_bit && Bits(score) == 0);
    cursor.Advance();
    assert(cursor.Exhausted());
}
}  // namespace
int main(int argc, char** argv) {
    assert(argc == 5);
    CheckEnglish(argv[1]);
    CheckEnglish(argv[2]);
    DirectMappingTokenExpander::Cursor digits(Load(argv[3]));
    KeyToken output{};
    float score = 99.0f;
    assert(digits.Reset({"0", 0x01000030u, 300, false}) && digits.Current(output, &score));
    assert(output.id == 0x08800030u && output.auxiliary == 300 && Bits(score) == 0x80000000u);
    digits.Advance();
    assert(digits.Exhausted());
    DirectMappingTokenExpander::Cursor pinyin(Load(argv[4]));
    KeyToken input{"重", 0x010091cdu, 16, false};
    assert(pinyin.Reset(input) && pinyin.Current(output, &score));
    assert(output.id == 0x0080e029u && output.auxiliary == 16 && Bits(score) == 0xbf5cdcddu);
    // 0x19d0f0 clears fallback BEFORE matching, not the previously selected range.
    auto wrong_kind = input;
    wrong_kind.id = 0x110091cdu;
    assert(!pinyin.Reset(wrong_kind) && pinyin.Current(output, &score));
    assert(output.id == 0x0080e029u && Bits(score) == 0xbf5cdcddu);
    pinyin.Advance();
    assert(pinyin.Current(output, &score));
    assert(output.id == 0x0080e1a2u && Bits(score) == 0xbf0c8c8du);
    pinyin.Advance();
    assert(pinyin.Exhausted());
    assert(pinyin.Reset({"中", 0x01004e2du, 26, false}) && pinyin.Current(output, &score));
    assert(output.id == 0x0080e1a2u && output.auxiliary == 16 && Bits(score) == 0x80000000u);
    std::cout << "four original DirectMapping resources, child cursor and binary32 scores passed\n";
}
