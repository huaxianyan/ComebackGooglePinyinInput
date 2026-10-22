// Shared host projection of recovered ordinary token cursors; see NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_DICTIONARY_CURSOR_H
#define COMEBACK_RECOVERED_TOKEN_DICTIONARY_CURSOR_H
#include "key_expansion.h"
#include <string>

namespace comeback::recovered {
// Not the original vtable ABI. Push/NextFrame manipulate match frames;
// Advance consumes a result. Current/Attribute may materialize a Manager cache.
// Use Attribute and Advance only while !Done(); inputs are complete valid UTF-8.
class TokenDictionaryCursor {
public:
    virtual ~TokenDictionaryCursor() = default;
    virtual bool Push(std::int32_t selector, std::int32_t language,
                      const std::string& input, bool target) = 0;
    virtual bool NextFrame() = 0;
    virtual bool Done() const = 0;
    virtual bool Current(KeyToken& output) = 0;
    virtual float Attribute() = 0;
    virtual void Advance() = 0;
    virtual bool Pop() = 0;
    virtual void Reset() = 0;
};
}  // namespace comeback::recovered
#endif
