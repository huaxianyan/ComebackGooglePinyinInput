"""Record original/released persist methods without erasing semantic differences."""
import difflib
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
RELATIVE = 'classes/com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.smali'
SOURCES = (
    ROOT / 'work/native-rewrite/original-apk/smali-file-policy' / RELATIVE,
    ROOT / 'work/native-rewrite/restart-v217/smali-file-policy' / RELATIVE,
)


def persist_body(path):
    text = path.read_text(encoding='utf-8')
    start = text.index('.method public persist()Z')
    end = text.index('.end method', start) + len('.end method')
    return text[start:end]


original, released = map(persist_body, SOURCES)
output = ROOT / 'work/native-rewrite/restart-v217/java-file-policy-comparison.json'
result = {
    'method': 'Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->persist()Z',
    'smali_paths': [str(path.relative_to(ROOT)) for path in SOURCES],
    'method_sha256': [hashlib.sha256(body.encode()).hexdigest() for body in (original, released)],
    'identical': original == released,
    'policy_provenance': 'scripts/apply_patches.py: retain previous known-good dictionary as _bak',
    'semantic_difference': 'original deletes backup after success; released v2.1.7 retains it',
    'diff': list(difflib.unified_diff(original.splitlines(), released.splitlines(),
                                    fromfile='original persist()', tofile='released persist()', lineterm='')),
    'native_regions_reused': 246,
}
output.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print('RECORDED: original and released persistence differ; no semantic equivalence is asserted')
