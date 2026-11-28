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

    .line 106
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    .line 137
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    .line 157
    new-instance v1, Landroid/os/Handler;

    .line 158
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    .line 159
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    .line 168
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 407
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

    .line 902
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 175
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static accentColor(Landroid/view/View;)I
    .locals 1

    .line 922
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentFromPixels(Landroid/view/View;)I

    move-result v0

    .line 923
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

    .line 973
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

    .line 974
    nop

    :goto_0
    if-ge v2, v0, :cond_5

    aget-object v4, v1, v2

    .line 975
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    .line 976
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "attr"

    invoke-virtual {v5, v4, v7, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    .line 977
    if-nez v4, :cond_0

    goto :goto_2

    .line 978
    :cond_0
    new-instance v5, Landroid/util/TypedValue;

    invoke-direct {v5}, Landroid/util/TypedValue;-><init>()V

    .line 979
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v6

    invoke-virtual {v6, v4, v5, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v4

    if-nez v4, :cond_1

    goto :goto_2

    .line 980
    :cond_1
    iget v4, v5, Landroid/util/TypedValue;->resourceId:I

    if-eqz v4, :cond_3

    .line 981
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_2

    .line 982
    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/Context;->getColor(I)I

    move-result p0

    goto :goto_1

    .line 983
    :cond_2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    .line 981
    :goto_1
    return p0

    .line 985
    :cond_3
    iget v4, v5, Landroid/util/TypedValue;->data:I

    if-eqz v4, :cond_4

    iget p0, v5, Landroid/util/TypedValue;->data:I

    return p0

    .line 974
    :cond_4
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 987
    :cond_5
    const p0, -0xb24954

    return p0
.end method

.method private static accentFromPixels(Landroid/view/View;)I
    .locals 9

    .line 935
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    .line 936
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v7

    .line 937
    const/4 v8, 0x0

    if-lez v3, :cond_3

    if-gtz v7, :cond_0

    goto :goto_2

    .line 939
    :cond_0
    :try_start_0
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v7, v0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 941
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 942
    invoke-virtual {p0, v1}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 943
    mul-int p0, v3, v7

    new-array v1, p0, [I

    .line 944
    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v2, 0x0

    move v6, v3

    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 945
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 946
    filled-new-array {v8, v8}, [I

    move-result-object p0

    .line 947
    nop

    .line 948
    const/4 v0, 0x0

    :goto_0
    if-ge v0, v7, :cond_2

    .line 949
    mul-int v2, v0, v3

    .line 950
    const/4 v4, 0x0

    :goto_1
    if-ge v4, v3, :cond_1

    .line 951
    add-int v5, v2, v4

    aget v5, v1, v5

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->considerAccent(I[I)V

    .line 950
    add-int/lit8 v4, v4, 0x3

    goto :goto_1

    .line 948
    :cond_1
    add-int/lit8 v0, v0, 0x3

    goto :goto_0

    .line 954
    :cond_2
    aget p0, p0, v8
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 955
    :catchall_0
    move-exception v0

    .line 956
    return v8

    .line 937
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

.method static synthetic access$1000(Landroid/view/View;Landroid/view/View;F)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    return-void
.end method

.method static synthetic access$1100(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOneHandedAccessPointHidden(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$1200()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    return-void
.end method

.method static synthetic access$1300(Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1400()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncCardShadow()V

    return-void
.end method

.method static synthetic access$1502(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    return p0
.end method

.method static synthetic access$1600(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1700(FFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditDrag(FFZ)V

    return-void
.end method

.method static synthetic access$1800(IFFZ)V
    .locals 0

    .line 33
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditScale(IFFZ)V

    return-void
.end method

.method static synthetic access$1900()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetFromEdit()V

    return-void
.end method

.method static synthetic access$200(Landroid/view/View;Z)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$2000(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 33
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$2102(Ljava/lang/Runnable;)Ljava/lang/Runnable;
    .locals 0

    .line 33
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    return-object p0
.end method

.method static synthetic access$2200()Z
    .locals 1

    .line 33
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return v0
.end method

.method static synthetic access$2202(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return p0
.end method

.method static synthetic access$2300()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    return v0
.end method

.method static synthetic access$2400(Landroid/view/View;Landroid/view/View;F)[F
    .locals 0

    .line 33
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2502(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    return p0
.end method

.method static synthetic access$2600()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    return v0
.end method

.method static synthetic access$2702(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    return p0
.end method

.method static synthetic access$2800()F
    .locals 1

    .line 33
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    return v0
.end method

.method static synthetic access$2902(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    return p0
.end method

.method static synthetic access$3000(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 0

    .line 33
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result p0

    return p0
.end method

.method static synthetic access$302(Z)Z
    .locals 0

    .line 33
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    return p0
.end method

.method static synthetic access$3102(F)F
    .locals 0

    .line 33
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

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

.method static synthetic access$900()V
    .locals 0

    .line 33
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dropFloatingChrome()V

    return-void
.end method

.method private static animateIdleAlpha(FJ)V
    .locals 1

    .line 478
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 479
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 480
    return-void
.end method

.method private static applyGutter(Landroid/view/View;Z)V
    .locals 3

    .line 548
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    if-gez v0, :cond_0

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 549
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 550
    if-eqz p1, :cond_1

    const/high16 p1, 0x42080000    # 34.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, p1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result p1

    add-int/2addr v0, p1

    .line 551
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    if-ne p1, v0, :cond_2

    return-void

    .line 552
    :cond_2
    nop

    .line 553
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p1

    .line 554
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    .line 555
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    .line 552
    invoke-virtual {p0, p1, v1, v2, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 557
    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 10

    .line 216
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 217
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 218
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 219
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V

    .line 220
    return-void

    .line 222
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 223
    if-nez v0, :cond_1

    return-void

    .line 224
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    .line 225
    if-nez v0, :cond_2

    return-void

    .line 228
    :cond_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchAccessPoints(Landroid/view/View;)V

    .line 229
    const/4 v2, 0x1

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 231
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    .line 232
    iget v4, v3, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 233
    iget v3, v3, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 234
    if-lez v4, :cond_8

    if-gtz v3, :cond_3

    goto/16 :goto_0

    .line 236
    :cond_3
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 237
    iput v3, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 238
    const/4 v5, 0x3

    iput v5, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 240
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 241
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v5

    .line 242
    new-instance v6, Landroid/graphics/Rect;

    invoke-direct {v6}, Landroid/graphics/Rect;-><init>()V

    .line 243
    if-eqz v5, :cond_5

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v7

    if-eqz v7, :cond_5

    .line 247
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 252
    invoke-virtual {v5}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v7

    instance-of v7, v7, Landroid/view/View;

    if-eqz v7, :cond_4

    .line 253
    invoke-virtual {v5}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v7

    check-cast v7, Landroid/view/View;

    .line 254
    invoke-virtual {v7}, Landroid/view/View;->getElevation()F

    move-result v8

    const/4 v9, 0x0

    cmpl-float v8, v8, v9

    if-eqz v8, :cond_4

    invoke-virtual {v7, v9}, Landroid/view/View;->setElevation(F)V

    .line 258
    :cond_4
    invoke-static {v5, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    .line 259
    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureCardShadow(Landroid/view/View;F)V

    .line 261
    :cond_5
    invoke-virtual {v6}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v7

    if-eqz v7, :cond_6

    .line 264
    div-int/lit8 v7, v3, 0x3

    sub-int v7, v3, v7

    .line 265
    invoke-virtual {v6, v1, v7, v4, v3}, Landroid/graphics/Rect;->set(IIII)V

    .line 270
    :cond_6
    const/4 v7, 0x2

    new-array v7, v7, [I

    .line 271
    invoke-virtual {v0, v7}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 272
    aget v1, v7, v1

    neg-int v1, v1

    aget v2, v7, v2

    neg-int v2, v2

    invoke-virtual {v6, v1, v2}, Landroid/graphics/Rect;->offset(II)V

    .line 273
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v6}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 275
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {v6, p1}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_7

    .line 276
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {p1, v6}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 277
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

    .line 280
    :cond_7
    invoke-static {v0, v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 281
    return-void

    .line 234
    :cond_8
    :goto_0
    return-void
.end method

.method private static applyPosition(Landroid/view/View;Landroid/view/View;F)Z
    .locals 5

    .line 584
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

    .line 585
    :cond_0
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 586
    if-nez v0, :cond_1

    return v1

    .line 587
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

    .line 588
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    sub-float/2addr p0, v3

    const/4 p2, 0x1

    aget v0, v0, p2

    mul-float p0, p0, v0

    .line 589
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

    .line 590
    :cond_3
    invoke-virtual {p1}, Landroid/view/View;->getTranslationX()F

    move-result p2

    cmpl-float p2, p2, v2

    if-eqz p2, :cond_4

    invoke-virtual {p1, v2}, Landroid/view/View;->setTranslationX(F)V

    .line 591
    :cond_4
    invoke-virtual {p1}, Landroid/view/View;->getTranslationY()F

    move-result p2

    cmpl-float p2, p2, p0

    if-eqz p2, :cond_5

    invoke-virtual {p1, p0}, Landroid/view/View;->setTranslationY(F)V

    .line 592
    :cond_5
    return v1

    .line 584
    :cond_6
    :goto_0
    return v1
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 4

    .line 561
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 562
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 563
    if-lez v0, :cond_5

    if-gtz v1, :cond_0

    goto :goto_0

    .line 564
    :cond_0
    const/4 v2, 0x1

    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 567
    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v3, :cond_1

    sget-boolean v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v3, :cond_2

    :cond_1
    sget p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 568
    :cond_2
    sget v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v3, v3, p1

    if-nez v3, :cond_3

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eq v3, p0, :cond_4

    .line 569
    :cond_3
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 570
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 571
    int-to-float v0, v0

    const/high16 v3, 0x40000000    # 2.0f

    div-float/2addr v0, v3

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 572
    int-to-float v0, v1

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 573
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 574
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 576
    :cond_4
    return v2

    .line 563
    :cond_5
    :goto_0
    const/4 p0, 0x0

    return p0
.end method

.method private static armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 1348
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1349
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1350
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$9;-><init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1370
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    const-wide/16 v0, 0x17c

    invoke-virtual {p0, p1, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1371
    return-void
.end method

.method private static attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 3

    .line 496
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_0

    return-void

    .line 497
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    .line 498
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 500
    :cond_1
    new-instance v0, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 501
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 503
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;

    invoke-direct {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 521
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 522
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 523
    return-void
.end method

.method private static cancelLongPress(Landroid/view/View;)V
    .locals 1

    .line 1336
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    .line 1337
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 1338
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1340
    :cond_0
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1341
    return-void
.end method

.method private static clamp01(F)F
    .locals 1

    .line 1510
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

    .line 961
    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result v0

    const/16 v1, 0xc8

    if-ge v0, v1, :cond_0

    return-void

    .line 962
    :cond_0
    const/4 v0, 0x3

    new-array v0, v0, [F

    .line 963
    invoke-static {p0, v0}, Landroid/graphics/Color;->colorToHSV(I[F)V

    .line 964
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

    .line 965
    :cond_1
    aget v3, v0, v1

    const/high16 v4, 0x42c80000    # 100.0f

    mul-float v3, v3, v4

    aget v0, v0, v2

    mul-float v3, v3, v0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 966
    aget v2, p1, v1

    if-le v0, v2, :cond_2

    .line 967
    const/4 v2, 0x0

    aput p0, p1, v2

    .line 968
    aput v0, p1, v1

    .line 970
    :cond_2
    return-void

    .line 964
    :cond_3
    :goto_0
    return-void
.end method

.method private static density(Landroid/view/View;)F
    .locals 0

    .line 1514
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 1299
    sub-float/2addr p0, p2

    .line 1300
    sub-float/2addr p1, p3

    .line 1301
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

    .line 745
    invoke-static {p0}, Landroid/graphics/Color;->red(I)I

    move-result v0

    invoke-static {p1}, Landroid/graphics/Color;->red(I)I

    move-result v1

    sub-int/2addr v0, v1

    .line 746
    invoke-static {p0}, Landroid/graphics/Color;->green(I)I

    move-result v1

    invoke-static {p1}, Landroid/graphics/Color;->green(I)I

    move-result v2

    sub-int/2addr v1, v2

    .line 747
    invoke-static {p0}, Landroid/graphics/Color;->blue(I)I

    move-result p0

    invoke-static {p1}, Landroid/graphics/Color;->blue(I)I

    move-result p1

    sub-int/2addr p0, p1

    .line 748
    mul-int v0, v0, v0

    mul-int v1, v1, v1

    add-int/2addr v0, v1

    mul-int p0, p0, p0

    add-int/2addr v0, p0

    return v0
.end method

.method private static dropFloatingChrome()V
    .locals 2

    .line 310
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 311
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 312
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 313
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 314
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 315
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 316
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 317
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 318
    return-void
.end method

.method private static ensureCardShadow(Landroid/view/View;F)V
    .locals 3

    .line 792
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    instance-of p1, p1, Landroid/view/ViewGroup;

    if-nez p1, :cond_0

    return-void

    .line 793
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup;

    .line 794
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-eq v0, p1, :cond_2

    .line 795
    :cond_1
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 796
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;-><init>(Landroid/content/Context;F)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 797
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/4 v2, 0x0

    invoke-virtual {p1, v0, v2, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;ILandroid/view/ViewGroup$LayoutParams;)V

    .line 799
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    const/high16 v1, -0x40800000    # -1.0f

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setTranslationZ(F)V

    .line 800
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 801
    new-instance p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;-><init>()V

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 808
    invoke-virtual {p1}, Landroid/view/ViewGroup;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    invoke-virtual {p0, p1}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 810
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->syncCardShadow()V

    .line 811
    return-void
.end method

.method private static ensureHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 610
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_0

    return-void

    .line 611
    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float p2, p2, v0

    if-ltz p2, :cond_1

    .line 613
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 614
    return-void

    .line 616
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object p2

    .line 617
    if-nez p2, :cond_2

    return-void

    .line 618
    :cond_2
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 619
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, p2, :cond_4

    .line 620
    :cond_3
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 621
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 622
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 623
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 624
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->bringToFront()V

    .line 625
    sget p0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt p0, v1, :cond_4

    .line 628
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v1, v0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setElevation(F)V

    .line 631
    :cond_4
    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 632
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 633
    invoke-static {p2, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 636
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz p0, :cond_5

    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    if-eq p0, p1, :cond_5

    .line 637
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->functionLayerColor(Landroid/view/View;)I

    move-result p0

    .line 638
    if-eqz p0, :cond_5

    .line 639
    sget-object p2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarColor(I)V

    .line 640
    sput-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    .line 643
    :cond_5
    return-void
.end method

.method private static enterEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 5

    .line 991
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_0

    .line 992
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 993
    if-nez v0, :cond_1

    return-void

    .line 994
    :cond_1
    const/4 v1, 0x1

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 995
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 996
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 997
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 998
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1000
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 1001
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1004
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-direct {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;-><init>(Landroid/content/Context;)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    .line 1005
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v3, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1007
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;

    invoke-direct {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;-><init>()V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;)V

    .line 1030
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 1031
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->bringToFront()V

    .line 1032
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_2

    .line 1033
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

    .line 1035
    :cond_2
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1036
    invoke-virtual {p1, v1}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 1037
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 1038
    return-void

    .line 991
    :cond_3
    :goto_0
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 1

    .line 1075
    const/4 v0, 0x1

    invoke-static {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;Z)V

    .line 1076
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;Z)V
    .locals 6

    .line 1079
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 1080
    :cond_0
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1081
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1082
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1083
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

    .line 1084
    :goto_0
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1085
    if-eqz p2, :cond_2

    if-eqz v2, :cond_2

    .line 1086
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 1087
    const/4 v3, 0x1

    invoke-static {p1, p0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1088
    invoke-static {p1, p0, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v0

    .line 1089
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1090
    const-string v4, "scale"

    invoke-interface {v2, v4, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "x_fraction_"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1091
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

    .line 1092
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {v2, p2, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    .line 1093
    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1095
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1096
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1097
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1098
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1099
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 1100
    return-void
.end method

.method private static fadeAlpha(Landroid/view/View;FJ)V
    .locals 1

    .line 483
    if-nez p0, :cond_0

    return-void

    .line 484
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    cmpl-float v0, v0, p1

    if-nez v0, :cond_1

    .line 485
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 486
    return-void

    .line 488
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 489
    return-void
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 1523
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 1524
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 1525
    if-nez v1, :cond_0

    .line 1526
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

    .line 1527
    const/4 p0, 0x0

    return-object p0

    .line 1529
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 1

    .line 1485
    const/high16 v0, 0x3f800000    # 1.0f

    if-eqz p4, :cond_0

    .line 1486
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

    .line 1489
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

    .line 597
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 598
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    .line 599
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 600
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 601
    if-lez v0, :cond_1

    if-lez p0, :cond_1

    if-lez v1, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 602
    :cond_0
    int-to-float v0, v0

    int-to-float v1, v1

    mul-float v1, v1, p2

    sub-float/2addr v0, v1

    .line 603
    const/high16 v1, 0x3f800000    # 1.0f

    invoke-static {v1, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    int-to-float p0, p0

    int-to-float p1, p1

    mul-float p1, p1, p2

    sub-float/2addr p0, p1

    .line 604
    invoke-static {v1, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    const/4 p1, 0x2

    new-array p1, p1, [F

    const/4 p2, 0x0

    aput v0, p1, p2

    const/4 p2, 0x1

    aput p0, p1, p2

    .line 602
    return-object p1

    .line 601
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static functionLayerColor(Landroid/view/View;)I
    .locals 7

    .line 658
    const/4 v0, 0x7

    new-array v1, v0, [I

    fill-array-data v1, :array_0

    .line 660
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v2

    .line 661
    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v0, :cond_4

    aget v5, v1, v4

    .line 662
    if-nez v2, :cond_0

    const/4 v5, 0x0

    goto :goto_1

    :cond_0
    invoke-virtual {v2, v5}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v5

    .line 663
    :goto_1
    if-eqz v5, :cond_3

    invoke-virtual {v5}, Landroid/view/View;->isShown()Z

    move-result v6

    if-nez v6, :cond_1

    goto :goto_2

    .line 666
    :cond_1
    invoke-virtual {v5}, Landroid/view/View;->getWidth()I

    move-result v6

    if-lez v6, :cond_3

    invoke-virtual {v5}, Landroid/view/View;->getHeight()I

    move-result v6

    if-gtz v6, :cond_2

    goto :goto_2

    .line 667
    :cond_2
    invoke-static {p0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->functionRowInk(Landroid/view/View;Landroid/view/View;)I

    move-result v5

    .line 668
    if-eqz v5, :cond_3

    return v5

    .line 661
    :cond_3
    :goto_2
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    .line 670
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

    .line 683
    move-object/from16 v0, p0

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 684
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v2

    .line 685
    invoke-virtual {v0}, Landroid/view/View;->getScaleX()F

    move-result v3

    .line 686
    const/4 v4, 0x0

    if-lez v1, :cond_e

    if-lez v2, :cond_e

    const/4 v5, 0x0

    cmpg-float v5, v3, v5

    if-gtz v5, :cond_0

    goto/16 :goto_8

    .line 688
    :cond_0
    const/4 v5, 0x2

    :try_start_0
    new-array v6, v5, [I

    .line 689
    new-array v5, v5, [I

    .line 690
    invoke-virtual {v0, v6}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 691
    move-object/from16 v7, p1

    invoke-virtual {v7, v5}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 693
    aget v8, v5, v4

    aget v9, v6, v4

    sub-int/2addr v8, v9

    int-to-float v8, v8

    div-float/2addr v8, v3

    invoke-static {v8}, Ljava/lang/Math;->round(F)I

    move-result v8

    .line 694
    const/4 v9, 0x1

    aget v5, v5, v9

    aget v6, v6, v9

    sub-int/2addr v5, v6

    int-to-float v5, v5

    div-float/2addr v5, v3

    invoke-static {v5}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 695
    invoke-virtual {v7}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 696
    invoke-virtual {v7}, Landroid/view/View;->getHeight()I

    move-result v6

    .line 698
    sget-object v7, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v1, v2, v7}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v7

    .line 700
    new-instance v10, Landroid/graphics/Canvas;

    invoke-direct {v10, v7}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    invoke-virtual {v0, v10}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 701
    const/16 v0, 0x40

    new-array v10, v0, [I

    .line 702
    nop

    .line 703
    const/4 v11, 0x1

    const/4 v12, 0x0

    :goto_0
    const/4 v13, 0x4

    if-gt v11, v13, :cond_5

    if-ge v12, v0, :cond_5

    .line 704
    mul-int v13, v6, v11

    div-int/lit8 v13, v13, 0x5

    add-int/2addr v13, v3

    .line 705
    if-ltz v13, :cond_4

    if-lt v13, v2, :cond_1

    goto :goto_3

    .line 706
    :cond_1
    const/4 v14, 0x1

    :goto_1
    const/16 v15, 0x10

    if-gt v14, v15, :cond_4

    if-ge v12, v0, :cond_4

    .line 707
    mul-int v15, v5, v14

    div-int/lit8 v15, v15, 0x11

    add-int/2addr v15, v8

    .line 708
    if-ltz v15, :cond_3

    if-lt v15, v1, :cond_2

    goto :goto_2

    .line 709
    :cond_2
    add-int/lit8 v16, v12, 0x1

    invoke-virtual {v7, v15, v13}, Landroid/graphics/Bitmap;->getPixel(II)I

    move-result v15

    aput v15, v10, v12

    move/from16 v12, v16

    .line 706
    :cond_3
    :goto_2
    add-int/lit8 v14, v14, 0x1

    goto :goto_1

    .line 703
    :cond_4
    :goto_3
    add-int/lit8 v11, v11, 0x1

    goto :goto_0

    .line 712
    :cond_5
    invoke-virtual {v7}, Landroid/graphics/Bitmap;->recycle()V

    .line 713
    if-nez v12, :cond_6

    return v4

    .line 715
    :cond_6
    nop

    .line 716
    nop

    .line 717
    const/4 v0, 0x0

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_4
    if-ge v0, v12, :cond_a

    .line 718
    nop

    .line 719
    const/4 v3, 0x0

    const/4 v5, 0x0

    :goto_5
    if-ge v3, v12, :cond_8

    .line 720
    aget v6, v10, v3

    aget v7, v10, v0

    if-ne v6, v7, :cond_7

    add-int/lit8 v5, v5, 0x1

    .line 719
    :cond_7
    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    .line 722
    :cond_8
    if-le v5, v2, :cond_9

    .line 723
    nop

    .line 724
    aget v1, v10, v0

    move v2, v5

    .line 717
    :cond_9
    add-int/lit8 v0, v0, 0x1

    goto :goto_4

    .line 728
    :cond_a
    nop

    .line 729
    nop

    .line 730
    const/4 v0, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_6
    if-ge v0, v12, :cond_c

    .line 731
    aget v5, v10, v0

    invoke-static {v5, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distanceSquared(II)I

    move-result v5

    .line 732
    if-le v5, v2, :cond_b

    .line 733
    nop

    .line 734
    aget v3, v10, v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    move v2, v5

    .line 730
    :cond_b
    add-int/lit8 v0, v0, 0x1

    goto :goto_6

    .line 738
    :cond_c
    const/16 v0, 0x640

    if-ge v2, v0, :cond_d

    goto :goto_7

    :cond_d
    move v4, v3

    :goto_7
    return v4

    .line 739
    :catchall_0
    move-exception v0

    .line 740
    return v4

    .line 686
    :cond_e
    :goto_8
    return v4
.end method

.method private static handleEditDrag(FFZ)V
    .locals 9

    .line 1164
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1165
    if-nez v0, :cond_0

    return-void

    .line 1166
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1167
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    const/high16 v4, 0x3f800000    # 1.0f

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1168
    :goto_0
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1169
    if-nez v3, :cond_2

    return-void

    .line 1171
    :cond_2
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v6, 0x1

    const/4 v7, 0x0

    if-nez v5, :cond_3

    .line 1172
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 1173
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 1174
    invoke-static {v0, v1, v2, v3, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1175
    invoke-static {v0, v1, v2, v3, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1176
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1177
    if-eqz p2, :cond_3

    .line 1178
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1179
    return-void

    .line 1183
    :cond_3
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr p0, v8

    aget v8, v3, v7

    div-float/2addr p0, v8

    add-float/2addr v5, p0

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    .line 1184
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v8

    aget v8, v3, v6

    div-float/2addr p1, v8

    add-float/2addr v5, p1

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1185
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

    .line 1186
    sub-float v2, p1, v4

    aget v3, v3, v6

    mul-float v2, v2, v3

    invoke-virtual {v0, v2}, Landroid/view/View;->setTranslationY(F)V

    .line 1187
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v2, :cond_4

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_4

    .line 1188
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1190
    :cond_4
    if-eqz p2, :cond_5

    .line 1191
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1192
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 1193
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "x_fraction_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 1194
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

    .line 1195
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1196
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1198
    :cond_5
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1199
    return-void
.end method

.method private static handleEditScale(IFFZ)V
    .locals 17

    .line 1204
    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1205
    if-nez v3, :cond_0

    return-void

    .line 1206
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    .line 1208
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    const/high16 v6, 0x3f800000    # 1.0f

    const/4 v7, 0x2

    const/4 v8, 0x0

    const/4 v9, 0x1

    const/4 v10, 0x0

    if-nez v5, :cond_5

    .line 1209
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 1210
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v11

    .line 1211
    if-lez v5, :cond_4

    if-gtz v11, :cond_1

    goto :goto_2

    .line 1212
    :cond_1
    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v12, v12, v10

    if-lez v12, :cond_2

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_2
    const/high16 v12, 0x3f800000    # 1.0f

    .line 1213
    :goto_0
    new-array v13, v7, [I

    .line 1214
    invoke-virtual {v3, v13}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1215
    aget v14, v13, v8

    int-to-float v14, v14

    .line 1216
    aget v13, v13, v9

    int-to-float v13, v13

    .line 1217
    int-to-float v5, v5

    mul-float v15, v5, v12

    add-float/2addr v15, v14

    .line 1218
    int-to-float v11, v11

    mul-float v16, v11, v12

    add-float v16, v13, v16

    .line 1219
    packed-switch v0, :pswitch_data_0

    .line 1239
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1240
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1241
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1242
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    goto :goto_1

    .line 1233
    :pswitch_0
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1234
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1235
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1236
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1237
    goto :goto_1

    .line 1227
    :pswitch_1
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1228
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1229
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1230
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1231
    goto :goto_1

    .line 1221
    :pswitch_2
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1222
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1223
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1224
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1225
    nop

    .line 1245
    :goto_1
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v11}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    .line 1246
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    cmpg-float v5, v5, v6

    if-gez v5, :cond_3

    return-void

    .line 1247
    :cond_3
    sput v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    .line 1248
    invoke-virtual {v3}, Landroid/view/View;->getTranslationX()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    .line 1249
    invoke-virtual {v3}, Landroid/view/View;->getTranslationY()F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    .line 1250
    sput-boolean v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1251
    if-eqz p3, :cond_5

    .line 1252
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1253
    return-void

    .line 1211
    :cond_4
    :goto_2
    return-void

    .line 1257
    :cond_5
    if-eqz p3, :cond_8

    .line 1258
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1259
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, v10

    if-lez v0, :cond_6

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1260
    :cond_6
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1261
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "scale"

    invoke-interface {v0, v1, v6}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1262
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v0, :cond_7

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_7

    .line 1263
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1265
    :cond_7
    return-void

    .line 1268
    :cond_8
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v1

    .line 1269
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    mul-float v2, v2, v1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    div-float/2addr v2, v1

    .line 1270
    const v1, 0x3f6b851f    # 0.92f

    invoke-static {v1, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 1269
    const/high16 v2, 0x3f000000    # 0.5f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1273
    if-eq v0, v9, :cond_a

    if-ne v0, v7, :cond_9

    goto :goto_3

    .line 1275
    :cond_9
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    goto :goto_4

    .line 1274
    :cond_a
    :goto_3
    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sub-float/2addr v5, v6

    .line 1276
    :goto_4
    if-eq v0, v7, :cond_c

    const/4 v6, 0x3

    if-ne v0, v6, :cond_b

    goto :goto_5

    .line 1278
    :cond_b
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    goto :goto_6

    .line 1277
    :cond_c
    :goto_5
    invoke-virtual {v4}, Landroid/view/View;->getHeight()I

    move-result v0

    int-to-float v0, v0

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    sub-float/2addr v0, v6

    .line 1279
    :goto_6
    cmpl-float v6, v5, v10

    if-lez v6, :cond_d

    cmpl-float v6, v0, v10

    if-lez v6, :cond_d

    .line 1280
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

    .line 1281
    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 1282
    invoke-static {v2, v0}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1284
    :cond_d
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 1285
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    .line 1286
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    sub-float/2addr v5, v1

    .line 1287
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleX(F)V

    .line 1288
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleY(F)V

    .line 1289
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1290
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    sub-float/2addr v6, v0

    mul-float v6, v6, v5

    add-float/2addr v1, v6

    invoke-virtual {v3, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 1291
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    sub-float/2addr v1, v2

    mul-float v1, v1, v5

    add-float/2addr v0, v1

    invoke-virtual {v3, v0}, Landroid/view/View;->setTranslationY(F)V

    .line 1292
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v0, :cond_e

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_e

    .line 1293
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1295
    :cond_e
    invoke-virtual {v4}, Landroid/view/View;->requestLayout()V

    .line 1296
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

    .line 757
    const p1, 0x1020002

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 758
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p1, Landroid/view/ViewGroup;

    return-object p1

    .line 759
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

    .line 183
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

    .line 178
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

    .line 192
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 193
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

    .line 1061
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 1062
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1063
    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    goto :goto_0

    .line 1064
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getRootView()Landroid/view/View;

    move-result-object v1

    goto :goto_0

    :cond_2
    const/4 v1, 0x0

    .line 1065
    :goto_0
    if-nez v0, :cond_3

    if-eqz v1, :cond_3

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1066
    :cond_3
    if-eqz v0, :cond_5

    if-nez v1, :cond_4

    goto :goto_1

    .line 1071
    :cond_4
    invoke-static {v1, v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;Z)V

    .line 1072
    return-void

    .line 1067
    :cond_5
    :goto_1
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1068
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1069
    return-void
.end method

.method private static moveHandle(Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 883
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 884
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 885
    if-eqz v0, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    .line 886
    :cond_1
    const/high16 v1, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    invoke-static {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 887
    return-void

    .line 885
    :cond_2
    :goto_0
    return-void
.end method

.method public static onCardRebuilt()V
    .locals 1

    .line 1057
    const/4 v0, 0x0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->leaveEditMode(Z)V

    .line 1058
    return-void
.end method

.method public static onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1374
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1375
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1376
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v2, :pswitch_data_0

    .line 1449
    return v1

    .line 1398
    :pswitch_0
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz v2, :cond_2

    .line 1399
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v2

    .line 1400
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v2

    .line 1401
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result p0

    .line 1402
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p0, p0

    mul-float p0, p0, p0

    cmpl-float p0, v0, p0

    if-lez p0, :cond_1

    .line 1403
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1404
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1406
    :cond_1
    return v4

    .line 1408
    :cond_2
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez v2, :cond_4

    .line 1409
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    if-eqz v0, :cond_3

    .line 1410
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v1

    .line 1411
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v1

    .line 1412
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result v1

    .line 1413
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p1, v1

    mul-float p1, p1, p1

    cmpl-float p1, v0, p1

    if-lez p1, :cond_3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1415
    :cond_3
    return v4

    .line 1417
    :cond_4
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1418
    if-nez v2, :cond_5

    return v1

    .line 1419
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

    .line 1420
    :goto_0
    invoke-static {v0, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1421
    if-nez v3, :cond_7

    return v1

    .line 1422
    :cond_7
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1423
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v6

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr v6, v7

    aget v7, v3, v1

    div-float/2addr v6, v7

    add-float/2addr v5, v6

    .line 1422
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result v5

    .line 1424
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1425
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v7

    aget v7, v3, v4

    div-float/2addr p1, v7

    add-float/2addr v6, p1

    .line 1424
    invoke-static {v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1426
    aget v1, v3, v1

    mul-float v5, v5, v1

    const/high16 v1, 0x3f800000    # 1.0f

    sub-float p0, v1, p0

    .line 1427
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v6

    int-to-float v6, v6

    mul-float p0, p0, v6

    const/high16 v6, 0x40000000    # 2.0f

    div-float/2addr p0, v6

    sub-float/2addr v5, p0

    .line 1426
    invoke-virtual {v2, v5}, Landroid/view/View;->setTranslationX(F)V

    .line 1428
    sub-float/2addr p1, v1

    aget p0, v3, v4

    mul-float p1, p1, p0

    invoke-virtual {v2, p1}, Landroid/view/View;->setTranslationY(F)V

    .line 1429
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveHandle(Landroid/view/View;Landroid/view/View;)V

    .line 1430
    return v4

    .line 1434
    :pswitch_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    .line 1435
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz p1, :cond_8

    .line 1436
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1437
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1438
    return v4

    .line 1440
    :cond_8
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1441
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez p1, :cond_9

    return v4

    .line 1442
    :cond_9
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1443
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->settle(Landroid/view/View;Landroid/view/View;)V

    .line 1444
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1445
    if-eqz p0, :cond_a

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1446
    :cond_a
    return v4

    .line 1378
    :pswitch_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1379
    if-nez v2, :cond_b

    return v1

    .line 1380
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

    .line 1381
    :goto_1
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1382
    if-nez v3, :cond_d

    return v1

    .line 1383
    :cond_d
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    .line 1384
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    .line 1385
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 1386
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    .line 1387
    sget-wide v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x140

    cmp-long p1, v5, v7

    if-gtz p1, :cond_e

    .line 1389
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1390
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0x12c

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_2

    .line 1392
    :cond_e
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1393
    invoke-static {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1395
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

.method public static onKeyboardHidden()V
    .locals 1

    .line 1046
    const/4 v0, 0x1

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->leaveEditMode(Z)V

    .line 1047
    return-void
.end method

.method private static orientation(Landroid/content/Context;)Ljava/lang/String;
    .locals 1

    .line 1504
    nop

    .line 1503
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->orientation:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    .line 1505
    const-string p0, "landscape"

    goto :goto_0

    .line 1506
    :cond_0
    const-string p0, "portrait"

    .line 1503
    :goto_0
    return-object p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 208
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static removeCardShadow()V
    .locals 3

    .line 763
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 764
    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    if-eqz v0, :cond_0

    .line 765
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 766
    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    .line 768
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowSync:Landroid/view/ViewTreeObserver$OnPreDrawListener;

    .line 769
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 770
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v1, :cond_1

    return-void

    .line 771
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_2

    .line 772
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    goto :goto_0

    .line 773
    :cond_2
    move-object v1, v0

    .line 774
    :goto_0
    if-eqz v1, :cond_3

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 775
    :cond_3
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 776
    return-void
.end method

.method private static removeEditOverlay()V
    .locals 3

    .line 1154
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-nez v0, :cond_0

    return-void

    .line 1155
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1156
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 1157
    :cond_1
    move-object v0, v1

    .line 1158
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1159
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    .line 1160
    return-void
.end method

.method private static removeHandle()V
    .locals 3

    .line 890
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 892
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 893
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 894
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 895
    :cond_1
    move-object v0, v1

    .line 896
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 897
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 899
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleColorSource:Landroid/view/View;

    .line 900
    return-void
.end method

.method private static removeIdleProbe()V
    .locals 2

    .line 526
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 527
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    .line 528
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 529
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 531
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v0, :cond_1

    .line 532
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 533
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setAlpha(F)V

    .line 535
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 536
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 538
    :cond_2
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 539
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 540
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V
    .locals 0

    .line 363
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 364
    if-nez p0, :cond_0

    return-void

    .line 365
    :cond_0
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 366
    if-nez p0, :cond_1

    return-void

    .line 367
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 368
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/view/View;Z)V
    .locals 7

    .line 373
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 374
    sget-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x32

    cmp-long v6, v2, v4

    if-gez v6, :cond_0

    return-void

    .line 375
    :cond_0
    sput-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    .line 376
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 386
    return-void
.end method

.method private static resetFromEdit()V
    .locals 7

    .line 1103
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1104
    if-nez v0, :cond_0

    return-void

    .line 1105
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1106
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 1107
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    .line 1108
    const-string v4, "scale"

    const v5, 0x3f3851ec    # 0.72f

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1109
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

    .line 1110
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1111
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1112
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1113
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleX(F)V

    .line 1114
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleY(F)V

    .line 1115
    invoke-static {v1, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1116
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-eqz v2, :cond_1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_1

    .line 1117
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1119
    :cond_1
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1120
    return-void
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    .line 322
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 323
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 324
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 325
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 326
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 327
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 328
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 329
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 330
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v1, v1, v2

    if-nez v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-nez v1, :cond_0

    return-void

    .line 331
    :cond_0
    sput v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 332
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 333
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 334
    if-nez p0, :cond_1

    return-void

    .line 335
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 336
    if-nez p0, :cond_2

    return-void

    .line 337
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 338
    if-nez p0, :cond_3

    return-void

    .line 339
    :cond_3
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleX(F)V

    .line 340
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleY(F)V

    .line 341
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 342
    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 343
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 344
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 197
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 198
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

    .line 289
    if-nez p1, :cond_0

    return-void

    .line 290
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;-><init>(Landroid/view/View;Landroid/view/View;F)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 300
    return-void
.end method

.method private static scheduleIdleFade(Landroid/view/View;)V
    .locals 3

    .line 451
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 452
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 455
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_0

    .line 456
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 457
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 458
    const/high16 p0, 0x3f800000    # 1.0f

    const-wide/16 v0, 0x78

    invoke-static {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 460
    :cond_0
    return-void

    .line 462
    :cond_1
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_2

    return-void

    .line 463
    :cond_2
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 464
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 465
    return-void
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 1518
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 1519
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

    .line 431
    invoke-virtual {p0}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    .line 432
    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 433
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 434
    array-length v2, p1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 435
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 436
    if-eqz p2, :cond_0

    const/16 v0, 0x8

    goto :goto_1

    :cond_0
    const/4 v0, 0x0

    .line 437
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eq v2, v0, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 434
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 442
    :cond_2
    :goto_2
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 443
    check-cast p0, Landroid/view/ViewGroup;

    .line 444
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 445
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 444
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 448
    :cond_3
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 187
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 188
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 189
    return-void
.end method

.method private static setOneHandedAccessPointHidden(Landroid/view/View;Z)V
    .locals 12

    .line 414
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 415
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v1, v1

    new-array v2, v1, [Ljava/lang/String;

    .line 416
    nop

    .line 417
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v4, :cond_1

    aget-object v8, v3, v6

    .line 418
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const-string v10, "string"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v9, v8, v10, v11}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v8

    .line 419
    if-eqz v8, :cond_0

    add-int/lit8 v9, v7, 0x1

    invoke-virtual {v0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v2, v7

    move v7, v9

    .line 417
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 421
    :cond_1
    if-nez v7, :cond_2

    return-void

    .line 422
    :cond_2
    if-ge v7, v1, :cond_3

    .line 423
    new-array v0, v7, [Ljava/lang/String;

    .line 424
    invoke-static {v2, v5, v0, v5, v7}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 425
    move-object v2, v0

    .line 427
    :cond_3
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 428
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 202
    const v0, 0x3f6b851f    # 0.92f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const/high16 v0, 0x3f000000    # 0.5f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 203
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 204
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 205
    return-void
.end method

.method private static settle(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1455
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1456
    if-nez v0, :cond_0

    return-void

    .line 1457
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

    .line 1458
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1459
    if-nez v2, :cond_2

    return-void

    .line 1460
    :cond_2
    const/4 v3, 0x1

    invoke-static {v0, p1, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1461
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromTranslation(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v2

    .line 1467
    const v4, 0x3f6b851f    # 0.92f

    cmpl-float v5, v2, v4

    if-lez v5, :cond_3

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    cmpg-float v4, v5, v4

    if-gez v4, :cond_3

    .line 1468
    nop

    .line 1469
    const/high16 v2, 0x3f800000    # 1.0f

    const/high16 v3, 0x3f000000    # 0.5f

    .line 1471
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1472
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1473
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

    .line 1474
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v3, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1475
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1476
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1477
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1480
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    .line 1481
    return-void
.end method

.method private static syncCardShadow()V
    .locals 7

    .line 815
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadowArea:Landroid/view/View;

    .line 816
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v1, :cond_5

    if-eqz v0, :cond_5

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 817
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getScaleX()F

    move-result v1

    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v1

    .line 818
    invoke-virtual {v0}, Landroid/view/View;->getScaleY()F

    move-result v2

    invoke-static {v2}, Ljava/lang/Math;->abs(F)F

    move-result v2

    .line 819
    const/4 v3, 0x0

    cmpg-float v4, v1, v3

    if-lez v4, :cond_4

    cmpg-float v4, v2, v3

    if-gtz v4, :cond_1

    goto :goto_1

    .line 822
    :cond_1
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v4

    int-to-float v4, v4

    mul-float v4, v4, v1

    .line 823
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v1

    int-to-float v1, v1

    mul-float v1, v1, v2

    .line 824
    cmpg-float v2, v4, v3

    if-lez v2, :cond_3

    cmpg-float v2, v1, v3

    if-gtz v2, :cond_2

    goto :goto_0

    .line 825
    :cond_2
    const/4 v2, 0x2

    new-array v3, v2, [I

    .line 826
    invoke-virtual {v0, v3}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 827
    new-array v0, v2, [I

    .line 828
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLocationOnScreen([I)V

    .line 829
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

    .line 834
    return-void

    .line 824
    :cond_3
    :goto_0
    return-void

    .line 819
    :cond_4
    :goto_1
    return-void

    .line 816
    :cond_5
    :goto_2
    return-void
.end method

.method private static touchSlop(Landroid/view/View;)I
    .locals 1

    .line 1329
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    if-gez v0, :cond_0

    .line 1330
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 1332
    :cond_0
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    return p0
.end method

.method private static unwatchAccessPoints()V
    .locals 2

    .line 396
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 397
    if-nez v0, :cond_0

    return-void

    .line 398
    :cond_0
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 399
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 400
    return-void
.end method

.method private static updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 5

    .line 1123
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    if-nez v0, :cond_0

    return-void

    .line 1124
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 1125
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1126
    new-array v0, v0, [I

    .line 1127
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 1128
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 1129
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 1130
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1131
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 1132
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget v4, v0, p1

    sub-int/2addr v3, v4

    .line 1133
    const/4 v4, 0x1

    aget v1, v1, v4

    aget v0, v0, v4

    sub-int/2addr v1, v0

    .line 1135
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_3

    .line 1136
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 1137
    :cond_3
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v2, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 1140
    :goto_1
    iget v4, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v4, v2, :cond_4

    iget v4, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v4, p0, :cond_4

    iget v4, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne v4, v3, :cond_4

    iget v4, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne v4, v1, :cond_4

    .line 1142
    return-void

    .line 1144
    :cond_4
    iput v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 1145
    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 1146
    const/16 v4, 0x33

    iput v4, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 1147
    iput v3, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 1148
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 1149
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1150
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;

    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1, p1, p1, v2, p0}, Landroid/graphics/Rect;-><init>(IIII)V

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->setFrameBounds(Landroid/graphics/Rect;)V

    .line 1151
    return-void

    .line 1131
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 6

    .line 837
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 841
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 842
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 843
    new-array v0, v0, [I

    .line 844
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 845
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 846
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 847
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 848
    if-lez v2, :cond_5

    if-gtz v3, :cond_2

    goto :goto_2

    .line 849
    :cond_2
    const/4 v4, 0x0

    aget v5, v1, v4

    aget v4, v0, v4

    sub-int/2addr v5, v4

    .line 851
    const/4 v4, 0x1

    aget v1, v1, v4

    aget v0, v0, v4

    sub-int/2addr v1, v0

    add-int/2addr v1, v3

    sub-int/2addr v1, p2

    .line 853
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_3

    .line 854
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 855
    :cond_3
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v2, p2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 864
    :goto_1
    const/high16 v3, 0x40800000    # 4.0f

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v4

    mul-float v4, v4, v3

    .line 865
    invoke-virtual {p1}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    const/high16 p0, 0x40000000    # 2.0f

    div-float/2addr p1, p0

    .line 866
    int-to-float p0, p2

    sub-float/2addr p0, v4

    invoke-static {p0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p0

    invoke-static {v4, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    .line 867
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarCenterFromBottom(F)V

    .line 868
    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p0, v2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p0, p2, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p0, v5, :cond_4

    iget p0, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p0, v1, :cond_4

    .line 870
    return-void

    .line 872
    :cond_4
    iput v2, v0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 873
    iput p2, v0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 874
    const/16 p0, 0x33

    iput p0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 877
    iput v5, v0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 878
    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 879
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 880
    return-void

    .line 848
    :cond_5
    :goto_2
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 6

    .line 1316
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_1

    .line 1317
    :cond_0
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1318
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1319
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1320
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1321
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1322
    aget v2, v0, v1

    const/4 v4, 0x1

    aget v5, v0, v4

    aget v1, v0, v1

    add-int/2addr v1, v3

    aget v0, v0, v4

    add-int/2addr v0, p0

    invoke-virtual {p1, v2, v5, v1, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 1324
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/2addr p0, v4

    return p0

    .line 1316
    :cond_2
    :goto_1
    return v1
.end method

.method private static wakeIdle()V
    .locals 3

    .line 468
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 469
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 470
    const/high16 v0, 0x3f800000    # 1.0f

    const-wide/16 v1, 0x78

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 471
    return-void
.end method

.method private static watchAccessPoints(Landroid/view/View;)V
    .locals 1

    .line 389
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    if-ne v0, p0, :cond_0

    return-void

    .line 390
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 391
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 392
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {p0, v0}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 393
    return-void
.end method

.method private static xFraction(Landroid/content/Context;)F
    .locals 3

    .line 1493
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1494
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f000000    # 0.5f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1493
    return p0
.end method

.method private static yFraction(Landroid/content/Context;)F
    .locals 3

    .line 1498
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1499
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1498
    return p0
.end method
