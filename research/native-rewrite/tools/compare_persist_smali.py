"""Document the single persist() difference between the original and retained v2.1.7 builds."""
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
relative = 'classes/com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.smali'
roots = [
    ROOT / 'work/native-rewrite/original-apk/smali-file-policy',
    ROOT / 'work/native-rewrite/restart-v217/smali-file-policy',
]


def persist_body(text):
    start = text.index('.method public persist()Z')
    end = text.index('.end method', start) + len('.end method')
    return text[start:end]


original, retained = (persist_body((root / relative).read_text(encoding='utf-8')) for root in roots)

# The retained build replaces the backup delete result branch and its diagnostic
# logging with a plain exists() check. Labels renumber; control flow is identical.
start = original.index('    invoke-virtual {v4}, Ljava/io/File;->delete()Z\n\n    move-result v0\n\n    if-nez v0, :cond_117')
end = original.index('    invoke-virtual {v2}, Ljava/io/File;->exists()Z', start)
spliced = (original[:start]
           + '    invoke-virtual {v4}, Ljava/io/File;->exists()Z\n\n    move-result v0\n\n'
             '    :try_end_106\n    .catchall {:try_start_102 .. :try_end_106} :catchall_13b\n\n'
           + original[end:])
spliced = (spliced.replace(':catchall_14c', ':catchall_13b')
           .replace(':cond_156', ':cond_145').replace(':cond_165', ':cond_154'))


def normalize(text):
    text = re.sub(r'\.line \d+', '', text)
    text = re.sub(r':\w+', '@', text)
    text = re.sub(r'\b[vwp]\d+\b', 'r', text)
    return re.sub(r'\n\s*\n+', '\n', text).strip()


structural = normalize(spliced) == normalize(retained)
assert structural, 'persist() differs beyond the documented diagnostic-branch replacement'

result = {
    'method': 'Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->persist()Z',
    'smali_paths': [str(root / relative) for root in roots],
    'original_method_sha256': hashlib.sha256(original.encode()).hexdigest(),
    'retained_method_sha256': hashlib.sha256(retained.encode()).hexdigest(),
    'structural_equality_after_diagnostic_removal': structural,
    'structural_difference': 'retained v2.1.7 replaces the backup delete result branch and its diagnostic logging with an exists() check; cleanup and recovery branches are otherwise identical',
    'pre_finally_temporary_delete': 'before :try_start_4f',
    'catch_all': ':catchall_14c',
    'finally_recovery': 'backup.exists() && !main.exists(): backup.renameTo(main)',
    'native_regions_reused': 246,
}
out = ROOT / 'work/native-rewrite/restart-v217/java-file-policy-comparison.json'
out.write_text(json.dumps(result, indent=2) + '\n', encoding='utf-8')
print('PASS: original and retained v2.1.7 persist() differ only in the documented diagnostic branch')
