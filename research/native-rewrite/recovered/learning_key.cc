// Native token-string key encoding and accessor count scaling; see NOTICE.
#include "learning_key.h"
#include <limits>

namespace comeback::recovered {
void SerializeLearningKey(const GeneratedLearningKey& key, bool in_token_order, std::string& output) {
    output.clear();
    if (in_token_order) {
        for (const auto& part : key.parts) output.append(part);
    } else {
        for (auto part = key.parts.rbegin(); part != key.parts.rend(); ++part) output.append(*part);
    }
}

std::int32_t ScaleLearningCount(std::int32_t count, float scale) {
    static_assert(sizeof(float) == 4 && std::numeric_limits<float>::is_iec559,
                  "native learning scaling requires IEEE binary32");
    const float scaled = static_cast<float>(count) * scale;
    if (!(scaled >= 1.0f)) return 1;
    if (scaled >= 0x1p31f) return std::numeric_limits<std::int32_t>::max();
    return static_cast<std::int32_t>(scaled);
}
}  // namespace comeback::recovered
