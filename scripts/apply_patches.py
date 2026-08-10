#!/usr/bin/env python3
"""Apply Android 16/17 compatibility patches to Google Pinyin 4.5.2.

This script intentionally targets the unmodified Google Pinyin Input
4.5.2.193126728 arm64-v8a APK. It aborts instead of guessing when an expected
source fragment is missing or appears more than once.
"""

from __future__ import annotations

import argparse
import shutil
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FORMAL_APPLICATION_ID = "com.google.android.inputmethod.pinyin.compat"


def replace_once(path: Path, old: str, new: str) -> None:
    text = path.read_text(encoding="utf-8")
    count = text.count(old)
    if count != 1:
        raise RuntimeError(f"Expected exactly one match in {path}, found {count}")
    path.write_text(text.replace(old, new), encoding="utf-8", newline="\n")


def replace_exactly(path: Path, old: str, new: str, expected: int) -> None:
    text = path.read_text(encoding="utf-8")
    count = text.count(old)
    if count != expected:
        raise RuntimeError(f"Expected {expected} matches in {path}, found {count}")
    path.write_text(text.replace(old, new), encoding="utf-8", newline="\n")


def apply(
    decoded: Path,
    application_id: str,
    debuggable: bool = False,
    version_name: str = "2.0.0",
    version_code: int = 4520385,
) -> None:
    if not (decoded / "apktool.yml").is_file():
        raise RuntimeError(f"Not an apktool output directory: {decoded}")
    if debuggable and application_id == FORMAL_APPLICATION_ID:
        raise RuntimeError("Refusing to make the formal application ID debuggable")

    # Target SDK modernization is deliberately staged one API level at a time.
    # API 35 has passed its isolated audit; this branch isolates Android 16 /
    # API 36 while retaining all previously accepted compatibility fixes.
    # V1 deliberately accepts enforced edge-to-edge without an opt-out or
    # speculative inset/measurement compensation so visual changes remain
    # attributable and can be fixed only where device evidence requires it.
    replace_once(
        decoded / "apktool.yml",
        "sdkInfo:\n  minSdkVersion: 17\n  targetSdkVersion: 26",
        "sdkInfo:\n  minSdkVersion: 17\n  targetSdkVersion: 36",
    )
    if version_code <= 0:
        raise ValueError("versionCode must be positive")
    if not version_name.strip():
        raise ValueError("versionName must not be empty")
    replace_once(
        decoded / "apktool.yml",
        "versionInfo:\n  versionCode: 4520313\n  versionName: 4.5.2.193126728-arm64-v8a",
        f"versionInfo:\n  versionCode: {version_code}\n"
        f"  versionName: {version_name}",
    )

    # Keep the formal product name unchanged. Isolated audit packages use a
    # conspicuous label so they can be distinguished in Launcher, Android's
    # app list, and the input-method picker without changing keyboard UI.
    if application_id != FORMAL_APPLICATION_ID:
        replace_once(
            decoded / "res/values/strings.xml",
            '<string name="ime_name_ref">@string/ime_name</string>',
            '<string name="ime_name_ref">Google 拼音输入法（测试版）</string>',
        )

    # Android 12 requires every PendingIntent to declare mutability. None of
    # these seven legacy tokens is modified by its recipient (no RemoteInput,
    # bubbles, fill-in data, or location callback), so preserve the existing
    # CANCEL_CURRENT/UPDATE_CURRENT behavior and add FLAG_IMMUTABLE narrowly.
    pending_intent_flags = (
        (
            "smali/agf.smali",
            "    const/high16 v1, 0x10000000\n\n"
            "    invoke-static {p0, v0, p1, v1}, Landroid/app/PendingIntent;->getService",
            "    const/high16 v1, 0x14000000\n\n"
            "    invoke-static {p0, v0, p1, v1}, Landroid/app/PendingIntent;->getService",
        ),
        (
            "smali/bfn.smali",
            "    const/high16 v1, 0x10000000\n\n"
            "    invoke-static {p1, p3, v0, v1}, Landroid/app/PendingIntent;->getActivity",
            "    const/high16 v1, 0x14000000\n\n"
            "    invoke-static {p1, p3, v0, v1}, Landroid/app/PendingIntent;->getActivity",
        ),
        (
            "smali/bnr.smali",
            "    const/high16 v6, 0x8000000\n\n"
            "    invoke-static {v4, v0, v2, v6}, Landroid/app/PendingIntent;->getActivity",
            "    const/high16 v6, 0xc000000\n\n"
            "    invoke-static {v4, v0, v2, v6}, Landroid/app/PendingIntent;->getActivity",
        ),
        (
            "smali/bmm.smali",
            "    const/high16 v3, 0x8000000\n\n"
            "    invoke-static {v0, v1, v2, v3}, Landroid/app/PendingIntent;->getActivity",
            "    const/high16 v3, 0xc000000\n\n"
            "    invoke-static {v0, v1, v2, v3}, Landroid/app/PendingIntent;->getActivity",
        ),
        (
            "smali/cbs.smali",
            "    const/4 v3, 0x0\n\n"
            "    invoke-static {v1, v2, v0, v3}, Landroid/app/PendingIntent;->getBroadcast",
            "    const/high16 v3, 0x4000000\n\n"
            "    invoke-static {v1, v2, v0, v3}, Landroid/app/PendingIntent;->getBroadcast",
        ),
        (
            "smali/com/google/firebase/iid/FirebaseInstanceIdService.smali",
            "    const/high16 v6, 0x10000000\n\n"
            "    invoke-static {p0, v4, v5, v6}, Landroid/app/PendingIntent;->getBroadcast",
            "    const/high16 v6, 0x14000000\n\n"
            "    invoke-static {p0, v4, v5, v6}, Landroid/app/PendingIntent;->getBroadcast",
        ),
        (
            "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
            "PinyinFirstRunActivity.smali",
            "    const/high16 v2, 0x8000000\n\n"
            "    invoke-static {p0, v0, v1, v2}, Landroid/app/PendingIntent;->getActivity",
            "    const/high16 v2, 0xc000000\n\n"
            "    invoke-static {p0, v0, v1, v2}, Landroid/app/PendingIntent;->getActivity",
        ),
    )
    for relative, old, new in pending_intent_flags:
        replace_once(decoded / relative, old, new)

    # Android 14 requires an explicit exported/not-exported flag when a
    # target-34 app dynamically registers for a non-system broadcast. This
    # GServices cache invalidation action is sent by another Google package,
    # so preserve the legacy cross-package behavior with RECEIVER_EXPORTED.
    # Keep the two-argument overload below API 33 so minSdk 17 remains valid.
    replace_once(
        decoded / "smali/btp.smali",
        "    invoke-virtual {v1, v0, v4}, Landroid/content/Context;->registerReceiver("
        "Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)"
        "Landroid/content/Intent;\n\n"
        "    goto :goto_0",
        "    sget v5, Landroid/os/Build$VERSION;->SDK_INT:I\n\n"
        "    const/16 v6, 0x21\n\n"
        "    if-lt v5, v6, :register_gservices_legacy\n\n"
        "    const/4 v5, 0x2\n\n"
        "    invoke-virtual {v1, v0, v4, v5}, Landroid/content/Context;->registerReceiver("
        "Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)"
        "Landroid/content/Intent;\n\n"
        "    goto :gservices_receiver_registered\n\n"
        "    :register_gservices_legacy\n"
        "    invoke-virtual {v1, v0, v4}, Landroid/content/Context;->registerReceiver("
        "Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)"
        "Landroid/content/Intent;\n\n"
        "    :gservices_receiver_registered\n"
        "    goto :goto_0",
    )

    # Android 15 disables the legacy bottom offset for edge-to-edge windows.
    # Activities keep their narrow bottom-inset handling. For the IME, follow
    # Gboard's covering IME model: the Window continues through the navigation
    # region so apps receive the complete IME inset, while a dedicated themed
    # bottom frame reserves navigationBars space below the native keyboard body.
    first_run_activity = decoded / "smali/apy.smali"
    replace_once(
        first_run_activity,
        "    const v0, 0x7f040034\n\n"
        "    invoke-virtual {p0, v0}, Lapy;->setContentView(I)V\n\n"
        "    .line 28",
        "    const v0, 0x7f040034\n\n"
        "    invoke-virtual {p0, v0}, Lapy;->setContentView(I)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->attachFirstRun(Landroid/app/Activity;)V\n\n"
        "    .line 28",
    )

    input_view = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/InputView.smali"
    )
    google_ime = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService.smali"
    )
    replace_once(
        google_ime,
        "    .line 489\n    iget-object v0, p0, Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/GoogleInputMethodService;->a:Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputView;\n\n    goto/16 :goto_0",
        "    .line 489\n    iget-object v0, p0, Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/GoogleInputMethodService;->a:Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputView;\n\n"
        "    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->attachInputView(Landroid/view/View;)V\n\n"
        "    goto/16 :goto_0",
    )

    arrays = decoded / "res/values/arrays.xml"
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_permission</item>\n"
        "        <item>@layout/first_run_page_setup_user_metrics</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_page_done</item>",
    )
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "        <item>@layout/first_run_page_setup_user_metrics</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "        <item>@layout/first_run_page_done</item>",
    )
    # The setup now has one stateful page with both system actions. Keep every
    # first-run array consistent so activation-page intents cannot resurrect a
    # legacy pager path.
    replace_once(
        arrays,
        "        <item>@layout/first_run_page_enable</item>\n"
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "    </array>\n"
        "    <string-array name=\"builtin_theme_package_name_to_theme_name_map\">",
        "        <item>@layout/first_run_single_page</item>\n"
        "    </array>\n"
        "    <string-array name=\"builtin_theme_package_name_to_theme_name_map\">",
    )
    replace_exactly(
        arrays,
        "        <item>@layout/first_run_page_enable</item>\n"
        "        <item>@layout/first_run_page_select_input_method</item>\n"
        "        <item>@layout/first_run_page_done</item>",
        "        <item>@layout/first_run_single_page</item>",
        2,
    )

    # API 35+ receives an MD3-inspired first-run surface with day/night colors,
    # rounded filled buttons, current typography and a finish-only final action.
    resource_patches = ROOT / "patches/res"
    for source in resource_patches.rglob("*"):
        if not source.is_file():
            continue
        destination = decoded / "res" / source.relative_to(resource_patches)
        destination.parent.mkdir(parents=True, exist_ok=True)
        overwritten_layouts = {
            "first_run.xml",
            "first_run_page_done.xml",
            "first_run_page_footer.xml",
            "keyboard_candidates_header_inner.xml",
            "keyboard_candidates_header_inner_no_deletable_label.xml",
            "softkey_candidate.xml",
        }
        if destination.exists() and source.name not in overwritten_layouts:
            raise RuntimeError(f"Refusing to overwrite resource: {destination}")
        shutil.copyfile(source, destination)

    # Preserve the framework Preference persistence/callback graph while
    # applying the API 35+ MD3 presentation layer to every generated fragment
    # and to the PreferenceActivity header list. This mirrors Gboard's
    # separation between Preference state and custom row presentation without
    # importing AndroidX or replacing legacy preference subclasses.
    common_preference_fragment = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/"
        "CommonPreferenceFragment.smali"
    )
    replace_once(
        common_preference_fragment,
        "    invoke-static {v0}, Lgc;->a(Landroid/preference/PreferenceGroup;)V\n\n"
        "    .line 40\n"
        "    :cond_0\n"
        "    return-void",
        "    invoke-static {v0}, Lgc;->a(Landroid/preference/PreferenceGroup;)V\n\n"
        "    .line 40\n"
        "    :cond_0\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "Md3SettingsCompat;->apply(Landroid/preference/PreferenceFragment;)V\n\n"
        "    return-void",
    )
    replace_once(
        common_preference_fragment,
        ".method public onCreateOptionsMenu(Landroid/view/Menu;Landroid/view/MenuInflater;)V",
        ".method public onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V\n"
        "    .locals 0\n\n"
        "    invoke-super {p0, p1, p2}, Landroid/preference/PreferenceFragment;"
        "->onViewCreated(Landroid/view/View;Landroid/os/Bundle;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "Md3SettingsCompat;->apply(Landroid/preference/PreferenceFragment;)V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public onCreateOptionsMenu(Landroid/view/Menu;Landroid/view/MenuInflater;)V",
    )
    abstract_settings = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/preference/"
        "AbstractSettingsActivity.smali"
    )
    replace_once(
        abstract_settings,
        "    invoke-super {p0, p1}, Landroid/preference/PreferenceActivity;->onCreate("
        "Landroid/os/Bundle;)V\n\n"
        "    .line 7",
        "    invoke-super {p0, p1}, Landroid/preference/PreferenceActivity;->onCreate("
        "Landroid/os/Bundle;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "Md3SettingsCompat;->apply(Landroid/app/Activity;)V\n\n"
        "    .line 7",
    )

    # API 35+ uses the source-built Compose host for every normal settings
    # entry. Keep the legacy Activity as the API 17-34 implementation and as a
    # narrowly gated same-package host for operations whose permission,
    # confirmation, and destructive task lifecycles have not been migrated.
    # The modern class is referenced only by name so primary DEX verification
    # and API 17-34 startup never resolve an AndroidX/Compose type.
    settings_activity = decoded / (
        "smali/com/google/android/apps/inputmethod/pinyin/preference/"
        "SettingsActivity.smali"
    )
    replace_once(
        settings_activity,
        "    invoke-direct {p0}, Labu;-><init>()V\n\n"
        "    return-void\n"
        ".end method\n\n\n"
        "# virtual methods",
        "    invoke-direct {p0}, Labu;-><init>()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public onCreate(Landroid/os/Bundle;)V\n"
        "    .locals 4\n\n"
        "    invoke-super {p0, p1}, Labu;->onCreate(Landroid/os/Bundle;)V\n\n"
        "    # The legacy first-run gate normally runs from the superclass'\n"
        "    # onResume(). The API-35 Compose redirect happens in onCreate(), so\n"
        "    # preserve that gate explicitly for launcher-icon entry before the\n"
        "    # redirect can finish this intermediary Activity.\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->getIntent()Landroid/content/Intent;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"entry\"\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->getStringExtra("
        "Ljava/lang/String;)Ljava/lang/String;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"app_icon\"\n\n"
        "    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :modern_route\n\n"
        "    invoke-static {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->b(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :modern_route\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->finish()V\n\n"
        "    return-void\n\n"
        "    :modern_route\n"
        "    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I\n\n"
        "    const/16 v1, 0x23\n\n"
        "    if-lt v0, v1, :legacy_settings\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->getIntent()Landroid/content/Intent;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"modern_settings_use_legacy\"\n\n"
        "    const/4 v2, 0x0\n\n"
        "    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->getBooleanExtra("
        "Ljava/lang/String;Z)Z\n\n"
        "    move-result v0\n\n"
        "    if-nez v0, :legacy_settings\n\n"
        "    new-instance v0, Landroid/content/Intent;\n\n"
        "    invoke-direct {v0}, Landroid/content/Intent;-><init>()V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->getPackageName()Ljava/lang/String;\n\n"
        "    move-result-object v1\n\n"
        "    const-string v2, \"com.google.android.inputmethod.pinyin."
        "modernsettings.compose.ModernSettingsActivity\"\n\n"
        "    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClassName("
        "Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->startActivity(Landroid/content/Intent;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "preference/SettingsActivity;->finish()V\n\n"
        "    :legacy_settings\n"
        "    return-void\n"
        ".end method\n\n\n"
        "# virtual methods",
    )

    # Do not launch a transparent permission Activity from the IME service.
    # Runtime permission requests made from a real settings Activity continue
    # through FeaturePermissionsManager's direct Activity.requestPermissions
    # path, while optional background features remain disabled until granted.
    permissions_activity = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "PermissionsActivity.smali"
    )
    replace_once(
        permissions_activity,
        ".method public static varargs a(Landroid/content/Context;I[Ljava/lang/String;)V\n"
        "    .locals 3\n\n"
        "    .prologue\n"
        "    .line 3\n"
        "    new-instance v0, Landroid/content/Intent;\n\n"
        "    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()"
        "Landroid/content/Context;\n\n"
        "    move-result-object v1\n\n"
        "    const-class v2, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "PermissionsActivity;\n\n"
        "    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/"
        "content/Context;Ljava/lang/Class;)V\n\n"
        "    .line 4\n"
        "    const-string v1, \"requested_permissions\"\n\n"
        "    invoke-virtual {v0, v1, p2}, Landroid/content/Intent;->putExtra(Ljava/"
        "lang/String;[Ljava/lang/String;)Landroid/content/Intent;\n\n"
        "    .line 5\n"
        "    const-string v1, \"request_code\"\n\n"
        "    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/"
        "lang/String;I)Landroid/content/Intent;\n\n"
        "    .line 6\n"
        "    const/high16 v1, 0x10800000\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/"
        "content/Intent;\n\n"
        "    .line 7\n"
        "    invoke-virtual {p0, v0}, Landroid/content/Context;->startActivity(Landroid/"
        "content/Intent;)V\n\n"
        "    .line 8\n"
        "    return-void\n"
        ".end method",
        ".method public static varargs a(Landroid/content/Context;I[Ljava/lang/String;)V\n"
        "    .locals 0\n\n"
        "    return-void\n"
        ".end method",
    )

    # Android rejects the legacy Region.Op.REPLACE clip used by the old
    # handwriting renderer. Match current Gboard: isolate every dirty-rect draw
    # with save/restore and use the default INTERSECT clipRect overload, without
    # depending on the deprecated Region.Op API.
    stroke_renderer = decoded / "smali/ayc.smali"
    for rect_register, op_register in (("v1", "v2"), ("v0", "v1"), ("v6", "v1")):
        replace_once(
            stroke_renderer,
            f"    sget-object {op_register}, Landroid/graphics/Region$Op;->REPLACE:"
            "Landroid/graphics/Region$Op;\n\n"
            f"    invoke-virtual {{p2, {rect_register}, {op_register}}}, "
            "Landroid/graphics/Canvas;->clipRect(Landroid/graphics/RectF;"
            "Landroid/graphics/Region$Op;)Z",
            "    invoke-virtual {p2}, Landroid/graphics/Canvas;->save()I\n\n"
            f"    invoke-virtual {{p2, {rect_register}}}, Landroid/graphics/Canvas;"
            "->clipRect(Landroid/graphics/RectF;)Z",
        )
    for draw_call in (
        "    invoke-virtual {p2, v2, v3, v0, v4}, Landroid/graphics/Canvas;"
        "->drawCircle(FFFLandroid/graphics/Paint;)V",
        "    invoke-virtual {p2, v1, v2}, Landroid/graphics/Canvas;->drawPath("
        "Landroid/graphics/Path;Landroid/graphics/Paint;)V",
        "    invoke-virtual {p2, v1, v2, v0, v3}, Landroid/graphics/Canvas;"
        "->drawCircle(FFFLandroid/graphics/Paint;)V",
    ):
        replace_once(
            stroke_renderer,
            draw_call,
            draw_call + "\n\n    invoke-virtual {p2}, Landroid/graphics/Canvas;->restore()V",
        )

    # Keep full-canvas handwriting clears state-neutral as well. Restore before
    # replaying retained strokes so every renderer call starts from a clean clip.
    for relative in (
        "smali/aye.smali",
        "smali/com/google/android/apps/inputmethod/libs/handwriting/keyboard/"
        "HandwritingOverlayView.smali",
    ):
        clear_path = decoded / relative
        replace_once(
            clear_path,
            "    iget-object v0, v6, Lcom/google/android/apps/inputmethod/libs/"
            "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
            "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
            "Landroid/graphics/PorterDuff$Mode;\n\n"
            "    invoke-virtual {v0, v7, v1}, Landroid/graphics/Canvas;->drawColor("
            "ILandroid/graphics/PorterDuff$Mode;)V"
            if relative == "smali/aye.smali"
            else
            "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/"
            "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
            "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
            "Landroid/graphics/PorterDuff$Mode;\n\n"
            "    invoke-virtual {v0, v6, v1}, Landroid/graphics/Canvas;->drawColor("
            "ILandroid/graphics/PorterDuff$Mode;)V",
            (
                "    iget-object v0, v6, Lcom/google/android/apps/inputmethod/libs/"
                "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
                "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
                "Landroid/graphics/PorterDuff$Mode;\n\n"
                "    invoke-virtual {v0, v7, v1}, Landroid/graphics/Canvas;->drawColor("
                "ILandroid/graphics/PorterDuff$Mode;)V\n\n"
                "    invoke-virtual {v0}, Landroid/graphics/Canvas;->restore()V"
                if relative == "smali/aye.smali"
                else
                "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/"
                "handwriting/keyboard/HandwritingOverlayView;->a:Landroid/graphics/Canvas;\n\n"
                "    sget-object v1, Landroid/graphics/PorterDuff$Mode;->CLEAR:"
                "Landroid/graphics/PorterDuff$Mode;\n\n"
                "    invoke-virtual {v0, v6, v1}, Landroid/graphics/Canvas;->drawColor("
                "ILandroid/graphics/PorterDuff$Mode;)V\n\n"
                "    invoke-virtual {v0}, Landroid/graphics/Canvas;->restore()V"
            ),
        )
        replace_once(
            clear_path,
            "    sget-object v5, Landroid/graphics/Region$Op;->REPLACE:"
            "Landroid/graphics/Region$Op;\n\n"
            "    move v2, v1\n\n"
            "    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->clipRect("
            "FFFFLandroid/graphics/Region$Op;)Z",
            "    invoke-virtual {v0}, Landroid/graphics/Canvas;->save()I\n\n"
            "    move v2, v1\n\n"
            "    invoke-virtual/range {v0 .. v4}, Landroid/graphics/Canvas;->clipRect(FFFF)Z",
        )

    # Gesture trails already bracket their local clear with save/restore; only
    # replace the prohibited operation there.
    replace_exactly(
        decoded / (
            "smali/com/google/android/apps/inputmethod/libs/gestureui/"
            "GestureOverlayView$a.smali"
        ),
        "Landroid/graphics/Region$Op;->REPLACE:Landroid/graphics/Region$Op;",
        "Landroid/graphics/Region$Op;->INTERSECT:Landroid/graphics/Region$Op;",
        1,
    )

    # Keep a stable three-step flow: enable, select, done. Current Gboard no
    # longer includes its legacy permission or user-metrics pages in the normal
    # first-run array; capabilities request permission only when actually used.
    first_run_activity = decoded / (
        "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity.smali"
    )
    old_page_selector = """.method protected final a()I
    .locals 4

    .prologue
    const/4 v1, 0x0

    .line 9
    .line 10
    iget-object v0, p0, Lapy;->a:[Ljava/lang/String;

    .line 11
    array-length v0, v0

    if-lez v0, :cond_0

    const/4 v0, 0x1

    .line 12
    :goto_0
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;->getIntent()Landroid/content/Intent;

    move-result-object v2

    const-string v3, "activation_page"

    invoke-virtual {v2, v3, v1}, Landroid/content/Intent;->getBooleanExtra(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :cond_1

    const v0, 0x7f0a0001

    .line 15
    :goto_1
    return v0

    :cond_0
    move v0, v1

    .line 11
    goto :goto_0

    .line 13
    :cond_1
    if-eqz v0, :cond_2

    const v0, 0x7f0a0018

    goto :goto_1

    .line 14
    :cond_2
    const v0, 0x7f0a0019

    .line 15
    goto :goto_1
.end method"""
    new_page_selector = """.method protected final a()I
    .locals 1

    .prologue
    const v0, 0x7f0a0019

    return v0
.end method"""
    replace_once(first_run_activity, old_page_selector, new_page_selector)

    # A completion marker in a separate, non-backed-up preferences file closes
    # the race between removing the guide task and IME service startup. Keep the
    # historical HAD_FIRST_RUN check as migration fallback for existing users.
    replace_once(
        first_run_activity,
        ".method public static b(Landroid/content/Context;)Z\n"
        "    .locals 1\n\n"
        "    .prologue\n"
        "    .line 2\n"
        "    sget-boolean v0, Laik;->h:Z",
        ".method public static b(Landroid/content/Context;)Z\n"
        "    .locals 1\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->isComplete(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :check_legacy_first_run\n\n"
        "    const/4 v0, 0x0\n\n"
        "    return v0\n\n"
        "    :check_legacy_first_run\n"
        "    .prologue\n"
        "    .line 2\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->prepareIncompleteGuideLaunch(Landroid/content/Context;)V\n\n"
        "    sget-boolean v0, Laik;->h:Z",
    )
    replace_once(
        first_run_activity,
        "    const/4 v0, 0x1\n\n"
        "    .line 4\n"
        "    :goto_0\n"
        "    return v0",
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->claimGuideLaunch(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    .line 4\n"
        "    :goto_0\n"
        "    return v0",
    )
    replace_once(
        first_run_activity,
        "\n\n# virtual methods\n.method protected final a()I",
        "\n\n# virtual methods\n.method public onCreate(Landroid/os/Bundle;)V\n"
        "    .locals 1\n\n"
        "    invoke-static {}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->activityCreated()V\n\n"
        "    invoke-super {p0, p1}, Lapy;->onCreate(Landroid/os/Bundle;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->isComplete(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :created\n\n"
        "    # A late singleTask intent must be discarded silently. Sending the\n"
        "    # normal HOME intent here behaves like a second Home press and can\n"
        "    # open a third-party launcher's app drawer.\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->finishAndRemoveTask()V\n\n"
        "    :created\n"
        "    return-void\n"
        ".end method\n\n"
        ".method protected onDestroy()V\n"
        "    .locals 0\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->activityDestroyed(Landroid/content/Context;)V\n\n"
        "    invoke-super {p0}, Lapy;->onDestroy()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public final completeGuide()V\n"
        "    .locals 2\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->complete(Landroid/content/Context;)V\n\n"
        "    new-instance v0, Landroid/content/Intent;\n\n"
        "    const-class v1, Lcom/google/android/apps/inputmethod/pinyin/preference/"
        "SettingsActivity;\n\n"
        "    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/"
        "content/Context;Ljava/lang/Class;)V\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;->startActivity(Landroid/content/Intent;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->finish()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public final exitGuide()V\n"
        "    .locals 2\n\n"
        "    new-instance v0, Landroid/content/Intent;\n\n"
        "    const-string v1, \"android.intent.action.MAIN\"\n\n"
        "    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V\n\n"
        "    const-string v1, \"android.intent.category.HOME\"\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->addCategory("
        "Ljava/lang/String;)Landroid/content/Intent;\n\n"
        "    const/high16 v1, 0x14000000\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)"
        "Landroid/content/Intent;\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;->startActivity(Landroid/content/Intent;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->finishAndRemoveTask()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method public onBackPressed()V\n"
        "    .locals 2\n\n"
        "    iget-object v0, p0, Lapy;->a:Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/widget/BidiViewPager;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    if-lez v1, :exit_guide\n\n"
        "    add-int/lit8 v1, v1, -0x1\n\n"
        "    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->b(I)V\n\n"
        "    return-void\n\n"
        "    :exit_guide\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->exitGuide()V\n\n"
        "    return-void\n"
        ".end method\n\n"
        ".method protected final a()I",
    )

    # The first-run footer uses the framework's existing navi_skip slot as a
    # Previous button. Keep the same listener's original Finish behavior for
    # feature-tour activities, but move one page back in Pinyin first-run.
    previous_listener = decoded / "smali/apz.smali"
    replace_once(
        previous_listener,
        ".method public final onClick(Landroid/view/View;)V\n"
        "    .locals 1\n\n"
        "    .prologue\n"
        "    .line 2\n"
        "    iget-object v0, p0, Lapz;->a:Lapy;\n\n"
        "    invoke-virtual {v0}, Lapy;->finish()V\n\n"
        "    .line 3\n"
        "    return-void\n"
        ".end method",
        ".method public final onClick(Landroid/view/View;)V\n"
        "    .locals 2\n\n"
        "    iget-object v0, p0, Lapz;->a:Lapy;\n\n"
        "    instance-of v1, v0, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;\n\n"
        "    if-eqz v1, :finish_feature_activity\n\n"
        "    iget-object v0, v0, Lapy;->a:Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/widget/BidiViewPager;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    if-lez v1, :done\n\n"
        "    add-int/lit8 v1, v1, -0x1\n\n"
        "    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->b(I)V\n\n"
        "    goto :done\n\n"
        "    :finish_feature_activity\n"
        "    invoke-virtual {v0}, Lapy;->finish()V\n\n"
        "    :done\n"
        "    return-void\n"
        ".end method",
    )

    # On the last first-run page the right-side Next slot becomes Finish,
    # records setup atomically, opens Google Pinyin settings, and finishes the
    # guide without issuing a HOME action.
    next_listener = decoded / "smali/aqa.smali"
    replace_once(
        next_listener,
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    .line 5\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;",
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/BidiViewPager;->a()I\n\n"
        "    move-result v1\n\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;\n\n"
        "    instance-of v2, v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    if-eqz v2, :continue_next\n\n"
        "    iget-object v2, v0, Lapy;->a:[I\n\n"
        "    array-length v2, v2\n\n"
        "    add-int/lit8 v2, v2, -0x1\n\n"
        "    if-ne v1, v2, :continue_next\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;->completeGuide()V\n\n"
        "    return-void\n\n"
        "    :continue_next\n"
        "    .line 5\n"
        "    iget-object v0, p0, Laqa;->a:Lapy;",
    )

    # Page selection owns footer visibility, Next/Finish text and initial enabled
    # state. Run this after old generic footer logic so first/last rules win.
    page_adapter = decoded / "smali/aqc.smali"
    replace_once(
        page_adapter,
        "    :cond_3\n"
        "    return-void\n\n"
        "    :cond_4",
        "    :cond_3\n"
        "    invoke-virtual {p0, p1}, Laqc;->a(I)I\n\n"
        "    move-result v4\n\n"
        "    iget-object v2, p0, Laqc;->a:Lapy;\n\n"
        "    invoke-static {v2, v4, p2}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/FirstRunNavigationCompat;->update(Lapy;ILjava/lang/Object;)V\n\n"
        "    return-void\n\n"
        "    :cond_4",
    )

    # Completing Enable/Select used to auto-advance through Lapt. Keep the page
    # in place and only unlock Next, so navigation is explicit and predictable.
    completion_runnable = decoded / "smali/apt.smali"
    replace_once(
        completion_runnable,
        "    check-cast v0, Lapy;\n\n"
        "    iget-object v1, p0, Lapt;->a:Lapr;",
        "    check-cast v0, Lapy;\n\n"
        "    instance-of v1, v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    if-eqz v1, :original_completion\n\n"
        "    invoke-static {v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "FirstRunNavigationCompat;->markCurrentComplete(Lapy;)V\n\n"
        "    return-void\n\n"
        "    :original_completion\n"
        "    iget-object v1, p0, Lapt;->a:Lapr;",
    )

    # Keep the original welcome/close control as a plain finish. The actual
    # Setup Done action records completion and opens Google Pinyin settings,
    # matching the original post-setup destination without sending HOME.
    setup_done_listener = decoded / "smali/aqe.smali"
    replace_once(
        setup_done_listener,
        "    invoke-virtual {v0}, Lapy;->finish()V",
        "    check-cast v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/"
        "PinyinFirstRunActivity;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/pinyin/"
        "firstrun/PinyinFirstRunActivity;->completeGuide()V",
    )

    # The left list scrolls correctly, but its original starting SoftKey is
    # selected on release. Detect actual pointer displacement directly in the
    # list (without GestureDetector heuristics) and replace UP with CANCEL.
    scroll_holder = decoded / "smali/awo.smali"
    replace_once(
        scroll_holder,
        ".field private d:I\n",
        ".field private d:I\n\n"
        ".field private compatDownScrollY:I\n\n"
        ".field private compatMoved:Z\n",
    )
    old_touch = """.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 3

    .prologue
    .line 14
    invoke-super {p0, p1}, Landroid/widget/ScrollView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    .line 15
    iget-object v1, p0, Lawo;->a:Landroid/view/GestureDetector;

    invoke-virtual {v1, p1}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 16
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    const/4 v2, 0x1

    if-ne v1, v2, :cond_0

    iget-object v1, p0, Lawo;->a:Lawp;

    iget-boolean v1, v1, Lawp;->a:Z

    if-eqz v1, :cond_0

    .line 17
    const/4 v1, 0x3

    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->setAction(I)V

    .line 18
    :cond_0
    return v0
.end method"""
    new_touch = """.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 4

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v1

    if-nez v1, :dispatch

    invoke-virtual {p0}, Lawo;->getScrollY()I

    move-result v2

    iput v2, p0, Lawo;->compatDownScrollY:I

    const/4 v2, 0x0

    iput-boolean v2, p0, Lawo;->compatMoved:Z

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->reset()V

    :dispatch
    invoke-super {p0, p1}, Landroid/widget/ScrollView;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    const/4 v2, 0x2

    if-ne v1, v2, :done

    iget-boolean v2, p0, Lawo;->compatMoved:Z

    if-nez v2, :done

    invoke-virtual {p0}, Lawo;->getScrollY()I

    move-result v2

    iget v3, p0, Lawo;->compatDownScrollY:I

    if-ne v2, v3, :mark_moved

    goto :done

    :mark_moved
    const/4 v2, 0x1

    iput-boolean v2, p0, Lawo;->compatMoved:Z

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/ScrollTouchCompat;->markScrolling()V

    :done
    return v0
.end method

.method public onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 1

    invoke-super {p0, p1}, Landroid/widget/ScrollView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    move-result v0

    return v0
.end method"""
    replace_once(scroll_holder, old_touch, new_touch)

    # Keep pageable holders' original order: the pager must see ACTION_UP before
    # the click-cancellation helper mutates it. v5 reversed this order and made
    # every genuine page swipe look like ACTION_CANCEL, forcing users to drag
    # beyond half a page before the page could change.
    #
    # Android now gives the pageable holder a transformed MotionEvent copy, so
    # aws cancelling only that copy does not reliably cancel SoftKeyboardView's
    # custom key pipeline. Preserve aws' own CANCEL and additionally bridge its
    # confirmed paging-touch-slop state to the outer event, matching Gboard's
    # ohc -> rzb -> SoftKeyboardView cancellation protocol.
    pageable_touch = decoded / "smali/aws.smali"
    replace_once(
        pageable_touch,
        "    .line 13\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 14\n",
        "    .line 13\n"
        "    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->markScrolling()V\n\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 14\n",
    )
    replace_once(
        pageable_touch,
        "    .line 17\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 5\n",
        "    .line 17\n"
        "    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->markScrolling()V\n\n"
        "    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->setAction(I)V\n\n"
        "    goto :goto_0\n\n"
        "    .line 5\n",
    )

    # V34: lk's legacy 25dp check compares UP against a final internal pointer
    # baseline and is always zero on current Android, making its fling branch
    # unreachable despite high VelocityTracker values. Only for the full
    # symbol/emoji subclass, rely on the existing dragging gate plus the system
    # minimum fling velocity, as RecyclerView/ViewPager2 does. Every other lk
    # user retains the original distance + velocity double gate.
    four_directional_pager = decoded / "smali/lk.smali"
    replace_once(
        four_directional_pager,
        "    iget v6, p0, Llk;->n:I\n\n"
        "    if-le v0, v6, :cond_f\n\n"
        "    invoke-static {v2}, Ljava/lang/Math;->abs(I)I",
        "    iget v6, p0, Llk;->n:I\n\n"
        "    instance-of v7, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;\n\n"
        "    if-nez v7, :compat_check_fling_velocity\n\n"
        "    if-le v0, v6, :cond_f\n\n"
        "    :compat_check_fling_velocity\n"
        "    invoke-static {v2}, Ljava/lang/Math;->abs(I)I",
    )

    # Let the ScrollView receive the original UP first so it can calculate
    # fling velocity. Only afterwards cancel the outer copy before the custom
    # keyboard handler consumes it.
    soft_keyboard = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/"
        "SoftKeyboardView.smali"
    )
    replace_once(
        soft_keyboard,
        "    .line 99\n"
        "    :cond_4\n"
        "    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchTouchEvent("
        "Landroid/view/MotionEvent;)Z\n\n"
        "    .line 100",
        "    .line 99\n"
        "    :cond_4\n"
        "    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchTouchEvent("
        "Landroid/view/MotionEvent;)Z\n\n"
        "    # Preserve ScrollView UP/fling, then cancel only the outer key event.\n"
        "    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/"
        "ScrollTouchCompat;->cancelOuterRelease(Landroid/view/MotionEvent;)V\n\n"
        "    .line 100",
    )

    # The original account-backed dictionary sync is discontinued. Never
    # construct its Google AuthHandler, even if a restored preference still
    # says that synchronization was enabled.
    account_auth_factory = decoded / "smali/aco.smali"
    replace_once(
        account_auth_factory,
        ".method public static a(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/dataservice/auth/AuthHandler;\n"
        "    .locals 1\n\n"
        "    .prologue\n"
        "    .line 39\n"
        "    invoke-static {p0}, Laco;->a(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :cond_0\n\n"
        "    new-instance v0, Lacp;\n\n"
        "    invoke-direct {v0, p0}, Lacp;-><init>(Landroid/content/Context;)V\n\n"
        "    :goto_0\n"
        "    return-object v0\n\n"
        "    :cond_0\n"
        "    const/4 v0, 0x0\n\n"
        "    goto :goto_0\n"
        ".end method",
        ".method public static a(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/dataservice/auth/AuthHandler;\n"
        "    .locals 1\n\n"
        "    const/4 v0, 0x0\n\n"
        "    return-object v0\n"
        ".end method",
    )

    # AbstractDictionarySettings persists the legacy toggle. Force its resume
    # path through the disabled branch before the now-removed Preference could
    # be dereferenced, and let the native preference wrapper persist false.
    dictionary_settings_fragment = decoded / "smali/ado.smali"
    replace_once(
        dictionary_settings_fragment,
        "    invoke-virtual {v0, v5, v1}, Lamx;->a(IZ)Z\n\n"
        "    move-result v0\n\n"
        "    .line 62\n"
        "    if-eqz v0, :cond_2",
        "    invoke-virtual {v0, v5, v1}, Lamx;->a(IZ)Z\n\n"
        "    move-result v0\n\n"
        "    const/4 v0, 0x0\n\n"
        "    .line 62\n"
        "    if-eqz v0, :cond_2",
    )

    # Remove obsolete network-facing features and their settings entry points.
    replace_once(
        decoded / "res/xml/setting_other.xml",
        '    <com.google.android.apps.inputmethod.libs.framework.preference.widget.'
        'CheckBoxPreferenceWithConfirmDialog android:persistent="true" '
        'android:title="@string/setting_user_metrics_title" '
        'android:key="@string/pref_key_enable_user_metrics" '
        'android:dialogTitle="@string/setting_user_metrics_feedback_title" '
        'android:dialogMessage="@string/setting_user_metrics_feedback_message" />\n',
        "",
    )
    replace_once(
        decoded / "res/menu/menu_settings.xml",
        '    <item android:id="@id/action_send_feedback" android:orderInCategory="2" '
        'android:title="@string/setting_send_feedback_title" '
        'android:showAsAction="never" />\n',
        "",
    )
    dictionary_settings_xml = decoded / "res/xml/setting_dictionary.xml"

    # The original Google-account dictionary sync service is no longer usable
    # with this independently signed package. Leaving its controls visible can
    # re-enable the platform SyncAdapter and repeatedly request account access.
    for obsolete_sync_preference in (
        '        <com.google.android.apps.inputmethod.libs.framework.preference.widget.'
        'AutoSyncedCheckBoxPreference android:persistent="true" '
        'android:title="@string/setting_sync_enabled_title" '
        'android:key="@string/pref_key_enable_sync_user_dictionary" />\n',
        '        <Preference android:persistent="false" '
        'android:title="@string/setting_sync_now_title" '
        'android:key="@string/setting_sync_now_key" '
        'android:dependency="@string/pref_key_enable_sync_user_dictionary" />\n',
    ):
        replace_once(dictionary_settings_xml, obsolete_sync_preference, "")

    replace_once(
        dictionary_settings_xml,
        '    <PreferenceCategory android:title="@string/setting_update_category_title">\n'
        '        <com.google.android.apps.inputmethod.libs.framework.preference.widget.'
        'AutoSyncedCheckBoxPreference android:persistent="true" '
        'android:title="@string/setting_update_enabled_title" '
        'android:key="@string/pref_key_enable_dictionary_update" />\n'
        '        <CheckBoxPreference android:persistent="true" '
        'android:title="@string/setting_update_notify_enabled_title" '
        'android:key="@string/pref_key_enable_notify_dictionary_update" '
        'android:dependency="@string/pref_key_enable_dictionary_update" />\n'
        '    </PreferenceCategory>\n',
        "",
    )

    # User-selected local SAF exports survive clear-data/uninstall. Backup and
    # the integrated import list share one persisted tree URI; configuration
    # remains outside the preferences registered with BackupAgent.
    replace_once(
        dictionary_settings_xml,
        '        <Preference android:persistent="false" '
        'android:title="@string/setting_import_user_dictionary_title" '
        'android:key="@string/setting_import_user_dictionary_key" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/setting_export_user_dictionary_title" '
        'android:key="@string/setting_export_user_dictionary_key" />',
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_current_status_title" '
        'android:key="dictionary_current_status" '
        'android:summary="@string/dictionary_current_status_summary" />\n'
        '        <CheckBoxPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_title" '
        'android:key="dictionary_auto_backup_enabled" '
        'android:summary="@string/dictionary_auto_backup_privacy_summary" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_location_title" '
        'android:key="dictionary_auto_backup_location" />\n'
        '        <ListPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_interval_title" '
        'android:key="dictionary_auto_backup_interval_days" '
        'android:entries="@array/dictionary_auto_backup_interval_entries" '
        'android:entryValues="@array/dictionary_auto_backup_interval_values" />\n'
        '        <ListPreference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_retention_title" '
        'android:key="dictionary_auto_backup_retention_count" '
        'android:entries="@array/dictionary_auto_backup_retention_entries" '
        'android:entryValues="@array/dictionary_auto_backup_retention_values" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_now_title" '
        'android:key="dictionary_auto_backup_now" />\n'
        '        <Preference android:persistent="false" '
        'android:title="@string/dictionary_auto_backup_import_title" '
        'android:key="dictionary_auto_backup_import" />',
    )

    # Restored setup flags are installation-local. Keeping HAD_FIRST_RUN or
    # USER_SELECTED_KEYBOARD from an uninstalled copy can skip or replay parts
    # of setup and bypass the original four-layout dashboard.
    backup_agent = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/BackupAgent.smali"
    )
    replace_once(
        backup_agent,
        "    invoke-super {p0, p1, p2, p3}, Landroid/app/backup/BackupAgentHelper;"
        "->onRestore(Landroid/app/backup/BackupDataInput;ILandroid/os/ParcelFileDescriptor;)V\n\n"
        "    .line 8",
        "    invoke-super {p0, p1, p2, p3}, Landroid/app/backup/BackupAgentHelper;"
        "->onRestore(Landroid/app/backup/BackupDataInput;ILandroid/os/ParcelFileDescriptor;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->clearRestoredSetupState(Landroid/content/Context;)V\n\n"
        "    .line 8",
    )

    # PinyinApp's Laym instance registers Clearcut/Primes processors, daily
    # pings and keyboard event collectors. Without it, IMetrics remains usable
    # internally but no upload processors are attached.
    replace_once(
        decoded / "smali/com/google/android/apps/inputmethod/pinyin/PinyinApp.smali",
        "    .line 16\n"
        "    :cond_1\n"
        "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/"
        "PinyinApp;->a:Laym;\n\n"
        "    if-nez v0, :cond_2\n\n"
        "    .line 17\n"
        "    new-instance v0, Laym;\n\n"
        "    invoke-direct {v0, p0}, Laym;-><init>(Landroid/app/Application;)V\n\n"
        "    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/"
        "PinyinApp;->a:Laym;\n\n"
        "    .line 18\n"
        "    :cond_2",
        "    .line 16\n"
        "    :cond_1\n"
        "    # Compatibility build: Clearcut/Primes collection is disabled.\n"
        "    .line 18\n"
        "    :cond_2",
    )

    # Remove the dead Chinese system-dictionary updater and the remaining daily
    # analytics task registration. Keep the unrelated local English model task.
    pinyin_ime = decoded / "smali/com/google/android/inputmethod/pinyin/PinyinIME.smali"
    replace_once(
        pinyin_ime,
        "    .line 5\n"
        "    invoke-static {p0}, Lamo;->a(Landroid/content/Context;)Lamo;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"new_words_update\"\n\n"
        "    new-instance v2, Lcom/google/android/apps/inputmethod/libs/hmm/sync/"
        "NewWordsUpdateTaskFactory;\n\n"
        "    const-string v3, \"https://tools.google.com/service/update?as=pinyinsysdict\"\n\n"
        "    .line 6\n"
        "    invoke-static {p0}, Lbdt;->a(Landroid/content/Context;)Lbdt;\n\n"
        "    move-result-object v4\n\n"
        "    .line 7\n"
        "    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/PinyinIME;"
        "->getResources()Landroid/content/res/Resources;\n\n"
        "    move-result-object v5\n\n"
        "    const v6, 0x7f110252\n\n"
        "    invoke-virtual {v5, v6}, Landroid/content/res/Resources;"
        "->getString(I)Ljava/lang/String;\n\n"
        "    move-result-object v5\n\n"
        "    invoke-direct {v2, p0, v3, v4, v5}, Lcom/google/android/apps/inputmethod/"
        "libs/hmm/sync/NewWordsUpdateTaskFactory;-><init>(Landroid/content/Context;"
        "Ljava/lang/String;Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;Ljava/lang/String;)V\n\n"
        "    .line 8\n"
        "    invoke-virtual {v0, v1, v2}, Lamo;->a(Ljava/lang/String;"
        "Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "PeriodicalTaskFactory;)V\n\n",
        "",
    )
    replace_once(
        pinyin_ime,
        "    .line 11\n"
        "    invoke-virtual {p0}, Landroid/content/Context;->getResources()"
        "Landroid/content/res/Resources;\n\n"
        "    move-result-object v0\n\n"
        "    const v1, 0x7f0b000b\n\n"
        "    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getBoolean(I)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :cond_0\n\n"
        "    .line 12\n"
        "    invoke-static {p0}, Lamo;->a(Landroid/content/Context;)Lamo;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"daily_ping_task\"\n\n"
        "    new-instance v2, Lazm;\n\n"
        "    invoke-direct {v2}, Lazm;-><init>()V\n\n"
        "    invoke-virtual {v0, v1, v2}, Lamo;->a(Ljava/lang/String;"
        "Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "PeriodicalTaskFactory;)V\n\n"
        "    .line 13\n"
        "    :cond_0",
        "    .line 13\n"
        "    :cond_0",
    )

    # Queue a due local export after Pinyin has submitted/completed both Chinese
    # and English save paths. The helper is a no-op unless explicitly enabled.
    replace_once(
        pinyin_ime,
        "    .line 22\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->saveDictionaryNow(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    .line 23",
        "    .line 22\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->saveDictionaryNow(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    const/4 v0, 0x0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V\n\n"
        "    .line 23",
    )
    replace_once(
        pinyin_ime,
        "    .line 32\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->launchTaskIfNeeded(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    .line 33",
        "    .line 32\n"
        "    invoke-static {p0}, Lagb;->a(Landroid/content/Context;)Lagb;\n\n"
        "    move-result-object v0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->launchTaskIfNeeded(Landroid/content/Context;"
        "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;)V\n\n"
        "    const/4 v0, 0x0\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryAutoBackupCompat;->request(Landroid/content/Context;Z)V\n\n"
        "    .line 33",
    )

    # Remove the dictionary-update permission feature registration.
    replace_once(
        decoded / "smali/com/google/android/apps/inputmethod/pinyin/PinyinApp.smali",
        "    .line 8\n"
        "    const v1, 0x7f110252\n\n"
        "    const v2, 0x7f1103ad\n\n"
        "    new-array v3, v7, [Ljava/lang/String;\n\n"
        "    const-string v4, \"android.permission.INTERNET\"\n\n"
        "    aput-object v4, v3, v5\n\n"
        "    const-string v4, \"android.permission.ACCESS_NETWORK_STATE\"\n\n"
        "    aput-object v4, v3, v6\n\n"
        "    invoke-virtual {v0, v1, v2, v3}, Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/FeaturePermissionsManager;->a(II[Ljava/lang/String;)V\n\n",
        "",
    )

    # Recover interrupted dictionary rotations before enrollment. If native
    # loading fails, retry once with the previous known-good rolling backup.
    engine_factory = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory.smali"
    )
    replace_once(
        engine_factory,
        ".method public final enrollMutableDictionary(Landroid/content/Context;"
        "Ljava/lang/String;II)V\n"
        "    .locals 10\n\n"
        "    .prologue\n"
        "    .line 289\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;->getDataManager()Lcom/google/android/apps/"
        "inputmethod/libs/hmm/DataManager;",
        ".method public final enrollMutableDictionary(Landroid/content/Context;"
        "Ljava/lang/String;II)V\n"
        "    .locals 10\n\n"
        "    .prologue\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->prepareForLoad(Landroid/content/Context;"
        "Ljava/lang/String;)V\n\n"
        "    .line 289\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "AbstractHmmEngineFactory;->getDataManager()Lcom/google/android/apps/"
        "inputmethod/libs/hmm/DataManager;",
    )
    replace_once(
        engine_factory,
        "    .line 299\n"
        "    :try_start_4\n"
        "    invoke-virtual {v7}, Ljava/io/FileInputStream;->close()V\n"
        "    :try_end_4\n"
        "    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0\n\n"
        "    .line 303\n"
        "    :cond_2",
        "    .line 299\n"
        "    :try_start_4\n"
        "    invoke-virtual {v7}, Ljava/io/FileInputStream;->close()V\n"
        "    :try_end_4\n"
        "    .catch Ljava/io/IOException; {:try_start_4 .. :try_end_4} :catch_0\n\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->recoverAfterLoadFailure(Landroid/content/"
        "Context;Ljava/lang/String;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :cond_2\n\n"
        "    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/apps/"
        "inputmethod/libs/hmm/AbstractHmmEngineFactory;->enrollMutableDictionary("
        "Landroid/content/Context;Ljava/lang/String;II)V\n\n"
        "    return-void\n\n"
        "    .line 303\n"
        "    :cond_2",
    )
    replace_once(
        engine_factory,
        "    :catch_0\n"
        "    move-exception v1\n\n"
        "    goto :goto_1\n"
        ".end method",
        "    :catch_0\n"
        "    move-exception v1\n\n"
        "    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/"
        "DictionaryRecoveryCompat;->recoverAfterLoadFailure(Landroid/content/"
        "Context;Ljava/lang/String;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :goto_1\n\n"
        "    invoke-virtual {p0, p1, p2, p3, p4}, Lcom/google/android/apps/"
        "inputmethod/libs/hmm/AbstractHmmEngineFactory;->enrollMutableDictionary("
        "Landroid/content/Context;Ljava/lang/String;II)V\n\n"
        "    return-void\n"
        ".end method",
    )

    # Keep one rolling backup after a successful atomic file rotation instead
    # of immediately deleting the only previous known-good dictionary.
    dictionary_accessor = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor.smali"
    )
    replace_once(
        dictionary_accessor,
        "    .line 102\n"
        "    :cond_8\n"
        "    :try_start_3\n"
        "    invoke-virtual {v4}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v0\n\n"
        "    if-nez v0, :cond_9\n\n"
        "    .line 103\n"
        "    const-string v0, \"error deleting file: %s\"\n\n"
        "    const/4 v5, 0x1\n\n"
        "    new-array v5, v5, [Ljava/lang/Object;\n\n"
        "    const/4 v6, 0x0\n\n"
        "    invoke-virtual {v4}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;\n\n"
        "    move-result-object v7\n\n"
        "    aput-object v7, v5, v6\n\n"
        "    invoke-static {v0, v5}, Lalg;->b(Ljava/lang/String;[Ljava/lang/Object;)V\n"
        "    :try_end_3\n"
        "    .catchall {:try_start_3 .. :try_end_3} :catchall_0\n\n"
        "    .line 104\n"
        "    :cond_9",
        "    .line 102\n"
        "    :cond_8\n"
        "    :try_start_3\n"
        "    # Compatibility build: retain the previous known-good dictionary as _bak.\n"
        "    invoke-virtual {v4}, Ljava/io/File;->exists()Z\n\n"
        "    move-result v0\n"
        "    :try_end_3\n"
        "    .catchall {:try_start_3 .. :try_end_3} :catchall_0\n\n"
        "    .line 104\n"
        "    :cond_9",
    )

    # Serialize scheduled and lifecycle-forced saves so separate task instances
    # cannot rotate the same main/_bak/_tmp paths concurrently. Current Gboard
    # likewise uses one class-wide monitor around its save runnable.
    save_dictionary_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask.smali"
    )
    replace_once(
        save_dictionary_task,
        ".field public static sRunningTasks:Ljava/util/Set;\n"
        "    .annotation system Ldalvik/annotation/Signature;\n"
        "        value = {\n"
        "            \"Ljava/util/Set\",\n"
        "            \"<\",\n"
        "            \"Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;\",\n"
        "            \">;\"\n"
        "        }\n"
        "    .end annotation\n"
        ".end field",
        ".field public static sRunningTasks:Ljava/util/Set;\n"
        "    .annotation system Ldalvik/annotation/Signature;\n"
        "        value = {\n"
        "            \"Ljava/util/Set\",\n"
        "            \"<\",\n"
        "            \"Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;\",\n"
        "            \">;\"\n"
        "        }\n"
        "    .end annotation\n"
        ".end field\n\n"
        ".field public static final sSaveLock:Ljava/lang/Object;",
    )
    replace_once(
        save_dictionary_task,
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sRunningTasks:Ljava/util/Set;\n\n"
        "    .line 49",
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sRunningTasks:Ljava/util/Set;\n\n"
        "    new-instance v0, Ljava/lang/Object;\n\n"
        "    invoke-direct {v0}, Ljava/lang/Object;-><init>()V\n\n"
        "    sput-object v0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    .line 49",
    )
    replace_once(
        save_dictionary_task,
        ".method saveDictionaries()V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    .line 7",
        ".method saveDictionaries()V\n"
        "    .locals 5\n\n"
        "    .prologue\n"
        "    sget-object v4, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    monitor-enter v4\n\n"
        "    :try_start_save\n"
        "    .line 7",
    )
    replace_once(
        save_dictionary_task,
        "    invoke-virtual {v0, v1, v2, v3}, Lamx;->a(Ljava/lang/String;J)V\n\n"
        "    .line 14\n"
        "    return-void\n"
        ".end method",
        "    invoke-virtual {v0, v1, v2, v3}, Lamx;->a(Ljava/lang/String;J)V\n"
        "    :try_end_save\n"
        "    .catchall {:try_start_save .. :try_end_save} :catchall_save\n\n"
        "    monitor-exit v4\n\n"
        "    .line 14\n"
        "    return-void\n\n"
        "    :catchall_save\n"
        "    move-exception v0\n\n"
        "    monitor-exit v4\n\n"
        "    throw v0\n"
        ".end method",
    )

    # A lifecycle-forced save runs synchronously and can otherwise overlap a
    # background manual/automatic exporter. Keep native accessor enumeration
    # under the same process-wide lock as dictionary rotation.
    export_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/userdictionary/"
        "UserDictExportTask.smali"
    )
    replace_once(
        export_task,
        ".method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Boolean;\n"
        "    .locals 2\n\n"
        "    .prologue\n"
        "    .line 7\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->openDictionaries()"
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;\n\n"
        "    move-result-object v0\n\n"
        "    .line 8\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->exportUserDictionary("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Z\n\n"
        "    move-result v1\n\n"
        "    .line 9\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->closeDictionaries("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)V\n\n"
        "    .line 10\n"
        "    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;\n\n"
        "    move-result-object v0\n\n"
        "    return-object v0\n"
        ".end method",
        ".method protected varargs doInBackground([Ljava/lang/Void;)Ljava/lang/Boolean;\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    sget-object v2, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "SaveDictionaryTask;->sSaveLock:Ljava/lang/Object;\n\n"
        "    monitor-enter v2\n\n"
        "    :try_start_export_lock\n"
        "    .line 7\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->openDictionaries()"
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;\n\n"
        "    move-result-object v0\n\n"
        "    .line 8\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->exportUserDictionary("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)Z\n\n"
        "    move-result v1\n\n"
        "    .line 9\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/"
        "userdictionary/UserDictExportTask;->closeDictionaries("
        "[Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;)V\n\n"
        "    .line 10\n"
        "    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;\n\n"
        "    move-result-object v0\n"
        "    :try_end_export_lock\n"
        "    .catchall {:try_start_export_lock .. :try_end_export_lock} "
        ":catchall_export_lock\n\n"
        "    monitor-exit v2\n\n"
        "    return-object v0\n\n"
        "    :catchall_export_lock\n"
        "    move-exception v3\n\n"
        "    monitor-exit v2\n\n"
        "    throw v3\n"
        ".end method",
    )

    # Keep the original confirmed "Clear user dictionary" flow, but run only
    # its native local task. The removed second task was an obsolete remote
    # Delight sync clear and would otherwise enter the deleted account path.
    local_dictionary_clear_controller = decoded / "smali/bdz.smali"
    replace_once(
        local_dictionary_clear_controller,
        "    .line 30\n"
        "    invoke-static {}, Laib;->a()Laib;\n\n"
        "    move-result-object v0\n\n"
        "    const-string v1, \"delight4_user_dict_clear\"\n\n"
        "    new-instance v2, Lafu;\n\n"
        "    iget-object v3, p0, Lbdz;->a:Landroid/content/Context;\n\n"
        "    iget-object v4, p0, Lbdz;->b:Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;\n\n"
        "    const-string v5, \"android-pinyin-input\"\n\n"
        "    const/4 v6, 0x0\n\n"
        "    invoke-direct {v2, v3, v4, v5, v6}, Lafu;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/TaskListener;Ljava/lang/String;B)V\n\n"
        "    invoke-virtual {v0, v1, v2, v8, v9}, Laib;->a(Ljava/lang/String;Lcom/google/android/apps/inputmethod/libs/framework/core/TaskFactory;J)V\n\n"
        "    .line 31",
        "    .line 31",
    )

    # Retained rolling backups must not resurrect data after an intentional
    # dictionary deletion. Purge sidecars only when main was deleted or is
    # already absent; preserve them if deletion itself failed.
    replace_once(
        engine_factory,
        "    invoke-virtual {v1}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v1\n\n"
        "    .line 358\n"
        "    sget-boolean v2, Laik;->b:Z",
        "    move-object v3, v1\n\n"
        "    invoke-virtual {v3}, Ljava/io/File;->delete()Z\n\n"
        "    move-result v1\n\n"
        "    if-nez v1, :purge_deleted_dictionary_sidecars\n\n"
        "    invoke-virtual {v3}, Ljava/io/File;->exists()Z\n\n"
        "    move-result v2\n\n"
        "    if-nez v2, :skip_deleted_dictionary_sidecars\n\n"
        "    :purge_deleted_dictionary_sidecars\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;->getMutableDictionaryFileName(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)Ljava/lang/String;\n\n"
        "    move-result-object v2\n\n"
        "    invoke-static {p1, v2}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->purgeSidecars(Landroid/content/Context;Ljava/lang/String;)V\n\n"
        "    :skip_deleted_dictionary_sidecars\n"
        "    .line 358\n"
        "    sget-boolean v2, Laik;->b:Z",
    )

    # A user-requested clear is destructive: once the empty dictionary has
    # persisted successfully, remove the previous non-empty rolling copy and
    # any stale recovery artifacts.
    user_dict_clear_task = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/hmm/sync/UserDictClearTask.smali"
    )
    replace_once(
        user_dict_clear_task,
        "    if-eqz v7, :cond_1\n\n"
        "    .line 28\n"
        "    sget-object v7, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;",
        "    if-eqz v7, :cond_1\n\n"
        "    iget-object v7, p0, Lcom/google/android/apps/inputmethod/libs/hmm/sync/UserDictClearTask;->mContext:Landroid/content/Context;\n\n"
        "    invoke-virtual {v4, v8}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;->getMutableDictionaryFileName(Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;)Ljava/lang/String;\n\n"
        "    move-result-object v9\n\n"
        "    invoke-static {v7, v9}, Lcom/google/android/inputmethod/pinyin/DictionaryRecoveryCompat;->purgeSidecars(Landroid/content/Context;Ljava/lang/String;)V\n\n"
        "    .line 28\n"
        "    sget-object v7, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;->USER_DICTIONARY:Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;",
    )

    # Use a distinct application ID so the compatibility build can coexist
    # with the official Google-signed package for side-by-side comparison.
    manifest = decoded / "AndroidManifest.xml"
    replace_once(
        manifest,
        'package="com.google.android.inputmethod.pinyin"',
        f'package="{application_id}"',
    )
    if debuggable:
        # Debug mode is deliberately build-time-only and restricted to isolated
        # audit IDs. It enables run-as, JDWP, heapprofd/Perfetto and debugger
        # attachment without changing the release-like build by default.
        replace_once(
            manifest,
            "    <application android:backupAgent=",
            '    <application android:debuggable="true" '
            'android:enableOnBackInvokedCallback="false" android:backupAgent=',
        )
    else:
        replace_once(
            manifest,
            "    <application android:backupAgent=",
            '    <application android:enableOnBackInvokedCallback="false" '
            'android:backupAgent=',
        )
    replace_once(
        manifest,
        'android:authorities="com.google.android.inputmethod.pinyin.user_dictionary"',
        f'android:authorities="{application_id}.user_dictionary"',
    )
    replace_once(
        decoded / "res/values/strings.xml",
        '<string name="user_dictionary_authority">com.google.android.inputmethod.pinyin.user_dictionary</string>',
        f'<string name="user_dictionary_authority">{application_id}.user_dictionary</string>',
    )
    replace_once(
        decoded / "smali/ayn.smali",
        '    const-string v2, "com.google.android.inputmethod.pinyin"',
        f'    const-string v2, "{application_id}"',
    )

    # The discontinued Google-account dictionary sync cannot authenticate an
    # independently signed package. Android otherwise rediscovers its hidden
    # SyncAdapter at boot and repeatedly asks the user for Google-account
    # access. SAF backup providers (including Google Drive) use persisted URI
    # grants and do not depend on any of these account/sync permissions.
    for obsolete_account_permission in (
        "android.permission.USE_CREDENTIALS",
        "android.permission.GET_ACCOUNTS",
        "android.permission.MANAGE_ACCOUNTS",
        "android.permission.READ_SYNC_SETTINGS",
        "android.permission.WRITE_SYNC_SETTINGS",
    ):
        replace_once(
            manifest,
            f'    <uses-permission android:name="{obsolete_account_permission}"/>\n',
            "",
        )

    obsolete_sync_components = (
        '        <service android:exported="true" android:label="@string/ime_name_ref" '
        'android:name="com.google.android.apps.inputmethod.pinyin.preference.SyncService">\n'
        '            <intent-filter>\n'
        '                <action android:name="android.content.SyncAdapter"/>\n'
        '            </intent-filter>\n'
        '            <meta-data android:name="android.content.SyncAdapter" '
        'android:resource="@xml/sync_adapter"/>\n'
        '        </service>\n',
        '        <activity android:label="@string/android_account_title" '
        'android:name="com.google.android.apps.inputmethod.libs.dataservice.auth.AndroidAccountActivity" '
        'android:theme="@style/SettingsTheme"/>\n',
        f'        <provider android:authorities="{application_id}.user_dictionary" '
        'android:exported="false" '
        'android:name="com.google.android.apps.inputmethod.libs.dataservice.sync.StubProvider" '
        'android:syncable="true"/>\n',
    )
    for obsolete_sync_component in obsolete_sync_components:
        replace_once(manifest, obsolete_sync_component, "")

    for obsolete_component in (
        '        <activity android:exported="false" android:name="com.google.android.apps.inputmethod.pinyin.preference.PinyinUserFeedbackActivity"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.UserFeedbackActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.PreviewActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.ShowTextActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <activity android:excludeFromRecents="true" android:name="com.google.userfeedback.android.api.ShowStringListActivity" android:theme="@android:style/Theme.Dialog"/>\n',
        '        <service android:name="com.google.userfeedback.android.api.SendUserFeedbackService"/>\n',
        '        <receiver android:exported="true" android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver" android:permission="com.google.android.c2dm.permission.SEND">\n            <intent-filter>\n                <action android:name="com.google.android.c2dm.intent.RECEIVE"/>\n                <action android:name="com.google.android.c2dm.intent.REGISTRATION"/>\n            </intent-filter>\n        </receiver>\n',
        '        <receiver android:exported="false" android:name="com.google.firebase.iid.FirebaseInstanceIdInternalReceiver"/>\n',
        '        <service android:exported="true" android:name="com.google.firebase.iid.FirebaseInstanceIdService">\n            <intent-filter android:priority="-500">\n                <action android:name="com.google.firebase.INSTANCE_ID_EVENT"/>\n            </intent-filter>\n        </service>\n',
        '        <service android:exported="true" android:name="com.firebase.jobdispatcher.GooglePlayReceiver" android:permission="com.google.android.gms.permission.BIND_NETWORK_TASK_SERVICE">\n            <intent-filter>\n                <action android:name="com.google.android.gms.gcm.ACTION_TASK_READY"/>\n            </intent-filter>\n        </service>\n',
    ):
        replace_once(manifest, obsolete_component, "")

    replace_once(
        manifest,
        '<service android:directBootAware="true" android:label="@string/ime_name_ref" '
        'android:name="com.google.android.inputmethod.pinyin.PinyinIME" '
        'android:permission="android.permission.BIND_INPUT_METHOD">',
        '<service android:directBootAware="true" android:exported="true" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.inputmethod.pinyin.PinyinIME" '
        'android:permission="android.permission.BIND_INPUT_METHOD">',
    )
    replace_once(
        manifest,
        '<activity android:enabled="@bool/show_launcher_icon" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity" '
        'android:theme="@style/SettingsTheme.Transparent">',
        '<activity android:enabled="@bool/show_launcher_icon" android:exported="true" '
        'android:label="@string/ime_name_ref" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.LauncherActivity" '
        'android:theme="@style/SettingsTheme.Transparent">',
    )
    replace_once(
        manifest,
        '    </application>\n</manifest>',
        '        <activity android:exported="true" '
        'android:label="@string/dictionary_auto_backup_import_title" '
        'android:name="com.google.android.inputmethod.pinyin.LocalBackupImportActivity" '
        'android:theme="@style/SettingsTheme">\n'
        '            <intent-filter>\n'
        '                <action android:name="android.intent.action.VIEW"/>\n'
        '                <category android:name="android.intent.category.DEFAULT"/>\n'
        '                <data android:mimeType="text/plain"/>\n'
        '            </intent-filter>\n'
        '            <intent-filter>\n'
        '                <action android:name="android.intent.action.SEND"/>\n'
        '                <category android:name="android.intent.category.DEFAULT"/>\n'
        '                <data android:mimeType="text/plain"/>\n'
        '            </intent-filter>\n'
        '        </activity>\n'
        '    </application>\n</manifest>',
    )

    replace_once(
        manifest,
        '<receiver android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
        '<receiver android:exported="false" '
        'android:name="com.google.android.apps.inputmethod.libs.framework.core.'
        'LauncherIconVisibilityInitializer">',
    )

    replace_once(
        pinyin_ime,
        "    .line 75\n"
        "    invoke-super {p0, p1, p2}, Labp;->onStartInputView("
        "Landroid/view/inputmethod/EditorInfo;Z)V\n\n"
        "    .line 77",
        "    .line 75\n"
        "    invoke-super {p0, p1, p2}, Labp;->onStartInputView("
        "Landroid/view/inputmethod/EditorInfo;Z)V\n\n"
        "    # After setup, show the original four-layout dashboard at the first\n"
        "    # eligible text field even if the IME service initialized on step 2.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->shouldForceDashboard(Landroid/content/Context;)Z\n\n"
        "    move-result v0\n\n"
        "    if-eqz v0, :first_run_dashboard_done\n\n"
        "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundleManager;\n\n"
        "    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundleManager;->a()I\n\n"
        "    move-result v1\n\n"
        "    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/PinyinIME;"
        "->shouldSwitchToDashboard(I)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :first_run_dashboard_done\n\n"
        "    const-string v1, \"dashboard\"\n\n"
        "    invoke-virtual {v0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundleManager;->b(Ljava/lang/String;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/"
        "FirstRunStateCompat;->markDashboardHandled(Landroid/content/Context;)V\n\n"
        "    :first_run_dashboard_done\n"
        "    # Android 15+: keep the non-floating IME content above system bars.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->configureImeWindow(Landroid/inputmethodservice/"
        "InputMethodService;)V\n\n"
        "    # Android 16: match the navigation area to the keyboard theme.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;"
        "->apply(Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService;)V\n\n"
        "    # Present recent, non-sensitive clipboard text as a native candidate.\n"
        "    invoke-static {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->start(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/GoogleInputMethodService;Landroid/view/inputmethod/EditorInfo;)V\n\n"
        "    .line 77",
    )

    framework = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService.smali"
    )
    replace_once(
        framework,
        "    .line 1783\n"
        "    invoke-virtual {v2, v1}, Landroid/view/Window;->setNavigationBarColor(I)V\n\n"
        "    goto/16 :goto_0",
        "    .line 1783\n"
        "    invoke-virtual {v2, v1}, Landroid/view/Window;->setNavigationBarColor(I)V\n\n"
        "    # Candidate/extension updates reset the old IME navigation bar.\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/NavigationBarCompat;"
        "->apply(Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "GoogleInputMethodService;)V\n\n"
        "    goto/16 :goto_0",
    )

    # Stop observing the clipboard as soon as the input view is no longer active.
    replace_once(
        pinyin_ime,
        "    .line 96\n"
        "    invoke-super {p0, p1}, Labp;->onFinishInputView(Z)V\n\n"
        "    .line 98",
        "    .line 96\n"
        "    invoke-static {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->stop(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/GoogleInputMethodService;)V\n\n"
        "    invoke-super {p0, p1}, Labp;->onFinishInputView(Z)V\n\n"
        "    .line 98",
    )

    input_bundle = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/InputBundle.smali"
    )
    # Intercept both candidate-selection paths before a custom payload can
    # reach an HMM implementation that requires an Integer payload.
    replace_once(
        input_bundle,
        "    iget-object v0, v4, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "KeyData;->a:Ljava/lang/Object;\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "Candidate;\n\n"
        "    .line 256",
        "    iget-object v0, v4, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "KeyData;->a:Ljava/lang/Object;\n\n"
        "    check-cast v0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "Candidate;\n\n"
        "    invoke-static {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->handleSelection(Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputBundle;Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/Candidate;)Z\n\n"
        "    move-result v1\n\n"
        "    if-eqz v1, :compat_not_clipboard_event\n\n"
        "    move v0, v2\n\n"
        "    goto/16 :goto_0\n\n"
        "    :compat_not_clipboard_event\n"
        "    .line 256",
    )
    # Inspect each candidate batch at the InputBundle boundary. Real Chinese,
    # English or handwriting candidates suppress the clipboard item for the
    # whole composition; an empty/idle cycle may restore it afterward.
    replace_once(
        input_bundle,
        "    .prologue\n"
        "    .line 549\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundle;->b:I",
        "    .prologue\n"
        "    invoke-static {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->decorateCandidates(Ljava/util/List;)Ljava/util/List;\n\n"
        "    move-result-object p1\n\n"
        "    .line 549\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "InputBundle;->b:I",
    )
    replace_once(
        input_bundle,
        "    .prologue\n"
        "    .line 545\n"
        "    const/4 v0, 0x0",
        "    .prologue\n"
        "    invoke-static {}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->candidatesUpdated()V\n\n"
        "    .line 545\n"
        "    const/4 v0, 0x0",
    )

    fixed_candidates = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/keyboard/widget/"
        "FixedSizeCandidatesHolderView.smali"
    )
    replace_once(
        fixed_candidates,
        ".method public appendCandidates(Ljava/util/List;)I\n    .locals 11",
        ".method public appendCandidates(Ljava/util/List;)I\n    .locals 12",
    )
    replace_once(
        fixed_candidates,
        "    iget-object v9, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/FixedSizeCandidatesHolderView;->a:Lavp;\n\n"
        "    iget v10, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I\n\n"
        "    .line 62",
        "    move-object v11, v5\n\n"
        "    iget-object v9, p0, Lcom/google/android/apps/inputmethod/libs/framework/"
        "keyboard/widget/FixedSizeCandidatesHolderView;->a:Lavp;\n\n"
        "    iget v10, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I\n\n"
        "    .line 62",
    )
    replace_once(
        fixed_candidates,
        "    invoke-virtual {v4, v5, v2}, Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/SoftKeyView;->a(IZ)V\n\n"
        "    .line 70",
        "    invoke-virtual {v4, v5, v2}, Lcom/google/android/apps/inputmethod/libs/"
        "framework/keyboard/SoftKeyView;->a(IZ)V\n\n"
        "    invoke-static {v4, v11}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->decorateView(Lcom/google/android/apps/inputmethod/"
        "libs/framework/keyboard/SoftKeyView;Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;)V\n\n"
        "    .line 70",
    )
    replace_once(
        fixed_candidates,
        "    .line 135\n"
        "    :cond_16\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I",
        "    .line 135\n"
        "    :cond_16\n"
        "    invoke-static {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat;->centerSingleClipboardCandidate(Lcom/google/android/"
        "apps/inputmethod/libs/framework/keyboard/widget/"
        "FixedSizeCandidatesHolderView;)V\n\n"
        "    iget v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/"
        "widget/FixedSizeCandidatesHolderView;->c:I",
    )
    replace_once(
        input_bundle,
        ".method public selectTextCandidate(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;Z)V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    const/4 v3, 0x0\n\n"
        "    .line 502",
        ".method public selectTextCandidate(Lcom/google/android/apps/inputmethod/libs/"
        "framework/core/Candidate;Z)V\n"
        "    .locals 4\n\n"
        "    .prologue\n"
        "    const/4 v3, 0x0\n\n"
        "    invoke-static {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/ClipboardCandidateCompat;->handleSelection(Lcom/google/android/apps/"
        "inputmethod/libs/framework/core/InputBundle;Lcom/google/android/apps/inputmethod/"
        "libs/framework/core/Candidate;)Z\n\n"
        "    move-result v0\n\n"
        "    if-nez v0, :cond_3\n\n"
        "    .line 502",
    )

    # Preserve an explicit automatic-theme mode, resolve it to the original
    # Material light/dark pair before theme construction, and update it before
    # the existing configuration-change teardown rebuilds the keyboard view.
    replace_once(
        framework,
        "    .line 76\n"
        "    invoke-super {p0}, Landroid/inputmethodservice/InputMethodService;->onCreate()V\n\n"
        "    .line 77",
        "    .line 76\n"
        "    invoke-super {p0}, Landroid/inputmethodservice/InputMethodService;->onCreate()V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->applyOnCreate(Landroid/content/Context;)Z\n\n"
        "    .line 77",
    )
    replace_once(
        framework,
        ".method public onConfigurationChanged(Landroid/content/res/Configuration;)V\n"
        "    .locals 9",
        ".method public onConfigurationChanged(Landroid/content/res/Configuration;)V\n"
        "    .locals 10",
    )
    replace_once(
        framework,
        "    .line 341\n"
        "    :cond_0\n"
        "    new-array v0, v2, [Ljava/lang/Object;",
        "    .line 341\n"
        "    :cond_0\n"
        "    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->applyIfEnabled(Landroid/content/Context;"
        "Landroid/content/res/Configuration;)Z\n\n"
        "    move-result v9\n\n"
        "    new-array v0, v2, [Ljava/lang/Object;",
    )
    # UI-mode changes enter the legacy broad configuration path, which tears
    # down InputView but does not itself call onCreateInputView(). Rebuild once
    # after the framework has accepted the new Configuration and only when the
    # automatic resolver changed the concrete theme pair.
    replace_once(
        framework,
        "    .line 362\n"
        "    invoke-super {p0, p1}, Landroid/inputmethodservice/InputMethodService;"
        "->onConfigurationChanged(Landroid/content/res/Configuration;)V\n\n"
        "    goto :goto_0",
        "    .line 362\n"
        "    invoke-super {p0, p1}, Landroid/inputmethodservice/InputMethodService;"
        "->onConfigurationChanged(Landroid/content/res/Configuration;)V\n\n"
        "    if-eqz v9, :system_auto_theme_minor_config_done\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->logInputViewRebuild(Landroid/content/Context;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/GoogleInputMethodService;->c()V\n\n"
        "    :system_auto_theme_minor_config_done\n"
        "    goto :goto_0",
    )
    replace_once(
        framework,
        "    .line 373\n"
        "    :cond_9\n"
        "    :goto_5\n"
        "    invoke-super {p0, p1}, Landroid/inputmethodservice/InputMethodService;"
        "->onConfigurationChanged(Landroid/content/res/Configuration;)V\n\n"
        "    goto :goto_0",
        "    .line 373\n"
        "    :cond_9\n"
        "    :goto_5\n"
        "    invoke-super {p0, p1}, Landroid/inputmethodservice/InputMethodService;"
        "->onConfigurationChanged(Landroid/content/res/Configuration;)V\n\n"
        "    if-eqz v9, :system_auto_theme_config_done\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->logInputViewRebuild(Landroid/content/Context;)V\n\n"
        "    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/"
        "core/GoogleInputMethodService;->c()V\n\n"
        "    :system_auto_theme_config_done\n"
        "    goto :goto_0",
    )

    theme_selector_activity = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/theme/preference/"
        "ThemeSelectorActivity.smali"
    )
    replace_once(
        theme_selector_activity,
        "    const v0, 0x7f0401cc\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->setContentView(I)V\n\n"
        "    .line 4",
        "    const v0, 0x7f0401cc\n\n"
        "    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->setContentView(I)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "ThemeSettingsInsetsCompat;->attachSelector(Landroid/app/Activity;)V\n\n"
        "    .line 4",
    )
    # A deliberate fixed/custom theme selection exits automatic mode. Merely
    # opening and cancelling the selector does not alter the mode.
    replace_once(
        theme_selector_activity,
        "    .prologue\n"
        "    .line 153\n"
        "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->a:Lbdb;",
        "    .prologue\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->disable(Landroid/content/Context;)V\n\n"
        "    .line 153\n"
        "    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->a:Lbdb;",
    )
    replace_once(
        theme_selector_activity,
        "    .line 160\n"
        "    :cond_0\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->a(Lbaq;)V\n\n"
        "    .line 161\n"
        "    return-void",
        "    .line 160\n"
        "    :cond_0\n"
        "    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->a(Lbaq;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->captureFixedTheme(Landroid/content/Context;)V\n\n"
        "    .line 161\n"
        "    return-void",
    )
    replace_once(
        theme_selector_activity,
        "    .line 202\n"
        "    invoke-static {p0}, Lamx;->a(Landroid/content/Context;)Lamx;",
        "    .line 202\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->disable(Landroid/content/Context;)V\n\n"
        "    invoke-static {p0}, Lamx;->a(Landroid/content/Context;)Lamx;",
    )
    # Custom-theme creation, edit and deletion stay in the original selector;
    # the slot transaction is captured only when the user navigates back.
    replace_once(
        theme_selector_activity,
        "    .line 246\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->c()V\n\n"
        "    goto :goto_0",
        "    .line 246\n"
        "    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/theme/"
        "preference/ThemeSelectorActivity;->c()V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->disable(Landroid/content/Context;)V\n\n"
        "    invoke-static {p0, p3}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->reconcileCustomThemeEdit(Landroid/content/Context;"
        "Landroid/content/Intent;)V\n\n"
        "    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/"
        "SystemAutoThemeCompat;->captureFixedTheme(Landroid/content/Context;)V\n\n"
        "    goto :goto_0",
    )

    for helper_name in (
        "NavigationBarCompat.smali",
        "ScrollTouchCompat.smali",
        "DictionaryRecoveryCompat.smali",
        "EdgeToEdgeCompat.smali",
        "EdgeToEdgeCompat$BottomInsetsListener.smali",
        "EdgeToEdgeCompat$ApplyInsetsRunnable.smali",
        "EdgeToEdgeCompat$InputViewAttachListener.smali",
        "EdgeToEdgeCompat$ImeInsetsListener.smali",
        "ImeNavigationColorCompat.smali",
        "ImeNavigationColorCompat$SyncRunnable.smali",
        "ImeSurfaceRendererCompat.smali",
        "ImeSurfaceRendererCompat$SyncRunnable.smali",
        "ImeSurfaceSliceDrawable.smali",
        "ThemeSettingsInsetsCompat.smali",
        "ThemeSettingsInsetsCompat$SystemBarsListener.smali",
        "SystemAutoThemeCompat.smali",
        "SensitiveClipboardCompat.smali",
    ):
        helper_src = ROOT / "patches/smali" / helper_name
        helper_dst = decoded / "smali/com/google/android/inputmethod/pinyin" / helper_name
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        helper_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(helper_src, helper_dst)

    ime_insets_listener = decoded / (
        "smali/com/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat$ImeInsetsListener.smali"
    )

    # The user-image crop viewport must match the complete visual surface,
    # including the dynamically measured IME-owned navigation extension.
    crop_page = decoded / "smali/bcp.smali"
    replace_once(
        crop_page,
        "    invoke-static {v0, v4}, Lats;->b(Landroid/content/Context;"
        "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/"
        "KeyboardViewDef$Type;)I\n\n"
        "    move-result v4\n\n"
        "    int-to-float v4, v4",
        "    invoke-static {v0, v4}, Lats;->b(Landroid/content/Context;"
        "[Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/"
        "KeyboardViewDef$Type;)I\n\n"
        "    move-result v4\n\n"
        "    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->getNavigationBarBottomInset(Landroid/view/View;)I\n\n"
        "    move-result v5\n\n"
        "    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->stableNavigationHeightOr(I)I\n\n"
        "    move-result v5\n\n"
        "    add-int/2addr v4, v5\n\n"
        "    int-to-float v4, v4",
    )

    replace_once(
        ime_insets_listener,
        "    :done\n    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->refreshNavigationBarTheme()V\n\n"
        "    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->suppressNavigationBarContrast(Landroid/view/View;)V\n\n"
        "    return-object p2",
        "    :done\n    invoke-static {}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->refreshNavigationBarTheme()V\n\n"
        "    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/"
        "EdgeToEdgeCompat;->suppressNavigationBarContrast(Landroid/view/View;)V\n\n"
        "    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/"
        "ImeNavigationColorCompat;->schedule(Landroid/view/View;)V\n\n"
        "    return-object p2",
    )

    auto_backup_helpers = sorted(
        list((ROOT / "patches/smali").glob("DictionaryAutoBackup*.smali"))
        + list((ROOT / "patches/smali").glob("DictionaryOperationsCompat*.smali"))
        + list((ROOT / "patches/smali").glob("DictionaryHealthStatusCompat*.smali"))
        + list((ROOT / "patches/smali").glob("LocalBackupImportActivity*.smali"))
    )
    if not auto_backup_helpers:
        raise RuntimeError("Missing generated dictionary auto-backup helpers")
    for helper_src in auto_backup_helpers:
        helper_dst = decoded / "smali/com/google/android/inputmethod/pinyin" / helper_src.name
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        shutil.copyfile(helper_src, helper_dst)

    dictionary_fragment_src = ROOT / "patches/smali/DictionarySettingsFragment.smali"
    dictionary_fragment_dst = decoded / (
        "smali/com/google/android/apps/inputmethod/pinyin/preference/"
        "DictionarySettingsFragment.smali"
    )
    if not dictionary_fragment_dst.exists():
        raise RuntimeError(f"Missing dictionary settings fragment: {dictionary_fragment_dst}")
    shutil.copyfile(dictionary_fragment_src, dictionary_fragment_dst)

    first_run_helpers = (
        (
            "FirstRunNavigationCompat.smali",
            "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
            "FirstRunNavigationCompat.smali",
        ),
        (
            "FirstRunSinglePage.smali",
            "smali/com/google/android/apps/inputmethod/pinyin/firstrun/"
            "FirstRunSinglePage.smali",
        ),
        (
            "FirstRunInsetsListener.smali",
            "smali/com/google/android/inputmethod/pinyin/firstrun/"
            "FirstRunInsetsListener.smali",
        ),
        (
            "NonSwipeableFirstRunViewPager.smali",
            "smali/com/google/android/apps/inputmethod/libs/framework/firstrun/"
            "NonSwipeableFirstRunViewPager.smali",
        ),
        (
            "FirstRunStateCompat.smali",
            "smali/com/google/android/inputmethod/pinyin/firstrun/"
            "FirstRunStateCompat.smali",
        ),
        (
            "Md3SettingsCompat.smali",
            "smali/com/google/android/inputmethod/pinyin/Md3SettingsCompat.smali",
        ),
        (
            "Md3SwitchView.smali",
            "smali/com/google/android/inputmethod/pinyin/Md3SwitchView.smali",
        ),
        (
            "Md3SwitchView$AnimatorUpdateListener.smali",
            "smali/com/google/android/inputmethod/pinyin/"
            "Md3SwitchView$AnimatorUpdateListener.smali",
        ),
    )
    for helper_name, relative_destination in first_run_helpers:
        helper_src = ROOT / "patches/smali" / helper_name
        helper_dst = decoded / relative_destination
        if helper_dst.exists():
            raise RuntimeError(f"Refusing to overwrite existing helper: {helper_dst}")
        helper_dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(helper_src, helper_dst)

    candidate_src = ROOT / "patches/smali/ClipboardCandidateCompat.smali"
    candidate_dst = decoded / (
        "smali/com/google/android/apps/inputmethod/libs/framework/core/"
        "ClipboardCandidateCompat.smali"
    )
    if candidate_dst.exists():
        raise RuntimeError(f"Refusing to overwrite existing helper: {candidate_dst}")
    shutil.copyfile(candidate_src, candidate_dst)

    mode = "debuggable audit" if debuggable else "release-like"
    print(
        f"Applied Google Pinyin compatibility 4.5.2 to {decoded} "
        f"({application_id}, {mode})"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("decoded", type=Path, help="apktool decoded directory")
    parser.add_argument(
        "--application-id",
        default=FORMAL_APPLICATION_ID,
        help="application ID for coexistence builds",
    )
    parser.add_argument(
        "--debuggable",
        action="store_true",
        help="enable Android debugging for an isolated non-formal audit ID",
    )
    parser.add_argument("--version-name", default="2.0.0")
    parser.add_argument("--version-code", type=int, default=4520385)
    args = parser.parse_args()
    apply(
        args.decoded.resolve(),
        args.application_id,
        args.debuggable,
        args.version_name,
        args.version_code,
    )


if __name__ == "__main__":
    main()
