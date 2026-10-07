.class public final Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunRoutingCompat;
.super Ljava/lang/Object;


# static fields
.field private static volatile sRedirected:Z


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static consumeRedirect()Z
    .locals 2

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunRoutingCompat;->sRedirected:Z

    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunRoutingCompat;->sRedirected:Z

    return v0
.end method

.method public static redirectToModernGuide(Landroid/app/Activity;)Z
    .locals 4

    # `if-lt`, not `if-ge`: the branch target is the legacy guide, so the
    # comparison has to be "below the threshold". Written the other way round it
    # still assembles and still reads plausibly, and then every version at or
    # above the threshold keeps the legacy guide while only older ones redirect
    # - the exact inverse of the intent. This file shipped with `if-ge` from
    # 2026-10-06 until the rollout, and nothing caught it because the first-run
    # redirect had never been exercised on a device.
    #
    # The threshold equals the APK's minSdkVersion, so with the direction right
    # no supported release reaches the legacy guide: it is retained, not
    # reachable. Raising the threshold without raising minSdk is what would hand
    # a version range back to the old page, so verify_modern_settings_runtime.py
    # reads the level out of the built artifacts and requires the two to agree.
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :legacy_guide

    # An already completed guide is the legacy activity's own case to finish;
    # redirecting it here would show the settings screen instead of discarding
    # a late singleTask intent.
    #
    # `if-nez`, not `if-eqz`: this branch target is again the legacy guide, and
    # the condition for keeping it is that the guide is already complete. The
    # inverted form reads just as naturally - "if the guide is not complete, let
    # the legacy one run" - and is what shipped: it sent every incomplete launch
    # back to the legacy guide and redirected only launches that had nothing
    # left to redirect, so the redirect was dead in both directions. Same
    # failure shape as the threshold above, in the very next condition.
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->isComplete(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :legacy_guide

    new-instance v0, Landroid/content/ComponentName;

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "com.google.android.inputmethod.pinyin.modernsettings.compose.ModernFirstRunActivity"

    invoke-direct {v0, v1, v2}, Landroid/content/ComponentName;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    # Apktool-only isolated audit builds intentionally omit the Compose runtime.
    # Route only when the merged package declares the Activity, so those builds
    # keep the legacy guide instead of failing to start anything.
    #
    # getActivityInfo, not queryIntentActivities. The latter answers from the
    # intent-filter resolver, so it cannot see a host that declares no
    # <intent-filter> - and this host declares none, because the legacy activity
    # names it explicitly rather than resolving it. The query therefore always
    # came back empty and the redirect could never fire, on any version. The
    # direct lookup asks the question the comment asks, and throws when the
    # component is not declared.
    :try_start
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v0, v2}, Landroid/content/pm/PackageManager;->getActivityInfo(Landroid/content/ComponentName;I)Landroid/content/pm/ActivityInfo;
    :try_end
    .catch Landroid/content/pm/PackageManager$NameNotFoundException; {:try_start .. :try_end} :legacy_guide

    new-instance v1, Landroid/content/Intent;

    invoke-direct {v1}, Landroid/content/Intent;-><init>()V

    invoke-virtual {v1, v0}, Landroid/content/Intent;->setComponent(Landroid/content/ComponentName;)Landroid/content/Intent;

    # The launch claim stays with this activity's process. The Compose host
    # takes it over in its own onCreate, and this activity's onDestroy skips
    # releasing it, so there is no window in which IME startup could enqueue a
    # second guide.
    const/4 v3, 0x1

    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunRoutingCompat;->sRedirected:Z

    invoke-virtual {p0, v1}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return v3

    :legacy_guide
    const/4 v0, 0x0

    return v0
.end method
