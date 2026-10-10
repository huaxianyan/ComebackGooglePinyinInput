"""Check native fallback, ownership ordering and unchanged interpolation."""
import re
import sys
from pathlib import Path


def verify(decoded: Path) -> None:
    text = (decoded / 'smali/axs.smali').read_text(encoding='utf-8')
    entry = text.split('.method public final animateKeyboardViewSwitch(', 1)[1].split('.end method', 1)[0]
    # Baksmali renames labels in the final APK. Validate actual branches.
    clean = '\n'.join(line.strip() for line in entry.splitlines()
                      if line.strip() and not line.strip().startswith(('#', '.line', '.prologue')))
    guards = list(re.finditer(r'if-lez v2, (:\w+)', clean))
    assert len(guards) == 3
    assert len({g.group(1) for g in guards}) == 1
    assert guards[-1].end() < clean.index('setPivotY(F)V')
    before_guard = clean[:guards[-1].end()]
    assert 'iget-object v2, p0, Laxs;->e:Landroid/view/View;' in before_guard
    assert 'invoke-virtual {p1}, Landroid/view/View;->getHeight()I' in before_guard
    assert 'invoke-virtual {p2}, Landroid/view/View;->getHeight()I' in before_guard
    fallback = guards[0].group(1) + '\nconst/4 v0, 0x0\nreturn v0'
    assert fallback in clean
    assert entry.count('iput-boolean v1, p0, Laxs;->b:Z') == 1
    assert entry.index('iput-boolean v1, p0, Laxs;->b:Z') < entry.index('invoke-virtual {v2}, Laxp;->c()V')
    assert 'invoke-virtual {p0, v0}, Laxs;->a(F)V' in entry
    assert 'invoke-virtual {v0}, Landroid/animation/AnimatorSet;->start()V' in entry
    interpolation = text.split('.method final a(F)V', 1)[1].split('.end method', 1)[0]
    assert 'div-float/2addr v1, v2' in interpolation
    assert 'setScaleY(F)V' in interpolation
    assert '.catch' not in entry + interpolation
    chain = (decoded / 'smali/aky.smali').read_text(encoding='utf-8')
    assert 'invoke-interface/range {p7 .. p7}, Ljava/lang/Runnable;->run()V' in chain
    print('Native handwriting geometry guard and original completion fallback verified')


if __name__ == '__main__':
    verify(Path(sys.argv[1]))
