#!/usr/bin/env python3
"""Verify native renderer binding and bounded Header motion ownership (API 36)."""
import argparse
from pathlib import Path


def verify(decoded: Path) -> None:
    smali = decoded / 'smali'
    platform = smali / 'com/google/android/inputmethod/pinyin/headerplatform'
    key = (smali / 'com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView.smali').read_text(encoding='utf-8')
    bar = (smali / 'com/google/android/apps/inputmethod/libs/framework/keyboard/widget/AccessPointsBar.smali').read_text(encoding='utf-8')
    assert 'HeaderMotionTargetSource;' in key and 'HeaderMotionTargetSource;' in bar
    renderer = key.split('.method public appendHeaderMotionTargets',1)[1].split('.end method',1)[0]
    assert 'SoftKeyDef;->a:[I' in renderer and 'SoftKeyDef;->b:[I' in renderer
    assert 'SoftKeyView;->a(I)I' in renderer and 'SoftKeyView;->b(I)I' in renderer
    assert 'SoftKeyView;->a()Landroid/view/ViewGroup;' in renderer
    assert 'invoke-interface {p1, p0}' in renderer
    provider = bar.split('.method public appendHeaderMotionTargets', 1)[1].split('.end method', 1)[0]
    assert 'Lkx;->b(I)Ljava/lang/Object;' in provider
    assert 'ViewGroup;->getChildAt(I)Landroid/view/View;' in provider
    assert 'invoke-interface {p1, p0}' in provider
    # c(I) is removeAt, not valueAt. Renderer enumeration must retain its cache.
    assert 'Lkx;->c(I)Ljava/lang/Object;' not in provider
    body = (smali / 'com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView.smali').read_text(encoding='utf-8')
    assert 'HeaderMotionTargetSource;' in body
    body_renderer = body.split('.method public appendHeaderMotionTargets', 1)[1].split('.end method', 1)[0]
    assert 'SoftKeyboardView;->b:Landroid/util/SparseArray;' in body_renderer
    assert 'SparseArray;->valueAt(I)Ljava/lang/Object;' in body_renderer
    assert 'SoftKeyView;->appendHeaderMotionTargets' in body_renderer
    assert 'View;->findViewById(I)Landroid/view/View;' in body_renderer
    module = (platform/'HeaderMotionCoordinator.smali').read_text(encoding='utf-8')
    assert 'prepareNativeMotion(Landroid/animation/Animator;[Landroid/view/View;)V' in module
    motion = (platform/'HeaderMotionCoordinator$Motion.smali').read_text(encoding='utf-8')
    assert 'HeaderModule;' in module and 'getRegisteredModule' in module
    assert 'const/16 v1, 0x24' in module or 'const/16 v0, 0x24' in module
    assert 'appendHeaderMotionTargets' in module
    for callback in ['onAnimationEnd','onAnimationCancel','onViewDetachedFromWindow','onPreDraw']:
        assert callback in motion, callback
    assert 'ViewFrameRateCompat;->requestHigh(Landroid/view/View;Z)V' in motion
    assert 'removeOnPreDrawListener' in motion and 'removeListener' in motion
    service=(smali/'com/google/android/inputmethod/pinyin/PinyinIME.smali').read_text(encoding='utf-8')
    assert service.count('new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;') == 1
    for filename in ['AccessPointsManager','AccessPointsViewHelper']:
        source=(smali/f'com/google/android/apps/inputmethod/libs/framework/core/{filename}.smali').read_text(encoding='utf-8')
        assert source.count('HeaderMotionCoordinator;->prepareNativeMotion') == 1
        assert 'prepareNativeMotion(Landroid/animation/Animator;[Landroid/view/View;)V' in source
        point=source.index('HeaderMotionCoordinator;->prepareNativeMotion')
        assert source.index('Animator;->start()V',point)>point
    host=(platform/'HeaderPlatformHostView.smali').read_text(encoding='utf-8')
    window=host.split('.method protected onWindowVisibilityChanged',1)[1].split('.end method',1)[0]
    assert 'HeaderMotionCoordinator;->finishNativeMotion' in window
    for filename in ['ClipboardHeaderModule','InlineAutofillHeaderModule']:
        assert (platform/(filename+'.smali')).is_file(), filename
    print('Native Header renderer targets and motion ownership verified')

if __name__ == '__main__':
    parser=argparse.ArgumentParser();parser.add_argument('decoded',type=Path)
    verify(parser.parse_args().decoded)
