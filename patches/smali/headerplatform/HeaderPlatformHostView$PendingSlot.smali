.class final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;
.super Ljava/lang/Object;
.source "HeaderPlatformHostView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "PendingSlot"
.end annotation


# instance fields
.field private committed:Z

.field private final contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

.field private prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

.field private final renderGeneration:J

.field private final target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

.field private final unchanged:Z


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;Z)V
    .locals 0

    .line 265
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 266
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    .line 267
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 268
    iput-wide p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->renderGeneration:J

    .line 269
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    .line 270
    iput-boolean p6, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->unchanged:Z

    .line 271
    return-void
.end method


# virtual methods
.method cancel()V
    .locals 1

    .line 298
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->committed:Z

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->release()V

    .line 299
    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    .line 300
    return-void
.end method

.method commit()V
    .locals 6

    .line 274
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->committed:Z

    const/4 v1, 0x1

    if-nez v0, :cond_7

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->unchanged:Z

    if-eqz v0, :cond_0

    goto/16 :goto_2

    .line 278
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    const/4 v2, 0x0

    if-nez v0, :cond_1

    move-object v0, v2

    goto :goto_0

    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->getView()Landroid/view/View;

    move-result-object v0

    .line 279
    :goto_0
    if-eqz v0, :cond_3

    .line 280
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    .line 281
    instance-of v4, v3, Landroid/view/ViewGroup;

    if-eqz v4, :cond_2

    check-cast v3, Landroid/view/ViewGroup;

    invoke-virtual {v3, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 282
    :cond_2
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$200(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Landroid/widget/FrameLayout;

    move-result-object v3

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->childLayoutParams()Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v4

    invoke-virtual {v3, v0, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 284
    :cond_3
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$300(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    move-result-object v0

    .line 285
    if-nez v0, :cond_4

    move-object v3, v2

    goto :goto_1

    :cond_4
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->getView()Landroid/view/View;

    move-result-object v3

    .line 286
    :goto_1
    if-eqz v3, :cond_5

    invoke-virtual {v3}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$200(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Landroid/widget/FrameLayout;

    move-result-object v5

    if-ne v4, v5, :cond_5

    .line 287
    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$200(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Landroid/widget/FrameLayout;

    move-result-object v4

    invoke-virtual {v4, v3}, Landroid/widget/FrameLayout;->removeView(Landroid/view/View;)V

    .line 289
    :cond_5
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    invoke-static {v3, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$302(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    .line 290
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    invoke-static {v3, v4}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$402(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 291
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->target:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-wide v4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->renderGeneration:J

    invoke-static {v3, v4, v5}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->access$502(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;J)J

    .line 292
    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->prepared:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    .line 293
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->committed:Z

    .line 294
    if-eqz v0, :cond_6

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->release()V

    .line 295
    :cond_6
    return-void

    .line 275
    :cond_7
    :goto_2
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->committed:Z

    .line 276
    return-void
.end method
