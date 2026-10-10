"""Preserve the native fallback when handwriting animation geometry is unavailable."""
from pathlib import Path


def apply_handwriting_animation(decoded: Path) -> None:
    path = decoded / 'smali/axs.smali'
    text = path.read_text(encoding='utf-8')
    consume = '    iput-boolean v1, p0, Laxs;->b:Z\n\n    .line 14'
    anchor = '    :cond_2\n    iget-object v1, p0, Laxs;->e:Landroid/view/View;'
    if text.count(consume) != 1 or text.count(anchor) != 1:
        raise RuntimeError('Native handwriting animation entry changed')
    height_start = text.index('    .line 21\n', text.index('.method public final animateKeyboardViewSwitch('))
    height_end = text.index('    .line 24\n', height_start)
    restore_height = text[height_start:height_end]
    text = text[:height_start] + text[height_end:]
    text = text.replace('    .line 14\n', restore_height + '    const/4 v1, 0x0\n\n    .line 14\n', 1)
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
    iget-object v2, p0, Laxs;->a:Ljava/lang/Runnable;
    if-eqz v2, :compat_fallback_done
    invoke-interface {v2}, Ljava/lang/Runnable;->run()V
    :compat_fallback_done
    const/4 v0, 0x0
    return v0

    :compat_geometry_ready
    iget-object v1, p0, Laxs;->e:Landroid/view/View;'''
    text = text.replace(anchor, guard, 1)
    start = '    invoke-virtual {v0}, Landroid/animation/AnimatorSet;->start()V'
    if text.count(start) != 1:
        raise RuntimeError('Native handwriting animation start changed')
    hook = '''    iget-object v1, p0, Laxs;->c:Landroid/view/View;
    iget-object v2, p0, Laxs;->e:Landroid/view/View;
    filled-new-array {p1, p2, v1, v2}, [Landroid/view/View;
    move-result-object v1
    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->prepareNativeMotion(Landroid/animation/Animator;[Landroid/view/View;)V

'''
    path.write_text(text.replace(start, hook + start, 1), encoding='utf-8')
    from handwriting_layout_patches import apply_first_handwriting_layout
    apply_first_handwriting_layout(decoded)
