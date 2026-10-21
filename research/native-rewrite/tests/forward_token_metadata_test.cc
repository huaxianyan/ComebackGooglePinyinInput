#include "forward_token_metadata.pb.h"
#include "token_query.h"
#include <cstdlib>
#include <iostream>
using i18n_input::engine::hmm::proto::ForwardTokenDictionaryMetaData;
using namespace comeback::recovered;
static void Check(bool value, const char* message) {
    if (!value) { std::cerr << message << '\n'; std::exit(1); }
}
int main() {
    ForwardTokenDictionaryMetaData metadata;
    Check(metadata.ParseFromString(""), "empty native metadata did not parse");
    Check(metadata.selector() == 0 && metadata.language_id() == 0 && metadata.encoding() == 0 &&
          metadata.case_sensitive() && !metadata.has_case_sensitive() && !metadata.scores_enabled() &&
          !metadata.target_uses_source() && !metadata.encoded_token_trie() && !metadata.length_penalty(),
          "native metadata absent/default distinction changed");
    const std::string wire("\x08\x03\x20\x10\x28\x01\x30\x01\x38\x00\x40\x01\x48\x00\x58\x01", 16);
    Check(metadata.ParseFromString(wire), "native metadata flags did not parse");
    Check(metadata.selector() == 3 && metadata.language_id() == 16 && metadata.scores_enabled() &&
          metadata.encoding() == 1 && metadata.has_case_sensitive() && !metadata.case_sensitive() &&
          metadata.target_uses_source() && !metadata.encoded_token_trie() && metadata.has_encoded_token_trie() &&
          metadata.length_penalty() && metadata.SerializeAsString() == wire,
          "native metadata explicit values did not round trip");
    Check(EncodeTokenCodepoint(0) == std::string(1, '\0') && EncodeTokenCodepoint(0x41) == "A" &&
          EncodeTokenCodepoint(0xe9) == "\xc3\xa9" && EncodeTokenCodepoint(0xe000) == "\xee\x80\x80" &&
          EncodeTokenCodepoint(0x1f600) == "\xf0\x9f\x98\x80",
          "native scalar text differs from literal UTF-8 bytes");
    std::cout << "native metadata presence and scalar text passed\n";
}
