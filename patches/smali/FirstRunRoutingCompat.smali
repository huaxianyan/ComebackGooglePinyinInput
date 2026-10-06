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

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-ge v0, v1, :legacy_guide

    # An already completed guide is the legacy activity's own case to finish;
    # redirecting it here would show the settings screen instead of discarding
    # a late singleTask intent.
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunStateCompat;->isComplete(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :legacy_guide

    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "com.google.android.inputmethod.pinyin.modernsettings.compose.ModernFirstRunActivity"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->setClassName(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    # Apktool-only isolated audit builds intentionally omit the Compose runtime.
    # Route only when the merged package declares the Activity, so those builds
    # keep the legacy guide instead of failing to start anything.
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v3

    const/4 v2, 0x0

    invoke-virtual {v3, v0, v2}, Landroid/content/pm/PackageManager;->queryIntentActivities(Landroid/content/Intent;I)Ljava/util/List;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v3

    if-nez v3, :legacy_guide

    # The launch claim stays with this activity's process. The Compose host
    # takes it over in its own onCreate, and this activity's onDestroy skips
    # releasing it, so there is no window in which IME startup could enqueue a
    # second guide.
    const/4 v3, 0x1

    sput-boolean v3, Lcom/google/android/inputmethod/pinyin/firstrun/FirstRunRoutingCompat;->sRedirected:Z

    invoke-virtual {p0, v0}, Landroid/app/Activity;->startActivity(Landroid/content/Intent;)V

    invoke-virtual {p0}, Landroid/app/Activity;->finish()V

    return v3

    :legacy_guide
    const/4 v0, 0x0

    return v0
.end method
