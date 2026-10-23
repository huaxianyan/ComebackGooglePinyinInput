// Frozen signed16 / unsigned32 / bit ordering from 0x18c658 / 0x196684.
#include "key_expansion.h"
#include <cassert>
#include <iostream>
using namespace comeback::recovered;
int main() {
    const KeyToken negative{"negative", 0xffffffffu, -1, true};
    const KeyToken zero{"zero", 0u, 0, false};
    assert(KeyTokenIdentityLess(negative, zero));
    const KeyToken high_id{"high", 0xffffffffu, 0, false};
    assert(KeyTokenIdentityLess(zero, high_id));
    const KeyToken flagged{"flag", 0u, 0, true};
    assert(KeyTokenIdentityLess(zero, flagged));
    const KeyToken other_text{"different text", 0u, 0, false};
    assert(!KeyTokenIdentityLess(zero, other_text) && !KeyTokenIdentityLess(other_text, zero));
    std::cout << "expansion identities order signed auxiliary, full unsigned ID and flag passed\n";
}
