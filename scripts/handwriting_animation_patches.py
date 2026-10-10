"""Preserve the native fallback when handwriting animation geometry is unavailable."""
from pathlib import Path


def apply_handwriting_animation(decoded: Path) -> None:
    path = decoded / 'smali/axs.smali'
    text = path.read_text(encoding='utf-8')
    consume = '    iput-boolean v1, p0, Laxs;->b:Z\n\n    .line 14'
    anchor = '    :cond_2\n    iget-object v1, p0, Laxs;->e:Landroid/view/View;'
    if text.count(consume) != 1 or text.count(anchor) != 1:
        raise RuntimeError('Native handwriting animation entry changed')
    guard = '''    :cond_2
    # Only claim animation when all native height inputs are usable.
    # Returning false leaves completion to the native animator chain.
    iget-object v2, p0, Laxs;->e:Landroid/view/View;
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_geometry_unready

    invoke-virtual {p1}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_geometry_unready

    invoke-virtual {p2}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_geometry_unready

    goto :compat_geometry_ready

    :compat_geometry_unready
    const/4 v0, 0x0
    return v0

    :compat_geometry_ready
    iget-object v1, p0, Laxs;->e:Landroid/view/View;'''
    path.write_text(text.replace(anchor, guard, 1), encoding='utf-8')
