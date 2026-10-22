#!/usr/bin/env bash
# Research-only Linux/WSL build. Uses the existing compiler and protobuf tools;
# no package installation, global configuration or Android product build.
set -euo pipefail
root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root"
build="$root/work/native-rewrite/forward-token-build"
recovered="$root/research/native-rewrite/recovered"
scope=${1:-all}
case "$scope" in all|queries|source|cursor|manager) ;; *) echo "Expected all, queries, source, cursor or manager" >&2; exit 1 ;; esac
read -r dependency commit research_patch < <(python3 - <<'PY'
import json
p = json.load(open('research/native-rewrite/dependencies/marisa.json'))
print(p['source_directory'], p['git_commit'], p['research_patch'])
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
source_root="$build/marisa-source"
rm -rf "$source_root"
mkdir -p "$source_root"
git -C "$dependency" archive "$commit" | tar -x -C "$source_root"
git apply --unsafe-paths --directory="$source_root" "$research_patch"
for source in $(find "$source_root/lib/marisa" -name '*.cc' | sort); do
    object=${source#"$source_root/lib/"}
    object=${object//\//_}
    g++ -std=c++11 -O2 -I"$source_root/include" -I"$source_root/lib" -c "$source" -o "$build/marisa/$object.o"
done
ar rcs "$build/libmarisa.a" "$build/marisa/"*.o
protoc -I"$recovered" --cpp_out="$build/generated" "$recovered/forward_token_metadata.proto"
flags=(-std=c++17 -O2 -Wall -Wextra -Werror -I"$recovered" -I"$build/generated" -I"$source_root/include" -I"$source_root/lib")
g++ -std=c++17 -O2 -I"$build/generated" -c "$build/generated/forward_token_metadata.pb.cc" -o "$build/objects/forward_token_metadata.pb.o"
for name in owned_byte_region file_mmap dictionary_string_image flat_integer_table token_query token_manager_selection token_manager_cursor direct_token_dictionary forward_token_dictionary forward_token_exact_cursor forward_token_cursor; do
    g++ "${flags[@]}" -c "$recovered/$name.cc" -o "$build/objects/$name.o"
done
tests=(forward_token_dictionary forward_token_exact_cursor)
if [[ "$scope" == source || "$scope" == cursor || "$scope" == manager ]]; then tests=(forward_token_exact_cursor); fi
if [[ "$scope" == all ]]; then tests+=(forward_token_metadata); fi
for test in "${tests[@]}"; do
    g++ "${flags[@]}" "research/native-rewrite/tests/${test}_test.cc" "$build/objects/"*.o "$build/libmarisa.a" \
        -lprotobuf-lite -pthread -o "$build/${test}_test"
done
if [[ "$scope" == all ]]; then "$build/forward_token_metadata_test"; fi
if [[ "$scope" == manager ]]; then
    python3 research/native-rewrite/tests/verify_forward_token_dictionary.py \
        --manifest work/native-rewrite/forward-token-data/manifest.json \
        --executable "$build/forward_token_exact_cursor_test" --fixture "$build/original-resource-fixture.tsv" --case manager
elif [[ "$scope" == source || "$scope" == cursor ]]; then
    python3 research/native-rewrite/tests/verify_forward_token_dictionary.py \
        --manifest work/native-rewrite/forward-token-data/manifest.json \
        --executable "$build/forward_token_exact_cursor_test" --fixture "$build/original-resource-fixture.tsv" --case source
else
    python3 research/native-rewrite/tests/verify_forward_token_dictionary.py \
        --manifest work/native-rewrite/forward-token-data/manifest.json \
        --executable "$build/forward_token_dictionary_test" --fixture "$build/original-resource-fixture.tsv"
    "$build/forward_token_exact_cursor_test" "$build/original-resource-fixture.tsv"
    "$build/forward_token_exact_cursor_test" "$build/original-resource-fixture.tsv" source
fi
if [[ "$scope" != source && "$scope" != manager ]]; then
    "$build/forward_token_exact_cursor_test" "$build/original-resource-fixture.tsv" target
fi
if [[ "$scope" == all || "$scope" == queries ]]; then
    python3 research/native-rewrite/tests/verify_forward_token_dictionary.py \
        --manifest work/native-rewrite/forward-token-data/manifest.json \
        --executable "$build/forward_token_exact_cursor_test" --fixture "$build/original-resource-fixture.tsv" --case manager
fi
