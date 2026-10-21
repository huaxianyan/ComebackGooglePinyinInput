// Native generated-key consumer fields and arithmetic; see NOTICE.
#ifndef COMEBACK_RECOVERED_LEARNING_KEY_H
#define COMEBACK_RECOVERED_LEARNING_KEY_H
#include <cstdint>
#include <string>
#include <vector>

namespace comeback::recovered {
// Consumed projection of a native 0x40-byte key result, not its ABI layout or
// a substitute generator. Parts retain the token strings; unused token identity
// and the other native vector are not reconstructed here. Supply all fields.
struct GeneratedLearningKey {
    std::vector<std::string> parts;
    float scale;
    bool flag30;
    std::int32_t category;
};

// Native 0x194e9c/0x194e14: clear and concatenate complete token strings, in
// source order for a nonzero mode or reversed token order for zero. No separator
// or escaping. Output must not alias an input part. Embedded bytes are retained.
void SerializeLearningKey(const GeneratedLearningKey& key, bool in_token_order, std::string& output);

// Native SCVTF -> binary32 FMUL -> signed FCVTZS -> minimum one. Saturation
// and NaN follow ARM64 FCVTZS, avoiding C++ out-of-range float-to-int UB.
// Normal FP rounding mode; no fast-math. Does not reproduce FP exception flags.
std::int32_t ScaleLearningCount(std::int32_t count, float scale);
}  // namespace comeback::recovered
#endif
