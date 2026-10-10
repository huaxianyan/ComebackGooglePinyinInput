"""Native renderer contracts and animation entry points for the Header motion module."""
from pathlib import Path

PKG = "Lcom/google/android/inputmethod/pinyin/headerplatform/"
KEY = "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;"
HELPER = "Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsViewHelper;"


def patch_renderer_targets(decoded: Path) -> None:
    key_path = decoded / "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView.smali"
    key = key_path.read_text(encoding="utf-8")
    key = key.replace('.source "PG"', '.source "PG"\n\n.implements ' + PKG + 'HeaderMotionTargetSource;', 1)
    # The renderer's existing metadata arrays and existing default-ID mapping are
    # the authoritative label protocol, exactly as used by native setEnabled().
    method = '\n.method public appendHeaderMotionTargets(Ljava/util/Collection;)V\n    .locals 5\n'
    method += f'''    invoke-interface {{p1, p0}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    invoke-virtual {{p0}}, {KEY}->a()Landroid/view/ViewGroup;
    move-result-object v4
    invoke-interface {{p1, v4}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
'''
    method += f'    iget-object v0, p0, {KEY}->a:Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/SoftKeyDef;\n    if-eqz v0, :motion_done\n'
    for field, mapper, tag in [('b', 'a', 'icon'), ('a', 'b', 'text')]:
        method += f'''    iget-object v1, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/SoftKeyDef;->{field}:[I
    const/4 v2, 0x0
    :motion_{tag}_loop
    array-length v3, v1
    if-ge v2, v3, :motion_{tag}_done
    aget v3, v1, v2
    invoke-static {{v3}}, {KEY}->{mapper}(I)I
    move-result v3
    invoke-virtual {{p0, v3}}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v4
    if-eqz v4, :motion_{tag}_next
    invoke-interface {{p1, v4}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    :motion_{tag}_next
    add-int/lit8 v2, v2, 0x1
    goto :motion_{tag}_loop
    :motion_{tag}_done
'''
    key += method + '    :motion_done\n    return-void\n.end method\n'
    key_path.write_text(key, encoding="utf-8")

    bar_path = decoded / "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/AccessPointsBar.smali"
    bar = bar_path.read_text(encoding="utf-8")
    bar = bar.replace('# interfaces\n', '# interfaces\n.implements ' + PKG + 'HeaderMotionTargetSource;\n', 1)
    owner = "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/AccessPointsBar;"
    bar += f'''
.method public appendHeaderMotionTargets(Ljava/util/Collection;)V
    .locals 4
    invoke-interface {{p1, p0}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    const/4 v1, 0x0
    :motion_holder_loop
    invoke-virtual {{p0}}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    if-ge v1, v2, :motion_holders_done
    invoke-virtual {{p0, v1}}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-interface {{p1, v3}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    add-int/lit8 v1, v1, 0x1
    goto :motion_holder_loop
    :motion_holders_done
    iget-object v0, p0, {owner}->a:{KEY}
    if-eqz v0, :motion_bar_items
    invoke-virtual {{v0, p1}}, {KEY}->appendHeaderMotionTargets(Ljava/util/Collection;)V
    :motion_bar_items
    iget-object v0, p0, {owner}->a:Lkx;
    const/4 v1, 0x0
    :motion_bar_loop
    invoke-virtual {{v0}}, Lkx;->size()I
    move-result v2
    if-ge v1, v2, :motion_bar_done
    invoke-virtual {{v0, v1}}, Lkx;->b(I)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, {KEY}
    invoke-virtual {{v3, p1}}, {KEY}->appendHeaderMotionTargets(Ljava/util/Collection;)V
    add-int/lit8 v1, v1, 0x1
    goto :motion_bar_loop
    :motion_bar_done
    return-void
.end method
'''
    bar_path.write_text(bar, encoding="utf-8")


def apply_header_motion(decoded: Path) -> None:
    patch_renderer_targets(decoded)
    owner = "Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/AccessPointsBar;"
    for relative, signature, locals_count, owner_register in [
        ('com/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager.smali', '.method final a(Z)V', 7, 'v3'),
        ('com/google/android/apps/inputmethod/libs/framework/core/AccessPointsViewHelper.smali', '.method public final a(Z)V', 4, 'p0'),
    ]:
        path = decoded / 'smali' / relative
        source = path.read_text(encoding="utf-8")
        start = source.index(signature)
        end = source.index('.end method', start)
        block = source[start:end]
        block = block.replace(f'.locals {locals_count}', f'.locals {locals_count + 2}', 1)
        needle = '    invoke-virtual {v0}, Landroid/animation/Animator;->start()V'
        if block.count(needle) != 1:
            raise RuntimeError(f'Native Header motion entry changed: {relative}')
        hook = f'''    iget-object v{locals_count}, {owner_register}, {HELPER}->a:{KEY}
    iget-object v{locals_count+1}, {owner_register}, {HELPER}->a:{owner}
    filled-new-array {{v{locals_count}, v{locals_count+1}}}, [Landroid/view/View;
    move-result-object v{locals_count}
    invoke-static {{v0, v{locals_count}}}, {PKG}HeaderMotionCoordinator;->prepareNativeMotion(Landroid/animation/Animator;[Landroid/view/View;)V

'''
        path.write_text(source[:start] + block.replace(needle, hook + needle) + source[end:], encoding="utf-8")

    patch_keyboard_renderer_targets(decoded)
    register_header_motion(decoded)


def patch_keyboard_renderer_targets(decoded: Path) -> None:
    import xml.etree.ElementTree as ET
    resources = ET.parse(decoded / 'res/values/public.xml').getroot()
    overlay_id = next(e.attrib['id'] for e in resources if e.get('type') == 'id' and e.get('name') == 'handwriting_overlay_view')
    owner = 'Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView;'
    path = decoded / 'smali/com/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyboardView.smali'
    text = path.read_text(encoding='utf-8')
    text = text.replace('.source "PG"', '.source "PG"\n\n.implements ' + PKG + 'HeaderMotionTargetSource;', 1)
    text += f'''
.method public appendHeaderMotionTargets(Ljava/util/Collection;)V
    .locals 4
    invoke-interface {{p1, p0}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    const/4 v1, 0x0
    :motion_children
    invoke-virtual {{p0}}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v2
    if-ge v1, v2, :motion_keys
    invoke-virtual {{p0, v1}}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v3
    invoke-interface {{p1, v3}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    add-int/lit8 v1, v1, 0x1
    goto :motion_children
    :motion_keys
    iget-object v0, p0, {owner}->b:Landroid/util/SparseArray;
    const/4 v1, 0x0
    :motion_key_loop
    invoke-virtual {{v0}}, Landroid/util/SparseArray;->size()I
    move-result v2
    if-ge v1, v2, :motion_drawing
    invoke-virtual {{v0, v1}}, Landroid/util/SparseArray;->valueAt(I)Ljava/lang/Object;
    move-result-object v3
    check-cast v3, {KEY}
    invoke-virtual {{v3, p1}}, {KEY}->appendHeaderMotionTargets(Ljava/util/Collection;)V
    add-int/lit8 v1, v1, 0x1
    goto :motion_key_loop
    :motion_drawing
    const v1, {overlay_id}
    invoke-virtual {{p0, v1}}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :motion_done
    invoke-interface {{p1, v3}}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z
    :motion_done
    return-void
.end method
'''
    path.write_text(text, encoding='utf-8')


def register_header_motion(decoded: Path) -> None:
    # Registration uses the same service-owned module registry as Clipboard and
    # Inline Autofill. No parallel motion registry or process-global lifetime.
    service = decoded / 'smali/com/google/android/inputmethod/pinyin/PinyinIME.smali'
    text = service.read_text(encoding='utf-8')
    needle = f'    new-instance v1, {PKG}ClipboardHeaderModule;'
    if text.count(needle) != 1:
        raise RuntimeError('Header module registration changed')
    text = text.replace(needle, f'''    new-instance v1, {PKG}HeaderMotionCoordinator;
    invoke-direct {{v1}}, {PKG}HeaderMotionCoordinator;-><init>()V
    invoke-virtual {{v0, v1}}, {PKG}HeaderPlatformController;->register({PKG}HeaderModule;)V

''' + needle)
    service.write_text(text, encoding='utf-8')
