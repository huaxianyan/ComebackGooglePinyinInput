.class final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;
.super Landroid/animation/AnimatorListenerAdapter;
.source "HeaderMotionCoordinator.java"

# interfaces
.implements Landroid/view/View$OnAttachStateChangeListener;
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "Motion"
.end annotation


# instance fields
.field private final anchor:Landroid/view/View;

.field private final animator:Landroid/animation/Animator;

.field private observer:Landroid/view/ViewTreeObserver;

.field private requested:Z

.field private final targets:Ljava/util/LinkedHashSet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/LinkedHashSet<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Landroid/animation/Animator;Landroid/view/View;Ljava/util/LinkedHashSet;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/animation/Animator;",
            "Landroid/view/View;",
            "Ljava/util/LinkedHashSet<",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 67
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-direct {p0}, Landroid/animation/AnimatorListenerAdapter;-><init>()V

    .line 68
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->animator:Landroid/animation/Animator;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->anchor:Landroid/view/View;

    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->targets:Ljava/util/LinkedHashSet;

    .line 69
    return-void
.end method


# virtual methods
.method close()V
    .locals 3

    .line 80
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->requested:Z

    if-eqz v0, :cond_0

    .line 81
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->requested:Z

    .line 82
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->targets:Ljava/util/LinkedHashSet;

    invoke-virtual {v1}, Ljava/util/LinkedHashSet;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/ViewFrameRateCompat;->requestHigh(Landroid/view/View;Z)V

    goto :goto_0

    .line 84
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->anchor:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->removeOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 85
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 86
    :cond_1
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    .line 87
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->animator:Landroid/animation/Animator;

    invoke-virtual {v1, p0}, Landroid/animation/Animator;->removeListener(Landroid/animation/Animator$AnimatorListener;)V

    .line 88
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    move-result-object v1

    if-ne v1, p0, :cond_2

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->access$002(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;

    .line 89
    :cond_2
    return-void
.end method

.method public onAnimationCancel(Landroid/animation/Animator;)V
    .locals 0

    .line 92
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    return-void
.end method

.method public onAnimationEnd(Landroid/animation/Animator;)V
    .locals 0

    .line 91
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    return-void
.end method

.method public onAnimationStart(Landroid/animation/Animator;)V
    .locals 2

    .line 72
    const/4 p1, 0x1

    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->requested:Z

    .line 73
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->targets:Ljava/util/LinkedHashSet;

    invoke-virtual {v0}, Ljava/util/LinkedHashSet;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/ViewFrameRateCompat;->requestHigh(Landroid/view/View;Z)V

    goto :goto_0

    .line 74
    :cond_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->anchor:Landroid/view/View;

    invoke-virtual {p1, p0}, Landroid/view/View;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 75
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->anchor:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    .line 76
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {p1, p0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 77
    return-void
.end method

.method public onPreDraw()Z
    .locals 3

    .line 96
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->targets:Ljava/util/LinkedHashSet;

    invoke-virtual {v0}, Ljava/util/LinkedHashSet;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->isShown()Z

    move-result v1

    if-eqz v1, :cond_0

    return v2

    .line 97
    :cond_1
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    .line 98
    return v2
.end method

.method public onViewAttachedToWindow(Landroid/view/View;)V
    .locals 0

    .line 94
    return-void
.end method

.method public onViewDetachedFromWindow(Landroid/view/View;)V
    .locals 0

    .line 93
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$Motion;->close()V

    return-void
.end method
