// Stored accessor property selection; Google-derived, see NOTICE.
#include "dictionary_property.h"

namespace comeback::recovered {
i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto ResolveDictionaryProperty(
    const i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
    const i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto& fallback) {
    i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto property;
    if (!metadata.extension_data().empty() &&
        property.ParseFromString(metadata.extension_data())) {
        return property;
    }
    return fallback;
}
}  // namespace comeback::recovered
