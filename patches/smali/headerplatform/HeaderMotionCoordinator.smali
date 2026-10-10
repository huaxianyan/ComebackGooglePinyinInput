.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;
.super Ljava/lang/Object;
.source "HeaderMotionCoordinator.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;,
        Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;
    }
.end annotation


# static fields
.field private static final MODULE_ID:Ljava/lang/String; = "native-motion"


# instance fields
.field private active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

.field private pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;
    .locals 0

    .line 12
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    return-object p0
.end method

.method static synthetic access$002(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;
    .locals 0

    .line 12
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    return-object p1
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
    .locals 0

    .line 12
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    return-object p0
.end method

.method static synthetic access$102(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
    .locals 0

    .line 12
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    return-object p1
.end method

.method public static awaitNativeLayout(Landroid/view/View;[Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)Z
    .locals 9

    .line 63
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object v0

    .line 64
    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 65
    :cond_0
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object v0

    const-string v2, "native-motion"

    invoke-virtual {v0, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object v0

    .line 66
    instance-of v2, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    if-nez v2, :cond_1

    return v1

    .line 67
    :cond_1
    move-object v4, v0

    check-cast v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    .line 68
    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    .line 69
    new-instance v3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-object v5, p0

    move-object v6, p1

    move-object v7, p2

    move-object v8, p3

    invoke-direct/range {v3 .. v8}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Landroid/view/View;[Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)V

    iput-object v3, v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    .line 70
    iget-object p0, v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->begin()V

    .line 71
    const/4 p0, 0x1

    return p0
.end method

.method public static finishNativeMotion(Landroid/content/Context;)V
    .locals 1

    .line 40
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object p0

    .line 41
    if-nez p0, :cond_0

    return-void

    .line 42
    :cond_0
    invoke-interface {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object p0

    const-string v0, "native-motion"

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object p0

    .line 43
    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    if-eqz v0, :cond_1

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    .line 44
    :cond_1
    return-void
.end method

.method public static prepareNativeMotion(Landroid/animation/Animator;[Landroid/view/View;)V
    .locals 2

    .line 29
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x24

    if-lt v0, v1, :cond_2

    if-eqz p0, :cond_2

    if-eqz p1, :cond_2

    array-length v0, p1

    if-eqz v0, :cond_2

    const/4 v0, 0x0

    aget-object v1, p1, v0

    if-nez v1, :cond_0

    goto :goto_0

    .line 30
    :cond_0
    aget-object v0, p1, v0

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object v0

    .line 31
    if-eqz v0, :cond_1

    .line 32
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object v0

    const-string v1, "native-motion"

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object v0

    .line 33
    instance-of v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    if-eqz v1, :cond_1

    .line 34
    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-virtual {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->prepare(Landroid/animation/Animator;[Landroid/view/View;)V

    .line 37
    :cond_1
    return-void

    .line 29
    :cond_2
    :goto_0
    return-void
.end method


# virtual methods
.method public finish()V
    .locals 2

    .line 75
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    .line 76
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->pending:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->complete(Z)V

    .line 77
    :cond_1
    return-void
.end method

.method public getDefaultPriority()I
    .locals 1

    .line 18
    const/4 v0, 0x0

    return v0
.end method

.method public getModuleId()Ljava/lang/String;
    .locals 1

    .line 17
    const-string v0, "native-motion"

    return-object v0
.end method

.method public onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
    .locals 0

    .line 19
    return-void
.end method

.method public onDetach()V
    .locals 0

    .line 26
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onFinishInput(J)V
    .locals 0

    .line 25
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V
    .locals 0

    .line 20
    return-void
.end method

.method public onHeaderUnavailable(J)V
    .locals 0

    .line 22
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onNativeCandidateStateChanged(Z)V
    .locals 0

    .line 23
    return-void
.end method

.method public onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V
    .locals 0

    .line 21
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onThemeChanged(J)V
    .locals 0

    .line 24
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public prepare(Landroid/animation/Animator;[Landroid/view/View;)V
    .locals 6

    .line 47
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    .line 48
    new-instance v0, Ljava/util/LinkedHashSet;

    invoke-direct {v0}, Ljava/util/LinkedHashSet;-><init>()V

    .line 49
    array-length v1, p2

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, p2, v3

    .line 50
    if-nez v4, :cond_0

    goto :goto_1

    .line 51
    :cond_0
    invoke-virtual {v0, v4}, Ljava/util/LinkedHashSet;->add(Ljava/lang/Object;)Z

    .line 52
    instance-of v5, v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;

    if-eqz v5, :cond_1

    .line 53
    check-cast v4, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;

    invoke-interface {v4, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;->appendHeaderMotionTargets(Ljava/util/Collection;)V

    .line 49
    :cond_1
    :goto_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 56
    :cond_2
    invoke-virtual {v0}, Ljava/util/LinkedHashSet;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_3

    return-void

    .line 57
    :cond_3
    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    aget-object p2, p2, v2

    invoke-direct {v1, p0, p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Landroid/animation/Animator;Landroid/view/View;Ljava/util/LinkedHashSet;)V

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    .line 58
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    invoke-virtual {p1, p2}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 59
    return-void
.end method
