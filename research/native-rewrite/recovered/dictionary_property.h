// Stored accessor property selection; Google-derived, see NOTICE.
#ifndef COMEBACK_RECOVERED_DICTIONARY_PROPERTY_H
#define COMEBACK_RECOVERED_DICTIONARY_PROPERTY_H

#include "dictionary_property.pb.h"
#include "user_dictionary_metadata.pb.h"

namespace comeback::recovered {
// Native 0x18bbcc selects nonempty, parseable model properties, otherwise the
// engine-derived fallback. The caller supplies that fallback explicitly;
// resource refresh, parameter 31 lookup and model locking remain higher layers.
i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto ResolveDictionaryProperty(
    const i18n_input::engine::hmm::proto::UserDictionaryMetaData& metadata,
    const i18n_input::engine::hmm::internal::proto::DictionaryPropertyProto& fallback);
}  // namespace comeback::recovered
#endif
