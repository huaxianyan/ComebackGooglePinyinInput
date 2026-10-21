// Actual ordinary Forward resources, with the original serialized Marisa graph.
// This is a reader, not a replacement IME or a speculative iterator facade.
#include "forward_token_dictionary.h"
#include "dictionary_alignment.h"
#include "dictionary_string_image.h"
#include "little_endian.h"
#include "token_query.h"
#include <utility>

namespace comeback::recovered {
ForwardTokenDictionaryView::ForwardTokenDictionaryView(const OwnedByteRegion& image,
    const MetadataProto& metadata, std::vector<FlatIntegerTableView>&& tables,
    const OwnedByteRegion& prefix_scores)
    : image_(image), metadata_(metadata), tables_(std::move(tables)), prefix_scores_(prefix_scores) {}

std::shared_ptr<ForwardTokenDictionaryView> ForwardTokenDictionaryView::Load(const OwnedByteRegion& payload) {
    if (payload.Size() < 16) return nullptr;
    const auto graph_size = detail::ReadLittleEndian<std::uint64_t>(payload.Data());
    const auto value_size = detail::ReadLittleEndian<std::uint64_t>(payload.Data() + 8);
    if (value_size != 0 || graph_size > payload.Size() - 16) return nullptr;
    std::size_t position = detail::AlignDictionaryBytes(16 + graph_size);
    if (position > payload.Size()) return nullptr;
    std::string wire;
    const auto advance = LoadDictionaryStringImage(payload.Slice(position, payload.Size() - position), wire);
    if (advance == 0 || advance > payload.Size() - position) return nullptr;
    position += advance;
    MetadataProto metadata;
    if (!metadata.ParseFromString(wire) || metadata.encoding() != MetadataProto::CODEPOINT_UTF8 ||
        metadata.encoded_token_trie() || !metadata.field_10().empty()) return nullptr;
    std::vector<FlatIntegerTableView> tables;
    for (std::size_t i = 0; i < static_cast<std::size_t>(ForwardTokenColumn::Count); ++i) {
        auto table = LoadFlatIntegerTableImage(payload, position);
        if (!table) return nullptr;
        tables.push_back(std::move(*table));
    }
    if (position > payload.Size() || payload.Size() - position < 8) return nullptr;
    const auto prefix_size = detail::ReadLittleEndian<std::uint64_t>(payload.Data() + position);
    if (prefix_size > payload.Size() - position - 8 ||
        detail::AlignDictionaryBytes(8 + prefix_size) > payload.Size() - position) return nullptr;
    const auto prefix = payload.Slice(position + 8, prefix_size);
    auto result = std::shared_ptr<ForwardTokenDictionaryView>(new ForwardTokenDictionaryView(
        payload, metadata, std::move(tables), prefix));
    try {
        result->trie_.map(payload.Data() + 16, graph_size);
    } catch (const marisa::Exception&) {
        return nullptr;
    }
    const auto count = result->Table(ForwardTokenColumn::Id).Count();
    if (result->trie_.io_size() != graph_size || result->trie_.num_keys() != count) return nullptr;
    for (const auto column : {ForwardTokenColumn::Meta, ForwardTokenColumn::Code, ForwardTokenColumn::NodeId}) {
        if (result->Table(column).Count() != count) return nullptr;
    }
    const auto score_count = result->Table(ForwardTokenColumn::Score).Count();
    if (score_count != count && (metadata.scores_enabled() || score_count != 0)) return nullptr;
    return result;
}

bool ForwardTokenDictionaryView::ReadExactSource(const std::string& input, std::int32_t selector,
    std::int32_t language, KeyToken& output) const {
    if (!MatchesTokenDictionary(metadata_.selector(), metadata_.language_id(), selector, language)) return false;
    std::string query = metadata_.case_sensitive() ? std::string(input.c_str()) : input;
    if (!metadata_.case_sensitive()) LowercaseTokenBytes(query);
    marisa::Agent agent;
    agent.set_query(query.data(), query.size());
    if (!trie_.lookup(agent)) return false;
    const auto index = agent.key().id();
    output.id = Table(ForwardTokenColumn::Id).At(index);
    output.auxiliary = TokenAuxiliaryFromWord(metadata_.language_id());
    output.identity_bit = Table(ForwardTokenColumn::Meta).At(index) != query.size();
    output.text = EncodeTokenCodepoint(output.id & kTokenCodepointMask);
    return true;
}

bool ForwardTokenDictionaryView::ReadTarget(const std::string& input, std::int32_t selector,
    std::int32_t language, KeyToken& output) const {
    if (metadata_.target_uses_source()) return ReadExactSource(input, selector, language, output);
    if (!MatchesTokenDictionary(metadata_.selector(), metadata_.language_id(), selector, language)) return false;
    const std::string query(input.c_str());
    std::vector<std::string> units;
    AppendTokenQueryUnits(query, units);
    if (units.size() != 1) return false;
    const auto scalar = ReadTokenQueryScalar(units.front());
    output.id = (static_cast<std::uint32_t>(metadata_.selector()) << 28) | kTokenLiteralBit |
                (scalar & 0xfbffffffu);
    output.auxiliary = TokenAuxiliaryFromWord(language);
    output.identity_bit = false;
    output.text = EncodeTokenCodepoint(output.id & kTokenCodepointMask);
    return true;
}
}  // namespace comeback::recovered
