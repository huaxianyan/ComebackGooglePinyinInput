.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;
.super Landroid/widget/FrameLayout;
.source "HeaderPlatformHostView.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;
.implements Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateListener;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;,
        Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;
    }
.end annotation


# instance fields
.field private appliedRenderGeneration:J

.field private boundHeaderToken:J

.field private final centerHost:Landroid/widget/FrameLayout;

.field private final centerSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

.field private chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

.field private controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

.field private currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

.field private final leadingHost:Landroid/widget/FrameLayout;

.field private final leadingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

.field private nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

.field private nativeLayer:Landroid/view/View;

.field private final renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

.field private final trailingHost:Landroid/widget/FrameLayout;

.field private final trailingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 31
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 32
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 2

    .line 35
    invoke-direct {p0, p1, p2}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 18
    new-instance p2, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    invoke-direct {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;-><init>()V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    .line 27
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->idle()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    move-result-object p2

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 36
    const/4 p2, 0x1

    invoke-virtual {p0, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setClipChildren(Z)V

    .line 37
    invoke-virtual {p0, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setClipToPadding(Z)V

    .line 38
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setSaveEnabled(Z)V

    .line 39
    const/16 v1, 0x8

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setVisibility(I)V

    .line 40
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->newContainer(Landroid/content/Context;)Landroid/widget/FrameLayout;

    move-result-object v1

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingHost:Landroid/widget/FrameLayout;

    .line 41
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->newContainer(Landroid/content/Context;)Landroid/widget/FrameLayout;

    move-result-object v1

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerHost:Landroid/widget/FrameLayout;

    .line 42
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->newContainer(Landroid/content/Context;)Landroid/widget/FrameLayout;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingHost:Landroid/widget/FrameLayout;

    .line 43
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerHost:Landroid/widget/FrameLayout;

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->matchParent()Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v1

    invoke-virtual {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 44
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingHost:Landroid/widget/FrameLayout;

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->wrapContentStart()Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v1

    invoke-virtual {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 45
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingHost:Landroid/widget/FrameLayout;

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->wrapContentEnd()Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v1

    invoke-virtual {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 46
    new-instance p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingHost:Landroid/widget/FrameLayout;

    invoke-direct {p1, v1, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;-><init>(Landroid/widget/FrameLayout;Z)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    .line 47
    new-instance p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerHost:Landroid/widget/FrameLayout;

    invoke-direct {p1, v1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;-><init>(Landroid/widget/FrameLayout;Z)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    .line 48
    new-instance p1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingHost:Landroid/widget/FrameLayout;

    invoke-direct {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;-><init>(Landroid/widget/FrameLayout;Z)V

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    .line 49
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    new-instance p2, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;

    invoke-direct {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeActionRenderer;-><init>()V

    invoke-virtual {p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->register(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;)V

    .line 50
    sget p1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 p2, 0x1e

    if-lt p1, p2, :cond_0

    .line 51
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    new-instance p2, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteRenderer;

    invoke-direct {p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/InlineAutofillRemoteRenderer;-><init>()V

    invoke-virtual {p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->register(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderer;)V

    .line 53
    :cond_0
    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V
    .locals 0

    .line 13
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->applyPlan(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z
    .locals 0

    .line 13
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->sameContribution(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z

    move-result p0

    return p0
.end method

.method private applyPlan(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V
    .locals 12

    .line 118
    if-nez p1, :cond_0

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->idle()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    move-result-object p1

    .line 119
    :cond_0
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getRenderGeneration()J

    move-result-wide v0

    .line 120
    const-wide/16 v2, 0x0

    const-string v4, "HeaderPlatformAudit"

    cmp-long v5, v0, v2

    if-lez v5, :cond_1

    iget-wide v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->appliedRenderGeneration:J

    cmp-long v7, v0, v5

    if-gez v7, :cond_1

    .line 121
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "host ignored stale plan generation="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " applied="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->appliedRenderGeneration:J

    invoke-virtual {p1, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v4, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    return-void

    .line 125
    :cond_1
    cmp-long v5, v0, v2

    if-lez v5, :cond_2

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->appliedRenderGeneration:J

    .line 126
    :cond_2
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 127
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "host plan native="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->isNativeOwned()Z

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " idle="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 128
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->isIdle()Z

    move-result v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " center="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 129
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getCenter()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_3

    const/4 v0, 0x1

    goto :goto_0

    :cond_3
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 127
    invoke-static {v4, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 130
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->isNativeOwned()Z

    move-result p1

    const/16 v0, 0x8

    if-eqz p1, :cond_5

    .line 133
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setVisibility(I)V

    .line 134
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    if-eqz p1, :cond_4

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    .line 135
    :cond_4
    return-void

    .line 137
    :cond_5
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->isIdle()Z

    move-result p1

    if-eqz p1, :cond_7

    .line 138
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->clearContainers()V

    .line 139
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setVisibility(I)V

    .line 140
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    if-eqz p1, :cond_6

    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    .line 141
    :cond_6
    return-void

    .line 143
    :cond_7
    nop

    .line 144
    nop

    .line 145
    nop

    .line 147
    const/4 p1, 0x0

    :try_start_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getRenderGeneration()J

    move-result-wide v8

    .line 148
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getContext()Landroid/content/Context;

    move-result-object v6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getLeading()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v7

    iget-object v10, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    iget-object v11, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    invoke-virtual/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;

    move-result-object v2
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_2

    .line 150
    :try_start_1
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getContext()Landroid/content/Context;

    move-result-object v6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getCenter()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v7

    iget-object v10, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    iget-object v11, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    invoke-virtual/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;

    move-result-object v3
    :try_end_1
    .catch Ljava/lang/RuntimeException; {:try_start_1 .. :try_end_1} :catch_1

    .line 152
    :try_start_2
    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getContext()Landroid/content/Context;

    move-result-object v6

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->getTrailing()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    move-result-object v7

    iget-object v10, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    iget-object v11, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    invoke-virtual/range {v5 .. v11}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;

    move-result-object p1

    .line 154
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->commit()V

    .line 155
    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->commit()V

    .line 156
    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->commit()V

    .line 157
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    if-eqz v0, :cond_8

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    const/4 v5, 0x4

    invoke-virtual {v0, v5}, Landroid/view/View;->setVisibility(I)V

    .line 158
    :cond_8
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setVisibility(I)V

    .line 159
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->bringToFront()V

    .line 160
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "host visible child="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getChildCount()I

    move-result v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v4, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catch Ljava/lang/RuntimeException; {:try_start_2 .. :try_end_2} :catch_0

    .line 168
    nop

    .line 169
    return-void

    .line 161
    :catch_0
    move-exception v0

    move-object v1, v0

    move-object v0, p1

    goto :goto_1

    :catch_1
    move-exception v0

    move-object v3, p1

    move-object v1, v0

    move-object v0, v3

    :goto_1
    move-object p1, v2

    goto :goto_2

    :catch_2
    move-exception v0

    move-object v3, p1

    move-object v1, v0

    move-object v0, v3

    .line 162
    :goto_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "host render failed type="

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 163
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 162
    invoke-static {v4, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 164
    if-eqz p1, :cond_9

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->cancel()V

    .line 165
    :cond_9
    if-eqz v3, :cond_a

    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->cancel()V

    .line 166
    :cond_a
    if-eqz v0, :cond_b

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;->cancel()V

    .line 167
    :cond_b
    throw v1
.end method

.method private clearContainers()V
    .locals 1

    .line 179
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->clear()V

    .line 180
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->clear()V

    .line 181
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingSlot:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->clear()V

    .line 182
    return-void
.end method

.method private static findChromeFactory(Landroid/view/View;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;
    .locals 3

    .line 328
    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    if-eqz v0, :cond_0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    return-object p0

    .line 329
    :cond_0
    instance-of v0, p0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-nez v0, :cond_1

    return-object v1

    .line 330
    :cond_1
    check-cast p0, Landroid/view/ViewGroup;

    .line 331
    const/4 v0, 0x0

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-ge v0, v2, :cond_3

    .line 332
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->findChromeFactory(Landroid/view/View;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    move-result-object v2

    .line 333
    if-eqz v2, :cond_2

    return-object v2

    .line 331
    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 335
    :cond_3
    return-object v1
.end method

.method private findNativeLayer()Landroid/view/View;
    .locals 6

    .line 304
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 305
    instance-of v1, v0, Landroid/view/ViewGroup;

    const/4 v2, 0x0

    if-nez v1, :cond_0

    return-object v2

    .line 306
    :cond_0
    check-cast v0, Landroid/view/ViewGroup;

    .line 307
    const/4 v1, 0x0

    :goto_0
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v3

    if-ge v1, v3, :cond_2

    .line 308
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v3

    .line 309
    invoke-virtual {v3}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v4

    .line 310
    if-eqz v4, :cond_1

    const-string v5, "header-platform-native-layer"

    invoke-virtual {v4}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 311
    return-object v3

    .line 307
    :cond_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 314
    :cond_2
    return-object v2
.end method

.method private findNearestChromeFactory()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;
    .locals 2

    .line 318
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 319
    :goto_0
    instance-of v1, v0, Landroid/view/View;

    if-eqz v1, :cond_1

    .line 320
    move-object v1, v0

    check-cast v1, Landroid/view/View;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->findChromeFactory(Landroid/view/View;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    move-result-object v1

    .line 321
    if-eqz v1, :cond_0

    return-object v1

    .line 322
    :cond_0
    invoke-interface {v0}, Landroid/view/ViewParent;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 323
    goto :goto_0

    .line 324
    :cond_1
    const/4 v0, 0x0

    return-object v0
.end method

.method private static matchParent()Landroid/widget/FrameLayout$LayoutParams;
    .locals 2

    .line 192
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x1

    invoke-direct {v0, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method private static newContainer(Landroid/content/Context;)Landroid/widget/FrameLayout;
    .locals 1

    .line 185
    new-instance v0, Landroid/widget/FrameLayout;

    invoke-direct {v0, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 186
    const/4 p0, 0x1

    invoke-virtual {v0, p0}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    .line 187
    invoke-virtual {v0, p0}, Landroid/widget/FrameLayout;->setClipToPadding(Z)V

    .line 188
    return-object v0
.end method

.method private static sameContribution(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z
    .locals 5

    .line 211
    if-eq p0, p1, :cond_1

    if-eqz p0, :cond_0

    if-eqz p1, :cond_0

    .line 212
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getSessionToken()J

    move-result-wide v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getSessionToken()J

    move-result-wide v2

    cmp-long v4, v0, v2

    if-nez v4, :cond_0

    .line 213
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getHeaderToken()J

    move-result-wide v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getHeaderToken()J

    move-result-wide v2

    cmp-long v4, v0, v2

    if-nez v4, :cond_0

    .line 214
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getModuleId()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 215
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getStableId()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getStableId()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 216
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPresentationKind()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v1

    if-ne v0, v1, :cond_0

    .line 217
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object p0

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;->getPayload()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererPayload;

    move-result-object p1

    if-ne p0, p1, :cond_0

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    goto :goto_1

    :cond_1
    :goto_0
    const/4 p0, 0x1

    .line 211
    :goto_1
    return p0
.end method

.method private static wrapContentEnd()Landroid/widget/FrameLayout$LayoutParams;
    .locals 3

    .line 203
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x2

    const/4 v2, -0x1

    invoke-direct {v0, v1, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 205
    const v1, 0x800005

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 206
    return-object v0
.end method

.method private static wrapContentStart()Landroid/widget/FrameLayout$LayoutParams;
    .locals 3

    .line 196
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x2

    const/4 v2, -0x1

    invoke-direct {v0, v1, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 198
    const v1, 0x800003

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 199
    return-object v0
.end method


# virtual methods
.method getCenterHost()Landroid/widget/FrameLayout;
    .locals 1

    .line 174
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->centerHost:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method getChromeFactory()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;
    .locals 1

    .line 171
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    return-object v0
.end method

.method getCurrentPlan()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;
    .locals 1

    .line 176
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    return-object v0
.end method

.method getLeadingHost()Landroid/widget/FrameLayout;
    .locals 1

    .line 173
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->leadingHost:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method getRendererRegistry()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;
    .locals 1

    .line 172
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->renderers:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;

    return-object v0
.end method

.method getTrailingHost()Landroid/widget/FrameLayout;
    .locals 1

    .line 175
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->trailingHost:Landroid/widget/FrameLayout;

    return-object v0
.end method

.method protected onAttachedToWindow()V
    .locals 3

    .line 57
    invoke-super {p0}, Landroid/widget/FrameLayout;->onAttachedToWindow()V

    .line 58
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwners;->find(Landroid/content/Context;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;

    move-result-object v0

    .line 59
    if-eqz v0, :cond_3

    .line 62
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->findNativeLayer()Landroid/view/View;

    move-result-object v1

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    .line 63
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    if-eqz v1, :cond_2

    .line 66
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->findNearestChromeFactory()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    move-result-object v1

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    .line 67
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    if-eqz v1, :cond_1

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    instance-of v1, v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    if-eqz v1, :cond_1

    .line 70
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    check-cast v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    .line 71
    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformOwner;->getHeaderPlatformController()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    .line 72
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;->captureNativeChrome()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;

    move-result-object v0

    .line 73
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    .line 74
    if-nez v0, :cond_0

    const/4 v0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeChromeSnapshot;->getCandidateTextColor()Ljava/lang/Integer;

    move-result-object v0

    .line 73
    :goto_0
    invoke-virtual {v1, p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->bindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;Ljava/lang/Integer;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;

    move-result-object v0

    .line 74
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;->getToken()J

    move-result-wide v0

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->boundHeaderToken:J

    .line 75
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "host attached token="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->boundHeaderToken:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "HeaderPlatformAudit"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    invoke-interface {v0, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;->setHeaderNativeCandidateStateListener(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateListener;)V

    .line 77
    return-void

    .line 68
    :cond_1
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Native Header chrome/source contract is missing"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 64
    :cond_2
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Native Header layer contract is missing"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 60
    :cond_3
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Header platform owner is missing"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method protected onDetachedFromWindow()V
    .locals 3

    .line 81
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 82
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    invoke-interface {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;->setHeaderNativeCandidateStateListener(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateStateListener;)V

    .line 84
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    invoke-virtual {v0, p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->unbindHost(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlanListener;)V

    .line 85
    :cond_1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    .line 86
    :cond_2
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    .line 87
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->chromeFactory:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;

    .line 88
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeCandidateSource:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderNativeCandidateSource;

    .line 89
    iput-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->nativeLayer:Landroid/view/View;

    .line 90
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->boundHeaderToken:J

    .line 91
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->clearContainers()V

    .line 92
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->idle()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    move-result-object v2

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->currentPlan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 93
    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->appliedRenderGeneration:J

    .line 94
    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->setVisibility(I)V

    .line 95
    invoke-super {p0}, Landroid/widget/FrameLayout;->onDetachedFromWindow()V

    .line 96
    return-void
.end method

.method public onHeaderRenderPlanChanged(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V
    .locals 2

    .line 108
    invoke-static {}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    if-eq v0, v1, :cond_0

    .line 109
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->post(Ljava/lang/Runnable;)Z

    .line 112
    return-void

    .line 114
    :cond_0
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->applyPlan(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    .line 115
    return-void
.end method

.method public onNativeCandidateStateChanged(ZZ)V
    .locals 5

    .line 100
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    if-eqz v0, :cond_0

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->boundHeaderToken:J

    const-wide/16 v2, 0x0

    cmp-long v4, v0, v2

    if-lez v4, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    .line 101
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->getCurrentHeaderToken()J

    move-result-wide v0

    iget-wide v2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->boundHeaderToken:J

    cmp-long v4, v0, v2

    if-nez v4, :cond_0

    .line 102
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->controller:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;

    invoke-virtual {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformController;->setNativeCandidateState(ZZ)V

    .line 104
    :cond_0
    return-void
.end method
