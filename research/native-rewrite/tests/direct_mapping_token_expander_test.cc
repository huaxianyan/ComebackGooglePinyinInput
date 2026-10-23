// Upgrade the actual-resource E2E to the original setting -> cache -> Manager
// path. Explicit DirectMapping selections below are NOT product defaults.
#include "token_expander_manager.h"
#include "token_expansion_setting.pb.h"
#include "original_token_resources.h"
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
void Consume(TokenExpanderCursor& cursor, std::uint32_t id, std::int16_t auxiliary,
             std::uint32_t score_word, const std::string& text = "", bool flag = false) {
    KeyToken output{"previous", 99, 99, true};
    float score = 99.0f;
    assert(cursor.Current(output, &score));
    assert(output.id == id && output.auxiliary == auxiliary && output.text == text &&
           output.identity_bit == flag && Bits(score) == score_word);
    cursor.Advance();
}
}  // namespace
int main(int argc, char** argv) {
    assert(argc == 3 && std::string(argv[2]) == "expander");
    const auto resources = test::OriginalTokenResources(argv[1]);
    const auto wire = test::OriginalImage(argv[1], "@expansion_setting");
    proto::TokenExpansionSetting selected;
    assert(selected.ParseFromArray(wire.Data(), wire.Size()));
    assert(selected.data_id_size() == 1 && selected.data_id(0) ==
           "zh_t_i0_pinyin_android_default_fuzzy_expansion_dictionary");
    // The actual default needs the unsupported InMemory backend. Select the
    // four actual DirectMapping IDs for this supported host profile instead.
    selected.clear_data_id();
    const std::string pinyin = "zh_t_i0_pinyin_android_reconversion_expansion_dictionary";
    const std::string english = "zh_t_i0_pinyin_android_english_reconversion_expansion_dictionary";
    selected.add_data_id(pinyin);
    selected.add_data_id("zh_t_i0_pinyin_android_digits_reconversion_expansion_dictionary");
    selected.add_data_id(english);
    selected.add_data_id("en_t_i0_und_android_english_reconversion_expansion_dictionary");
    // Original registration logs/skips a missing ID, retaining valid models.
    selected.add_data_id("missing-research-token-expander");
    const auto manager = TokenExpanderManager::Load(selected.SerializeAsString(), *resources);
    assert(manager);
    auto cursor = manager->CreateCursor({3, 3});
    assert(cursor->Reset({"唔", 0x01005514u, 16, true}));
    // Array order was en/n/wu; native ordered identities produce n/en/wu.
    // Later accepted fallbacks carry the already nonzero scores forward.
    Consume(*cursor, 0x0020e0ddu, 16, 0xc0169697u);
    Consume(*cursor, 0x0040e055u, 16, 0xc0169697u);
    Consume(*cursor, 0x0080e16du, 16, 0xbe70f0f2u);
    assert(cursor->Exhausted());
    assert(cursor->Reset({"I", 0x01000049u, 26, true}));
    Consume(*cursor, 0x0020e201u, 16, 0);  // First pinyin stage changes the next stage's input.
    assert(cursor->Exhausted());
    proto::TokenExpansionSetting reversed;
    reversed.add_data_id(english);
    reversed.add_data_id(pinyin);
    const auto english_first = TokenExpanderManager::Load(reversed.SerializeAsString(), *resources);
    assert(english_first);
    auto reordered = english_first->CreateCursor({3});
    assert(reordered->Reset({"I", 0x01000049u, 26, true}));
    Consume(*reordered, 0x00800069u, 0, 0);
    assert(reordered->Exhausted());  // Not a union of both children on the original I.
    assert(cursor->Reset({"A", 0x01000041u, 0, true}));
    Consume(*cursor, 0x00800061u, 0, 0);
    assert(cursor->Exhausted());
    assert(cursor->Reset({"0", 0x01000030u, 300, true}));
    Consume(*cursor, 0x08800030u, 300, 0);
    assert(cursor->Exhausted());
    // Reset after a partially consumed range clears the old Manager results.
    assert(cursor->Reset({"唔", 0x01005514u, 16, false}));
    cursor->Advance();
    assert(cursor->Reset({"kind one", 0x11000049u, 26, true}));
    Consume(*cursor, 0x11000049u, 26, 0, "kind one", true);
    assert(cursor->Exhausted());
    auto no_category = manager->CreateCursor({4});
    assert(no_category->Reset({"original", 0x01000049u, -1, true}));
    KeyToken output;
    assert(no_category->Current(output));  // Optional score on the real Manager.
    Consume(*no_category, 0x01000049u, -1, 0, "original", true);
    assert(no_category->Exhausted());
    std::cout << "original schemes, four DirectMapping IDs, ordered Manager stages and scores passed\n";
}
