#!/usr/bin/env bash
# Research-only Linux/WSL build. Uses the existing compiler and protobuf tools;
# no package installation, global configuration or Android product build.
set -euo pipefail
root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root"
build="$root/work/native-rewrite/forward-token-build"
recovered="$root/research/native-rewrite/recovered"
read -r dependency commit < <(python3 - <<'PY'
import json
p = json.load(open('research/native-rewrite/dependencies/marisa.json'))
print(p['source_directory'], p['git_commit'])
PY
)
if [[ ! -d "$dependency/.git" ]]; then
    echo "Fetch the pinned source listed in research/native-rewrite/dependencies/marisa.json first." >&2
    exit 1
fi
[[ $(git -C "$dependency" rev-parse HEAD) == "$commit" ]] || {
    echo "Marisa source does not match the pinned research revision." >&2; exit 1;
}
mkdir -p "$build/marisa" "$build/objects" "$build/generated"
for source in $(find "$dependency/lib/marisa" -name '*.cc' | sort); do
    object=${source#"$dependency/lib/"}
    object=${object//\//_}
    g++ -std=c++11 -O2 -I"$dependency/include" -I"$dependency/lib" -c "$source" -o "$build/marisa/$object.o"
done
ar rcs "$build/libmarisa.a" "$build/marisa/"*.o
protoc -I"$recovered" --cpp_out="$build/generated" "$recovered/forward_token_metadata.proto"
flags=(-std=c++17 -O2 -Wall -Wextra -Werror -I"$recovered" -I"$build/generated" -I"$dependency/include")
g++ -std=c++17 -O2 -I"$build/generated" -c "$build/generated/forward_token_metadata.pb.cc" -o "$build/objects/forward_token_metadata.pb.o"
for name in owned_byte_region file_mmap dictionary_string_image flat_integer_table token_query token_manager_selection direct_token_dictionary forward_token_dictionary; do
    g++ "${flags[@]}" -c "$recovered/$name.cc" -o "$build/objects/$name.o"
done
for test in forward_token_metadata forward_token_dictionary; do
    g++ "${flags[@]}" "research/native-rewrite/tests/${test}_test.cc" "$build/objects/"*.o "$build/libmarisa.a" \
        -lprotobuf-lite -pthread -o "$build/${test}_test"
done
"$build/forward_token_metadata_test"
python3 research/native-rewrite/tests/verify_forward_token_dictionary.py \
    --manifest work/native-rewrite/forward-token-data/manifest.json \
    --executable "$build/forward_token_dictionary_test" --fixture "$build/original-resource-fixture.tsv"
