.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;
.super Ljava/lang/Object;
.source "FloatingKeyboardCompat.java"


# static fields
.field private static final DEFAULT_SCALE:F = 0.72f

.field private static final DEFAULT_X_FRACTION:F = 0.5f

.field private static final DEFAULT_Y_FRACTION:F = 1.0f

.field private static final DOCK_THRESHOLD:F = 0.92f

.field private static final DOUBLE_TAP_MS:J = 0x140L

.field private static final DRAG_LONG_PRESS_MS:J = 0x17cL

.field private static final EDIT_HOLD_MS:J = 0x12cL

.field static final HANDLE_GUTTER_DP:I = 0x22

.field static final HANDLE_HEIGHT_DP:I = 0x14

.field private static final IDLE_ALPHA:F = 0.5f

.field private static final IDLE_FADE_DELAY_MS:J = 0x1388L

.field private static final IDLE_FADE_OUT_MS:J = 0x140L

.field private static final IDLE_WAKE_MS:J = 0x78L

.field private static final KEY_ENABLED:Ljava/lang/String; = "enabled"

.field private static final KEY_IDLE_FADE:Ljava/lang/String; = "idle_fade"

.field private static final KEY_SCALE:Ljava/lang/String; = "scale"

.field private static final KEY_X_FRACTION:Ljava/lang/String; = "x_fraction_"

.field private static final KEY_Y_FRACTION:Ljava/lang/String; = "y_fraction_"

.field private static final MAX_SCALE:F = 0.92f

.field private static final MIN_SCALE:F = 0.5f

.field private static final ONE_HANDED_LABELS:[Ljava/lang/String;

.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final TABLET_SMALLEST_WIDTH_DP:I = 0x258

.field private static final TAG:Ljava/lang/String; = "FloatingKeyboard"

.field private static appliedScale:F

.field private static armingEdit:Z

.field private static baseBottomPadding:I

.field private static baseInputElevation:F

.field private static basePaddingArea:Ljava/lang/ref/WeakReference;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/lang/ref/WeakReference<",
            "Landroid/view/View;",
            ">;"
        }
    .end annotation
.end field

.field private static cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

.field private static cardShadowArea:Landroid/view/View;

.field private static cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

.field private static downRawX:F

.field private static downRawY:F

.field private static dragDownRawX:F

.field private static dragDownRawY:F

.field private static dragStartX:F

.field private static dragStartY:F

.field private static dragging:Z

.field private static editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

.field private static editing:Z

.field private static final enterEditRunnable:Ljava/lang/Runnable;

.field private static final fadeOut:Ljava/lang/Runnable;

.field private static handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

.field private static handleColorSource:Landroid/view/View;

.field private static idleArea:Landroid/view/View;

.field private static final idleHandler:Landroid/os/Handler;

.field private static idleProbe:Landroid/view/View;

.field private static idleProbeArea:Landroid/view/View;

.field private static idleScheduled:Z

.field private static lastAccessPointPost:J

.field private static lastAccessPointScan:J

.field private static lastAccessPointTarget:Z

.field private static lastHandleUp:J

.field private static final lastRegion:Landroid/graphics/Rect;

.field private static final layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

.field private static pendingDrag:Z

.field private static pendingLongPress:Ljava/lang/Runnable;

.field private static scaleAnchorOffX:F

.field private static scaleAnchorOffY:F

.field private static scaleAnchorX:F

.field private static scaleAnchorY:F

.field private static scaleStartDistance:F

.field private static scaleStartFactor:F

.field private static scaleStartTx:F

.field private static scaleStartTy:F

.field private static scaledView:Landroid/view/View;

.field private static scaling:Z

.field private static touchSlop:I

.field private static watchedDecor:Landroid/view/View;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 69
    const/4 v0, -0x1

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 92
    const/high16 v1, -0x40800000    # -1.0f

    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 106
    new-instance v2, Landroid/graphics/Rect;

    invoke-direct {v2}, Landroid/graphics/Rect;-><init>()V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    .line 139
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;

    invoke-direct {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;-><init>()V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    .line 161
    new-instance v2, Landroid/os/Handler;

    .line 162
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    .line 163
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;

    invoke-direct {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;-><init>()V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    .line 172
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 176
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    .line 451
    const/4 v0, 0x4

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "one_handed_access_point_content_desc"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "left_handed_content_desc"

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "right_handed_content_desc"

    const/4 v2, 0x2

    aput-object v1, v0, v2

    const-string v1, "expand_keyboard_content_desc"

    const/4 v2, 0x3

    aput-object v1, v0, v2

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    .line 991
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 183
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()J
    .locals 2

    .line 33
    sget-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointScan:J

    return-wide v0
.end method

.method static synthetic access$002(J)J
    .locals 0

    .line 33
    sput-wide p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointScan:J

    return-wide p0
.end method

.method static synthetic access$100()Landroid/view/View;
    .locals 1

    .line 33
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$1000(Landroid/view/View;)Landroid/view/View;
    .locals 0

    .line 33
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$1100(Landroid/view/View;Landroid/view/View;F)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    return-void
.end method

.method static synthetic access$1200(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOneHandedAccessPointHidden(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$1300()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    return-void
.end method

.method static synthetic access$1400(Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->rearmIdleFade(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1500(Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1600()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncCardShadow()V

    return-void
.end method

.method static synthetic access$1702(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    return p0
.end method

.method static synthetic access$1800(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1900(FFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditDrag(FFZ)V

    return-void
.end method

.method static synthetic access$200(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$2000(IFFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditScale(IFFZ)V

    return-void
.end method

.method static synthetic access$2100()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetFromEdit()V

    return-void
.end method

.method static synthetic access$2200(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$2302(Ljava/lang/Runnable;)Ljava/lang/Runnable;
    .locals 0

    .line 33
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    return-object p0
.end method

.method static synthetic access$2400()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return v0
.end method

.method static synthetic access$2402(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return p0
.end method

.method static synthetic access$2500(Landroid/view/View;Landroid/view/View;Landroid/view/View;)Z
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->beginDrag(Landroid/view/View;Landroid/view/View;Landroid/view/View;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$302(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    return p0
.end method

.method static synthetic access$400()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    return v0
.end method

.method static synthetic access$500()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    return v0
.end method

.method static synthetic access$600()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    return v0
.end method

.method static synthetic access$700()Landroid/view/View;
    .locals 1

    .line 33
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$800(FJ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    return-void
.end method

.method static synthetic access$900()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dropFloatingChrome()V

    return-void
.end method

.method private static animateIdleAlpha(FJ)V
    .locals 1

    .line 540
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 541
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 542
    return-void
.end method

.method private static applyGutter(Landroid/view/View;Z)V
    .locals 3

    .line 631
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->basePaddingArea:Ljava/lang/ref/WeakReference;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->basePaddingArea:Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    .line 632
    :goto_0
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    if-ltz v1, :cond_1

    if-eq v0, p0, :cond_2

    .line 635
    :cond_1
    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->basePaddingArea:Ljava/lang/ref/WeakReference;

    .line 636
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 638
    :cond_2
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 639
    if-eqz p1, :cond_3

    const/high16 p1, 0x42080000    # 34.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, p1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result p1

    add-int/2addr v0, p1

    .line 640
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    if-ne p1, v0, :cond_4

    return-void

    .line 641
    :cond_4
    nop

    .line 642
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p1

    .line 643
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    .line 644
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    .line 641
    invoke-virtual {p0, p1, v1, v2, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 646
    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 11

    .line 224
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 225
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 226
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 227
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V

    .line 228
    return-void

    .line 230
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 231
    if-nez v0, :cond_1

    return-void

    .line 232
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 233
    if-nez v0, :cond_2

    return-void

    .line 236
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchAccessPoints(Landroid/view/View;)V

    .line 237
    const/4 v2, 0x1

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 239
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    .line 240
    iget v4, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 241
    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 242
    if-lez v4, :cond_a

    if-gtz v3, :cond_3

    goto/16 :goto_0

    .line 244
    :cond_3
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 245
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 246
    const/4 v5, 0x3

    iput v5, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 248
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v5

    .line 249
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v6

    .line 250
    new-instance v7, Landroid/graphics/Rect;

    invoke-direct {v7}, Landroid/graphics/Rect;-><init>()V

    .line 251
    if-eqz v6, :cond_6

    invoke-static {v6, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v8

    if-eqz v8, :cond_6

    .line 255
    invoke-static {v0, v6, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 260
    invoke-virtual {v6}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v8

    instance-of v8, v8, Landroid/view/View;

    if-eqz v8, :cond_5

    .line 261
    invoke-virtual {v6}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v8

    check-cast v8, Landroid/view/View;

    .line 262
    invoke-virtual {v8}, Landroid/view/View;->getElevation()F

    move-result v9

    const/4 v10, 0x0

    cmpl-float v9, v9, v10

    if-eqz v9, :cond_5

    .line 263
    sget v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    cmpg-float v9, v9, v10

    if-gez v9, :cond_4

    invoke-virtual {v8}, Landroid/view/View;->getElevation()F

    move-result v9

    sput v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    .line 264
    :cond_4
    invoke-virtual {v8, v10}, Landroid/view/View;->setElevation(F)V

    .line 269
    :cond_5
    invoke-static {v6, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    .line 270
    invoke-static {v6, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureCardShadow(Landroid/view/View;F)V

    .line 272
    :cond_6
    invoke-virtual {v7}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v8

    if-eqz v8, :cond_7

    .line 275
    div-int/lit8 v8, v3, 0x3

    sub-int v8, v3, v8

    .line 276
    invoke-virtual {v7, v1, v8, v4, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 281
    :cond_7
    const/4 v8, 0x2

    new-array v8, v8, [I

    .line 282
    invoke-virtual {v0, v8}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 283
    aget v9, v8, v1

    neg-int v9, v9

    aget v2, v8, v2

    neg-int v2, v2

    invoke-virtual {v7, v9, v2}, Landroid/graphics/Rect;->offset(II)V

    .line 284
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v7}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 286
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {v7, p1}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_8

    .line 287
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {p1, v7}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 288
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "scale="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, " region="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {v7}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, " screen="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "x"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v2, "FloatingKeyboard"

    invoke-static {v2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 291
    :cond_8
    invoke-static {v0, v6, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 295
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_9

    .line 296
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 297
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 300
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->restoreOpaque()V

    .line 302
    :cond_9
    return-void

    .line 242
    :cond_a
    :goto_0
    return-void
.end method

.method private static applyPosition(Landroid/view/View;Landroid/view/View;F)Z
    .locals 5

    .line 673
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v1, 0x0

    if-nez v0, :cond_6

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v0, :cond_6

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_6

    const/4 v0, 0x0

    cmpg-float v0, p2, v0

    if-gtz v0, :cond_0

    goto :goto_0

    .line 674
    :cond_0
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 675
    if-nez v0, :cond_1

    return v1

    .line 676
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->xFraction(Landroid/content/Context;)F

    move-result v2

    aget v3, v0, v1

    mul-float v2, v2, v3

    const/high16 v3, 0x3f800000    # 1.0f

    sub-float p2, v3, p2

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v4

    int-to-float v4, v4

    mul-float p2, p2, v4

    const/high16 v4, 0x40000000    # 2.0f

    div-float/2addr p2, v4

    sub-float/2addr v2, p2

    .line 677
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    sub-float/2addr p0, v3

    const/4 p2, 0x1

    aget v0, v0, p2

    mul-float p0, p0, v0

    .line 678
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result v0

    cmpl-float v0, v0, v2

    if-nez v0, :cond_2

    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result v0

    cmpl-float v0, v0, p0

    if-eqz v0, :cond_3

    :cond_2
    const/4 v1, 0x1

    .line 679
    :cond_3
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result p2

    cmpl-float p2, p2, v2

    if-eqz p2, :cond_4

    invoke-virtual {p1, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 680
    :cond_4
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result p2

    cmpl-float p2, p2, p0

    if-eqz p2, :cond_5

    invoke-virtual {p1, p0}, Landroid/view/View;->setTranslationY(F)V

    .line 681
    :cond_5
    return v1

    .line 673
    :cond_6
    :goto_0
    return v1
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 4

    .line 650
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 651
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 652
    if-lez v0, :cond_5

    if-gtz v1, :cond_0

    goto :goto_0

    .line 653
    :cond_0
    const/4 v2, 0x1

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 656
    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v3, :cond_1

    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v3, :cond_2

    :cond_1
    sget p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 657
    :cond_2
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v3, p1

    if-nez v3, :cond_3

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eq v3, p0, :cond_4

    .line 658
    :cond_3
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 659
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 660
    int-to-float v0, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float/2addr v0, v3

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 661
    int-to-float v0, v1

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 662
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 663
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 665
    :cond_4
    return v2

    .line 652
    :cond_5
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 1423
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1424
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1425
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;-><init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1436
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    const-wide/16 v0, 0x17c

    invoke-virtual {p0, p1, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1437
    return-void
.end method

.method private static attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 3

    .line 572
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbeArea:Landroid/view/View;

    if-ne v0, p1, :cond_0

    return-void

    .line 573
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    .line 574
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 576
    :cond_1
    new-instance v0, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 577
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 579
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;

    invoke-direct {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 600
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 601
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 602
    sput-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbeArea:Landroid/view/View;

    .line 603
    return-void
.end method

.method private static beginDrag(Landroid/view/View;Landroid/view/View;Landroid/view/View;)Z
    .locals 4

    .line 1411
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v1, 0x0

    cmpl-float v0, v0, v1

    if-lez v0, :cond_0

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 1412
    :goto_0
    invoke-static {p1, p2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 1413
    const/4 v1, 0x0

    if-nez v0, :cond_1

    return v1

    .line 1414
    :cond_1
    const/4 v2, 0x1

    sput-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1415
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 1416
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 1417
    invoke-static {p2, p1, p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1418
    invoke-static {p2, p1, p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1419
    return v2
.end method

.method private static cancelGestures()V
    .locals 9

    .line 1081
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1082
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1083
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1084
    :cond_0
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1085
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/View;

    if-eqz v1, :cond_3

    .line 1087
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/View;

    .line 1088
    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1089
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v4, 0x0

    cmpl-float v3, v3, v4

    if-lez v3, :cond_1

    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v3

    .line 1090
    :goto_0
    if-nez v2, :cond_2

    const/4 v4, 0x0

    goto :goto_1

    :cond_2
    invoke-static {v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v4

    .line 1091
    :goto_1
    if-eqz v4, :cond_3

    .line 1092
    sget-object v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getContext()Landroid/content/Context;

    move-result-object v5

    .line 1093
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v6

    invoke-interface {v6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "x_fraction_"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    .line 1094
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 1095
    const/4 v8, 0x1

    invoke-static {v2, v1, v3, v4, v8}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v8

    .line 1094
    invoke-interface {v6, v7, v8}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v6

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "y_fraction_"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    .line 1096
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 1097
    invoke-static {v2, v1, v3, v4, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v1

    .line 1096
    invoke-interface {v6, v5, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    .line 1098
    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1101
    :cond_3
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1102
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1103
    return-void
.end method

.method private static cancelLongPress(Landroid/view/View;)V
    .locals 1

    .line 1392
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    .line 1393
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 1394
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1396
    :cond_0
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1397
    return-void
.end method

.method private static clamp01(F)F
    .locals 1

    .line 1619
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const/4 v0, 0x0

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static density(Landroid/view/View;)F
    .locals 0

    .line 1623
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 1355
    sub-float/2addr p0, p2

    .line 1356
    sub-float/2addr p1, p3

    .line 1357
    mul-float p0, p0, p0

    mul-float p1, p1, p1

    add-float/2addr p0, p1

    float-to-double p0, p0

    invoke-static {p0, p1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-float p0, p0

    return p0
.end method

.method private static distanceSquared(II)I
    .locals 3

    .line 834
    invoke-static {p0}, Landroid/graphics/Color;->red(I)I

    move-result v0

    invoke-static {p1}, Landroid/graphics/Color;->red(I)I

    move-result v1

    sub-int/2addr v0, v1

    .line 835
    invoke-static {p0}, Landroid/graphics/Color;->green(I)I

    move-result v1

    invoke-static {p1}, Landroid/graphics/Color;->green(I)I

    move-result v2

    sub-int/2addr v1, v2

    .line 836
    invoke-static {p0}, Landroid/graphics/Color;->blue(I)I

    move-result p0

    invoke-static {p1}, Landroid/graphics/Color;->blue(I)I

    move-result p1

    sub-int/2addr p0, p1

    .line 837
    mul-int v0, v0, v0

    mul-int v1, v1, v1

    add-int/2addr v0, v1

    mul-int p0, p0, p0

    add-int/2addr v0, p0

    return v0
.end method

.method private static dropFloatingChrome()V
    .locals 2

    .line 334
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 335
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 336
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 337
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 338
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 339
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 340
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 341
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 342
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->restoreInputElevation()V

    .line 343
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 344
    return-void
.end method

.method private static ensureCardShadow(Landroid/view/View;F)V
    .locals 3

    .line 881
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    instance-of p1, p1, Landroid/view/ViewGroup;

    if-nez p1, :cond_0

    return-void

    .line 882
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup;

    .line 883
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-eq v0, p1, :cond_2

    .line 884
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 885
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;-><init>(Landroid/content/Context;F)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 886
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 888
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    const/high16 v1, -0x40800000    # -1.0f

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setTranslationZ(F)V

    .line 889
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 890
    new-instance p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;-><init>()V

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 897
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    invoke-virtual {p0, p1}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 899
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncCardShadow()V

    .line 900
    return-void
.end method

.method private static ensureHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 699
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_0

    return-void

    .line 700
    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float p2, p2, v0

    if-ltz p2, :cond_1

    .line 702
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 703
    return-void

    .line 705
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object p2

    .line 706
    if-nez p2, :cond_2

    return-void

    .line 707
    :cond_2
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 708
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, p2, :cond_4

    .line 709
    :cond_3
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 710
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 711
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 712
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 713
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->bringToFront()V

    .line 714
    sget p0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt p0, v1, :cond_4

    .line 717
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v1, v0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setElevation(F)V

    .line 720
    :cond_4
    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 721
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 722
    invoke-static {p2, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 725
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz p0, :cond_5

    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    if-eq p0, p1, :cond_5

    .line 726
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->functionLayerColor(Landroid/view/View;)I

    move-result p0

    .line 727
    if-eqz p0, :cond_5

    .line 728
    sget-object p2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarColor(I)V

    .line 729
    sput-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    .line 732
    :cond_5
    return-void
.end method

.method private static enterEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 5

    .line 1002
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_0

    .line 1003
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 1004
    if-nez v0, :cond_1

    return-void

    .line 1005
    :cond_1
    const/4 v1, 0x1

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1006
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1007
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1008
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1009
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1011
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 1012
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1015
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-direct {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;-><init>(Landroid/content/Context;)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    .line 1016
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1018
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;

    invoke-direct {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;-><init>()V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;)V

    .line 1041
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 1042
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->bringToFront()V

    .line 1043
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_2

    .line 1044
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v3

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    int-to-float p0, p0

    const/high16 v3, 0x40000000    # 2.0f

    add-float/2addr p0, v3

    invoke-virtual {v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setElevation(F)V

    .line 1046
    :cond_2
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1047
    invoke-virtual {p1, v1}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 1048
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 1049
    return-void

    .line 1002
    :cond_3
    :goto_0
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 1

    .line 1120
    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;Z)V

    .line 1121
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;Z)V
    .locals 6

    .line 1124
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 1125
    :cond_0
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1126
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1127
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1128
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-lez v1, :cond_1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v1

    .line 1129
    :goto_0
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1130
    if-eqz p2, :cond_2

    if-eqz v2, :cond_2

    .line 1131
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 1132
    const/4 v3, 0x1

    invoke-static {p1, p0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1133
    invoke-static {p1, p0, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v0

    .line 1134
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1135
    const-string v4, "scale"

    invoke-interface {v2, v4, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "x_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1136
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-interface {v2, v4, v3}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "y_fraction_"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 1137
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {v2, p2, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 1138
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1140
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1141
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1142
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1143
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1144
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 1145
    return-void
.end method

.method private static fadeAlpha(Landroid/view/View;FJ)V
    .locals 1

    .line 557
    if-nez p0, :cond_0

    return-void

    .line 558
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    cmpl-float v0, v0, p1

    if-nez v0, :cond_1

    .line 559
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 560
    return-void

    .line 562
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 563
    return-void
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 1632
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 1633
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 1634
    if-nez v1, :cond_0

    .line 1635
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "id keyboard_area not found in "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v0, "FloatingKeyboard"

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 1636
    const/4 p0, 0x0

    return-object p0

    .line 1638
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 1

    .line 1594
    const/high16 v0, 0x3f800000    # 1.0f

    if-eqz p4, :cond_0

    .line 1595
    invoke-virtual {p0}, Landroid/view/View;->getTranslationX()F

    move-result p0

    sub-float/2addr v0, p2

    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p1

    int-to-float p1, p1

    mul-float v0, v0, p1

    const/high16 p1, 0x40000000    # 2.0f

    div-float/2addr v0, p1

    add-float/2addr p0, v0

    const/4 p1, 0x0

    aget p1, p3, p1

    div-float/2addr p0, p1

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    return p0

    .line 1598
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getTranslationY()F

    move-result p0

    const/4 p1, 0x1

    aget p1, p3, p1

    div-float/2addr p0, p1

    add-float/2addr p0, v0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    return p0
.end method

.method private static freeRange(Landroid/view/View;Landroid/view/View;F)[F
    .locals 2

    .line 686
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 687
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    .line 688
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 689
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 690
    if-lez v0, :cond_1

    if-lez p0, :cond_1

    if-lez v1, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 691
    :cond_0
    int-to-float v0, v0

    int-to-float v1, v1

    mul-float v1, v1, p2

    sub-float/2addr v0, v1

    .line 692
    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    int-to-float p0, p0

    int-to-float p1, p1

    mul-float p1, p1, p2

    sub-float/2addr p0, p1

    .line 693
    invoke-static {v1, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    const/4 p1, 0x2

    new-array p1, p1, [F

    const/4 p2, 0x0

    aput v0, p1, p2

    const/4 p2, 0x1

    aput p0, p1, p2

    .line 691
    return-object p1

    .line 690
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static functionLayerColor(Landroid/view/View;)I
    .locals 7

    .line 747
    const/4 v0, 0x7

    new-array v1, v0, [I

    fill-array-data v1, :array_0

    .line 749
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v2

    .line 750
    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v0, :cond_4

    aget v5, v1, v4

    .line 751
    if-nez v2, :cond_0

    const/4 v5, 0x0

    goto :goto_1

    :cond_0
    invoke-virtual {v2, v5}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v5

    .line 752
    :goto_1
    if-eqz v5, :cond_3

    invoke-virtual {v5}, Landroid/view/View;->isShown()Z

    move-result v6

    if-nez v6, :cond_1

    goto :goto_2

    .line 755
    :cond_1
    invoke-virtual {v5}, Landroid/view/View;->getWidth()I

    move-result v6

    if-lez v6, :cond_3

    invoke-virtual {v5}, Landroid/view/View;->getHeight()I

    move-result v6

    if-gtz v6, :cond_2

    goto :goto_2

    .line 756
    :cond_2
    invoke-static {p0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->functionRowInk(Landroid/view/View;Landroid/view/View;)I

    move-result v5

    .line 757
    if-eqz v5, :cond_3

    return v5

    .line 750
    :cond_3
    :goto_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 759
    :cond_4
    return v3

    nop

    :array_0
    .array-data 4
        0x7f0f0002
        0x7f0f0005
        0x7f0f004f
        0x7f0f0169
        0x7f0f02b7
        0x7f0f0276
        0x7f0f022f
    .end array-data
.end method

.method private static functionRowInk(Landroid/view/View;Landroid/view/View;)I
    .locals 17

    .line 772
    move-object/from16 v0, p0

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 773
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v2

    .line 774
    invoke-virtual {v0}, Landroid/view/View;->getScaleX()F

    move-result v3

    .line 775
    const/4 v4, 0x0

    if-lez v1, :cond_e

    if-lez v2, :cond_e

    const/4 v5, 0x0

    cmpg-float v5, v3, v5

    if-gtz v5, :cond_0

    goto/16 :goto_8

    .line 777
    :cond_0
    const/4 v5, 0x2

    :try_start_0
    new-array v6, v5, [I

    .line 778
    new-array v5, v5, [I

    .line 779
    invoke-virtual {v0, v6}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 780
    move-object/from16 v7, p1

    invoke-virtual {v7, v5}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 782
    aget v8, v5, v4

    aget v9, v6, v4

    sub-int/2addr v8, v9

    int-to-float v8, v8

    div-float/2addr v8, v3

    invoke-static {v8}, Ljava/lang/Math;->round(F)I

    move-result v8

    .line 783
    const/4 v9, 0x1

    aget v5, v5, v9

    aget v6, v6, v9

    sub-int/2addr v5, v6

    int-to-float v5, v5

    div-float/2addr v5, v3

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 784
    invoke-virtual {v7}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 785
    invoke-virtual {v7}, Landroid/view/View;->getHeight()I

    move-result v6

    .line 787
    sget-object v7, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v1, v2, v7}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v7

    .line 789
    new-instance v10, Landroid/graphics/Canvas;

    invoke-direct {v10, v7}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    invoke-virtual {v0, v10}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 790
    const/16 v0, 0x40

    new-array v10, v0, [I

    .line 791
    nop

    .line 792
    const/4 v11, 0x1

    const/4 v12, 0x0

    :goto_0
    const/4 v13, 0x4

    if-gt v11, v13, :cond_5

    if-ge v12, v0, :cond_5

    .line 793
    mul-int v13, v6, v11

    div-int/lit8 v13, v13, 0x5

    add-int/2addr v13, v3

    .line 794
    if-ltz v13, :cond_4

    if-lt v13, v2, :cond_1

    goto :goto_3

    .line 795
    :cond_1
    const/4 v14, 0x1

    :goto_1
    const/16 v15, 0x10

    if-gt v14, v15, :cond_4

    if-ge v12, v0, :cond_4

    .line 796
    mul-int v15, v5, v14

    div-int/lit8 v15, v15, 0x11

    add-int/2addr v15, v8

    .line 797
    if-ltz v15, :cond_3

    if-lt v15, v1, :cond_2

    goto :goto_2

    .line 798
    :cond_2
    add-int/lit8 v16, v12, 0x1

    invoke-virtual {v7, v15, v13}, Landroid/graphics/Bitmap;->getPixel(II)I

    move-result v15

    aput v15, v10, v12

    move/from16 v12, v16

    .line 795
    :cond_3
    :goto_2
    add-int/lit8 v14, v14, 0x1

    goto :goto_1

    .line 792
    :cond_4
    :goto_3
    add-int/lit8 v11, v11, 0x1

    goto :goto_0

    .line 801
    :cond_5
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    .line 802
    if-nez v12, :cond_6

    return v4

    .line 804
    :cond_6
    nop

    .line 805
    nop

    .line 806
    const/4 v0, 0x0

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_4
    if-ge v0, v12, :cond_a

    .line 807
    nop

    .line 808
    const/4 v3, 0x0

    const/4 v5, 0x0

    :goto_5
    if-ge v3, v12, :cond_8

    .line 809
    aget v6, v10, v3

    aget v7, v10, v0

    if-ne v6, v7, :cond_7

    add-int/lit8 v5, v5, 0x1

    .line 808
    :cond_7
    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    .line 811
    :cond_8
    if-le v5, v2, :cond_9

    .line 812
    nop

    .line 813
    aget v1, v10, v0

    move v2, v5

    .line 806
    :cond_9
    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 817
    :cond_a
    nop

    .line 818
    nop

    .line 819
    const/4 v0, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_6
    if-ge v0, v12, :cond_c

    .line 820
    aget v5, v10, v0

    invoke-static {v5, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distanceSquared(II)I

    move-result v5

    .line 821
    if-le v5, v2, :cond_b

    .line 822
    nop

    .line 823
    aget v3, v10, v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move v2, v5

    .line 819
    :cond_b
    add-int/lit8 v0, v0, 0x1

    goto :goto_6

    .line 827
    :cond_c
    const/16 v0, 0x640

    if-ge v2, v0, :cond_d

    goto :goto_7

    :cond_d
    move v4, v3

    :goto_7
    return v4

    .line 828
    :catchall_0
    move-exception v0

    .line 829
    return v4

    .line 775
    :cond_e
    :goto_8
    return v4
.end method

.method private static handleEditDrag(FFZ)V
    .locals 9

    .line 1216
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1217
    if-nez v0, :cond_0

    return-void

    .line 1218
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1219
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    const/high16 v4, 0x3f800000    # 1.0f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1220
    :goto_0
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1221
    if-nez v3, :cond_2

    return-void

    .line 1223
    :cond_2
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez v5, :cond_3

    .line 1224
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 1225
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 1226
    invoke-static {v0, v1, v2, v3, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1227
    invoke-static {v0, v1, v2, v3, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1228
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1229
    if-eqz p2, :cond_3

    .line 1230
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1231
    return-void

    .line 1235
    :cond_3
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr p0, v8

    aget v8, v3, v7

    div-float/2addr p0, v8

    add-float/2addr v5, p0

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    .line 1236
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v8

    aget v8, v3, v6

    div-float/2addr p1, v8

    add-float/2addr v5, p1

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1237
    aget v5, v3, v7

    mul-float v5, v5, p0

    sub-float v2, v4, v2

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v8

    int-to-float v8, v8

    mul-float v2, v2, v8

    const/high16 v8, 0x40000000    # 2.0f

    div-float/2addr v2, v8

    sub-float/2addr v5, v2

    invoke-virtual {v0, v5}, Landroid/view/View;->setTranslationX(F)V

    .line 1238
    sub-float v2, p1, v4

    aget v3, v3, v6

    mul-float v2, v2, v3

    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationY(F)V

    .line 1239
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v2, :cond_4

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_4

    .line 1240
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1242
    :cond_4
    if-eqz p2, :cond_5

    .line 1243
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1244
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 1245
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "x_fraction_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 1246
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2, p0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 1247
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1248
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1250
    :cond_5
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1251
    return-void
.end method

.method private static handleEditScale(IFFZ)V
    .locals 17

    .line 1256
    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1257
    if-nez v3, :cond_0

    return-void

    .line 1258
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    .line 1260
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    const/high16 v6, 0x3f800000    # 1.0f

    const/4 v7, 0x2

    const/4 v8, 0x0

    const/4 v9, 0x1

    const/4 v10, 0x0

    if-nez v5, :cond_5

    .line 1261
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 1262
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v11

    .line 1263
    if-lez v5, :cond_4

    if-gtz v11, :cond_1

    goto :goto_2

    .line 1264
    :cond_1
    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v12, v12, v10

    if-lez v12, :cond_2

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_2
    const/high16 v12, 0x3f800000    # 1.0f

    .line 1265
    :goto_0
    new-array v13, v7, [I

    .line 1266
    invoke-virtual {v3, v13}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1267
    aget v14, v13, v8

    int-to-float v14, v14

    .line 1268
    aget v13, v13, v9

    int-to-float v13, v13

    .line 1269
    int-to-float v5, v5

    mul-float v15, v5, v12

    add-float/2addr v15, v14

    .line 1270
    int-to-float v11, v11

    mul-float v16, v11, v12

    add-float v16, v13, v16

    .line 1271
    packed-switch v0, :pswitch_data_0

    .line 1291
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1292
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1293
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1294
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    goto :goto_1

    .line 1285
    :pswitch_0
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1286
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1287
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1288
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1289
    goto :goto_1

    .line 1279
    :pswitch_1
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1280
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1281
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1282
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1283
    goto :goto_1

    .line 1273
    :pswitch_2
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1274
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1275
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1276
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1277
    nop

    .line 1297
    :goto_1
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v11}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    .line 1298
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    cmpg-float v5, v5, v6

    if-gez v5, :cond_3

    return-void

    .line 1299
    :cond_3
    sput v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    .line 1300
    invoke-virtual {v3}, Landroid/view/View;->getTranslationX()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    .line 1301
    invoke-virtual {v3}, Landroid/view/View;->getTranslationY()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    .line 1302
    sput-boolean v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1303
    if-eqz p3, :cond_5

    .line 1304
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1305
    return-void

    .line 1263
    :cond_4
    :goto_2
    return-void

    .line 1309
    :cond_5
    if-eqz p3, :cond_8

    .line 1310
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1311
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, v10

    if-lez v0, :cond_6

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1312
    :cond_6
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1313
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "scale"

    invoke-interface {v0, v1, v6}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1314
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v0, :cond_7

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_7

    .line 1315
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1317
    :cond_7
    return-void

    .line 1320
    :cond_8
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v1

    .line 1321
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    mul-float v2, v2, v1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    div-float/2addr v2, v1

    .line 1322
    const v1, 0x3f6b851f    # 0.92f

    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 1321
    const/high16 v2, 0x3f000000    # 0.5f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1326
    new-array v2, v7, [I

    .line 1327
    invoke-virtual {v4, v2}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1328
    if-eq v0, v9, :cond_a

    if-ne v0, v7, :cond_9

    goto :goto_3

    .line 1330
    :cond_9
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    aget v6, v2, v8

    int-to-float v6, v6

    sub-float/2addr v5, v6

    goto :goto_4

    .line 1329
    :cond_a
    :goto_3
    aget v5, v2, v8

    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v6

    add-int/2addr v5, v6

    int-to-float v5, v5

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sub-float/2addr v5, v6

    .line 1331
    :goto_4
    if-eq v0, v7, :cond_c

    const/4 v6, 0x3

    if-ne v0, v6, :cond_b

    goto :goto_5

    .line 1333
    :cond_b
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    aget v2, v2, v9

    int-to-float v2, v2

    sub-float/2addr v0, v2

    goto :goto_6

    .line 1332
    :cond_c
    :goto_5
    aget v0, v2, v9

    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v2

    add-int/2addr v0, v2

    int-to-float v0, v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    sub-float/2addr v0, v2

    .line 1334
    :goto_6
    cmpl-float v2, v5, v10

    if-lez v2, :cond_d

    cmpl-float v2, v0, v10

    if-lez v2, :cond_d

    .line 1335
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v5, v2

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    div-float/2addr v0, v2

    invoke-static {v5, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 1338
    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 1340
    :cond_d
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 1341
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    .line 1342
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    sub-float/2addr v5, v1

    .line 1343
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleX(F)V

    .line 1344
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleY(F)V

    .line 1345
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1346
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    sub-float/2addr v6, v0

    mul-float v6, v6, v5

    add-float/2addr v1, v6

    invoke-virtual {v3, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 1347
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    sub-float/2addr v1, v2

    mul-float v1, v1, v5

    add-float/2addr v0, v1

    invoke-virtual {v3, v0}, Landroid/view/View;->setTranslationY(F)V

    .line 1348
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v0, :cond_e

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_e

    .line 1349
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1351
    :cond_e
    invoke-virtual {v4}, Landroid/view/View;->requestLayout()V

    .line 1352
    return-void

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;
    .locals 1

    .line 846
    const p1, 0x1020002

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 847
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p1, Landroid/view/ViewGroup;

    return-object p1

    .line 848
    :cond_0
    instance-of p1, p0, Landroid/view/ViewGroup;

    if-eqz p1, :cond_1

    check-cast p0, Landroid/view/ViewGroup;

    goto :goto_0

    :cond_1
    const/4 p0, 0x0

    :goto_0
    return-object p0
.end method

.method static idleFadeEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 191
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "idle_fade"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 186
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "enabled"

    const/4 v1, 0x0

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method static isTablet(Landroid/content/Context;)Z
    .locals 1

    .line 200
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 201
    iget p0, p0, Landroid/content/res/Configuration;->smallestScreenWidthDp:I

    const/16 v0, 0x258

    if-lt p0, v0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    :cond_0
    const/4 p0, 0x0

    :goto_0
    return p0
.end method

.method private static leaveEditMode(Z)V
    .locals 2

    .line 1106
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 1107
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1108
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    goto :goto_0

    .line 1109
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getRootView()Landroid/view/View;

    move-result-object v1

    goto :goto_0

    :cond_2
    const/4 v1, 0x0

    .line 1110
    :goto_0
    if-nez v0, :cond_3

    if-eqz v1, :cond_3

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1111
    :cond_3
    if-eqz v0, :cond_5

    if-nez v1, :cond_4

    goto :goto_1

    .line 1116
    :cond_4
    invoke-static {v1, v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;Z)V

    .line 1117
    return-void

    .line 1112
    :cond_5
    :goto_1
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1113
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1114
    return-void
.end method

.method private static moveHandle(Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 972
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 973
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 974
    if-eqz v0, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    .line 975
    :cond_1
    const/high16 v1, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    invoke-static {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 976
    return-void

    .line 974
    :cond_2
    :goto_0
    return-void
.end method

.method public static onCardRebuilt()V
    .locals 1

    .line 1069
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelGestures()V

    .line 1070
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->leaveEditMode(Z)V

    .line 1071
    return-void
.end method

.method public static onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1440
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1441
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1442
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v2, :pswitch_data_0

    .line 1542
    return v1

    .line 1507
    :pswitch_0
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1508
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1509
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1510
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1511
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1512
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1513
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1515
    if-eqz v2, :cond_1

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->persistPosition(Landroid/view/View;Landroid/view/View;)V

    .line 1516
    :cond_1
    if-nez p1, :cond_2

    if-eqz v2, :cond_3

    .line 1517
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1518
    if-eqz p0, :cond_3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1520
    :cond_3
    return v4

    .line 1464
    :pswitch_1
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz v2, :cond_5

    .line 1465
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v2

    .line 1466
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v2

    .line 1467
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result p0

    .line 1468
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p0, p0

    mul-float p0, p0, p0

    cmpl-float p0, v0, p0

    if-lez p0, :cond_4

    .line 1472
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1473
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1475
    :cond_4
    return v4

    .line 1477
    :cond_5
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez v2, :cond_7

    .line 1478
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    if-eqz v0, :cond_6

    .line 1479
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v1

    .line 1480
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v1

    .line 1481
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result v1

    .line 1482
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p1, v1

    mul-float p1, p1, p1

    cmpl-float p1, v0, p1

    if-lez p1, :cond_6

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1484
    :cond_6
    return v4

    .line 1486
    :cond_7
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1487
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v5, v3

    if-lez v3, :cond_8

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_8
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 1488
    :goto_0
    if-nez v2, :cond_9

    const/4 v3, 0x0

    goto :goto_1

    :cond_9
    invoke-static {v0, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1492
    :goto_1
    if-nez v3, :cond_a

    return v4

    .line 1493
    :cond_a
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1494
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v6

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr v6, v7

    aget v7, v3, v1

    div-float/2addr v6, v7

    add-float/2addr v5, v6

    .line 1493
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result v5

    .line 1495
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1496
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v7

    aget v7, v3, v4

    div-float/2addr p1, v7

    add-float/2addr v6, p1

    .line 1495
    invoke-static {v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1497
    aget v1, v3, v1

    mul-float v5, v5, v1

    const/high16 v1, 0x3f800000    # 1.0f

    sub-float p0, v1, p0

    .line 1498
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v6

    int-to-float v6, v6

    mul-float p0, p0, v6

    const/high16 v6, 0x40000000    # 2.0f

    div-float/2addr p0, v6

    sub-float/2addr v5, p0

    .line 1497
    invoke-virtual {v2, v5}, Landroid/view/View;->setTranslationX(F)V

    .line 1499
    sub-float/2addr p1, v1

    aget p0, v3, v4

    mul-float p1, p1, p0

    invoke-virtual {v2, p1}, Landroid/view/View;->setTranslationY(F)V

    .line 1500
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveHandle(Landroid/view/View;Landroid/view/View;)V

    .line 1501
    return v4

    .line 1523
    :pswitch_2
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz p1, :cond_b

    .line 1524
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1525
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1526
    return v4

    .line 1528
    :cond_b
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1529
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez p1, :cond_c

    .line 1532
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide p0

    sput-wide p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    .line 1533
    return v4

    .line 1535
    :cond_c
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1536
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->settle(Landroid/view/View;Landroid/view/View;)V

    .line 1537
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1538
    if-eqz p0, :cond_d

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1539
    :cond_d
    return v4

    .line 1444
    :pswitch_3
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1445
    if-nez v2, :cond_e

    return v1

    .line 1446
    :cond_e
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v5, v3

    if-lez v3, :cond_f

    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_2

    :cond_f
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v3

    .line 1447
    :goto_2
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1448
    if-nez v3, :cond_10

    return v1

    .line 1449
    :cond_10
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    .line 1450
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    .line 1451
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 1452
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    .line 1453
    sget-wide v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x140

    cmp-long p1, v5, v7

    if-gtz p1, :cond_11

    .line 1455
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1456
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0x12c

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_3

    .line 1458
    :cond_11
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1459
    invoke-static {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1461
    :goto_3
    return v4

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static onKeyboardHidden()V
    .locals 1

    .line 1057
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelGestures()V

    .line 1058
    const/4 v0, 0x1

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->leaveEditMode(Z)V

    .line 1059
    return-void
.end method

.method private static orientation(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    .line 1613
    nop

    .line 1612
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->orientation:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    .line 1614
    const-string p0, "landscape"

    goto :goto_0

    .line 1615
    :cond_0
    const-string p0, "portrait"

    .line 1612
    :goto_0
    return-object p0
.end method

.method private static persistPosition(Landroid/view/View;Landroid/view/View;)V
    .locals 6

    .line 1549
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1550
    if-nez v0, :cond_0

    return-void

    .line 1551
    :cond_0
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-lez v1, :cond_1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v1

    .line 1552
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1553
    if-nez v2, :cond_2

    return-void

    .line 1554
    :cond_2
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1555
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "x_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1556
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 1557
    const/4 v5, 0x1

    invoke-static {v0, p1, v1, v2, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    .line 1556
    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "y_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1558
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 1559
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result p1

    .line 1558
    invoke-interface {v3, p0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1560
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1561
    return-void
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 216
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static rearmIdleFade(Landroid/view/View;)V
    .locals 3

    .line 514
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 517
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 518
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 519
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOpaque(Landroid/view/View;)V

    .line 520
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOpaque(Landroid/view/View;)V

    .line 521
    return-void

    .line 523
    :cond_0
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 524
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 525
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 526
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 527
    return-void
.end method

.method private static removeCardShadow()V
    .locals 3

    .line 852
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 853
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    if-eqz v0, :cond_0

    .line 854
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 855
    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 857
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 858
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 859
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v1, :cond_1

    return-void

    .line 860
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_2

    .line 861
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    goto :goto_0

    .line 862
    :cond_2
    move-object v1, v0

    .line 863
    :goto_0
    if-eqz v1, :cond_3

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 864
    :cond_3
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 865
    return-void
.end method

.method private static removeEditOverlay()V
    .locals 3

    .line 1206
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-nez v0, :cond_0

    return-void

    .line 1207
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1208
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 1209
    :cond_1
    move-object v0, v1

    .line 1210
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1211
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    .line 1212
    return-void
.end method

.method private static removeHandle()V
    .locals 3

    .line 979
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 981
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 982
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 983
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 984
    :cond_1
    move-object v0, v1

    .line 985
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 986
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 988
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    .line 989
    return-void
.end method

.method private static removeIdleProbe()V
    .locals 2

    .line 606
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 607
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    .line 608
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 609
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 611
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v0, :cond_1

    .line 612
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 613
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setAlpha(F)V

    .line 615
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 616
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 618
    :cond_2
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 619
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbeArea:Landroid/view/View;

    .line 620
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 621
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V
    .locals 0

    .line 403
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 404
    if-nez p0, :cond_0

    return-void

    .line 405
    :cond_0
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 406
    if-nez p0, :cond_1

    return-void

    .line 407
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 408
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/view/View;Z)V
    .locals 7

    .line 413
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 417
    sget-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x32

    cmp-long v6, v2, v4

    if-gez v6, :cond_0

    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointTarget:Z

    if-ne p1, v2, :cond_0

    return-void

    .line 418
    :cond_0
    sput-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    .line 419
    sput-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointTarget:Z

    .line 420
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 430
    return-void
.end method

.method private static resetFromEdit()V
    .locals 8

    .line 1148
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1149
    if-nez v0, :cond_0

    return-void

    .line 1150
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1151
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 1155
    const v3, 0x3f3851ec    # 0.72f

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1156
    invoke-virtual {v0, v3}, Landroid/view/View;->setScaleX(F)V

    .line 1157
    invoke-virtual {v0, v3}, Landroid/view/View;->setScaleY(F)V

    .line 1158
    invoke-static {v1, v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v4

    .line 1159
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v5

    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 1160
    const-string v6, "scale"

    invoke-interface {v5, v6, v3}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v5

    .line 1161
    if-eqz v4, :cond_1

    .line 1162
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "x_fraction_"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 1163
    const/4 v7, 0x1

    invoke-static {v0, v1, v3, v4, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v7

    .line 1162
    invoke-interface {v5, v6, v7}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    .line 1164
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "y_fraction_"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1165
    const/4 v6, 0x0

    invoke-static {v0, v1, v3, v4, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1164
    invoke-interface {v5, v2, v3}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    .line 1167
    :cond_1
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1168
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v2, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_2

    .line 1169
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1171
    :cond_2
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1172
    return-void
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    .line 358
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 359
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 360
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 361
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 362
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 363
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 364
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 365
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 368
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->restoreInputElevation()V

    .line 369
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 370
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v1, v1, v2

    if-nez v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-nez v1, :cond_0

    return-void

    .line 371
    :cond_0
    sput v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 372
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 373
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 374
    if-nez p0, :cond_1

    return-void

    .line 375
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 376
    if-nez p0, :cond_2

    return-void

    .line 377
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 378
    if-nez p0, :cond_3

    return-void

    .line 379
    :cond_3
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleX(F)V

    .line 380
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleY(F)V

    .line 381
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 382
    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 383
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 384
    return-void
.end method

.method private static restoreInputElevation()V
    .locals 2

    .line 348
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    const/4 v1, 0x0

    cmpg-float v0, v0, v1

    if-gez v0, :cond_0

    return-void

    .line 349
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    goto :goto_0

    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 350
    :goto_0
    if-eqz v0, :cond_2

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/View;

    if-eqz v1, :cond_2

    .line 351
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    invoke-virtual {v0, v1}, Landroid/view/View;->setElevation(F)V

    .line 353
    :cond_2
    const/high16 v0, -0x40800000    # -1.0f

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseInputElevation:F

    .line 354
    return-void
.end method

.method private static restoreOpaque()V
    .locals 1

    .line 546
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOpaque(Landroid/view/View;)V

    .line 547
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOpaque(Landroid/view/View;)V

    .line 548
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 205
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 206
    const v0, 0x3f6b851f    # 0.92f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const/high16 v0, 0x3f000000    # 0.5f

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static scheduleHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 1

    .line 310
    if-nez p1, :cond_0

    return-void

    .line 311
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;-><init>(Landroid/view/View;Landroid/view/View;F)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 324
    return-void
.end method

.method private static scheduleIdleFade(Landroid/view/View;)V
    .locals 3

    .line 498
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 499
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_0

    .line 502
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 503
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 504
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->restoreOpaque()V

    .line 505
    return-void

    .line 507
    :cond_0
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_1

    return-void

    .line 508
    :cond_1
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 509
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 510
    return-void
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 1627
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 1628
    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p0

    :goto_0
    return-object p0
.end method

.method private static setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V
    .locals 5

    .line 478
    invoke-virtual {p0}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    .line 479
    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 480
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 481
    array-length v2, p1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 482
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 483
    if-eqz p2, :cond_0

    const/16 v0, 0x8

    goto :goto_1

    :cond_0
    const/4 v0, 0x0

    .line 484
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eq v2, v0, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 481
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 489
    :cond_2
    :goto_2
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 490
    check-cast p0, Landroid/view/ViewGroup;

    .line 491
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 492
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 491
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 495
    :cond_3
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 195
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 196
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 197
    return-void
.end method

.method private static setOneHandedAccessPointHidden(Landroid/view/View;Z)V
    .locals 12

    .line 461
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 462
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v1, v1

    new-array v2, v1, [Ljava/lang/String;

    .line 463
    nop

    .line 464
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v4, :cond_1

    aget-object v8, v3, v6

    .line 465
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const-string v10, "string"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v9, v8, v10, v11}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v8

    .line 466
    if-eqz v8, :cond_0

    add-int/lit8 v9, v7, 0x1

    invoke-virtual {v0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v2, v7

    move v7, v9

    .line 464
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 468
    :cond_1
    if-nez v7, :cond_2

    return-void

    .line 469
    :cond_2
    if-ge v7, v1, :cond_3

    .line 470
    new-array v0, v7, [Ljava/lang/String;

    .line 471
    invoke-static {v2, v5, v0, v5, v7}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 472
    move-object v2, v0

    .line 474
    :cond_3
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 475
    return-void
.end method

.method private static setOpaque(Landroid/view/View;)V
    .locals 2

    .line 551
    if-nez p0, :cond_0

    return-void

    .line 552
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 553
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_1

    invoke-virtual {p0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 554
    :cond_1
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 210
    const v0, 0x3f6b851f    # 0.92f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const/high16 v0, 0x3f000000    # 0.5f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 211
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 212
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 213
    return-void
.end method

.method private static settle(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1564
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1565
    if-nez v0, :cond_0

    return-void

    .line 1566
    :cond_0
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float v1, v1, v2

    if-lez v1, :cond_1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v1

    .line 1567
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1568
    if-nez v2, :cond_2

    return-void

    .line 1569
    :cond_2
    const/4 v3, 0x1

    invoke-static {v0, p1, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1570
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v2

    .line 1576
    const v4, 0x3f6b851f    # 0.92f

    cmpl-float v5, v2, v4

    if-lez v5, :cond_3

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    cmpg-float v4, v5, v4

    if-gez v4, :cond_3

    .line 1577
    nop

    .line 1578
    const/high16 v2, 0x3f800000    # 1.0f

    const/high16 v3, 0x3f000000    # 0.5f

    .line 1580
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1581
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1582
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v4, v5, v3}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "y_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1583
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v3, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1584
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1585
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1586
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1589
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    .line 1590
    return-void
.end method

.method private static syncCardShadow()V
    .locals 7

    .line 904
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 905
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v1, :cond_5

    if-eqz v0, :cond_5

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 906
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getScaleX()F

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v1

    .line 907
    invoke-virtual {v0}, Landroid/view/View;->getScaleY()F

    move-result v2

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    .line 908
    const/4 v3, 0x0

    cmpg-float v4, v1, v3

    if-lez v4, :cond_4

    cmpg-float v4, v2, v3

    if-gtz v4, :cond_1

    goto :goto_1

    .line 911
    :cond_1
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v4

    int-to-float v4, v4

    mul-float v4, v4, v1

    .line 912
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    mul-float v1, v1, v2

    .line 913
    cmpg-float v2, v4, v3

    if-lez v2, :cond_3

    cmpg-float v2, v1, v3

    if-gtz v2, :cond_2

    goto :goto_0

    .line 914
    :cond_2
    const/4 v2, 0x2

    new-array v3, v2, [I

    .line 915
    invoke-virtual {v0, v3}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 916
    new-array v0, v2, [I

    .line 917
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLocationOnScreen([I)V

    .line 918
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    const/4 v5, 0x0

    aget v6, v3, v5

    aget v5, v0, v5

    sub-int/2addr v6, v5

    int-to-float v5, v6

    const/4 v6, 0x1

    aget v3, v3, v6

    aget v0, v0, v6

    sub-int/2addr v3, v0

    int-to-float v0, v3

    invoke-virtual {v2, v5, v0, v4, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setCardRect(FFFF)V

    .line 923
    return-void

    .line 913
    :cond_3
    :goto_0
    return-void

    .line 908
    :cond_4
    :goto_1
    return-void

    .line 905
    :cond_5
    :goto_2
    return-void
.end method

.method private static touchSlop(Landroid/view/View;)I
    .locals 1

    .line 1385
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    if-gez v0, :cond_0

    .line 1386
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 1388
    :cond_0
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    return p0
.end method

.method private static unwatchAccessPoints()V
    .locals 2

    .line 440
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 441
    if-nez v0, :cond_0

    return-void

    .line 442
    :cond_0
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 443
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 444
    return-void
.end method

.method private static updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 4

    .line 1175
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-nez v0, :cond_0

    return-void

    .line 1176
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 1177
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1178
    new-array v0, v0, [I

    .line 1179
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 1180
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 1181
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 1182
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1183
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 1184
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget p1, v0, p1

    sub-int/2addr v3, p1

    .line 1185
    const/4 p1, 0x1

    aget v1, v1, p1

    aget p1, v0, p1

    sub-int/2addr v1, p1

    .line 1187
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p1, p1, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p1, :cond_3

    .line 1188
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 1189
    :cond_3
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p1, v2, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 1192
    :goto_1
    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v0, v2, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v0, p0, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne v0, v3, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne v0, v1, :cond_4

    .line 1194
    return-void

    .line 1196
    :cond_4
    iput v2, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 1197
    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 1198
    const/16 p0, 0x33

    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 1199
    iput v3, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 1200
    iput v1, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 1201
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1202
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->fitFrame()V

    .line 1203
    return-void

    .line 1183
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 6

    .line 926
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 930
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 931
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 932
    new-array v0, v0, [I

    .line 933
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 934
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 935
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 936
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 937
    if-lez v2, :cond_5

    if-gtz v3, :cond_2

    goto :goto_2

    .line 938
    :cond_2
    const/4 v4, 0x0

    aget v5, v1, v4

    aget v4, v0, v4

    sub-int/2addr v5, v4

    .line 940
    const/4 v4, 0x1

    aget v1, v1, v4

    aget v0, v0, v4

    sub-int/2addr v1, v0

    add-int/2addr v1, v3

    sub-int/2addr v1, p2

    .line 942
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_3

    .line 943
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 944
    :cond_3
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v2, p2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 953
    :goto_1
    const/high16 v3, 0x40800000    # 4.0f

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v4

    mul-float v4, v4, v3

    .line 954
    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    const/high16 p0, 0x40000000    # 2.0f

    div-float/2addr p1, p0

    .line 955
    int-to-float p0, p2

    sub-float/2addr p0, v4

    invoke-static {p0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p0

    invoke-static {v4, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    .line 956
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarCenterFromBottom(F)V

    .line 957
    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p0, v2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p0, p2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p0, v5, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p0, v1, :cond_4

    .line 959
    return-void

    .line 961
    :cond_4
    iput v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 962
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 963
    const/16 p0, 0x33

    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 966
    iput v5, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 967
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 968
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 969
    return-void

    .line 937
    :cond_5
    :goto_2
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 6

    .line 1372
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_1

    .line 1373
    :cond_0
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1374
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1375
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1376
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1377
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1378
    aget v2, v0, v1

    const/4 v4, 0x1

    aget v5, v0, v4

    aget v1, v0, v1

    add-int/2addr v1, v3

    aget v0, v0, v4

    add-int/2addr v0, p0

    invoke-virtual {p1, v2, v5, v1, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 1380
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/2addr p0, v4

    return p0

    .line 1372
    :cond_2
    :goto_1
    return v1
.end method

.method private static wakeIdle()V
    .locals 3

    .line 530
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 531
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 532
    const/high16 v0, 0x3f800000    # 1.0f

    const-wide/16 v1, 0x78

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 533
    return-void
.end method

.method private static watchAccessPoints(Landroid/view/View;)V
    .locals 1

    .line 433
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    if-ne v0, p0, :cond_0

    return-void

    .line 434
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 435
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 436
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {p0, v0}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 437
    return-void
.end method

.method private static xFraction(Landroid/content/Context;)F
    .locals 3

    .line 1602
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1603
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f000000    # 0.5f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1602
    return p0
.end method

.method private static yFraction(Landroid/content/Context;)F
    .locals 3

    .line 1607
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1608
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1607
    return p0
.end method
