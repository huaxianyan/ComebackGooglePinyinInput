// Real expansion cursor protocol, semantic fields rather than ARM ABI; NOTICE.
#ifndef COMEBACK_RECOVERED_TOKEN_EXPANDER_CURSOR_H
#define COMEBACK_RECOVERED_TOKEN_EXPANDER_CURSOR_H
#include "key_expansion.h"
namespace comeback::recovered {
class TokenExpanderCursor {
public:
    virtual ~TokenExpanderCursor() = default;
    virtual bool Reset(const KeyToken& input) = 0;
    // Actual supported callers supply a token; native Manager's nullable token
    // output extension is not projected. Score is optional for both real classes.
    virtual bool Current(KeyToken& output, float* score = nullptr) const = 0;
    virtual void Advance() = 0;
    virtual bool Exhausted() const = 0;
};
}  // namespace comeback::recovered
#endif
