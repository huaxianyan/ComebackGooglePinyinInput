.class final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;
.super Ljava/lang/Object;
.source "HeaderPlatformHostView.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "RenderedSlot"
.end annotation


# instance fields
.field private final container:Landroid/widget/FrameLayout;

.field private content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

.field private contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

.field private final fillWidth:Z

.field private renderGeneration:J


# direct methods
.method constructor <init>(Landroid/widget/FrameLayout;Z)V
    .locals 0

    .line 227
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 228
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->container:Landroid/widget/FrameLayout;

    .line 229
    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->fillWidth:Z

    .line 230
    return-void
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Landroid/widget/FrameLayout;
    .locals 0

    .line 220
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->container:Landroid/widget/FrameLayout;

    return-object p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
    .locals 0

    .line 220
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    return-object p0
.end method

.method static synthetic access$302(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;
    .locals 0

    .line 220
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    return-object p1
.end method

.method static synthetic access$402(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
    .locals 0

    .line 220
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    return-object p1
.end method

.method static synthetic access$502(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;J)J
    .locals 0

    .line 220
    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->renderGeneration:J

    return-wide p1
.end method


# virtual methods
.method childLayoutParams()Landroid/widget/FrameLayout$LayoutParams;
    .locals 3

    .line 233
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    iget-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->fillWidth:Z

    const/4 v2, -0x1

    if-eqz v1, :cond_0

    const/4 v1, -0x1

    goto :goto_0

    .line 234
    :cond_0
    const/4 v1, -0x2

    :goto_0
    invoke-direct {v0, v1, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 233
    return-object v0
.end method

.method clear()V
    .locals 2

    .line 248
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->container:Landroid/widget/FrameLayout;

    invoke-virtual {v0}, Landroid/widget/FrameLayout;->removeAllViews()V

    .line 249
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    invoke-interface {v0}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;->release()V

    .line 250
    :cond_0
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->content:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    .line 251
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 252
    const-wide/16 v0, 0x0

    iput-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->renderGeneration:J

    .line 253
    return-void
.end method

.method prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;
    .locals 7

    .line 239
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;->contribution:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    invoke-static {v0, p2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->access$100(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 240
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;

    const/4 v5, 0x0

    const/4 v6, 0x1

    move-object v1, p0

    move-object v2, p2

    move-wide v3, p3

    invoke-direct/range {v0 .. v6}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;Z)V

    return-object v0

    .line 242
    :cond_0
    if-nez p2, :cond_1

    const/4 v0, 0x0

    move-object v5, v0

    goto :goto_0

    .line 243
    :cond_1
    invoke-virtual {p5, p1, p2, p6}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRendererRegistry;->prepare(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderChromeFactory;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;

    move-result-object v0

    move-object v5, v0

    .line 244
    :goto_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;

    const/4 v6, 0x0

    move-object v1, p0

    move-object v2, p2

    move-wide v3, p3

    invoke-direct/range {v0 .. v6}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$PendingSlot;-><init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$RenderedSlot;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;JLcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderedContent;Z)V

    return-object v0
.end method
