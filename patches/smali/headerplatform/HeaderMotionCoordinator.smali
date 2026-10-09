.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;
.super Ljava/lang/Object;
.source "HeaderMotionCoordinator.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
    }
.end annotation


# static fields
.field private static final MODULE_ID:Ljava/lang/String; = "native-motion"


# instance fields
.field private active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
    .locals 0

    .line 12
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    return-object p0
.end method

.method static synthetic access$002(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
    .locals 0

    .line 12
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    return-object p1
.end method

.method public static finishNativeMotion(Landroid/content/Context;)V
    .locals 1

    .line 39
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object p0

    .line 40
    if-nez p0, :cond_0

    return-void

    .line 41
    :cond_0
    invoke-interface {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object p0

    const-string v0, "native-motion"

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object p0

    .line 42
    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    if-eqz v0, :cond_1

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    .line 43
    :cond_1
    return-void
.end method

.method public static prepareNativeMotion(Landroid/animation/Animator;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 28
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x24

    if-lt v0, v1, :cond_2

    if-eqz p0, :cond_2

    if-eqz p1, :cond_2

    if-nez p2, :cond_0

    goto :goto_0

    .line 29
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object v0

    .line 30
    if-eqz v0, :cond_1

    .line 31
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object v0

    const-string v1, "native-motion"

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getRegisteredModule(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;

    move-result-object v0

    .line 32
    instance-of v1, v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    if-eqz v1, :cond_1

    .line 33
    check-cast v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-virtual {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->prepare(Landroid/animation/Animator;Landroid/view/View;Landroid/view/View;)V

    .line 36
    :cond_1
    return-void

    .line 28
    :cond_2
    :goto_0
    return-void
.end method


# virtual methods
.method public finish()V
    .locals 1

    .line 56
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    .line 57
    :cond_0
    return-void
.end method

.method public getDefaultPriority()I
    .locals 1

    .line 17
    const/4 v0, 0x0

    return v0
.end method

.method public getModuleId()Ljava/lang/String;
    .locals 1

    .line 16
    const-string v0, "native-motion"

    return-object v0
.end method

.method public onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
    .locals 0

    .line 18
    return-void
.end method

.method public onDetach()V
    .locals 0

    .line 25
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onFinishInput(J)V
    .locals 0

    .line 24
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V
    .locals 0

    .line 19
    return-void
.end method

.method public onHeaderUnavailable(J)V
    .locals 0

    .line 21
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onNativeCandidateStateChanged(Z)V
    .locals 0

    .line 22
    return-void
.end method

.method public onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V
    .locals 0

    .line 20
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public onThemeChanged(J)V
    .locals 0

    .line 23
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    return-void
.end method

.method public prepare(Landroid/animation/Animator;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 46
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->finish()V

    .line 47
    new-instance v0, Ljava/util/LinkedHashSet;

    invoke-direct {v0}, Ljava/util/LinkedHashSet;-><init>()V

    .line 48
    move-object v1, p2

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;

    invoke-interface {v1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;->appendHeaderMotionTargets(Ljava/util/Collection;)V

    .line 49
    check-cast p3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;

    invoke-interface {p3, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionTargetSource;->appendHeaderMotionTargets(Ljava/util/Collection;)V

    .line 50
    invoke-virtual {v0}, Ljava/util/LinkedHashSet;->isEmpty()Z

    move-result p3

    if-eqz p3, :cond_0

    return-void

    .line 51
    :cond_0
    new-instance p3, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    invoke-direct {p3, p0, p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Landroid/animation/Animator;Landroid/view/View;Ljava/util/LinkedHashSet;)V

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    .line 52
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->active:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    invoke-virtual {p1, p2}, Landroid/animation/Animator;->addListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 53
    return-void
.end method
