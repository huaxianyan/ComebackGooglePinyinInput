"""Mutation checks using an unpatched decoded native animator."""
import tempfile
from pathlib import Path
import sys
from handwriting_animation_patches import apply_handwriting_animation
from verify_handwriting_animation import verify

source = Path(sys.argv[1])
with tempfile.TemporaryDirectory(dir='work/tmp') as tmp:
    root = Path(tmp)
    (root / 'smali').mkdir()
    original = (source / 'smali/axs.smali').read_text(encoding='utf-8')
    for name in ['axs', 'aky', 'akx']:
        (root / f'smali/{name}.smali').write_bytes((source / f'smali/{name}.smali').read_bytes())
    try:
        verify(root)
    except (AssertionError, IndexError):
        pass
    else:
        raise AssertionError('Unpatched native animator must fail the gate')
    apply_handwriting_animation(root)
    verify(root)
    patched = (root / 'smali/axs.smali').read_text(encoding='utf-8')
    def interpolation(text):
        return text.split('.method final a(F)V', 1)[1].split('.end method', 1)[0]
    assert interpolation(original) == interpolation(patched)
    for removed in [
        '    if-lez v2, :compat_geometry_unready\n',
        '    const/4 v0, 0x0\n    return v0\n',
        '    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I\n',
        '    invoke-interface {v2}, Ljava/lang/Runnable;->run()V\n',
    ]:
        (root / 'smali/axs.smali').write_text(patched.replace(removed, '', 1), encoding='utf-8')
        try:
            verify(root)
        except AssertionError:
            pass
        else:
            raise AssertionError('Missing geometry guard or fallback must fail')
    (root / 'smali/axs.smali').write_text(patched, encoding='utf-8')
    try:
        apply_handwriting_animation(root)
    except RuntimeError:
        pass
    else:
        raise AssertionError('Unexpected patched input must be rejected')
print('Unpatched failure, guard/fallback mutations and interpolation preservation passed')
