.class public final Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;
.super Ljava/lang/Object;
.source "FloatingAccessPointHandler.java"

# interfaces
.implements Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager$IAccessPointFeatureHandler;


# static fields
.field private static final STRING_ID:Ljava/lang/String; = "id_access_point_floating"

.field private static instance:Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;

.field private static registered:Z


# instance fields
.field private final context:Landroid/content/Context;

.field private final id:Ljava/lang/String;

.field private final manager:Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;


# direct methods
.method private constructor <init>(Landroid/content/Context;Ljava/lang/String;Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;)V
    .locals 0

    .line 31
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 32
    invoke-virtual {p1}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->context:Landroid/content/Context;

    .line 33
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    .line 34
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->manager:Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;

    .line 35
    return-void
.end method

.method public static register(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;)V
    .locals 2

    .line 42
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->registered:Z

    if-nez v0, :cond_2

    if-eqz p0, :cond_2

    if-nez p1, :cond_0

    goto :goto_0

    .line 43
    :cond_0
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->registered:Z

    .line 44
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->resolveId(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, p0, v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;-><init>(Landroid/content/Context;Ljava/lang/String;Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->instance:Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;

    .line 45
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->instance:Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;

    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    if-eqz p0, :cond_1

    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->instance:Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;

    invoke-virtual {p1, p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;->a(Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager$IAccessPointFeatureHandler;)V

    .line 46
    :cond_1
    return-void

    .line 42
    :cond_2
    :goto_0
    return-void
.end method

.method private static resolveId(Landroid/content/Context;)Ljava/lang/String;
    .locals 4

    .line 49
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "string"

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "id_access_point_floating"

    invoke-virtual {v0, v3, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    .line 50
    if-nez v0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0, v0}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p0

    :goto_0
    return-object p0
.end method


# virtual methods
.method public closeFeature(Ljava/lang/String;)Z
    .locals 1

    .line 71
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    return p1
.end method

.method public launchFeature(Ljava/lang/String;Ljava/util/Map;)Z
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/util/Map<",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ">;)Z"
        }
    .end annotation

    .line 55
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    if-eqz p2, :cond_1

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->id:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_1

    .line 56
    :cond_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->context:Landroid/content/Context;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->context:Landroid/content/Context;

    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result p2

    const/4 v0, 0x1

    xor-int/2addr p2, v0

    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setEnabled(Landroid/content/Context;Z)V

    .line 60
    :try_start_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingAccessPointHandler;->manager:Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;

    invoke-virtual {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/AccessPointsManager;->collapseAccessPoints()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 63
    goto :goto_0

    .line 61
    :catchall_0
    move-exception p1

    .line 64
    :goto_0
    return v0

    .line 55
    :cond_1
    :goto_1
    const/4 p1, 0x0

    return p1
.end method
