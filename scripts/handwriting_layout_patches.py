"""Native adapters for the service-owned, layout-ready first expansion."""
from pathlib import Path

PKG = 'Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;'


def apply_first_handwriting_layout(decoded: Path) -> None:
    path = decoded / 'smali/axs.smali'
    text = path.read_text(encoding='utf-8')
    start = text.index('    .line 21\n', text.index('.method public final animateKeyboardViewSwitch('))
    end = text.index('    .line 14\n', start)
    text = text[:start] + '''    iget-object v1, p0, Laxs;->d:Landroid/view/View;
    invoke-static {v1}, Laxs;->restoreBodyLayout(Landroid/view/View;)V
    const/4 v1, 0x0

''' + text[end:]
    cancel = '    .line 8\n    iget-object v0, p0, Laxs;->a:Landroid/animation/ValueAnimator;'
    assert text.count(cancel) == 1
    text = text.replace(cancel, f'''    iget-object v0, p0, Laxs;->d:Landroid/view/View;
    if-eqz v0, :compat_cancel_value
    invoke-virtual {{v0}}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0
    invoke-static {{v0}}, {PKG}->finishNativeMotion(Landroid/content/Context;)V
    :compat_cancel_value
{cancel}''', 1)
    text += '''
.method public static restoreBodyLayout(Landroid/view/View;)V
    .locals 2
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;
    move-result-object v0
    const/4 v1, -0x2
    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I
    invoke-virtual {p0, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    return-void
.end method

.method public deferFirstExpansion(Landroid/view/View;Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)Z
    .locals 6
    iget-boolean v0, p0, Laxs;->b:Z
    if-eqz v0, :compat_no_wait
    iget-boolean v0, p0, Laxs;->a:Z
    if-eqz v0, :compat_no_wait
    iget-object v0, p0, Laxs;->a:Laxp;
    if-eqz v0, :compat_no_wait
    invoke-virtual {v0}, Laxp;->c()V
    iget-object v1, v0, Laxp;->b:Landroid/view/View;
    if-eqz v1, :compat_no_wait
    invoke-virtual {v1}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_wait
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_wait
    invoke-virtual {p2}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :compat_wait
    :compat_no_wait
    const/4 v0, 0x0
    return v0
    :compat_wait
    iget-object v3, p0, Laxs;->d:Landroid/view/View;
    if-eqz v3, :compat_no_wait
    new-instance v5, LHwrLayoutCompletion;
    invoke-direct {v5, v3, p4}, LHwrLayoutCompletion;-><init>(Landroid/view/View;Ljava/lang/Runnable;)V
    filled-new-array {p1, p2, v1}, [Landroid/view/View;
    move-result-object v4
    invoke-static {v3, v4, p3, v5}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->awaitNativeLayout(Landroid/view/View;[Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)Z
    move-result v0
    return v0
.end method
'''
    path.write_text(text, encoding='utf-8')
    # The native holder's original Runnable remains the only resume action.
    path = decoded / 'smali/akx.smali'
    text = path.read_text(encoding='utf-8').replace('.locals 8', '.locals 9', 1)
    call = '    invoke-interface/range {v0 .. v7}, Lcom/google/android/apps/inputmethod/libs/framework/core/IKeyboardViewSwitchAnimator;->animateKeyboardViewSwitch(Landroid/view/View;Landroid/view/View;Ljava/lang/String;ILjava/lang/String;ILjava/lang/Runnable;)Z'
    assert text.count(call) == 1
    text = text.replace(call, '''    instance-of v8, v0, Laky;
    if-eqz v8, :compat_run_native
    check-cast v0, Laky;
    move-object v8, p0
    invoke-virtual/range {v0 .. v8}, Laky;->deferKeyboardViewSwitch(Landroid/view/View;Landroid/view/View;Ljava/lang/String;ILjava/lang/String;ILjava/lang/Runnable;Ljava/lang/Runnable;)Z
    move-result v8
    if-eqz v8, :compat_run_native
    return-void
    :compat_run_native
''' + call, 1)
    path.write_text(text, encoding='utf-8')
    path = decoded / 'smali/aky.smali'
    text = path.read_text(encoding='utf-8')
    text += '''
.method public deferKeyboardViewSwitch(Landroid/view/View;Landroid/view/View;Ljava/lang/String;ILjava/lang/String;ILjava/lang/Runnable;Ljava/lang/Runnable;)Z
    .locals 8
    iget-object v0, p0, Laky;->a:Ljava/util/List;
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v0
    :compat_next_animator
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z
    move-result v1
    if-eqz v1, :compat_no_wait
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v1
    instance-of v2, v1, Laxs;
    if-eqz v2, :compat_next_animator
    check-cast v1, Laxs;
    move-object/from16 v2, p1
    move-object/from16 v3, p2
    move-object/from16 v4, p3
    move/from16 v5, p4
    move-object/from16 v6, p5
    move/from16 v7, p6
    invoke-virtual/range {v1 .. v7}, Laxs;->shouldAnimate(Landroid/view/View;Landroid/view/View;Ljava/lang/String;ILjava/lang/String;I)Z
    move-result v2
    if-eqz v2, :compat_next_animator
    move-object/from16 v2, p1
    move-object/from16 v3, p2
    move-object/from16 v4, p8
    move-object/from16 v5, p7
    invoke-virtual {v1, v2, v3, v4, v5}, Laxs;->deferFirstExpansion(Landroid/view/View;Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)Z
    move-result v1
    return v1
    :compat_no_wait
    const/4 v0, 0x0
    return v0
.end method
'''
    path.write_text(text, encoding='utf-8')
    (decoded / 'smali/HwrLayoutCompletion.smali').write_text('''.class public final LHwrLayoutCompletion;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.field private final parent:Landroid/view/View;
.field private final completion:Ljava/lang/Runnable;
.method public constructor <init>(Landroid/view/View;Ljava/lang/Runnable;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, LHwrLayoutCompletion;->parent:Landroid/view/View;
    iput-object p2, p0, LHwrLayoutCompletion;->completion:Ljava/lang/Runnable;
    return-void
.end method
.method public run()V
    .locals 1
    iget-object v0, p0, LHwrLayoutCompletion;->parent:Landroid/view/View;
    invoke-static {v0}, Laxs;->restoreBodyLayout(Landroid/view/View;)V
    iget-object v0, p0, LHwrLayoutCompletion;->completion:Ljava/lang/Runnable;
    if-eqz v0, :done
    invoke-interface {v0}, Ljava/lang/Runnable;->run()V
    :done
    return-void
.end method
''', encoding='utf-8')
