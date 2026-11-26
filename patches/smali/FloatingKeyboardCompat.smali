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

.field static final SHADOW_GROW_DP:F = 14.0f

.field private static final TABLET_SMALLEST_WIDTH_DP:I = 0x258

.field private static final TAG:Ljava/lang/String; = "FloatingKeyboard"

.field private static appliedScale:F

.field private static armingEdit:Z

.field private static baseBottomPadding:I

.field private static cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

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

    .line 71
    const/4 v0, -0x1

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 94
    const/high16 v1, -0x40800000    # -1.0f

    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 98
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    .line 129
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    .line 149
    new-instance v1, Landroid/os/Handler;

    .line 150
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    .line 151
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    .line 160
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 374
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

    .line 735
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 167
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static accentColor(Landroid/view/View;)I
    .locals 1

    .line 755
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentFromPixels(Landroid/view/View;)I

    move-result v0

    .line 756
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

    .line 806
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

    .line 807
    nop

    :goto_0
    if-ge v2, v0, :cond_5

    aget-object v4, v1, v2

    .line 808
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    .line 809
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "attr"

    invoke-virtual {v5, v4, v7, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    .line 810
    if-nez v4, :cond_0

    goto :goto_2

    .line 811
    :cond_0
    new-instance v5, Landroid/util/TypedValue;

    invoke-direct {v5}, Landroid/util/TypedValue;-><init>()V

    .line 812
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v6

    invoke-virtual {v6, v4, v5, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v4

    if-nez v4, :cond_1

    goto :goto_2

    .line 813
    :cond_1
    iget v4, v5, Landroid/util/TypedValue;->resourceId:I

    if-eqz v4, :cond_3

    .line 814
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_2

    .line 815
    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/Context;->getColor(I)I

    move-result p0

    goto :goto_1

    .line 816
    :cond_2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    .line 814
    :goto_1
    return p0

    .line 818
    :cond_3
    iget v4, v5, Landroid/util/TypedValue;->data:I

    if-eqz v4, :cond_4

    iget p0, v5, Landroid/util/TypedValue;->data:I

    return p0

    .line 807
    :cond_4
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 820
    :cond_5
    const p0, -0xb24954

    return p0
.end method

.method private static accentFromPixels(Landroid/view/View;)I
    .locals 9

    .line 768
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    .line 769
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v7

    .line 770
    const/4 v8, 0x0

    if-lez v3, :cond_3

    if-gtz v7, :cond_0

    goto :goto_2

    .line 772
    :cond_0
    :try_start_0
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v7, v0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 774
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 775
    invoke-virtual {p0, v1}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 776
    mul-int p0, v3, v7

    new-array v1, p0, [I

    .line 777
    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v2, 0x0

    move v6, v3

    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 778
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 779
    filled-new-array {v8, v8}, [I

    move-result-object p0

    .line 780
    nop

    .line 781
    const/4 v0, 0x0

    :goto_0
    if-ge v0, v7, :cond_2

    .line 782
    mul-int v2, v0, v3

    .line 783
    const/4 v4, 0x0

    :goto_1
    if-ge v4, v3, :cond_1

    .line 784
    add-int v5, v2, v4

    aget v5, v1, v5

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->considerAccent(I[I)V

    .line 783
    add-int/lit8 v4, v4, 0x3

    goto :goto_1

    .line 781
    :cond_1
    add-int/lit8 v0, v0, 0x3

    goto :goto_0

    .line 787
    :cond_2
    aget p0, p0, v8
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 788
    :catchall_0
    move-exception v0

    .line 789
    return v8

    .line 770
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

    .line 445
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 446
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 447
    return-void
.end method

.method private static applyGutter(Landroid/view/View;Z)V
    .locals 3

    .line 515
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    if-gez v0, :cond_0

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 516
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 517
    if-eqz p1, :cond_1

    const/high16 p1, 0x42080000    # 34.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, p1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result p1

    add-int/2addr v0, p1

    .line 518
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    if-ne p1, v0, :cond_2

    return-void

    .line 519
    :cond_2
    nop

    .line 520
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p1

    .line 521
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    .line 522
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    .line 519
    invoke-virtual {p0, p1, v1, v2, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 524
    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 8

    .line 208
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 209
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 210
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 211
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V

    .line 212
    return-void

    .line 214
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 215
    if-nez v0, :cond_1

    return-void

    .line 216
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 217
    if-nez v0, :cond_2

    return-void

    .line 220
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchAccessPoints(Landroid/view/View;)V

    .line 221
    const/4 v2, 0x1

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 223
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    .line 224
    iget v4, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 225
    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 226
    if-lez v4, :cond_9

    if-gtz v3, :cond_3

    goto/16 :goto_0

    .line 228
    :cond_3
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 229
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 230
    const/4 v5, 0x3

    iput v5, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 232
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 233
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v5

    .line 237
    if-eqz v5, :cond_4

    const/4 v6, 0x0

    invoke-virtual {v5, v6}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 238
    :cond_4
    if-eqz v5, :cond_5

    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureCardShadow(Landroid/view/View;Landroid/view/View;F)V

    .line 239
    :cond_5
    new-instance v6, Landroid/graphics/Rect;

    invoke-direct {v6}, Landroid/graphics/Rect;-><init>()V

    .line 240
    if-eqz v5, :cond_6

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v7

    if-eqz v7, :cond_6

    .line 244
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 247
    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    .line 249
    :cond_6
    invoke-virtual {v6}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_7

    .line 252
    div-int/lit8 v7, v3, 0x3

    sub-int v7, v3, v7

    .line 253
    invoke-virtual {v6, v1, v7, v4, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 258
    :cond_7
    const/4 v7, 0x2

    new-array v7, v7, [I

    .line 259
    invoke-virtual {v0, v7}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 260
    aget v1, v7, v1

    neg-int v1, v1

    aget v2, v7, v2

    neg-int v2, v2

    invoke-virtual {v6, v1, v2}, Landroid/graphics/Rect;->offset(II)V

    .line 261
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v6}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 263
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {v6, p1}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_8

    .line 264
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {p1, v6}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 265
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

    .line 268
    :cond_8
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 269
    return-void

    .line 226
    :cond_9
    :goto_0
    return-void
.end method

.method private static applyPosition(Landroid/view/View;Landroid/view/View;F)Z
    .locals 5

    .line 616
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

    .line 617
    :cond_0
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 618
    if-nez v0, :cond_1

    return v1

    .line 619
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

    .line 620
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    sub-float/2addr p0, v3

    const/4 p2, 0x1

    aget v0, v0, p2

    mul-float p0, p0, v0

    .line 621
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

    .line 622
    :cond_3
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result p2

    cmpl-float p2, p2, v2

    if-eqz p2, :cond_4

    invoke-virtual {p1, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 623
    :cond_4
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result p2

    cmpl-float p2, p2, p0

    if-eqz p2, :cond_5

    invoke-virtual {p1, p0}, Landroid/view/View;->setTranslationY(F)V

    .line 624
    :cond_5
    return v1

    .line 616
    :cond_6
    :goto_0
    return v1
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 4

    .line 593
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 594
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 595
    if-lez v0, :cond_5

    if-gtz v1, :cond_0

    goto :goto_0

    .line 596
    :cond_0
    const/4 v2, 0x1

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 599
    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v3, :cond_1

    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v3, :cond_2

    :cond_1
    sget p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 600
    :cond_2
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v3, p1

    if-nez v3, :cond_3

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eq v3, p0, :cond_4

    .line 601
    :cond_3
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 602
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 603
    int-to-float v0, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float/2addr v0, v3

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 604
    int-to-float v0, v1

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 605
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 606
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 608
    :cond_4
    return v2

    .line 595
    :cond_5
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 1137
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1138
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1139
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;-><init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1159
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    const-wide/16 v0, 0x17c

    invoke-virtual {p0, p1, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1160
    return-void
.end method

.method private static attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 3

    .line 463
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_0

    return-void

    .line 464
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    .line 465
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 467
    :cond_1
    new-instance v0, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 468
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 470
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;

    invoke-direct {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 488
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 489
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 490
    return-void
.end method

.method private static cancelLongPress(Landroid/view/View;)V
    .locals 1

    .line 1125
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    .line 1126
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 1127
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1129
    :cond_0
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1130
    return-void
.end method

.method private static clamp01(F)F
    .locals 1

    .line 1299
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

    .line 794
    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result v0

    const/16 v1, 0xc8

    if-ge v0, v1, :cond_0

    return-void

    .line 795
    :cond_0
    const/4 v0, 0x3

    new-array v0, v0, [F

    .line 796
    invoke-static {p0, v0}, Landroid/graphics/Color;->colorToHSV(I[F)V

    .line 797
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

    .line 798
    :cond_1
    aget v3, v0, v1

    const/high16 v4, 0x42c80000    # 100.0f

    mul-float v3, v3, v4

    aget v0, v0, v2

    mul-float v3, v3, v0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 799
    aget v2, p1, v1

    if-le v0, v2, :cond_2

    .line 800
    const/4 v2, 0x0

    aput p0, p1, v2

    .line 801
    aput v0, p1, v1

    .line 803
    :cond_2
    return-void

    .line 797
    :cond_3
    :goto_0
    return-void
.end method

.method private static density(Landroid/view/View;)F
    .locals 0

    .line 1303
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 1088
    sub-float/2addr p0, p2

    .line 1089
    sub-float/2addr p1, p3

    .line 1090
    mul-float p0, p0, p0

    mul-float p1, p1, p1

    add-float/2addr p0, p1

    float-to-double p0, p0

    invoke-static {p0, p1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-float p0, p0

    return p0
.end method

.method private static ensureCardShadow(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 533
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-ge v0, v1, :cond_0

    return-void

    .line 534
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 535
    if-nez v0, :cond_1

    return-void

    .line 536
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_3

    .line 537
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 538
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    invoke-direct {v1, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;-><init>(Landroid/content/Context;F)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 539
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 540
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 542
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    const/high16 v1, -0x40800000    # -1.0f

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setTranslationZ(F)V

    .line 544
    :cond_3
    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateCardShadowBounds(Landroid/view/ViewGroup;Landroid/view/View;F)V

    .line 545
    return-void
.end method

.method private static ensureHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 642
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_0

    return-void

    .line 643
    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float p2, p2, v0

    if-ltz p2, :cond_1

    .line 645
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 646
    return-void

    .line 648
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object p2

    .line 649
    if-nez p2, :cond_2

    return-void

    .line 650
    :cond_2
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 651
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, p2, :cond_4

    .line 652
    :cond_3
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 653
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 654
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 655
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 656
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->bringToFront()V

    .line 657
    sget p0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt p0, v1, :cond_4

    .line 660
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v1, v0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setElevation(F)V

    .line 663
    :cond_4
    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 664
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 665
    invoke-static {p2, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 666
    return-void
.end method

.method private static enterEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 5

    .line 824
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_0

    .line 825
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 826
    if-nez v0, :cond_1

    return-void

    .line 827
    :cond_1
    const/4 v1, 0x1

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 828
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 829
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 830
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 831
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 833
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 834
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 835
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentColor(Landroid/view/View;)I

    move-result v4

    invoke-direct {v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;-><init>(Landroid/content/Context;I)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 836
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 837
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;

    invoke-direct {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;-><init>()V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;)V

    .line 860
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 861
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->bringToFront()V

    .line 862
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_2

    .line 863
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

    .line 865
    :cond_2
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 866
    invoke-virtual {p1, v1}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 867
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 868
    return-void

    .line 824
    :cond_3
    :goto_0
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 871
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 872
    :cond_0
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 873
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 874
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 875
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

    .line 876
    :goto_0
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 877
    if-eqz v2, :cond_2

    .line 878
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    .line 879
    const/4 v4, 0x1

    invoke-static {p1, p0, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v4

    .line 880
    invoke-static {p1, p0, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v0

    .line 881
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 882
    const-string v5, "scale"

    invoke-interface {v2, v5, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 883
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

    .line 884
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 885
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 887
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 888
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 889
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 890
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 891
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 892
    return-void
.end method

.method private static fadeAlpha(Landroid/view/View;FJ)V
    .locals 1

    .line 450
    if-nez p0, :cond_0

    return-void

    .line 451
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    cmpl-float v0, v0, p1

    if-nez v0, :cond_1

    .line 452
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 453
    return-void

    .line 455
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 456
    return-void
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 1312
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 1313
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 1314
    if-nez v1, :cond_0

    .line 1315
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

    .line 1316
    const/4 p0, 0x0

    return-object p0

    .line 1318
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 1

    .line 1274
    const/high16 v0, 0x3f800000    # 1.0f

    if-eqz p4, :cond_0

    .line 1275
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

    .line 1278
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

    .line 629
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 630
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    .line 631
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 632
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 633
    if-lez v0, :cond_1

    if-lez p0, :cond_1

    if-lez v1, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 634
    :cond_0
    int-to-float v0, v0

    int-to-float v1, v1

    mul-float v1, v1, p2

    sub-float/2addr v0, v1

    .line 635
    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    int-to-float p0, p0

    int-to-float p1, p1

    mul-float p1, p1, p2

    sub-float/2addr p0, p1

    .line 636
    invoke-static {v1, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    const/4 p1, 0x2

    new-array p1, p1, [F

    const/4 p2, 0x0

    aput v0, p1, p2

    const/4 p2, 0x1

    aput p0, p1, p2

    .line 634
    return-object p1

    .line 633
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static handleEditDrag(FFZ)V
    .locals 9

    .line 953
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 954
    if-nez v0, :cond_0

    return-void

    .line 955
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 956
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    const/high16 v4, 0x3f800000    # 1.0f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 957
    :goto_0
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 958
    if-nez v3, :cond_2

    return-void

    .line 960
    :cond_2
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez v5, :cond_3

    .line 961
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 962
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 963
    invoke-static {v0, v1, v2, v3, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 964
    invoke-static {v0, v1, v2, v3, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 965
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 966
    if-eqz p2, :cond_3

    .line 967
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 968
    return-void

    .line 972
    :cond_3
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr p0, v8

    aget v8, v3, v7

    div-float/2addr p0, v8

    add-float/2addr v5, p0

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    .line 973
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v8

    aget v8, v3, v6

    div-float/2addr p1, v8

    add-float/2addr v5, p1

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 974
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

    .line 975
    sub-float v2, p1, v4

    aget v3, v3, v6

    mul-float v2, v2, v3

    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationY(F)V

    .line 976
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_4

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_4

    .line 977
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 979
    :cond_4
    if-eqz p2, :cond_5

    .line 980
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 981
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 982
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "x_fraction_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 983
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

    .line 984
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 985
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 987
    :cond_5
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 988
    return-void
.end method

.method private static handleEditScale(IFFZ)V
    .locals 17

    .line 993
    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 994
    if-nez v3, :cond_0

    return-void

    .line 995
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    .line 997
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    const/4 v6, 0x2

    const/4 v7, 0x0

    const/4 v8, 0x1

    const/high16 v9, 0x3f800000    # 1.0f

    const/4 v10, 0x0

    if-nez v5, :cond_5

    .line 998
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 999
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v11

    .line 1000
    if-lez v5, :cond_4

    if-gtz v11, :cond_1

    goto :goto_2

    .line 1001
    :cond_1
    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v12, v12, v10

    if-lez v12, :cond_2

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_2
    const/high16 v12, 0x3f800000    # 1.0f

    .line 1002
    :goto_0
    new-array v13, v6, [I

    .line 1003
    invoke-virtual {v3, v13}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1004
    aget v14, v13, v7

    int-to-float v14, v14

    .line 1005
    aget v13, v13, v8

    int-to-float v13, v13

    .line 1006
    int-to-float v5, v5

    mul-float v15, v5, v12

    add-float/2addr v15, v14

    .line 1007
    int-to-float v11, v11

    mul-float v16, v11, v12

    add-float v16, v13, v16

    .line 1008
    packed-switch v0, :pswitch_data_0

    .line 1028
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1029
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1030
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1031
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    goto :goto_1

    .line 1022
    :pswitch_0
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1023
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1024
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1025
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1026
    goto :goto_1

    .line 1016
    :pswitch_1
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1017
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1018
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1019
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1020
    goto :goto_1

    .line 1010
    :pswitch_2
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1011
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1012
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1013
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1014
    nop

    .line 1034
    :goto_1
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v11}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    .line 1035
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    cmpg-float v5, v5, v9

    if-gez v5, :cond_3

    return-void

    .line 1036
    :cond_3
    sput v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    .line 1037
    invoke-virtual {v3}, Landroid/view/View;->getTranslationX()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    .line 1038
    invoke-virtual {v3}, Landroid/view/View;->getTranslationY()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    .line 1039
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1040
    if-eqz p3, :cond_5

    .line 1041
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1042
    return-void

    .line 1000
    :cond_4
    :goto_2
    return-void

    .line 1046
    :cond_5
    if-eqz p3, :cond_8

    .line 1047
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1048
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, v10

    if-lez v0, :cond_6

    sget v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1049
    :cond_6
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1050
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "scale"

    invoke-interface {v0, v1, v9}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1051
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_7

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_7

    .line 1052
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1054
    :cond_7
    return-void

    .line 1057
    :cond_8
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v1

    .line 1058
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    mul-float v2, v2, v1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    div-float/2addr v2, v1

    .line 1059
    invoke-static {v9, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 1058
    const v2, 0x3ecccccd    # 0.4f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1062
    if-eq v0, v8, :cond_a

    if-ne v0, v6, :cond_9

    goto :goto_3

    .line 1064
    :cond_9
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    goto :goto_4

    .line 1063
    :cond_a
    :goto_3
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sub-float/2addr v5, v7

    .line 1065
    :goto_4
    if-eq v0, v6, :cond_c

    const/4 v6, 0x3

    if-ne v0, v6, :cond_b

    goto :goto_5

    .line 1067
    :cond_b
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    goto :goto_6

    .line 1066
    :cond_c
    :goto_5
    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v0

    int-to-float v0, v0

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    sub-float/2addr v0, v6

    .line 1068
    :goto_6
    cmpl-float v6, v5, v10

    if-lez v6, :cond_d

    cmpl-float v6, v0, v10

    if-lez v6, :cond_d

    .line 1069
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

    .line 1070
    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 1071
    invoke-static {v2, v0}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1073
    :cond_d
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 1074
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    .line 1075
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    sub-float/2addr v5, v1

    .line 1076
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleX(F)V

    .line 1077
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleY(F)V

    .line 1078
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1079
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    sub-float/2addr v6, v0

    mul-float v6, v6, v5

    add-float/2addr v1, v6

    invoke-virtual {v3, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 1080
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    sub-float/2addr v1, v2

    mul-float v1, v1, v5

    add-float/2addr v0, v1

    invoke-virtual {v3, v0}, Landroid/view/View;->setTranslationY(F)V

    .line 1081
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_e

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_e

    .line 1082
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1084
    :cond_e
    invoke-virtual {v4}, Landroid/view/View;->requestLayout()V

    .line 1085
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

    .line 674
    const p1, 0x1020002

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 675
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p1, Landroid/view/ViewGroup;

    return-object p1

    .line 676
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

    .line 175
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

    .line 170
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

    .line 184
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 185
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

    .line 717
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 718
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 719
    if-eqz v0, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    .line 720
    :cond_1
    const/high16 v1, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    invoke-static {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 721
    return-void

    .line 719
    :cond_2
    :goto_0
    return-void
.end method

.method public static onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1163
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1164
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1165
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v2, :pswitch_data_0

    .line 1238
    return v1

    .line 1187
    :pswitch_0
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz v2, :cond_2

    .line 1188
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v2

    .line 1189
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v2

    .line 1190
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result p0

    .line 1191
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p0, p0

    mul-float p0, p0, p0

    cmpl-float p0, v0, p0

    if-lez p0, :cond_1

    .line 1192
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1193
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1195
    :cond_1
    return v4

    .line 1197
    :cond_2
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez v2, :cond_4

    .line 1198
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    if-eqz v0, :cond_3

    .line 1199
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v1

    .line 1200
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v1

    .line 1201
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result v1

    .line 1202
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p1, v1

    mul-float p1, p1, p1

    cmpl-float p1, v0, p1

    if-lez p1, :cond_3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1204
    :cond_3
    return v4

    .line 1206
    :cond_4
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1207
    if-nez v2, :cond_5

    return v1

    .line 1208
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

    .line 1209
    :goto_0
    invoke-static {v0, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1210
    if-nez v3, :cond_7

    return v1

    .line 1211
    :cond_7
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1212
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v6

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr v6, v7

    aget v7, v3, v1

    div-float/2addr v6, v7

    add-float/2addr v5, v6

    .line 1211
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result v5

    .line 1213
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1214
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v7

    aget v7, v3, v4

    div-float/2addr p1, v7

    add-float/2addr v6, p1

    .line 1213
    invoke-static {v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1215
    aget v1, v3, v1

    mul-float v5, v5, v1

    const/high16 v1, 0x3f800000    # 1.0f

    sub-float p0, v1, p0

    .line 1216
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v6

    int-to-float v6, v6

    mul-float p0, p0, v6

    const/high16 v6, 0x40000000    # 2.0f

    div-float/2addr p0, v6

    sub-float/2addr v5, p0

    .line 1215
    invoke-virtual {v2, v5}, Landroid/view/View;->setTranslationX(F)V

    .line 1217
    sub-float/2addr p1, v1

    aget p0, v3, v4

    mul-float p1, p1, p0

    invoke-virtual {v2, p1}, Landroid/view/View;->setTranslationY(F)V

    .line 1218
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveHandle(Landroid/view/View;Landroid/view/View;)V

    .line 1219
    return v4

    .line 1223
    :pswitch_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    .line 1224
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz p1, :cond_8

    .line 1225
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1226
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1227
    return v4

    .line 1229
    :cond_8
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1230
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez p1, :cond_9

    return v4

    .line 1231
    :cond_9
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1232
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->settle(Landroid/view/View;Landroid/view/View;)V

    .line 1233
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1234
    if-eqz p0, :cond_a

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1235
    :cond_a
    return v4

    .line 1167
    :pswitch_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1168
    if-nez v2, :cond_b

    return v1

    .line 1169
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

    .line 1170
    :goto_1
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1171
    if-nez v3, :cond_d

    return v1

    .line 1172
    :cond_d
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    .line 1173
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    .line 1174
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 1175
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    .line 1176
    sget-wide v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x140

    cmp-long p1, v5, v7

    if-gtz p1, :cond_e

    .line 1178
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1179
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0x12c

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_2

    .line 1181
    :cond_e
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1182
    invoke-static {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1184
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

    .line 1293
    nop

    .line 1292
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->orientation:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    .line 1294
    const-string p0, "landscape"

    goto :goto_0

    .line 1295
    :cond_0
    const-string p0, "portrait"

    .line 1292
    :goto_0
    return-object p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 200
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static removeCardShadow()V
    .locals 3

    .line 583
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v0, :cond_0

    return-void

    .line 584
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 585
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 586
    :cond_1
    move-object v0, v1

    .line 587
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 588
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 589
    return-void
.end method

.method private static removeEditOverlay()V
    .locals 3

    .line 943
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 944
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 945
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 946
    :cond_1
    move-object v0, v1

    .line 947
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 948
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 949
    return-void
.end method

.method private static removeHandle()V
    .locals 3

    .line 724
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 725
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 727
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 728
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 729
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 730
    :cond_1
    move-object v0, v1

    .line 731
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 732
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 733
    return-void
.end method

.method private static removeIdleProbe()V
    .locals 2

    .line 493
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 494
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    .line 495
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 496
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 498
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v0, :cond_1

    .line 499
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 500
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setAlpha(F)V

    .line 502
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 503
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 505
    :cond_2
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 506
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 507
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V
    .locals 0

    .line 330
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 331
    if-nez p0, :cond_0

    return-void

    .line 332
    :cond_0
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 333
    if-nez p0, :cond_1

    return-void

    .line 334
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 335
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/view/View;Z)V
    .locals 7

    .line 340
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 341
    sget-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x32

    cmp-long v6, v2, v4

    if-gez v6, :cond_0

    return-void

    .line 342
    :cond_0
    sput-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    .line 343
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 353
    return-void
.end method

.method private static resetFromEdit()V
    .locals 7

    .line 895
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 896
    if-nez v0, :cond_0

    return-void

    .line 897
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 898
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 899
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    .line 900
    const-string v4, "scale"

    const v5, 0x3f3851ec    # 0.72f

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 901
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

    .line 902
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 903
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 904
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 905
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleX(F)V

    .line 906
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleY(F)V

    .line 907
    invoke-static {v1, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 908
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_1

    .line 909
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 911
    :cond_1
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 912
    return-void
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    .line 289
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 290
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 291
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 292
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 293
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 294
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 295
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 296
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 297
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v1, v1, v2

    if-nez v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-nez v1, :cond_0

    return-void

    .line 298
    :cond_0
    sput v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 299
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 300
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 301
    if-nez p0, :cond_1

    return-void

    .line 302
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 303
    if-nez p0, :cond_2

    return-void

    .line 304
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 305
    if-nez p0, :cond_3

    return-void

    .line 306
    :cond_3
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleX(F)V

    .line 307
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleY(F)V

    .line 308
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 309
    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 310
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 311
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 189
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 190
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

    .line 277
    if-nez p1, :cond_0

    return-void

    .line 278
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;-><init>(Landroid/view/View;Landroid/view/View;F)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 285
    return-void
.end method

.method private static scheduleIdleFade(Landroid/view/View;)V
    .locals 3

    .line 418
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 419
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 422
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_0

    .line 423
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 424
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 425
    const/high16 p0, 0x3f800000    # 1.0f

    const-wide/16 v0, 0x78

    invoke-static {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 427
    :cond_0
    return-void

    .line 429
    :cond_1
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_2

    return-void

    .line 430
    :cond_2
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 431
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 432
    return-void
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 1307
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 1308
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

    .line 398
    invoke-virtual {p0}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    .line 399
    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 400
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 401
    array-length v2, p1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 402
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 403
    if-eqz p2, :cond_0

    const/16 v0, 0x8

    goto :goto_1

    :cond_0
    const/4 v0, 0x0

    .line 404
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eq v2, v0, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 401
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 409
    :cond_2
    :goto_2
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 410
    check-cast p0, Landroid/view/ViewGroup;

    .line 411
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 412
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 411
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 415
    :cond_3
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 179
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 180
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 181
    return-void
.end method

.method private static setOneHandedAccessPointHidden(Landroid/view/View;Z)V
    .locals 12

    .line 381
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 382
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v1, v1

    new-array v2, v1, [Ljava/lang/String;

    .line 383
    nop

    .line 384
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v4, :cond_1

    aget-object v8, v3, v6

    .line 385
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const-string v10, "string"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v9, v8, v10, v11}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v8

    .line 386
    if-eqz v8, :cond_0

    add-int/lit8 v9, v7, 0x1

    invoke-virtual {v0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v2, v7

    move v7, v9

    .line 384
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 388
    :cond_1
    if-nez v7, :cond_2

    return-void

    .line 389
    :cond_2
    if-ge v7, v1, :cond_3

    .line 390
    new-array v0, v7, [Ljava/lang/String;

    .line 391
    invoke-static {v2, v5, v0, v5, v7}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 392
    move-object v2, v0

    .line 394
    :cond_3
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 395
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 194
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 195
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 196
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 197
    return-void
.end method

.method private static settle(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1244
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1245
    if-nez v0, :cond_0

    return-void

    .line 1246
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

    .line 1247
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1248
    if-nez v2, :cond_2

    return-void

    .line 1249
    :cond_2
    const/4 v3, 0x1

    invoke-static {v0, p1, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1250
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v2

    .line 1256
    const v4, 0x3f6b851f    # 0.92f

    cmpl-float v5, v2, v4

    if-lez v5, :cond_3

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    cmpg-float v4, v5, v4

    if-gez v4, :cond_3

    .line 1257
    nop

    .line 1258
    const/high16 v2, 0x3f800000    # 1.0f

    const/high16 v3, 0x3f000000    # 0.5f

    .line 1260
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1261
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1262
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

    .line 1263
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v3, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1264
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1265
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1266
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1269
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    .line 1270
    return-void
.end method

.method private static touchSlop(Landroid/view/View;)I
    .locals 1

    .line 1118
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    if-gez v0, :cond_0

    .line 1119
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 1121
    :cond_0
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    return p0
.end method

.method private static unwatchAccessPoints()V
    .locals 2

    .line 363
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 364
    if-nez v0, :cond_0

    return-void

    .line 365
    :cond_0
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 366
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 367
    return-void
.end method

.method private static updateCardShadowBounds(Landroid/view/ViewGroup;Landroid/view/View;F)V
    .locals 5

    .line 548
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v0, :cond_0

    return-void

    .line 549
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 550
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 551
    new-array v2, v0, [I

    .line 552
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 553
    const/4 v3, 0x0

    cmpl-float v3, p2, v3

    if-lez v3, :cond_1

    goto :goto_0

    :cond_1
    const/high16 p2, 0x3f800000    # 1.0f

    .line 554
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 555
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p2

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    .line 556
    if-lez v3, :cond_5

    if-gtz p1, :cond_2

    goto :goto_2

    .line 557
    :cond_2
    const/4 p2, 0x0

    aget v4, v1, p2

    aget p2, v2, p2

    sub-int/2addr v4, p2

    .line 558
    const/4 p2, 0x1

    aget v1, v1, p2

    aget p2, v2, p2

    sub-int/2addr v1, p2

    .line 562
    const/high16 p2, 0x41600000    # 14.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, p2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 563
    sub-int/2addr v4, p0

    .line 564
    sub-int/2addr v1, p0

    .line 565
    mul-int/lit8 p0, p0, 0x2

    add-int/2addr v3, p0

    .line 566
    add-int/2addr p1, p0

    .line 568
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    instance-of p0, p0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p0, :cond_3

    .line 569
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    check-cast p0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 570
    :cond_3
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v3, p1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 571
    :goto_1
    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p2, v3, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p2, p1, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p2, v4, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p2, v1, :cond_4

    .line 573
    return-void

    .line 575
    :cond_4
    iput v3, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 576
    iput p1, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 577
    iput v4, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 578
    iput v1, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 579
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 580
    return-void

    .line 556
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 4

    .line 915
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 916
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 917
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 918
    new-array v0, v0, [I

    .line 919
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 920
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 921
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 922
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 923
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 924
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget p1, v0, p1

    sub-int/2addr v3, p1

    .line 925
    const/4 p1, 0x1

    aget v1, v1, p1

    aget p1, v0, p1

    sub-int/2addr v1, p1

    .line 927
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p1, p1, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p1, :cond_3

    .line 928
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 929
    :cond_3
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p1, v2, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 930
    :goto_1
    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v0, v2, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v0, p0, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne v0, v3, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne v0, v1, :cond_4

    .line 932
    return-void

    .line 934
    :cond_4
    iput v2, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 935
    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 936
    const/16 p0, 0x33

    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 937
    iput v3, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 938
    iput v1, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 939
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 940
    return-void

    .line 923
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 6

    .line 680
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 684
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 685
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 686
    new-array v0, v0, [I

    .line 687
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 688
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 689
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 690
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 691
    if-lez v2, :cond_5

    if-gtz v3, :cond_2

    goto :goto_2

    .line 692
    :cond_2
    const/4 v4, 0x0

    aget v5, v1, v4

    aget v4, v0, v4

    sub-int/2addr v5, v4

    .line 694
    const/4 v4, 0x1

    aget v1, v1, v4

    aget v0, v0, v4

    sub-int/2addr v1, v0

    add-int/2addr v1, v3

    sub-int/2addr v1, p2

    .line 696
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_3

    .line 697
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 698
    :cond_3
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v2, p2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 701
    :goto_1
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    const/high16 p0, 0x40000000    # 2.0f

    div-float/2addr p1, p0

    invoke-virtual {v3, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarCenterFromBottom(F)V

    .line 702
    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p0, v2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p0, p2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p0, v5, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p0, v1, :cond_4

    .line 704
    return-void

    .line 706
    :cond_4
    iput v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 707
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 708
    const/16 p0, 0x33

    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 711
    iput v5, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 712
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 713
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 714
    return-void

    .line 691
    :cond_5
    :goto_2
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 6

    .line 1105
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_1

    .line 1106
    :cond_0
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1107
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1108
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1109
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1110
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1111
    aget v2, v0, v1

    const/4 v4, 0x1

    aget v5, v0, v4

    aget v1, v0, v1

    add-int/2addr v1, v3

    aget v0, v0, v4

    add-int/2addr v0, p0

    invoke-virtual {p1, v2, v5, v1, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 1113
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/2addr p0, v4

    return p0

    .line 1105
    :cond_2
    :goto_1
    return v1
.end method

.method private static wakeIdle()V
    .locals 3

    .line 435
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 436
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 437
    const/high16 v0, 0x3f800000    # 1.0f

    const-wide/16 v1, 0x78

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 438
    return-void
.end method

.method private static watchAccessPoints(Landroid/view/View;)V
    .locals 1

    .line 356
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    if-ne v0, p0, :cond_0

    return-void

    .line 357
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 358
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 359
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {p0, v0}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 360
    return-void
.end method

.method private static xFraction(Landroid/content/Context;)F
    .locals 3

    .line 1282
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1283
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f000000    # 0.5f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1282
    return p0
.end method

.method private static yFraction(Landroid/content/Context;)F
    .locals 3

    .line 1287
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1288
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1287
    return p0
.end method
