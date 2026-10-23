// One actual-resource E2E: original schemes/settings -> real Managers -> text
// fill -> collection/normalization -> selected-key admission -> real consumption.
// Selections are test-only; no replacement for the native path decoder.
#include "token_expander_manager.h"
#include "token_expansion_setting.pb.h"
#include "token_dictionary_manager.h"
#include "token_dictionary_setting.pb.h"
#include "original_token_resources.h"
#include "learning_key_result_set.h"
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
void CheckRecord(const ScoredKeyToken& record, std::uint32_t id, std::int16_t auxiliary,
                 const std::string& text, std::uint32_t score, std::uint8_t marker, bool flag = false) {
    assert(record.token.id == id && record.token.auxiliary == auxiliary && record.token.text == text &&
           record.token.identity_bit == flag && Bits(record.score) == score && record.marker == marker);
}
}  // namespace
int main(int argc, char** argv) {
    assert(argc == 3 && std::string(argv[2]) == "expander");
    const auto resources = test::OriginalTokenResources(argv[1]);
    const auto wire = test::OriginalImage(argv[1], "@expansion_setting");
    proto::TokenExpansionSetting selected;
    assert(selected.ParseFromArray(wire.Data(), wire.Size()));
    // The actual default needs InMemory. These are explicit selections of real
    // registered DirectMapping IDs, not replacement defaults or prepared results.
    selected.clear_data_id();
    const std::string pinyin = "zh_t_i0_pinyin_android_reconversion_expansion_dictionary";
    const std::string english = "zh_t_i0_pinyin_android_english_reconversion_expansion_dictionary";
    selected.add_data_id(pinyin);
    selected.add_data_id("zh_t_i0_pinyin_android_digits_reconversion_expansion_dictionary");
    selected.add_data_id(english);
    selected.add_data_id("en_t_i0_und_android_english_reconversion_expansion_dictionary");
    const auto manager = TokenExpanderManager::Load(selected.SerializeAsString(), *resources);
    assert(manager);
    auto cursor = manager->CreateCursor({3, 3});
    const auto dictionary_wire = test::OriginalImage(argv[1], "@token_setting");
    const std::string original(reinterpret_cast<const char*>(dictionary_wire.Data()), dictionary_wire.Size());
    const auto pinyin_only = TokenDictionaryManager::Load(original, *resources);
    i18n_input::engine::hmm::proto::TokenDictionaryDataSetting dictionary_setting;
    assert(dictionary_setting.ParseFromString(original));
    dictionary_setting.add_data_id("en_t_i0_und_android_token_dictionary");
    dictionary_setting.add_data_id("zh_t_i0_pinyin_android_digits_token_dictionary");
    const auto dictionaries = TokenDictionaryManager::Load(dictionary_setting.SerializeAsString(), *resources);
    assert(pinyin_only && dictionaries);

    // Manager selection is not query wildcard matching; selected-model failure
    // does not try another model. All frozen boundaries are visible at 0x1920a0.
    KeyToken token{"saved", 0x00800061u, 26, true};
    assert(!dictionaries->FillTokenText(token) && token.text == "saved");
    token = {"saved", 0x00804e2du, 0, true};
    assert(!dictionaries->FillTokenText(token) && token.text == "saved");
    // Literal ignores auxiliary and picks first same-kind nonnegative language:
    // English Direct zero clears text, while ordinary Forward zero is one NUL.
    token = {"saved", 0x01000000u, 16, true};
    assert(dictionaries->FillTokenText(token) && token.text.empty() &&
           token.id == 0x01000000u && token.auxiliary == 16 && token.identity_bit);
    token = {"saved", 0x01000000u, 26, true};
    assert(pinyin_only->FillTokenText(token) && token.text == std::string(1, '\0'));
    token = {"saved", 0x0101f600u, 26, true};
    assert(dictionaries->FillTokenText(token) && token.text == "\xf0\x9f\x98\x80");

    std::vector<ScoredKeyToken> collected;
    const KeyToken source{"唔", 0x01005514u, 16, true};
    assert(CollectTokenExpansions(*dictionaries, cursor.get(), source, -1.0f, 0xd3, collected, false));
    assert(collected.size() == 3 && cursor->Exhausted());
    // Actual full IDs and UTF-8 internal units, not guessed n/en/wu spellings.
    CheckRecord(collected[0], 0x0020e0ddu, 16, "\xee\x83\x9d", 0xc0569697u, 0xd3);
    CheckRecord(collected[1], 0x0040e055u, 16, "\xee\x81\x95", 0xc0569697u, 0xd3);
    CheckRecord(collected[2], 0x0080e16du, 16, "\xee\x85\xad", 0xbf9e1e1eu, 0xd3);
    NormalizeAndPruneExpansions(collected);
    assert(collected.size() == 1 && collected[0].token.id == 0x0080e16du &&
           collected[0].token.text == "\xee\x85\xad" && collected[0].marker == 0xd3);

    auto identity = manager->CreateCursor({4});
    const KeyToken same{"saved spelling", 0x00800061u, 0, true};
    std::vector<ScoredKeyToken> repeated;
    assert(!CollectTokenExpansions(*dictionaries, identity.get(), same, 0.0f, 0xa5, repeated, false));
    assert(repeated.size() == 1);  // False retains a text-filled singleton of the same identity.
    CheckRecord(repeated[0], 0x00800061u, 0, "a", 0, 0xa5, true);
    repeated.clear();
    assert(CollectTokenExpansions(*dictionaries, identity.get(), same, 0.0f, 0xa6, repeated, true));
    assert(CollectTokenExpansions(*dictionaries, identity.get(), same, 0.0f, 0xa7, repeated, false));
    assert(repeated.size() == 2);  // Old output counts toward the decision, not just this iteration.
    assert(!CollectTokenExpansions(*dictionaries, nullptr, same, 0.0f, 0, repeated, true));
    assert(repeated.size() == 2 && repeated[0].marker == 0xa6 && repeated[1].marker == 0xa7);

    proto::TokenExpansionSetting english_setting;
    english_setting.add_data_id(english);
    const auto english_manager = TokenExpanderManager::Load(english_setting.SerializeAsString(), *resources);
    assert(english_manager);
    auto english_cursor = english_manager->CreateCursor({3});
    std::vector<ScoredKeyToken> no_text;
    assert(CollectTokenExpansions(*pinyin_only, english_cursor.get(),
                                 {"I", 0x01000049u, 26, false}, -0.5f, 0x71, no_text, false));
    assert(no_text.size() == 1);  // Native collection ignores the text-fill miss.
    CheckRecord(no_text[0], 0x00800069u, 0, "", 0xbf000000u, 0x71);
    collected.clear();
    assert(CollectTokenExpansions(*dictionaries, cursor.get(),
                                 {"0", 0x01000030u, 300, true}, 0.0f, 0x62, collected, false));
    assert(collected.size() == 1);
    CheckRecord(collected[0], 0x08800030u, 300, "0", 0, 0x62);
    // Native 0x18def4 consumes actual appended records, not fabricated rows.
    // The two identity results follow the digit in input, but sort before it.
    assert(CollectTokenExpansions(*dictionaries, identity.get(), same, 0.0f, 0x63, collected, true));
    assert(CollectTokenExpansions(*dictionaries, identity.get(), same, 0.0f, 0x64, collected, true));
    MergeExpansionScoresByIdentity(collected);
    assert(collected.size() == 2);
    // 0 + 0 in native log-add is +ln(2), not Manager's max or normalization.
    // Native copyback leaves destination markers in place rather than moving
    // them with sorted tokens: digit's 0x62 now accompanies English's identity.
    CheckRecord(collected[0], 0x00800061u, 0, "a", 0x3f317218u, 0x62, true);
    CheckRecord(collected[1], 0x08800030u, 300, "0", 0, 0x63);
    // Real equal-score choices normalize to -ln(2). The native inline
    // exponential has an exact zero-residual cell here: scale is binary32 1/2.
    NormalizeAndPruneExpansions(repeated);
    LearningKeyResultSet result_set;
    result_set.Admit(repeated[0].score, {&repeated[0]});
    std::vector<ScoredKeyToken> choices;
    assert(CollectTokenExpansions(*dictionaries, cursor.get(),
                                 {"A", 0x01000041u, 0, true}, 0.0f, 0, choices, false));
    assert(CollectTokenExpansions(*dictionaries, cursor.get(),
                                 {"0", 0x01000030u, 300, true}, 0.0f, 0, choices, false));
    assert(choices.size() == 2);
    // Insert two IDs before the digit singleton: native result order is length
    // first, not ordinary vector lexicographic order or score/insertion order.
    result_set.Admit(0.0f, {&choices[0], &choices[1]});
    result_set.Admit(choices[1].score, {&choices[1]});
    result_set.Admit(choices[0].score, {&choices[0]});  // Same ID, different flag/score; first wins.
    choices.clear();
    repeated.clear();
    std::vector<GeneratedLearningKey> keys;
    result_set.CopyTo(keys);
    assert(keys.size() == 3);
    assert(keys[0].parts == std::vector<std::string>{"a"} &&
           Bits(keys[0].scale) == 0x3f000000u && keys[0].flag30 && keys[0].category == 0);
    assert(keys[1].parts == std::vector<std::string>{"0"} &&
           Bits(keys[1].scale) == 0x3f800000u && !keys[1].flag30 && keys[1].category == 0);
    assert(keys[2].parts == std::vector<std::string>({"a", "0"}) &&
           Bits(keys[2].scale) == 0x3f800000u && !keys[2].flag30 && keys[2].category == 0);
    std::string serialized;
    SerializeLearningKey(keys[2], true, serialized);
    assert(serialized == "a0");
    SerializeLearningKey(keys[2], false, serialized);
    assert(serialized == "0a");
    assert(ScaleLearningCount(4, keys[0].scale) == 2);
    std::cout << "original resources to admitted ID-ordered learning keys and real key consumption passed\n";
}
