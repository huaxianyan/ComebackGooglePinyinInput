.class final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;
.super Ljava/lang/Object;
.source "HeaderMotionCoordinator.java"

# interfaces
.implements Ljava/lang/Runnable;
.implements Landroid/view/View$OnAttachStateChangeListener;
.implements Landroid/view/View$OnLayoutChangeListener;
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x12
    name = "LayoutWait"
.end annotation


# instance fields
.field final anchor:Landroid/view/View;

.field closed:Z

.field final fallback:Ljava/lang/Runnable;

.field observer:Landroid/view/ViewTreeObserver;

.field final panelAlpha:F

.field queued:Z

.field final resume:Ljava/lang/Runnable;

.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

.field final views:[Landroid/view/View;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Landroid/view/View;[Landroid/view/View;Ljava/lang/Runnable;Ljava/lang/Runnable;)V
    .locals 0

    .line 88
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 89
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    .line 90
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->resume:Ljava/lang/Runnable;

    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->fallback:Ljava/lang/Runnable;

    .line 91
    const/4 p1, 0x2

    aget-object p1, p3, p1

    invoke-virtual {p1}, Landroid/view/View;->getAlpha()F

    move-result p1

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->panelAlpha:F

    .line 92
    return-void
.end method


# virtual methods
.method begin()V
    .locals 4

    .line 95
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 96
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 97
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_0

    aget-object v3, v0, v2

    invoke-virtual {v3, p0}, Landroid/view/View;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 98
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->observer:Landroid/view/ViewTreeObserver;

    .line 99
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 100
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->check()V

    .line 101
    return-void
.end method

.method check()V
    .locals 1

    .line 109
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 110
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getWindowVisibility()I

    move-result v0

    if-eqz v0, :cond_1

    goto :goto_0

    .line 112
    :cond_1
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->queued:Z

    if-nez v0, :cond_3

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->ready()Z

    move-result v0

    if-eqz v0, :cond_3

    .line 113
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->queued:Z

    .line 114
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    goto :goto_1

    .line 111
    :cond_2
    :goto_0
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->complete(Z)V

    .line 116
    :cond_3
    :goto_1
    return-void
.end method

.method complete(Z)V
    .locals 4

    .line 126
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->closed:Z

    if-eqz v0, :cond_0

    return-void

    .line 127
    :cond_0
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->closed:Z

    .line 128
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 129
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0, p0}, Landroid/view/View;->removeOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 130
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, v1, :cond_1

    aget-object v3, v0, v2

    invoke-virtual {v3, p0}, Landroid/view/View;->removeOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 131
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->observer:Landroid/view/ViewTreeObserver;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->observer:Landroid/view/ViewTreeObserver;

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 132
    :cond_2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    const/4 v1, 0x2

    aget-object v0, v0, v1

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->panelAlpha:F

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 133
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    move-result-object v0

    if-ne v0, p0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;

    const/4 v1, 0x0

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;->access$002(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;

    .line 134
    :cond_3
    if-eqz p1, :cond_4

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->resume:Ljava/lang/Runnable;

    goto :goto_1

    :cond_4
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->fallback:Ljava/lang/Runnable;

    :goto_1
    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    .line 135
    return-void
.end method

.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 0

    .line 139
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->check()V

    return-void
.end method

.method public onPreDraw()Z
    .locals 1

    .line 137
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->check()V

    const/4 v0, 0x1

    return v0
.end method

.method public onViewAttachedToWindow(Landroid/view/View;)V
    .locals 0

    .line 140
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->check()V

    return-void
.end method

.method public onViewDetachedFromWindow(Landroid/view/View;)V
    .locals 0

    .line 141
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->complete(Z)V

    return-void
.end method

.method ready()Z
    .locals 6

    .line 104
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->views:[Landroid/view/View;

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_2

    aget-object v4, v0, v3

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v5

    if-lez v5, :cond_1

    invoke-virtual {v4}, Landroid/view/View;->isLayoutRequested()Z

    move-result v4

    if-eqz v4, :cond_0

    goto :goto_1

    :cond_0
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_1
    :goto_1
    return v2

    .line 105
    :cond_2
    const/4 v0, 0x1

    return v0
.end method

.method public run()V
    .locals 1

    .line 119
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->queued:Z

    .line 120
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->closed:Z

    if-nez v0, :cond_0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->ready()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->anchor:Landroid/view/View;

    .line 121
    invoke-virtual {v0}, Landroid/view/View;->getWindowVisibility()I

    move-result v0

    if-nez v0, :cond_0

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->complete(Z)V

    goto :goto_0

    .line 122
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderMotionCoordinator$LayoutWait;->check()V

    .line 123
    :goto_0
    return-void
.end method
