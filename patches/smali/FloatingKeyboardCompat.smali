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

.field private static final MAX_SCALE:F = 1.0f

.field private static final MIN_SCALE:F = 0.4f

.field private static final ONE_HANDED_LABELS:[Ljava/lang/String;

.field private static final PREFERENCES:Ljava/lang/String; = "floating_keyboard_preferences"

.field private static final TABLET_SMALLEST_WIDTH_DP:I = 0x258

.field private static final TAG:Ljava/lang/String; = "FloatingKeyboard"

.field private static appliedScale:F

.field private static armingEdit:Z

.field private static baseBottomPadding:I

.field private static downRawX:F

.field private static downRawY:F

.field private static dragDownRawX:F

.field private static dragDownRawY:F

.field private static dragStartX:F

.field private static dragStartY:F

.field private static dragging:Z

.field private static editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

.field private static editing:Z

.field private static final enterEditRunnable:Ljava/lang/Runnable;

.field private static final fadeOut:Ljava/lang/Runnable;

.field private static handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

.field private static idleArea:Landroid/view/View;

.field private static final idleHandler:Landroid/os/Handler;

.field private static idleProbe:Landroid/view/View;

.field private static idleScheduled:Z

.field private static lastAccessPointPost:J

.field private static lastAccessPointScan:J

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
    .locals 3

    .line 69
    const/4 v0, -0x1

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 92
    const/high16 v1, -0x40800000    # -1.0f

    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 96
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    .line 124
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    .line 144
    new-instance v1, Landroid/os/Handler;

    .line 145
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    .line 146
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    .line 155
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 364
    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "left_handed_content_desc"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "right_handed_content_desc"

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "expand_keyboard_content_desc"

    const/4 v2, 0x2

    aput-object v1, v0, v2

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    .line 659
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 162
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static accentColor(Landroid/view/View;)I
    .locals 1

    .line 679
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentFromPixels(Landroid/view/View;)I

    move-result v0

    .line 680
    if-eqz v0, :cond_0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentFromAttributes(Landroid/content/Context;)I

    move-result v0

    :goto_0
    return v0
.end method

.method private static accentFromAttributes(Landroid/content/Context;)I
    .locals 8

    .line 730
    const/4 v0, 0x3

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "colorAccent"

    aput-object v3, v1, v2

    const/4 v3, 0x1

    const-string v4, "colorPrimary"

    aput-object v4, v1, v3

    const-string v4, "colorControlActivated"

    const/4 v5, 0x2

    aput-object v4, v1, v5

    .line 731
    nop

    :goto_0
    if-ge v2, v0, :cond_5

    aget-object v4, v1, v2

    .line 732
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    .line 733
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "attr"

    invoke-virtual {v5, v4, v7, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    .line 734
    if-nez v4, :cond_0

    goto :goto_2

    .line 735
    :cond_0
    new-instance v5, Landroid/util/TypedValue;

    invoke-direct {v5}, Landroid/util/TypedValue;-><init>()V

    .line 736
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v6

    invoke-virtual {v6, v4, v5, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v4

    if-nez v4, :cond_1

    goto :goto_2

    .line 737
    :cond_1
    iget v4, v5, Landroid/util/TypedValue;->resourceId:I

    if-eqz v4, :cond_3

    .line 738
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_2

    .line 739
    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/Context;->getColor(I)I

    move-result p0

    goto :goto_1

    .line 740
    :cond_2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    .line 738
    :goto_1
    return p0

    .line 742
    :cond_3
    iget v4, v5, Landroid/util/TypedValue;->data:I

    if-eqz v4, :cond_4

    iget p0, v5, Landroid/util/TypedValue;->data:I

    return p0

    .line 731
    :cond_4
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 744
    :cond_5
    const p0, -0xb24954

    return p0
.end method

.method private static accentFromPixels(Landroid/view/View;)I
    .locals 9

    .line 692
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    .line 693
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v7

    .line 694
    const/4 v8, 0x0

    if-lez v3, :cond_3

    if-gtz v7, :cond_0

    goto :goto_2

    .line 696
    :cond_0
    :try_start_0
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v7, v0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 698
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 699
    invoke-virtual {p0, v1}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 700
    mul-int p0, v3, v7

    new-array v1, p0, [I

    .line 701
    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v2, 0x0

    move v6, v3

    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 702
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 703
    filled-new-array {v8, v8}, [I

    move-result-object p0

    .line 704
    nop

    .line 705
    const/4 v0, 0x0

    :goto_0
    if-ge v0, v7, :cond_2

    .line 706
    mul-int v2, v0, v3

    .line 707
    const/4 v4, 0x0

    :goto_1
    if-ge v4, v3, :cond_1

    .line 708
    add-int v5, v2, v4

    aget v5, v1, v5

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->considerAccent(I[I)V

    .line 707
    add-int/lit8 v4, v4, 0x3

    goto :goto_1

    .line 705
    :cond_1
    add-int/lit8 v0, v0, 0x3

    goto :goto_0

    .line 711
    :cond_2
    aget p0, p0, v8
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 712
    :catchall_0
    move-exception v0

    .line 713
    return v8

    .line 694
    :cond_3
    :goto_2
    return v8
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

.method static synthetic access$1000(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOneHandedAccessPointHidden(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$1100()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    return-void
.end method

.method static synthetic access$1200(Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1302(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    return p0
.end method

.method static synthetic access$1400(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1500(FFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditDrag(FFZ)V

    return-void
.end method

.method static synthetic access$1600(IFFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditScale(IFFZ)V

    return-void
.end method

.method static synthetic access$1700()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetFromEdit()V

    return-void
.end method

.method static synthetic access$1800(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1902(Ljava/lang/Runnable;)Ljava/lang/Runnable;
    .locals 0

    .line 33
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    return-object p0
.end method

.method static synthetic access$200(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$2000()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return v0
.end method

.method static synthetic access$2002(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return p0
.end method

.method static synthetic access$2100()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    return v0
.end method

.method static synthetic access$2200(Landroid/view/View;Landroid/view/View;F)[F
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2302(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    return p0
.end method

.method static synthetic access$2400()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    return v0
.end method

.method static synthetic access$2502(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    return p0
.end method

.method static synthetic access$2600()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    return v0
.end method

.method static synthetic access$2702(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    return p0
.end method

.method static synthetic access$2800(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 0

    .line 33
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result p0

    return p0
.end method

.method static synthetic access$2902(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

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

.method static synthetic access$402(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    return p0
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

.method static synthetic access$900(Landroid/view/View;Landroid/view/View;F)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    return-void
.end method

.method private static animateIdleAlpha(FJ)V
    .locals 1

    .line 435
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 436
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 437
    return-void
.end method

.method private static applyGutter(Landroid/view/View;Z)V
    .locals 3

    .line 505
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    if-gez v0, :cond_0

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 506
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 507
    if-eqz p1, :cond_1

    const/high16 p1, 0x42080000    # 34.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, p1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result p1

    add-int/2addr v0, p1

    .line 508
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    if-ne p1, v0, :cond_2

    return-void

    .line 509
    :cond_2
    nop

    .line 510
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p1

    .line 511
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    .line 512
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    .line 509
    invoke-virtual {p0, p1, v1, v2, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 514
    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 8

    .line 203
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 204
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 205
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 206
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V

    .line 207
    return-void

    .line 209
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 210
    if-nez v0, :cond_1

    return-void

    .line 211
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 212
    if-nez v0, :cond_2

    return-void

    .line 215
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchAccessPoints(Landroid/view/View;)V

    .line 216
    const/4 v2, 0x1

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 218
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    .line 219
    iget v4, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 220
    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 221
    if-lez v4, :cond_7

    if-gtz v3, :cond_3

    goto/16 :goto_0

    .line 223
    :cond_3
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 224
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 225
    const/4 v5, 0x3

    iput v5, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 227
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 228
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v5

    .line 229
    new-instance v6, Landroid/graphics/Rect;

    invoke-direct {v6}, Landroid/graphics/Rect;-><init>()V

    .line 230
    if-eqz v5, :cond_4

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v7

    if-eqz v7, :cond_4

    .line 234
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 237
    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    .line 239
    :cond_4
    invoke-virtual {v6}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_5

    .line 242
    div-int/lit8 v7, v3, 0x3

    sub-int v7, v3, v7

    .line 243
    invoke-virtual {v6, v1, v7, v4, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 248
    :cond_5
    const/4 v7, 0x2

    new-array v7, v7, [I

    .line 249
    invoke-virtual {v0, v7}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 250
    aget v1, v7, v1

    neg-int v1, v1

    aget v2, v7, v2

    neg-int v2, v2

    invoke-virtual {v6, v1, v2}, Landroid/graphics/Rect;->offset(II)V

    .line 251
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v6}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 253
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {v6, p1}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    .line 254
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {p1, v6}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 255
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "scale="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " region="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {v6}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " screen="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "x"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v1, "FloatingKeyboard"

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 258
    :cond_6
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 259
    return-void

    .line 221
    :cond_7
    :goto_0
    return-void
.end method

.method private static applyPosition(Landroid/view/View;Landroid/view/View;F)Z
    .locals 5

    .line 541
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

    .line 542
    :cond_0
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 543
    if-nez v0, :cond_1

    return v1

    .line 544
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

    .line 545
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    sub-float/2addr p0, v3

    const/4 p2, 0x1

    aget v0, v0, p2

    mul-float p0, p0, v0

    .line 546
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

    .line 547
    :cond_3
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result p2

    cmpl-float p2, p2, v2

    if-eqz p2, :cond_4

    invoke-virtual {p1, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 548
    :cond_4
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result p2

    cmpl-float p2, p2, p0

    if-eqz p2, :cond_5

    invoke-virtual {p1, p0}, Landroid/view/View;->setTranslationY(F)V

    .line 549
    :cond_5
    return v1

    .line 541
    :cond_6
    :goto_0
    return v1
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 4

    .line 518
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 519
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 520
    if-lez v0, :cond_5

    if-gtz v1, :cond_0

    goto :goto_0

    .line 521
    :cond_0
    const/4 v2, 0x1

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 524
    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v3, :cond_1

    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v3, :cond_2

    :cond_1
    sget p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 525
    :cond_2
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v3, p1

    if-nez v3, :cond_3

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eq v3, p0, :cond_4

    .line 526
    :cond_3
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 527
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 528
    int-to-float v0, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float/2addr v0, v3

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 529
    int-to-float v0, v1

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 530
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 531
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 533
    :cond_4
    return v2

    .line 520
    :cond_5
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 1061
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1062
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1063
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;-><init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1083
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    const-wide/16 v0, 0x17c

    invoke-virtual {p0, p1, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1084
    return-void
.end method

.method private static attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 3

    .line 453
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_0

    return-void

    .line 454
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    .line 455
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 457
    :cond_1
    new-instance v0, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 458
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 460
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;

    invoke-direct {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 478
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 479
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 480
    return-void
.end method

.method private static cancelLongPress(Landroid/view/View;)V
    .locals 1

    .line 1049
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    .line 1050
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 1051
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1053
    :cond_0
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1054
    return-void
.end method

.method private static clamp01(F)F
    .locals 1

    .line 1223
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const/4 v0, 0x0

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static considerAccent(I[I)V
    .locals 5

    .line 718
    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result v0

    const/16 v1, 0xc8

    if-ge v0, v1, :cond_0

    return-void

    .line 719
    :cond_0
    const/4 v0, 0x3

    new-array v0, v0, [F

    .line 720
    invoke-static {p0, v0}, Landroid/graphics/Color;->colorToHSV(I[F)V

    .line 721
    const/4 v1, 0x1

    aget v2, v0, v1

    const v3, 0x3eb33333    # 0.35f

    cmpg-float v2, v2, v3

    if-ltz v2, :cond_3

    const/4 v2, 0x2

    aget v4, v0, v2

    cmpg-float v3, v4, v3

    if-gez v3, :cond_1

    goto :goto_0

    .line 722
    :cond_1
    aget v3, v0, v1

    const/high16 v4, 0x42c80000    # 100.0f

    mul-float v3, v3, v4

    aget v0, v0, v2

    mul-float v3, v3, v0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 723
    aget v2, p1, v1

    if-le v0, v2, :cond_2

    .line 724
    const/4 v2, 0x0

    aput p0, p1, v2

    .line 725
    aput v0, p1, v1

    .line 727
    :cond_2
    return-void

    .line 721
    :cond_3
    :goto_0
    return-void
.end method

.method private static density(Landroid/view/View;)F
    .locals 0

    .line 1227
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 1012
    sub-float/2addr p0, p2

    .line 1013
    sub-float/2addr p1, p3

    .line 1014
    mul-float p0, p0, p0

    mul-float p1, p1, p1

    add-float/2addr p0, p1

    float-to-double p0, p0

    invoke-static {p0, p1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-float p0, p0

    return p0
.end method

.method private static ensureHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 567
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_0

    return-void

    .line 568
    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float p2, p2, v0

    if-ltz p2, :cond_1

    .line 570
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 571
    return-void

    .line 573
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object p2

    .line 574
    if-nez p2, :cond_2

    return-void

    .line 575
    :cond_2
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 576
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, p2, :cond_4

    .line 577
    :cond_3
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 578
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 579
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 580
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 581
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->bringToFront()V

    .line 582
    sget p0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt p0, v1, :cond_4

    .line 585
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v1, v0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setElevation(F)V

    .line 588
    :cond_4
    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 589
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 590
    invoke-static {p2, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 591
    return-void
.end method

.method private static enterEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 5

    .line 748
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_0

    .line 749
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 750
    if-nez v0, :cond_1

    return-void

    .line 751
    :cond_1
    const/4 v1, 0x1

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 752
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 753
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 754
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 755
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 757
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 758
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 759
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentColor(Landroid/view/View;)I

    move-result v4

    invoke-direct {v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;-><init>(Landroid/content/Context;I)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 760
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 761
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;

    invoke-direct {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;-><init>()V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;)V

    .line 784
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 785
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->bringToFront()V

    .line 786
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_2

    .line 787
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v3

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    int-to-float p0, p0

    const/high16 v3, 0x40000000    # 2.0f

    add-float/2addr p0, v3

    invoke-virtual {v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setElevation(F)V

    .line 789
    :cond_2
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 790
    invoke-virtual {p1, v1}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 791
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 792
    return-void

    .line 748
    :cond_3
    :goto_0
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 795
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 796
    :cond_0
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 797
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 798
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 799
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

    .line 800
    :goto_0
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 801
    if-eqz v2, :cond_2

    .line 802
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    .line 803
    const/4 v4, 0x1

    invoke-static {p1, p0, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v4

    .line 804
    invoke-static {p1, p0, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v0

    .line 805
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 806
    const-string v5, "scale"

    invoke-interface {v2, v5, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 807
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v2, v5, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "y_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 808
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 809
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 811
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 812
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 813
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 814
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 815
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 816
    return-void
.end method

.method private static fadeAlpha(Landroid/view/View;FJ)V
    .locals 1

    .line 440
    if-nez p0, :cond_0

    return-void

    .line 441
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    cmpl-float v0, v0, p1

    if-nez v0, :cond_1

    .line 442
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 443
    return-void

    .line 445
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 446
    return-void
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 1236
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 1237
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 1238
    if-nez v1, :cond_0

    .line 1239
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

    .line 1240
    const/4 p0, 0x0

    return-object p0

    .line 1242
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 1

    .line 1198
    const/high16 v0, 0x3f800000    # 1.0f

    if-eqz p4, :cond_0

    .line 1199
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

    .line 1202
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

    .line 554
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 555
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    .line 556
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 557
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 558
    if-lez v0, :cond_1

    if-lez p0, :cond_1

    if-lez v1, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 559
    :cond_0
    int-to-float v0, v0

    int-to-float v1, v1

    mul-float v1, v1, p2

    sub-float/2addr v0, v1

    .line 560
    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    int-to-float p0, p0

    int-to-float p1, p1

    mul-float p1, p1, p2

    sub-float/2addr p0, p1

    .line 561
    invoke-static {v1, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    const/4 p1, 0x2

    new-array p1, p1, [F

    const/4 p2, 0x0

    aput v0, p1, p2

    const/4 p2, 0x1

    aput p0, p1, p2

    .line 559
    return-object p1

    .line 558
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static handleEditDrag(FFZ)V
    .locals 9

    .line 877
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 878
    if-nez v0, :cond_0

    return-void

    .line 879
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 880
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    const/high16 v4, 0x3f800000    # 1.0f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 881
    :goto_0
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 882
    if-nez v3, :cond_2

    return-void

    .line 884
    :cond_2
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez v5, :cond_3

    .line 885
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 886
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 887
    invoke-static {v0, v1, v2, v3, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 888
    invoke-static {v0, v1, v2, v3, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 889
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 890
    if-eqz p2, :cond_3

    .line 891
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 892
    return-void

    .line 896
    :cond_3
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr p0, v8

    aget v8, v3, v7

    div-float/2addr p0, v8

    add-float/2addr v5, p0

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    .line 897
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v8

    aget v8, v3, v6

    div-float/2addr p1, v8

    add-float/2addr v5, p1

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 898
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

    .line 899
    sub-float v2, p1, v4

    aget v3, v3, v6

    mul-float v2, v2, v3

    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationY(F)V

    .line 900
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_4

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_4

    .line 901
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 903
    :cond_4
    if-eqz p2, :cond_5

    .line 904
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 905
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 906
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "x_fraction_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 907
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

    .line 908
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 909
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 911
    :cond_5
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 912
    return-void
.end method

.method private static handleEditScale(IFFZ)V
    .locals 17

    .line 917
    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 918
    if-nez v3, :cond_0

    return-void

    .line 919
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    .line 921
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    const/4 v6, 0x2

    const/4 v7, 0x0

    const/4 v8, 0x1

    const/high16 v9, 0x3f800000    # 1.0f

    const/4 v10, 0x0

    if-nez v5, :cond_5

    .line 922
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 923
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v11

    .line 924
    if-lez v5, :cond_4

    if-gtz v11, :cond_1

    goto :goto_2

    .line 925
    :cond_1
    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v12, v12, v10

    if-lez v12, :cond_2

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_2
    const/high16 v12, 0x3f800000    # 1.0f

    .line 926
    :goto_0
    new-array v13, v6, [I

    .line 927
    invoke-virtual {v3, v13}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 928
    aget v14, v13, v7

    int-to-float v14, v14

    .line 929
    aget v13, v13, v8

    int-to-float v13, v13

    .line 930
    int-to-float v5, v5

    mul-float v15, v5, v12

    add-float/2addr v15, v14

    .line 931
    int-to-float v11, v11

    mul-float v16, v11, v12

    add-float v16, v13, v16

    .line 932
    packed-switch v0, :pswitch_data_0

    .line 952
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 953
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 954
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 955
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    goto :goto_1

    .line 946
    :pswitch_0
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 947
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 948
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 949
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 950
    goto :goto_1

    .line 940
    :pswitch_1
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 941
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 942
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 943
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 944
    goto :goto_1

    .line 934
    :pswitch_2
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 935
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 936
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 937
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 938
    nop

    .line 958
    :goto_1
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v11}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    .line 959
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    cmpg-float v5, v5, v9

    if-gez v5, :cond_3

    return-void

    .line 960
    :cond_3
    sput v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    .line 961
    invoke-virtual {v3}, Landroid/view/View;->getTranslationX()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    .line 962
    invoke-virtual {v3}, Landroid/view/View;->getTranslationY()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    .line 963
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 964
    if-eqz p3, :cond_5

    .line 965
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 966
    return-void

    .line 924
    :cond_4
    :goto_2
    return-void

    .line 970
    :cond_5
    if-eqz p3, :cond_8

    .line 971
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 972
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, v10

    if-lez v0, :cond_6

    sget v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 973
    :cond_6
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 974
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "scale"

    invoke-interface {v0, v1, v9}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 975
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_7

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_7

    .line 976
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 978
    :cond_7
    return-void

    .line 981
    :cond_8
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v1

    .line 982
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    mul-float v2, v2, v1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    div-float/2addr v2, v1

    .line 983
    invoke-static {v9, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 982
    const v2, 0x3ecccccd    # 0.4f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 986
    if-eq v0, v8, :cond_a

    if-ne v0, v6, :cond_9

    goto :goto_3

    .line 988
    :cond_9
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    goto :goto_4

    .line 987
    :cond_a
    :goto_3
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sub-float/2addr v5, v7

    .line 989
    :goto_4
    if-eq v0, v6, :cond_c

    const/4 v6, 0x3

    if-ne v0, v6, :cond_b

    goto :goto_5

    .line 991
    :cond_b
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    goto :goto_6

    .line 990
    :cond_c
    :goto_5
    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v0

    int-to-float v0, v0

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    sub-float/2addr v0, v6

    .line 992
    :goto_6
    cmpl-float v6, v5, v10

    if-lez v6, :cond_d

    cmpl-float v6, v0, v10

    if-lez v6, :cond_d

    .line 993
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v6

    int-to-float v6, v6

    div-float/2addr v5, v6

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v6

    int-to-float v6, v6

    div-float/2addr v0, v6

    invoke-static {v5, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 994
    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 995
    invoke-static {v2, v0}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 997
    :cond_d
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 998
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    .line 999
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    sub-float/2addr v5, v1

    .line 1000
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleX(F)V

    .line 1001
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleY(F)V

    .line 1002
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1003
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    sub-float/2addr v6, v0

    mul-float v6, v6, v5

    add-float/2addr v1, v6

    invoke-virtual {v3, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 1004
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    sub-float/2addr v1, v2

    mul-float v1, v1, v5

    add-float/2addr v0, v1

    invoke-virtual {v3, v0}, Landroid/view/View;->setTranslationY(F)V

    .line 1005
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_e

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_e

    .line 1006
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1008
    :cond_e
    invoke-virtual {v4}, Landroid/view/View;->requestLayout()V

    .line 1009
    return-void

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;
    .locals 1

    .line 599
    const p1, 0x1020002

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 600
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p1, Landroid/view/ViewGroup;

    return-object p1

    .line 601
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

    .line 170
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "idle_fade"

    const/4 v1, 0x1

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0
.end method

.method public static isEnabled(Landroid/content/Context;)Z
    .locals 2

    .line 165
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

    .line 179
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 180
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

.method private static moveHandle(Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 642
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 643
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 644
    if-eqz v0, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    .line 645
    :cond_1
    const/high16 v1, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    invoke-static {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 646
    return-void

    .line 644
    :cond_2
    :goto_0
    return-void
.end method

.method public static onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1087
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1088
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1089
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v2, :pswitch_data_0

    .line 1162
    return v1

    .line 1111
    :pswitch_0
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz v2, :cond_2

    .line 1112
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v2

    .line 1113
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v2

    .line 1114
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result p0

    .line 1115
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p0, p0

    mul-float p0, p0, p0

    cmpl-float p0, v0, p0

    if-lez p0, :cond_1

    .line 1116
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1117
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1119
    :cond_1
    return v4

    .line 1121
    :cond_2
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez v2, :cond_4

    .line 1122
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    if-eqz v0, :cond_3

    .line 1123
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v1

    .line 1124
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v1

    .line 1125
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result v1

    .line 1126
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p1, v1

    mul-float p1, p1, p1

    cmpl-float p1, v0, p1

    if-lez p1, :cond_3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1128
    :cond_3
    return v4

    .line 1130
    :cond_4
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1131
    if-nez v2, :cond_5

    return v1

    .line 1132
    :cond_5
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v5, v3

    if-lez v3, :cond_6

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_6
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 1133
    :goto_0
    invoke-static {v0, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1134
    if-nez v3, :cond_7

    return v1

    .line 1135
    :cond_7
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1136
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v6

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr v6, v7

    aget v7, v3, v1

    div-float/2addr v6, v7

    add-float/2addr v5, v6

    .line 1135
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result v5

    .line 1137
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1138
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v7

    aget v7, v3, v4

    div-float/2addr p1, v7

    add-float/2addr v6, p1

    .line 1137
    invoke-static {v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1139
    aget v1, v3, v1

    mul-float v5, v5, v1

    const/high16 v1, 0x3f800000    # 1.0f

    sub-float p0, v1, p0

    .line 1140
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v6

    int-to-float v6, v6

    mul-float p0, p0, v6

    const/high16 v6, 0x40000000    # 2.0f

    div-float/2addr p0, v6

    sub-float/2addr v5, p0

    .line 1139
    invoke-virtual {v2, v5}, Landroid/view/View;->setTranslationX(F)V

    .line 1141
    sub-float/2addr p1, v1

    aget p0, v3, v4

    mul-float p1, p1, p0

    invoke-virtual {v2, p1}, Landroid/view/View;->setTranslationY(F)V

    .line 1142
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveHandle(Landroid/view/View;Landroid/view/View;)V

    .line 1143
    return v4

    .line 1147
    :pswitch_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    .line 1148
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz p1, :cond_8

    .line 1149
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1150
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1151
    return v4

    .line 1153
    :cond_8
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1154
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez p1, :cond_9

    return v4

    .line 1155
    :cond_9
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1156
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->settle(Landroid/view/View;Landroid/view/View;)V

    .line 1157
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1158
    if-eqz p0, :cond_a

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1159
    :cond_a
    return v4

    .line 1091
    :pswitch_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1092
    if-nez v2, :cond_b

    return v1

    .line 1093
    :cond_b
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v5, v3

    if-lez v3, :cond_c

    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_1

    :cond_c
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result v3

    .line 1094
    :goto_1
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1095
    if-nez v3, :cond_d

    return v1

    .line 1096
    :cond_d
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    .line 1097
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    .line 1098
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 1099
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    .line 1100
    sget-wide v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x140

    cmp-long p1, v5, v7

    if-gtz p1, :cond_e

    .line 1102
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1103
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0x12c

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_2

    .line 1105
    :cond_e
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1106
    invoke-static {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1108
    :goto_2
    return v4

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private static orientation(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    .line 1217
    nop

    .line 1216
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->orientation:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    .line 1218
    const-string p0, "landscape"

    goto :goto_0

    .line 1219
    :cond_0
    const-string p0, "portrait"

    .line 1216
    :goto_0
    return-object p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 195
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static removeEditOverlay()V
    .locals 3

    .line 867
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 868
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 869
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 870
    :cond_1
    move-object v0, v1

    .line 871
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 872
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 873
    return-void
.end method

.method private static removeHandle()V
    .locals 3

    .line 649
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 651
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 652
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 653
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 654
    :cond_1
    move-object v0, v1

    .line 655
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 656
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 657
    return-void
.end method

.method private static removeIdleProbe()V
    .locals 2

    .line 483
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 484
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    .line 485
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 486
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 488
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v0, :cond_1

    .line 489
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 490
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setAlpha(F)V

    .line 492
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 493
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 495
    :cond_2
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 496
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 497
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V
    .locals 0

    .line 320
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 321
    if-nez p0, :cond_0

    return-void

    .line 322
    :cond_0
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 323
    if-nez p0, :cond_1

    return-void

    .line 324
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 325
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/view/View;Z)V
    .locals 7

    .line 330
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 331
    sget-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x32

    cmp-long v6, v2, v4

    if-gez v6, :cond_0

    return-void

    .line 332
    :cond_0
    sput-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    .line 333
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 343
    return-void
.end method

.method private static resetFromEdit()V
    .locals 7

    .line 819
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 820
    if-nez v0, :cond_0

    return-void

    .line 821
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 822
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 823
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    .line 824
    const-string v4, "scale"

    const v5, 0x3f3851ec    # 0.72f

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 825
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    const/high16 v6, 0x3f000000    # 0.5f

    invoke-interface {v3, v4, v6}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "y_fraction_"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 826
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 827
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 828
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 829
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleX(F)V

    .line 830
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleY(F)V

    .line 831
    invoke-static {v1, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 832
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_1

    .line 833
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 835
    :cond_1
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 836
    return-void
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    .line 279
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 280
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 281
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 282
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 283
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 284
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 285
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 286
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 287
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v1, v1, v2

    if-nez v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-nez v1, :cond_0

    return-void

    .line 288
    :cond_0
    sput v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 289
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 290
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 291
    if-nez p0, :cond_1

    return-void

    .line 292
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 293
    if-nez p0, :cond_2

    return-void

    .line 294
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 295
    if-nez p0, :cond_3

    return-void

    .line 296
    :cond_3
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleX(F)V

    .line 297
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleY(F)V

    .line 298
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 299
    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 300
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 301
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 184
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 185
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static scheduleHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 1

    .line 267
    if-nez p1, :cond_0

    return-void

    .line 268
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;-><init>(Landroid/view/View;Landroid/view/View;F)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 275
    return-void
.end method

.method private static scheduleIdleFade(Landroid/view/View;)V
    .locals 3

    .line 408
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 409
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 412
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_0

    .line 413
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 414
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 415
    const/high16 p0, 0x3f800000    # 1.0f

    const-wide/16 v0, 0x78

    invoke-static {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 417
    :cond_0
    return-void

    .line 419
    :cond_1
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_2

    return-void

    .line 420
    :cond_2
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 421
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 422
    return-void
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 1231
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 1232
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

    .line 388
    invoke-virtual {p0}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    .line 389
    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 390
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 391
    array-length v2, p1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 392
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 393
    if-eqz p2, :cond_0

    const/16 v0, 0x8

    goto :goto_1

    :cond_0
    const/4 v0, 0x0

    .line 394
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eq v2, v0, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 391
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 399
    :cond_2
    :goto_2
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 400
    check-cast p0, Landroid/view/ViewGroup;

    .line 401
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 402
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 401
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 405
    :cond_3
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 174
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 175
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 176
    return-void
.end method

.method private static setOneHandedAccessPointHidden(Landroid/view/View;Z)V
    .locals 12

    .line 371
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 372
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v1, v1

    new-array v2, v1, [Ljava/lang/String;

    .line 373
    nop

    .line 374
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v4, :cond_1

    aget-object v8, v3, v6

    .line 375
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const-string v10, "string"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v9, v8, v10, v11}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v8

    .line 376
    if-eqz v8, :cond_0

    add-int/lit8 v9, v7, 0x1

    invoke-virtual {v0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v2, v7

    move v7, v9

    .line 374
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 378
    :cond_1
    if-nez v7, :cond_2

    return-void

    .line 379
    :cond_2
    if-ge v7, v1, :cond_3

    .line 380
    new-array v0, v7, [Ljava/lang/String;

    .line 381
    invoke-static {v2, v5, v0, v5, v7}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 382
    move-object v2, v0

    .line 384
    :cond_3
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 385
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 189
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 190
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 191
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 192
    return-void
.end method

.method private static settle(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1168
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1169
    if-nez v0, :cond_0

    return-void

    .line 1170
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

    .line 1171
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1172
    if-nez v2, :cond_2

    return-void

    .line 1173
    :cond_2
    const/4 v3, 0x1

    invoke-static {v0, p1, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1174
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v2

    .line 1180
    const v4, 0x3f6b851f    # 0.92f

    cmpl-float v5, v2, v4

    if-lez v5, :cond_3

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    cmpg-float v4, v5, v4

    if-gez v4, :cond_3

    .line 1181
    nop

    .line 1182
    const/high16 v2, 0x3f800000    # 1.0f

    const/high16 v3, 0x3f000000    # 0.5f

    .line 1184
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1185
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1186
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

    .line 1187
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v3, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1188
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1189
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1190
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1193
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    .line 1194
    return-void
.end method

.method private static touchSlop(Landroid/view/View;)I
    .locals 1

    .line 1042
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    if-gez v0, :cond_0

    .line 1043
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 1045
    :cond_0
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    return p0
.end method

.method private static unwatchAccessPoints()V
    .locals 2

    .line 353
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 354
    if-nez v0, :cond_0

    return-void

    .line 355
    :cond_0
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 356
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 357
    return-void
.end method

.method private static updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 4

    .line 839
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 840
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 841
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 842
    new-array v0, v0, [I

    .line 843
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 844
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 845
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 846
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 847
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 848
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget p1, v0, p1

    sub-int/2addr v3, p1

    .line 849
    const/4 p1, 0x1

    aget v1, v1, p1

    aget p1, v0, p1

    sub-int/2addr v1, p1

    .line 851
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p1, p1, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p1, :cond_3

    .line 852
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 853
    :cond_3
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p1, v2, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 854
    :goto_1
    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v0, v2, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v0, p0, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne v0, v3, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne v0, v1, :cond_4

    .line 856
    return-void

    .line 858
    :cond_4
    iput v2, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 859
    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 860
    const/16 p0, 0x33

    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 861
    iput v3, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 862
    iput v1, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 863
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 864
    return-void

    .line 847
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 6

    .line 605
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 609
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 610
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 611
    new-array v0, v0, [I

    .line 612
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 613
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 614
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 615
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 616
    if-lez v2, :cond_5

    if-gtz v3, :cond_2

    goto :goto_2

    .line 617
    :cond_2
    const/4 v4, 0x0

    aget v5, v1, v4

    aget v4, v0, v4

    sub-int/2addr v5, v4

    .line 619
    const/4 v4, 0x1

    aget v1, v1, v4

    aget v0, v0, v4

    sub-int/2addr v1, v0

    add-int/2addr v1, v3

    sub-int/2addr v1, p2

    .line 621
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_3

    .line 622
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 623
    :cond_3
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v2, p2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 626
    :goto_1
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    const/high16 p0, 0x40000000    # 2.0f

    div-float/2addr p1, p0

    invoke-virtual {v3, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarCenterFromBottom(F)V

    .line 627
    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p0, v2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p0, p2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p0, v5, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p0, v1, :cond_4

    .line 629
    return-void

    .line 631
    :cond_4
    iput v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 632
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 633
    const/16 p0, 0x33

    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 636
    iput v5, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 637
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 638
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 639
    return-void

    .line 616
    :cond_5
    :goto_2
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 6

    .line 1029
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_1

    .line 1030
    :cond_0
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1031
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1032
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1033
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1034
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1035
    aget v2, v0, v1

    const/4 v4, 0x1

    aget v5, v0, v4

    aget v1, v0, v1

    add-int/2addr v1, v3

    aget v0, v0, v4

    add-int/2addr v0, p0

    invoke-virtual {p1, v2, v5, v1, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 1037
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/2addr p0, v4

    return p0

    .line 1029
    :cond_2
    :goto_1
    return v1
.end method

.method private static wakeIdle()V
    .locals 3

    .line 425
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 426
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 427
    const/high16 v0, 0x3f800000    # 1.0f

    const-wide/16 v1, 0x78

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 428
    return-void
.end method

.method private static watchAccessPoints(Landroid/view/View;)V
    .locals 1

    .line 346
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    if-ne v0, p0, :cond_0

    return-void

    .line 347
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 348
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 349
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {p0, v0}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 350
    return-void
.end method

.method private static xFraction(Landroid/content/Context;)F
    .locals 3

    .line 1206
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1207
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f000000    # 0.5f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1206
    return p0
.end method

.method private static yFraction(Landroid/content/Context;)F
    .locals 3

    .line 1211
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1212
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1211
    return p0
.end method
