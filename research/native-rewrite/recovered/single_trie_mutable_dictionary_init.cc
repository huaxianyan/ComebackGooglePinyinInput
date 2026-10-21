// Native 0x1a259c + 0x1a6dfc empty-data path; Google-derived, see NOTICE.
#include "single_trie_mutable_dictionary_init.h"
#include "association_records.h"
#include "datrie_view.h"
#include "index_pool.h"
#include "payload_codec.h"
#include <string>
#include <utility>

namespace comeback::recovered {
bool InitializeSingleTrieUserStorage(std::int32_t token_category,
                                     SingleTrieMutableDictionaryStorage& output) {
    SingleTrieMutableDictionaryStorage initialized;
    initialized.metadata.set_forward_payload_size(kPayloadSize);
    initialized.metadata.set_reverse_data_size(0);
    initialized.metadata.set_forward_trie_omitted(false);
    initialized.metadata.set_key_checksum_enabled(true);
    initialized.metadata.set_format_parameter(token_category);
    std::string alphabet;
    for (unsigned int byte = 1; byte < 256; ++byte) alphabet.push_back(static_cast<char>(byte));
    initialized.trie.values = FixedPhraseTable(kSingleTrieValueSize);
    initialized.phrases = FixedPhraseTable(
        kPayloadSize + AssociationRecordHeaderSize(AssociationRecordLayout::KeyPair));
    if (!InitializeDATrie(initialized.trie.metadata, initialized.trie.nodes, alphabet, 0) ||
        !initialized.trie.values.Initialize() ||
        !InitializeIndexPool(initialized.range_metadata, initialized.range_cells) ||
        !initialized.phrases.Initialize()) return false;
    output = std::move(initialized);
    return true;
}
}  // namespace comeback::recovered
