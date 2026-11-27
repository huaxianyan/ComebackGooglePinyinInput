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

.field static final SHADOW_GROW_DP:F = 10.0f

.field private static final TABLET_SMALLEST_WIDTH_DP:I = 0x258

.field private static final TAG:Ljava/lang/String; = "FloatingKeyboard"

.field private static appliedScale:F

.field private static armingEdit:Z

.field private static baseAreaBackground:Landroid/graphics/drawable/Drawable;

.field private static baseAreaHeight:I

.field private static baseAreaWidth:I

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

.field private static floatingWindow:Landroid/view/Window;

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

    .line 74
    const/4 v0, -0x1

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 97
    const/high16 v1, -0x40800000    # -1.0f

    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 107
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    .line 108
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    .line 112
    new-instance v1, Landroid/graphics/Rect;

    invoke-direct {v1}, Landroid/graphics/Rect;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    .line 147
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$1;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    .line 167
    new-instance v1, Landroid/os/Handler;

    .line 168
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    .line 169
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;

    invoke-direct {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$2;-><init>()V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    .line 178
    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 398
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

    .line 1014
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;

    invoke-direct {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$6;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 185
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static accentColor(Landroid/view/View;)I
    .locals 1

    .line 1034
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentFromPixels(Landroid/view/View;)I

    move-result v0

    .line 1035
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

    .line 1085
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

    .line 1086
    nop

    :goto_0
    if-ge v2, v0, :cond_5

    aget-object v4, v1, v2

    .line 1087
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    .line 1088
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    const-string v7, "attr"

    invoke-virtual {v5, v4, v7, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    .line 1089
    if-nez v4, :cond_0

    goto :goto_2

    .line 1090
    :cond_0
    new-instance v5, Landroid/util/TypedValue;

    invoke-direct {v5}, Landroid/util/TypedValue;-><init>()V

    .line 1091
    invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;

    move-result-object v6

    invoke-virtual {v6, v4, v5, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z

    move-result v4

    if-nez v4, :cond_1

    goto :goto_2

    .line 1092
    :cond_1
    iget v4, v5, Landroid/util/TypedValue;->resourceId:I

    if-eqz v4, :cond_3

    .line 1093
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x17

    if-lt v0, v1, :cond_2

    .line 1094
    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/Context;->getColor(I)I

    move-result p0

    goto :goto_1

    .line 1095
    :cond_2
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    iget v0, v5, Landroid/util/TypedValue;->resourceId:I

    invoke-virtual {p0, v0}, Landroid/content/res/Resources;->getColor(I)I

    move-result p0

    .line 1093
    :goto_1
    return p0

    .line 1097
    :cond_3
    iget v4, v5, Landroid/util/TypedValue;->data:I

    if-eqz v4, :cond_4

    iget p0, v5, Landroid/util/TypedValue;->data:I

    return p0

    .line 1086
    :cond_4
    :goto_2
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 1099
    :cond_5
    const p0, -0xb24954

    return p0
.end method

.method private static accentFromPixels(Landroid/view/View;)I
    .locals 9

    .line 1047
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    .line 1048
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v7

    .line 1049
    const/4 v8, 0x0

    if-lez v3, :cond_3

    if-gtz v7, :cond_0

    goto :goto_2

    .line 1051
    :cond_0
    :try_start_0
    sget-object v0, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;

    invoke-static {v3, v7, v0}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;

    move-result-object v0

    .line 1053
    new-instance v1, Landroid/graphics/Canvas;

    invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V

    .line 1054
    invoke-virtual {p0, v1}, Landroid/view/View;->draw(Landroid/graphics/Canvas;)V

    .line 1055
    mul-int p0, v3, v7

    new-array v1, p0, [I

    .line 1056
    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v2, 0x0

    move v6, v3

    invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V

    .line 1057
    invoke-virtual {v0}, Landroid/graphics/Bitmap;->recycle()V

    .line 1058
    filled-new-array {v8, v8}, [I

    move-result-object p0

    .line 1059
    nop

    .line 1060
    const/4 v0, 0x0

    :goto_0
    if-ge v0, v7, :cond_2

    .line 1061
    mul-int v2, v0, v3

    .line 1062
    const/4 v4, 0x0

    :goto_1
    if-ge v4, v3, :cond_1

    .line 1063
    add-int v5, v2, v4

    aget v5, v1, v5

    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->considerAccent(I[I)V

    .line 1062
    add-int/lit8 v4, v4, 0x3

    goto :goto_1

    .line 1060
    :cond_1
    add-int/lit8 v0, v0, 0x3

    goto :goto_0

    .line 1066
    :cond_2
    aget p0, p0, v8
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return p0

    .line 1067
    :catchall_0
    move-exception v0

    .line 1068
    return v8

    .line 1049
    :cond_3
    :goto_2
    return v8
.end method

.method static synthetic access$000()J
    .locals 2

    .line 36
    sget-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointScan:J

    return-wide v0
.end method

.method static synthetic access$002(J)J
    .locals 0

    .line 36
    sput-wide p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointScan:J

    return-wide p0
.end method

.method static synthetic access$100()Landroid/view/View;
    .locals 1

    .line 36
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$1000(Landroid/view/View;Z)V
    .locals 0

    .line 36
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setOneHandedAccessPointHidden(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$1100()V
    .locals 0

    .line 36
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    return-void
.end method

.method static synthetic access$1200(Landroid/view/View;)V
    .locals 0

    .line 36
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1302(Z)Z
    .locals 0

    .line 36
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    return p0
.end method

.method static synthetic access$1400(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 36
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1500(FFZ)V
    .locals 0

    .line 36
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditDrag(FFZ)V

    return-void
.end method

.method static synthetic access$1600(IFFZ)V
    .locals 0

    .line 36
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleEditScale(IFFZ)V

    return-void
.end method

.method static synthetic access$1700()V
    .locals 0

    .line 36
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetFromEdit()V

    return-void
.end method

.method static synthetic access$1800(Landroid/view/View;Landroid/view/View;)V
    .locals 0

    .line 36
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->exitEditMode(Landroid/view/View;Landroid/view/View;)V

    return-void
.end method

.method static synthetic access$1902(Ljava/lang/Runnable;)Ljava/lang/Runnable;
    .locals 0

    .line 36
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    return-object p0
.end method

.method static synthetic access$200(Landroid/view/View;Z)V
    .locals 0

    .line 36
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    return-void
.end method

.method static synthetic access$2000()Z
    .locals 1

    .line 36
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return v0
.end method

.method static synthetic access$2002(Z)Z
    .locals 0

    .line 36
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    return p0
.end method

.method static synthetic access$2100()F
    .locals 1

    .line 36
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    return v0
.end method

.method static synthetic access$2200(Landroid/view/View;Landroid/view/View;F)[F
    .locals 0

    .line 36
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2302(F)F
    .locals 0

    .line 36
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    return p0
.end method

.method static synthetic access$2400()F
    .locals 1

    .line 36
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    return v0
.end method

.method static synthetic access$2502(F)F
    .locals 0

    .line 36
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    return p0
.end method

.method static synthetic access$2600()F
    .locals 1

    .line 36
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    return v0
.end method

.method static synthetic access$2702(F)F
    .locals 0

    .line 36
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    return p0
.end method

.method static synthetic access$2800(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 0

    .line 36
    invoke-static {p0, p1, p2, p3, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result p0

    return p0
.end method

.method static synthetic access$2902(F)F
    .locals 0

    .line 36
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    return p0
.end method

.method static synthetic access$302(Z)Z
    .locals 0

    .line 36
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    return p0
.end method

.method static synthetic access$400()Z
    .locals 1

    .line 36
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    return v0
.end method

.method static synthetic access$402(Z)Z
    .locals 0

    .line 36
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    return p0
.end method

.method static synthetic access$500()Z
    .locals 1

    .line 36
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    return v0
.end method

.method static synthetic access$600()Z
    .locals 1

    .line 36
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    return v0
.end method

.method static synthetic access$700()Landroid/view/View;
    .locals 1

    .line 36
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$800(FJ)V
    .locals 0

    .line 36
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    return-void
.end method

.method static synthetic access$900(Landroid/view/View;Landroid/view/View;F)V
    .locals 0

    .line 36
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    return-void
.end method

.method private static animateIdleAlpha(FJ)V
    .locals 1

    .line 469
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 470
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeAlpha(Landroid/view/View;FJ)V

    .line 471
    return-void
.end method

.method private static applyGutter(Landroid/view/View;Z)V
    .locals 3

    .line 539
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    if-gez v0, :cond_0

    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result v0

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 540
    :cond_0
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseBottomPadding:I

    .line 541
    if-eqz p1, :cond_1

    const/high16 p1, 0x42080000    # 34.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, p1

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result p1

    add-int/2addr v0, p1

    .line 542
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getPaddingBottom()I

    move-result p1

    if-ne p1, v0, :cond_2

    return-void

    .line 543
    :cond_2
    nop

    .line 544
    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result p1

    .line 545
    invoke-virtual {p0}, Landroid/view/View;->getPaddingTop()I

    move-result v1

    .line 546
    invoke-virtual {p0}, Landroid/view/View;->getPaddingRight()I

    move-result v2

    .line 543
    invoke-virtual {p0, p1, v1, v2, v0}, Landroid/view/View;->setPadding(IIII)V

    .line 548
    return-void
.end method

.method public static applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 10

    .line 226
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->isEnabled(Landroid/content/Context;)Z

    move-result v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 227
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->resetScale(Landroid/inputmethodservice/InputMethodService;)V

    .line 228
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 229
    invoke-static {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V

    .line 230
    return-void

    .line 232
    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object v0

    .line 233
    if-nez v0, :cond_1

    return-void

    .line 234
    :cond_1
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v2

    .line 235
    if-nez v2, :cond_2

    return-void

    .line 238
    :cond_2
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchAccessPoints(Landroid/view/View;)V

    .line 239
    const/4 v3, 0x1

    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 241
    invoke-virtual {v2}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    invoke-virtual {v4}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v4

    .line 242
    iget v5, v4, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 243
    iget v4, v4, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 244
    if-lez v5, :cond_7

    if-gtz v4, :cond_3

    goto/16 :goto_0

    .line 246
    :cond_3
    iput v4, p1, Landroid/inputmethodservice/InputMethodService$Insets;->contentTopInsets:I

    .line 247
    iput v4, p1, Landroid/inputmethodservice/InputMethodService$Insets;->visibleTopInsets:I

    .line 248
    const/4 v6, 0x3

    iput v6, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableInsets:I

    .line 250
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scale(Landroid/content/Context;)F

    move-result p0

    .line 251
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v6

    .line 252
    new-instance v7, Landroid/graphics/Rect;

    invoke-direct {v7}, Landroid/graphics/Rect;-><init>()V

    .line 253
    if-eqz v6, :cond_4

    invoke-static {v6, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyScale(Landroid/view/View;F)Z

    move-result v8

    if-eqz v8, :cond_4

    .line 256
    invoke-static {v0, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->narrowWindowToCard(Landroid/view/Window;Landroid/view/View;)V

    .line 259
    invoke-static {v2, v6, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 260
    invoke-static {v6, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z

    .line 261
    invoke-static {v2, v6, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureCardShadow(Landroid/view/View;Landroid/view/View;F)V

    .line 266
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v8

    mul-float v8, v8, v0

    invoke-static {v8}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 267
    iget v8, v7, Landroid/graphics/Rect;->bottom:I

    mul-int/lit8 v9, v0, 0x2

    add-int/2addr v8, v9

    iput v8, v7, Landroid/graphics/Rect;->bottom:I

    .line 268
    iget v8, v7, Landroid/graphics/Rect;->top:I

    sub-int/2addr v8, v0

    iput v8, v7, Landroid/graphics/Rect;->top:I

    .line 270
    :cond_4
    invoke-virtual {v7}, Landroid/graphics/Rect;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 273
    div-int/lit8 v0, v4, 0x3

    sub-int v0, v4, v0

    .line 274
    invoke-virtual {v7, v1, v0, v5, v4}, Landroid/graphics/Rect;->set(IIII)V

    .line 279
    :cond_5
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 280
    invoke-virtual {v2, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 281
    aget v1, v0, v1

    neg-int v1, v1

    aget v0, v0, v3

    neg-int v0, v0

    invoke-virtual {v7, v1, v0}, Landroid/graphics/Rect;->offset(II)V

    .line 282
    iget-object p1, p1, Landroid/inputmethodservice/InputMethodService$Insets;->touchableRegion:Landroid/graphics/Region;

    invoke-virtual {p1, v7}, Landroid/graphics/Region;->set(Landroid/graphics/Rect;)Z

    .line 284
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {v7, p1}, Landroid/graphics/Rect;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_6

    .line 285
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastRegion:Landroid/graphics/Rect;

    invoke-virtual {p1, v7}, Landroid/graphics/Rect;->set(Landroid/graphics/Rect;)V

    .line 286
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "scale="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " region="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {v7}, Landroid/graphics/Rect;->toShortString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " screen="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, "x"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "FloatingKeyboard"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 289
    :cond_6
    invoke-static {v2, v6, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 290
    return-void

    .line 244
    :cond_7
    :goto_0
    return-void
.end method

.method private static applyPosition(Landroid/view/View;Landroid/view/View;F)Z
    .locals 2

    .line 767
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v1, 0x0

    if-nez v0, :cond_2

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v0, :cond_2

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_2

    const/4 v0, 0x0

    cmpg-float v0, p2, v0

    if-gtz v0, :cond_0

    goto :goto_0

    .line 768
    :cond_0
    invoke-static {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v0

    .line 769
    if-nez v0, :cond_1

    return v1

    .line 770
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->xFraction(Landroid/content/Context;)F

    move-result v1

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    invoke-static {p2, v0, v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveWindow(F[FFFLandroid/view/View;)V

    .line 772
    const/4 p0, 0x1

    return p0

    .line 767
    :cond_2
    :goto_0
    return v1
.end method

.method private static applyScale(Landroid/view/View;F)Z
    .locals 3

    .line 735
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 736
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    .line 737
    const/4 v2, 0x0

    if-lez v0, :cond_5

    if-gtz v1, :cond_0

    goto :goto_0

    .line 738
    :cond_0
    invoke-static {p0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 739
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clearAreaBackground(Landroid/view/View;)V

    .line 742
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    if-nez v0, :cond_1

    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_2

    :cond_1
    sget p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 743
    :cond_2
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, p1

    if-nez v0, :cond_3

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-eq v0, p0, :cond_4

    .line 744
    :cond_3
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 745
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 749
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotX(F)V

    .line 755
    invoke-virtual {p0, v0}, Landroid/view/View;->setPivotY(F)V

    .line 756
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleX(F)V

    .line 757
    invoke-virtual {p0, p1}, Landroid/view/View;->setScaleY(F)V

    .line 759
    :cond_4
    const/4 p0, 0x1

    return p0

    .line 737
    :cond_5
    :goto_0
    return v2
.end method

.method private static armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V
    .locals 2

    .line 1427
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1428
    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1429
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$8;-><init>(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1449
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    const-wide/16 v0, 0x17c

    invoke-virtual {p0, p1, v0, v1}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1450
    return-void
.end method

.method private static attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 3

    .line 487
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    if-ne v0, p0, :cond_0

    return-void

    .line 488
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_1

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_1

    .line 489
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 491
    :cond_1
    new-instance v0, Landroid/view/View;

    invoke-virtual {p0}, Landroid/view/ViewGroup;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 492
    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, -0x1

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 494
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;

    invoke-direct {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$5;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 512
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 513
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 514
    return-void
.end method

.method private static cancelLongPress(Landroid/view/View;)V
    .locals 1

    .line 1415
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    if-eqz v0, :cond_0

    .line 1416
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/view/View;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 1417
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingLongPress:Ljava/lang/Runnable;

    .line 1419
    :cond_0
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    .line 1420
    return-void
.end method

.method private static cardOffsetInWindow(Landroid/view/View;)[I
    .locals 1

    .line 843
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    .line 844
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    .line 845
    nop

    .line 846
    invoke-virtual {p0}, Landroid/view/View;->getLeft()I

    move-result v0

    invoke-virtual {p0}, Landroid/view/View;->getTop()I

    move-result p0

    filled-new-array {v0, p0}, [I

    move-result-object p0

    return-object p0
.end method

.method private static clamp01(F)F
    .locals 1

    .line 1597
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p0}, Ljava/lang/Math;->min(FF)F

    move-result p0

    const/4 v0, 0x0

    invoke-static {v0, p0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    return p0
.end method

.method private static clearAreaBackground(Landroid/view/View;)V
    .locals 1

    .line 557
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaBackground:Landroid/graphics/drawable/Drawable;

    if-eqz v0, :cond_0

    return-void

    .line 558
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaBackground:Landroid/graphics/drawable/Drawable;

    .line 559
    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 560
    return-void
.end method

.method private static considerAccent(I[I)V
    .locals 5

    .line 1073
    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result v0

    const/16 v1, 0xc8

    if-ge v0, v1, :cond_0

    return-void

    .line 1074
    :cond_0
    const/4 v0, 0x3

    new-array v0, v0, [F

    .line 1075
    invoke-static {p0, v0}, Landroid/graphics/Color;->colorToHSV(I[F)V

    .line 1076
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

    .line 1077
    :cond_1
    aget v3, v0, v1

    const/high16 v4, 0x42c80000    # 100.0f

    mul-float v3, v3, v4

    aget v0, v0, v2

    mul-float v3, v3, v0

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 1078
    aget v2, p1, v1

    if-le v0, v2, :cond_2

    .line 1079
    const/4 v2, 0x0

    aput p0, p1, v2

    .line 1080
    aput v0, p1, v1

    .line 1082
    :cond_2
    return-void

    .line 1076
    :cond_3
    :goto_0
    return-void
.end method

.method private static density(Landroid/view/View;)F
    .locals 0

    .line 1601
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    return p0
.end method

.method private static distance(FFFF)F
    .locals 0

    .line 1378
    sub-float/2addr p0, p2

    .line 1379
    sub-float/2addr p1, p3

    .line 1380
    mul-float p0, p0, p0

    mul-float p1, p1, p1

    add-float/2addr p0, p1

    float-to-double p0, p0

    invoke-static {p0, p1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide p0

    double-to-float p0, p0

    return p0
.end method

.method private static dumpTree(Landroid/view/View;I)V
    .locals 6

    .line 647
    const/4 v0, 0x3

    if-le p1, v0, :cond_0

    return-void

    .line 648
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 649
    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_0
    if-ge v2, p1, :cond_1

    const-string v3, "  "

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 650
    :cond_1
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v2

    .line 652
    :try_start_0
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "#"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    invoke-virtual {p0}, Landroid/view/View;->getId()I

    move-result v5

    invoke-virtual {v4, v5}, Landroid/content/res/Resources;->getResourceEntryName(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 654
    goto :goto_1

    .line 653
    :catch_0
    move-exception v3

    .line 655
    :goto_1
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "tree "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " pos="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 656
    invoke-virtual {p0}, Landroid/view/View;->getLeft()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, ","

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Landroid/view/View;->getTop()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " size="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 657
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, "x"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " scale="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 658
    invoke-virtual {p0}, Landroid/view/View;->getScaleY()F

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " bg="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    .line 659
    invoke-virtual {p0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v2

    const/4 v3, 0x1

    if-eqz v2, :cond_2

    const/4 v2, 0x1

    goto :goto_2

    :cond_2
    const/4 v2, 0x0

    :goto_2
    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 655
    const-string v2, "FloatingKeyboard"

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 660
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 661
    check-cast p0, Landroid/view/ViewGroup;

    .line 662
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 663
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    add-int/lit8 v2, p1, 0x1

    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dumpTree(Landroid/view/View;I)V

    .line 662
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 666
    :cond_3
    return-void
.end method

.method private static ensureCardShadow(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 574
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-ge v0, v1, :cond_0

    return-void

    .line 575
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 576
    if-nez v0, :cond_1

    return-void

    .line 577
    :cond_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-eqz v1, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_3

    .line 578
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 579
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    invoke-direct {v1, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;-><init>(Landroid/content/Context;F)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 580
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 581
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 583
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    const/high16 v1, -0x40800000    # -1.0f

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setTranslationZ(F)V

    .line 585
    :cond_3
    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateCardShadowBounds(Landroid/view/ViewGroup;Landroid/view/View;F)V

    .line 586
    return-void
.end method

.method private static ensureHandle(Landroid/view/View;Landroid/view/View;F)V
    .locals 3

    .line 920
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-eqz v0, :cond_0

    return-void

    .line 921
    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    cmpl-float p2, p2, v0

    if-ltz p2, :cond_1

    .line 923
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 924
    return-void

    .line 926
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object p2

    .line 927
    if-nez p2, :cond_2

    return-void

    .line 928
    :cond_2
    const/high16 v0, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v1

    mul-float v1, v1, v0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v0

    .line 929
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v1, :cond_3

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, p2, :cond_4

    .line 930
    :cond_3
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 931
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 932
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    new-instance v1, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v2, 0x0

    invoke-direct {v1, v2, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 933
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p2, p0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 934
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->bringToFront()V

    .line 935
    sget p0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt p0, v1, :cond_4

    .line 938
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v1, v0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setElevation(F)V

    .line 941
    :cond_4
    invoke-static {p2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->attachIdleProbe(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 942
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 943
    invoke-static {p2, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 944
    return-void
.end method

.method private static enterEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 5

    .line 1103
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_3

    if-nez p1, :cond_0

    goto :goto_0

    .line 1104
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 1105
    if-nez v0, :cond_1

    return-void

    .line 1106
    :cond_1
    const/4 v1, 0x1

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1107
    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1108
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1109
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1110
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v2, v3}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1112
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 1113
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1114
    new-instance v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->accentColor(Landroid/view/View;)I

    move-result v4

    invoke-direct {v2, v3, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;-><init>(Landroid/content/Context;I)V

    sput-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 1115
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v1, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1116
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    new-instance v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;

    invoke-direct {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$7;-><init>()V

    invoke-virtual {v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit$Listener;)V

    .line 1139
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 1140
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->bringToFront()V

    .line 1141
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x15

    if-lt v2, v3, :cond_2

    .line 1142
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

    .line 1144
    :cond_2
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1145
    invoke-virtual {p1, v1}, Landroid/view/View;->performHapticFeedback(I)Z

    .line 1146
    invoke-virtual {p1}, Landroid/view/View;->invalidate()V

    .line 1147
    return-void

    .line 1103
    :cond_3
    :goto_0
    return-void
.end method

.method private static exitEditMode(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1150
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    if-nez v0, :cond_0

    return-void

    .line 1151
    :cond_0
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 1152
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1153
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1154
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

    .line 1155
    :goto_0
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1156
    if-eqz v2, :cond_2

    .line 1157
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    .line 1158
    const/4 v4, 0x1

    invoke-static {p1, p0, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v4

    .line 1159
    invoke-static {p1, p0, v1, v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v0

    .line 1160
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1161
    const-string v5, "scale"

    invoke-interface {v2, v5, v1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1162
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

    .line 1163
    invoke-static {v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    .line 1164
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1166
    :cond_2
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 1167
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1168
    invoke-static {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1169
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1170
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 1171
    return-void
.end method

.method private static fadeAlpha(Landroid/view/View;FJ)V
    .locals 1

    .line 474
    if-nez p0, :cond_0

    return-void

    .line 475
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getAlpha()F

    move-result v0

    cmpl-float v0, v0, p1

    if-nez v0, :cond_1

    .line 476
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 477
    return-void

    .line 479
    :cond_1
    invoke-virtual {p0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p1}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0, p2, p3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    .line 480
    return-void
.end method

.method private static findKeyboardArea(Landroid/view/View;)Landroid/view/View;
    .locals 4

    .line 1610
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 1611
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "keyboard_area"

    const-string v3, "id"

    invoke-virtual {v1, v2, v3, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    .line 1612
    if-nez v1, :cond_0

    .line 1613
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

    .line 1614
    const/4 p0, 0x0

    return-object p0

    .line 1616
    :cond_0
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    return-object p0
.end method

.method private static fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F
    .locals 0

    .line 1564
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    .line 1565
    if-nez p1, :cond_1

    .line 1566
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    if-eqz p4, :cond_0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->xFraction(Landroid/content/Context;)F

    move-result p0

    goto :goto_0

    :cond_0
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->yFraction(Landroid/content/Context;)F

    move-result p0

    :goto_0
    return p0

    .line 1568
    :cond_1
    invoke-virtual {p1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object p2

    .line 1571
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardOffsetInWindow(Landroid/view/View;)[I

    move-result-object p0

    .line 1572
    invoke-static {p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->windowOriginShift(Landroid/view/Window;Landroid/view/WindowManager$LayoutParams;)[I

    move-result-object p1

    .line 1573
    if-eqz p4, :cond_2

    .line 1574
    iget p2, p2, Landroid/view/WindowManager$LayoutParams;->x:I

    const/4 p4, 0x0

    aget p0, p0, p4

    add-int/2addr p2, p0

    aget p0, p1, p4

    add-int/2addr p2, p0

    int-to-float p0, p2

    aget p1, p3, p4

    div-float/2addr p0, p1

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    return p0

    .line 1576
    :cond_2
    iget p2, p2, Landroid/view/WindowManager$LayoutParams;->y:I

    const/4 p4, 0x1

    aget p0, p0, p4

    add-int/2addr p2, p0

    aget p0, p1, p4

    add-int/2addr p2, p0

    int-to-float p0, p2

    aget p1, p3, p4

    div-float/2addr p0, p1

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    return p0
.end method

.method private static freeRange(Landroid/view/View;Landroid/view/View;F)[F
    .locals 4

    .line 784
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 785
    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    .line 786
    iget v1, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 791
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->systemBarHeight(Landroid/view/View;)I

    move-result p0

    .line 792
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v2

    const/high16 v3, 0x41a00000    # 20.0f

    mul-float v2, v2, v3

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    add-int/2addr p0, v2

    .line 793
    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v0, p0

    .line 794
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result p0

    .line 795
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    .line 796
    if-lez v1, :cond_1

    if-lez v0, :cond_1

    if-lez p0, :cond_1

    if-gtz p1, :cond_0

    goto :goto_0

    .line 797
    :cond_0
    int-to-float v1, v1

    int-to-float p0, p0

    mul-float p0, p0, p2

    sub-float/2addr v1, p0

    .line 798
    const/high16 p0, 0x3f800000    # 1.0f

    invoke-static {p0, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    int-to-float v0, v0

    int-to-float p1, p1

    mul-float p1, p1, p2

    sub-float/2addr v0, p1

    .line 799
    invoke-static {p0, v0}, Ljava/lang/Math;->max(FF)F

    move-result p0

    const/4 p1, 0x2

    new-array p1, p1, [F

    const/4 p2, 0x0

    aput v1, p1, p2

    const/4 p2, 0x1

    aput p0, p1, p2

    .line 797
    return-object p1

    .line 796
    :cond_1
    :goto_0
    const/4 p0, 0x0

    return-object p0
.end method

.method private static handleEditDrag(FFZ)V
    .locals 8

    .line 1232
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1233
    if-nez v0, :cond_0

    return-void

    .line 1234
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1235
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1236
    :goto_0
    invoke-static {v1, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1237
    if-nez v3, :cond_2

    return-void

    .line 1239
    :cond_2
    sget-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    const/4 v5, 0x1

    const/4 v6, 0x0

    if-nez v4, :cond_3

    .line 1240
    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    .line 1241
    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    .line 1242
    invoke-static {v0, v1, v2, v3, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v4

    sput v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1243
    invoke-static {v0, v1, v2, v3, v6}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v4

    sput v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1244
    sput-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1245
    if-eqz p2, :cond_3

    .line 1246
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1247
    return-void

    .line 1251
    :cond_3
    sget v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr p0, v7

    aget v7, v3, v6

    div-float/2addr p0, v7

    add-float/2addr v4, p0

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p0

    .line 1252
    sget v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v7

    aget v5, v3, v5

    div-float/2addr p1, v5

    add-float/2addr v4, p1

    invoke-static {v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1253
    invoke-static {v2, v3, p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveWindow(F[FFFLandroid/view/View;)V

    .line 1254
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_4

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_4

    .line 1255
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1257
    :cond_4
    if-eqz p2, :cond_5

    .line 1258
    sput-boolean v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1259
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p2

    .line 1260
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "x_fraction_"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 1261
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

    .line 1262
    invoke-static {p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p2

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1263
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1265
    :cond_5
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1266
    return-void
.end method

.method private static handleEditScale(IFFZ)V
    .locals 17

    .line 1271
    move/from16 v0, p0

    move/from16 v1, p1

    move/from16 v2, p2

    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1272
    if-nez v3, :cond_0

    return-void

    .line 1273
    :cond_0
    invoke-virtual {v3}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    .line 1275
    sget-boolean v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    const/4 v6, 0x2

    const/4 v7, 0x0

    const/4 v8, 0x1

    const/high16 v9, 0x3f800000    # 1.0f

    const/4 v10, 0x0

    if-nez v5, :cond_8

    .line 1276
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    .line 1277
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v11

    .line 1278
    if-lez v5, :cond_7

    if-gtz v11, :cond_1

    goto/16 :goto_5

    .line 1279
    :cond_1
    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v12, v12, v10

    if-lez v12, :cond_2

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_2
    const/high16 v12, 0x3f800000    # 1.0f

    .line 1280
    :goto_0
    new-array v13, v6, [I

    .line 1281
    invoke-virtual {v3, v13}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1282
    aget v14, v13, v7

    int-to-float v14, v14

    .line 1283
    aget v13, v13, v8

    int-to-float v13, v13

    .line 1284
    int-to-float v5, v5

    mul-float v15, v5, v12

    add-float/2addr v15, v14

    .line 1285
    int-to-float v11, v11

    mul-float v16, v11, v12

    add-float v16, v13, v16

    .line 1286
    packed-switch v0, :pswitch_data_0

    .line 1306
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1307
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1308
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1309
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    goto :goto_1

    .line 1300
    :pswitch_0
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1301
    sput v13, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1302
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1303
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1304
    goto :goto_1

    .line 1294
    :pswitch_1
    sput v14, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1295
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1296
    sput v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1297
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1298
    goto :goto_1

    .line 1288
    :pswitch_2
    sput v15, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    .line 1289
    sput v16, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    .line 1290
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    .line 1291
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    .line 1292
    nop

    .line 1312
    :goto_1
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v11}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    .line 1313
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    cmpg-float v5, v5, v9

    if-gez v5, :cond_3

    return-void

    .line 1314
    :cond_3
    sput v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    .line 1316
    sget-object v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    if-nez v5, :cond_4

    const/4 v5, 0x0

    goto :goto_2

    :cond_4
    sget-object v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    invoke-virtual {v5}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v5

    .line 1317
    :goto_2
    if-nez v5, :cond_5

    const/4 v11, 0x0

    goto :goto_3

    :cond_5
    iget v11, v5, Landroid/view/WindowManager$LayoutParams;->x:I

    int-to-float v11, v11

    :goto_3
    sput v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    .line 1318
    if-nez v5, :cond_6

    const/4 v5, 0x0

    goto :goto_4

    :cond_6
    iget v5, v5, Landroid/view/WindowManager$LayoutParams;->y:I

    int-to-float v5, v5

    :goto_4
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    .line 1319
    sput-boolean v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1320
    if-eqz p3, :cond_8

    .line 1321
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1322
    return-void

    .line 1278
    :cond_7
    :goto_5
    return-void

    .line 1326
    :cond_8
    if-eqz p3, :cond_b

    .line 1327
    sput-boolean v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 1328
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v0, v0, v10

    if-lez v0, :cond_9

    sget v9, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1329
    :cond_9
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 1330
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "scale"

    invoke-interface {v0, v1, v9}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1331
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_a

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_a

    .line 1332
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1334
    :cond_a
    return-void

    .line 1337
    :cond_b
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    invoke-static {v1, v2, v5, v7}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->distance(FFFF)F

    move-result v1

    .line 1338
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    mul-float v2, v2, v1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartDistance:F

    div-float/2addr v2, v1

    .line 1339
    invoke-static {v9, v2}, Ljava/lang/Math;->min(FF)F

    move-result v1

    .line 1338
    const v2, 0x3ecccccd    # 0.4f

    invoke-static {v2, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1342
    invoke-virtual {v3}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    .line 1343
    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v5

    .line 1344
    if-eq v0, v8, :cond_d

    if-ne v0, v6, :cond_c

    goto :goto_6

    .line 1346
    :cond_c
    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    goto :goto_7

    .line 1345
    :cond_d
    :goto_6
    iget v7, v5, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v7, v7

    sget v8, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorX:F

    sub-float/2addr v7, v8

    .line 1347
    :goto_7
    if-eq v0, v6, :cond_f

    const/4 v6, 0x3

    if-ne v0, v6, :cond_e

    goto :goto_8

    .line 1349
    :cond_e
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    goto :goto_9

    .line 1348
    :cond_f
    :goto_8
    iget v0, v5, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-float v0, v0

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorY:F

    sub-float/2addr v0, v5

    .line 1350
    :goto_9
    cmpl-float v5, v7, v10

    if-lez v5, :cond_10

    cmpl-float v5, v0, v10

    if-lez v5, :cond_10

    .line 1351
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v7, v5

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v0, v5

    invoke-static {v7, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 1352
    invoke-static {v1, v0}, Ljava/lang/Math;->min(FF)F

    move-result v0

    .line 1353
    invoke-static {v2, v0}, Ljava/lang/Math;->max(FF)F

    move-result v1

    .line 1355
    :cond_10
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v0

    int-to-float v0, v0

    const/high16 v2, 0x40000000    # 2.0f

    div-float/2addr v0, v2

    .line 1356
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v2

    int-to-float v2, v2

    .line 1357
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartFactor:F

    sub-float/2addr v5, v1

    .line 1358
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleX(F)V

    .line 1359
    invoke-virtual {v3, v1}, Landroid/view/View;->setScaleY(F)V

    .line 1360
    sput v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1361
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    if-eqz v1, :cond_11

    .line 1365
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->narrowWindowToCard(Landroid/view/Window;Landroid/view/View;)V

    .line 1366
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    invoke-virtual {v1}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v1

    .line 1367
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTx:F

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffX:F

    sub-float/2addr v7, v0

    mul-float v7, v7, v5

    add-float/2addr v6, v7

    invoke-static {v6}, Ljava/lang/Math;->round(F)I

    move-result v0

    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 1368
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleStartTy:F

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaleAnchorOffY:F

    sub-float/2addr v6, v2

    mul-float v6, v6, v5

    add-float/2addr v0, v6

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 1369
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    invoke-virtual {v0, v1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 1371
    :cond_11
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v0, :cond_12

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_12

    .line 1372
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1374
    :cond_12
    invoke-virtual {v4}, Landroid/view/View;->requestLayout()V

    .line 1375
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

    .line 952
    const p1, 0x1020002

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 953
    instance-of v0, p1, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p1, Landroid/view/ViewGroup;

    return-object p1

    .line 954
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

    .line 193
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

    .line 188
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

    .line 202
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 203
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

    .line 997
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 998
    :cond_0
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handleHost(Landroid/view/View;Landroid/view/View;)Landroid/view/ViewGroup;

    move-result-object v0

    .line 999
    if-eqz v0, :cond_2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    if-eq v1, v0, :cond_1

    goto :goto_0

    .line 1000
    :cond_1
    const/high16 v1, 0x41a00000    # 20.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, v1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    invoke-static {v0, p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V

    .line 1001
    return-void

    .line 999
    :cond_2
    :goto_0
    return-void
.end method

.method private static moveWindow(F[FFFLandroid/view/View;)V
    .locals 9

    .line 877
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    .line 878
    if-eqz v0, :cond_8

    if-nez p1, :cond_0

    goto/16 :goto_3

    .line 879
    :cond_0
    invoke-virtual {p4}, Landroid/view/View;->getWidth()I

    move-result v1

    .line 880
    invoke-virtual {p4}, Landroid/view/View;->getHeight()I

    move-result v2

    .line 881
    if-lez v1, :cond_7

    if-gtz v2, :cond_1

    goto/16 :goto_2

    .line 885
    :cond_1
    invoke-static {p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardOffsetInWindow(Landroid/view/View;)[I

    move-result-object v3

    .line 890
    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object v4

    .line 891
    invoke-static {v0, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->windowOriginShift(Landroid/view/Window;Landroid/view/WindowManager$LayoutParams;)[I

    move-result-object v4

    .line 892
    const/4 v5, 0x0

    aget v6, p1, v5

    mul-float p2, p2, v6

    invoke-static {p2}, Ljava/lang/Math;->round(F)I

    move-result p2

    aget v6, v3, v5

    sub-int/2addr p2, v6

    aget v6, v4, v5

    sub-int/2addr p2, v6

    .line 893
    const/4 v6, 0x1

    aget p1, p1, v6

    mul-float p3, p3, p1

    invoke-static {p3}, Ljava/lang/Math;->round(F)I

    move-result p1

    aget p3, v3, v6

    sub-int/2addr p1, p3

    aget p3, v4, v6

    sub-int/2addr p1, p3

    .line 898
    invoke-virtual {p4}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p3

    invoke-virtual {p3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p3

    invoke-virtual {p3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p3

    .line 899
    invoke-static {p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->systemBarHeight(Landroid/view/View;)I

    move-result v7

    .line 900
    const/high16 v8, 0x41a00000    # 20.0f

    invoke-static {p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p4

    mul-float p4, p4, v8

    invoke-static {p4}, Ljava/lang/Math;->round(F)I

    move-result p4

    .line 901
    int-to-float v1, v1

    mul-float v1, v1, p0

    invoke-static {v1}, Ljava/lang/Math;->round(F)I

    move-result v1

    .line 902
    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 903
    iget v2, p3, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v2, v7

    aget v7, v4, v6

    sub-int/2addr v2, v7

    aget v7, v3, v6

    sub-int/2addr v2, v7

    sub-int/2addr v2, p0

    sub-int/2addr v2, p4

    .line 904
    aget p0, v3, v6

    neg-int p0, p0

    aget p4, v4, v6

    sub-int/2addr p0, p4

    .line 905
    if-le p1, v2, :cond_2

    move p1, v2

    .line 906
    :cond_2
    if-ge p1, p0, :cond_3

    goto :goto_0

    :cond_3
    move p0, p1

    .line 907
    :goto_0
    iget p1, p3, Landroid/util/DisplayMetrics;->widthPixels:I

    aget p3, v3, v5

    sub-int/2addr p1, p3

    sub-int/2addr p1, v1

    aget p3, v4, v5

    sub-int/2addr p1, p3

    .line 908
    aget p3, v3, v5

    neg-int p3, p3

    aget p4, v4, v5

    sub-int/2addr p3, p4

    .line 909
    if-le p2, p1, :cond_4

    move p2, p1

    .line 910
    :cond_4
    if-ge p2, p3, :cond_5

    goto :goto_1

    :cond_5
    move p3, p2

    .line 911
    :goto_1
    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object p1

    .line 912
    iget p2, p1, Landroid/view/WindowManager$LayoutParams;->x:I

    if-ne p2, p3, :cond_6

    iget p2, p1, Landroid/view/WindowManager$LayoutParams;->y:I

    if-ne p2, p0, :cond_6

    return-void

    .line 913
    :cond_6
    iput p3, p1, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 914
    iput p0, p1, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 915
    invoke-virtual {v0, p1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 916
    return-void

    .line 881
    :cond_7
    :goto_2
    return-void

    .line 878
    :cond_8
    :goto_3
    return-void
.end method

.method private static narrowWindowToCard(Landroid/view/Window;Landroid/view/View;)V
    .locals 13

    .line 669
    if-nez p0, :cond_0

    return-void

    .line 670
    :cond_0
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    .line 671
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/View;->getElevation()F

    move-result v0

    const/4 v1, 0x0

    cmpl-float v0, v0, v1

    if-eqz v0, :cond_1

    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0, v1}, Landroid/view/View;->setElevation(F)V

    .line 676
    :cond_1
    new-instance v0, Landroid/graphics/drawable/ColorDrawable;

    const/4 v2, 0x0

    invoke-direct {v0, v2}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    .line 678
    invoke-virtual {p0, v0}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 682
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v3

    .line 683
    invoke-virtual {v3, v0}, Landroid/view/View;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 684
    const v4, 0x1020002

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v5

    .line 685
    if-eqz v5, :cond_2

    invoke-virtual {v5, v0}, Landroid/view/View;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 686
    :cond_2
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 687
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result v5

    .line 688
    if-lez v0, :cond_e

    if-gtz v5, :cond_3

    goto/16 :goto_3

    .line 689
    :cond_3
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    if-gez v6, :cond_4

    sput v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    .line 690
    :cond_4
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    if-gez v6, :cond_5

    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    .line 691
    :cond_5
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v6

    .line 694
    instance-of v7, v6, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v8, 0x1

    const v9, 0x800033

    if-eqz v7, :cond_7

    move-object v10, v6

    check-cast v10, Landroid/widget/FrameLayout$LayoutParams;

    iget v10, v10, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    if-eq v10, v9, :cond_6

    goto :goto_0

    :cond_6
    const/4 v10, 0x0

    goto :goto_1

    :cond_7
    :goto_0
    const/4 v10, 0x1

    .line 697
    :goto_1
    if-eqz v6, :cond_a

    iget v11, v6, Landroid/view/ViewGroup$LayoutParams;->width:I

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    if-ne v11, v12, :cond_8

    iget v11, v6, Landroid/view/ViewGroup$LayoutParams;->height:I

    sget v12, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    if-ne v11, v12, :cond_8

    if-eqz v10, :cond_a

    .line 699
    :cond_8
    sget v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    iput v10, v6, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 700
    sget v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    iput v10, v6, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 701
    if-eqz v7, :cond_9

    .line 702
    move-object v7, v6

    check-cast v7, Landroid/widget/FrameLayout$LayoutParams;

    iput v9, v7, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 704
    :cond_9
    invoke-virtual {p1, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 706
    :cond_a
    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    cmpl-float v1, v6, v1

    if-lez v1, :cond_b

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_2

    :cond_b
    const/high16 v1, 0x3f800000    # 1.0f

    .line 707
    :goto_2
    const/high16 v6, 0x41200000    # 10.0f

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v7

    mul-float v7, v7, v6

    invoke-static {v7}, Ljava/lang/Math;->round(F)I

    move-result v6

    mul-int/lit8 v6, v6, 0x2

    .line 708
    const/high16 v7, 0x41a00000    # 20.0f

    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result v10

    mul-float v10, v10, v7

    invoke-static {v10}, Ljava/lang/Math;->round(F)I

    move-result v7

    .line 709
    sget v10, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    int-to-float v10, v10

    mul-float v10, v10, v1

    invoke-static {v10}, Ljava/lang/Math;->round(F)I

    move-result v10

    add-int/2addr v10, v6

    .line 712
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardOffsetInWindow(Landroid/view/View;)[I

    move-result-object v11

    aget v8, v11, v8

    sget v11, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    int-to-float v11, v11

    mul-float v11, v11, v1

    .line 713
    invoke-static {v11}, Ljava/lang/Math;->round(F)I

    move-result v11

    add-int/2addr v8, v11

    add-int/2addr v8, v7

    add-int/2addr v8, v6

    .line 714
    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    .line 715
    if-eqz v3, :cond_c

    invoke-static {v3, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dumpTree(Landroid/view/View;I)V

    .line 716
    :cond_c
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "win "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v8}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v4, " factor="

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, " areaScale="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 717
    invoke-virtual {p1}, Landroid/view/View;->getScaleX()F

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ","

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/View;->getScaleY()F

    move-result v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, " pivot="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 718
    invoke-virtual {p1}, Landroid/view/View;->getPivotX()F

    move-result v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/View;->getPivotY()F

    move-result v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v4, " areaPos="

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 719
    invoke-virtual {p1}, Landroid/view/View;->getLeft()I

    move-result v4

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " areaSize="

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " base="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaWidth:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaHeight:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 716
    const-string v0, "FloatingKeyboard"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 722
    invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    move-result-object p1

    .line 723
    iget v0, p1, Landroid/view/WindowManager$LayoutParams;->width:I

    if-ne v0, v10, :cond_d

    iget v0, p1, Landroid/view/WindowManager$LayoutParams;->height:I

    if-ne v0, v8, :cond_d

    iget v0, p1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    if-ne v0, v9, :cond_d

    .line 725
    return-void

    .line 727
    :cond_d
    iput v10, p1, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 728
    iput v8, p1, Landroid/view/WindowManager$LayoutParams;->height:I

    .line 729
    iput v9, p1, Landroid/view/WindowManager$LayoutParams;->gravity:I

    .line 730
    invoke-virtual {p0, p1}, Landroid/view/Window;->setAttributes(Landroid/view/WindowManager$LayoutParams;)V

    .line 731
    return-void

    .line 688
    :cond_e
    :goto_3
    return-void
.end method

.method public static onHandleTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1453
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 1454
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    .line 1455
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "handleTouch act="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " raw="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, ","

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 1456
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 1455
    const-string v3, "FloatingKeyboard"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1457
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    packed-switch v2, :pswitch_data_0

    .line 1528
    return v1

    .line 1479
    :pswitch_0
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz v2, :cond_2

    .line 1480
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v2

    .line 1481
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v2

    .line 1482
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result p0

    .line 1483
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p0, p0

    mul-float p0, p0, p0

    cmpl-float p0, v0, p0

    if-lez p0, :cond_1

    .line 1484
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1485
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1487
    :cond_1
    return v4

    .line 1489
    :cond_2
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez v2, :cond_4

    .line 1490
    sget-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->pendingDrag:Z

    if-eqz v0, :cond_3

    .line 1491
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    sub-float/2addr v0, v1

    .line 1492
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    sub-float/2addr p1, v1

    .line 1493
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop(Landroid/view/View;)I

    move-result v1

    .line 1494
    mul-float v0, v0, v0

    mul-float p1, p1, p1

    add-float/2addr v0, p1

    int-to-float p1, v1

    mul-float p1, p1, p1

    cmpl-float p1, v0, p1

    if-lez p1, :cond_3

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1496
    :cond_3
    return v4

    .line 1498
    :cond_4
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1499
    if-nez v2, :cond_5

    return v1

    .line 1500
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

    .line 1501
    :goto_0
    invoke-static {v0, v2, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1502
    if-nez v3, :cond_7

    return v1

    .line 1503
    :cond_7
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartX:F

    .line 1504
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v6

    sget v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawX:F

    sub-float/2addr v6, v7

    aget v1, v3, v1

    div-float/2addr v6, v1

    add-float/2addr v5, v6

    .line 1503
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result v1

    .line 1505
    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    .line 1506
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sget v6, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragDownRawY:F

    sub-float/2addr p1, v6

    aget v6, v3, v4

    div-float/2addr p1, v6

    add-float/2addr v5, p1

    .line 1505
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clamp01(F)F

    move-result p1

    .line 1507
    invoke-static {p0, v3, v1, p1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveWindow(F[FFFLandroid/view/View;)V

    .line 1508
    invoke-static {v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->moveHandle(Landroid/view/View;Landroid/view/View;)V

    .line 1509
    return v4

    .line 1513
    :pswitch_1
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v2

    sput-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    .line 1514
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    if-eqz p1, :cond_8

    .line 1515
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1516
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {p0, p1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1517
    return v4

    .line 1519
    :cond_8
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1520
    sget-boolean p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    if-nez p1, :cond_9

    return v4

    .line 1521
    :cond_9
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 1522
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->settle(Landroid/view/View;Landroid/view/View;)V

    .line 1523
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 1524
    if-eqz p0, :cond_a

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scheduleIdleFade(Landroid/view/View;)V

    .line 1525
    :cond_a
    return v4

    .line 1459
    :pswitch_2
    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v2

    .line 1460
    if-nez v2, :cond_b

    return v1

    .line 1461
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

    .line 1462
    :goto_1
    invoke-static {v0, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v3

    .line 1463
    if-nez v3, :cond_d

    return v1

    .line 1464
    :cond_d
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v3

    sput v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawX:F

    .line 1465
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    sput p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->downRawY:F

    .line 1466
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 1467
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v5

    .line 1468
    sget-wide v7, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastHandleUp:J

    sub-long/2addr v5, v7

    const-wide/16 v7, 0x140

    cmp-long p1, v5, v7

    if-gtz p1, :cond_e

    .line 1470
    sput-boolean v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1471
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    const-wide/16 v0, 0x12c

    invoke-virtual {p0, p1, v0, v1}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    goto :goto_2

    .line 1473
    :cond_e
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 1474
    invoke-static {p0, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armLongPress(Landroid/view/View;Landroid/view/View;Landroid/view/View;)V

    .line 1476
    :goto_2
    return v4

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

    .line 1591
    nop

    .line 1590
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->orientation:I

    const/4 v0, 0x2

    if-ne p0, v0, :cond_0

    .line 1592
    const-string p0, "landscape"

    goto :goto_0

    .line 1593
    :cond_0
    const-string p0, "portrait"

    .line 1590
    :goto_0
    return-object p0
.end method

.method private static preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    .locals 2

    .line 218
    const-string v0, "floating_keyboard_preferences"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0
.end method

.method private static removeCardShadow()V
    .locals 3

    .line 623
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v0, :cond_0

    return-void

    .line 624
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 625
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 626
    :cond_1
    move-object v0, v1

    .line 627
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 628
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    .line 629
    return-void
.end method

.method private static removeEditOverlay()V
    .locals 3

    .line 1222
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 1223
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1224
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 1225
    :cond_1
    move-object v0, v1

    .line 1226
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1227
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    .line 1228
    return-void
.end method

.method private static removeHandle()V
    .locals 3

    .line 1004
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 1006
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cancelLongPress(Landroid/view/View;)V

    .line 1007
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1008
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    goto :goto_0

    .line 1009
    :cond_1
    move-object v0, v1

    .line 1010
    :goto_0
    if-eqz v0, :cond_2

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 1011
    :cond_2
    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    .line 1012
    return-void
.end method

.method private static removeIdleProbe()V
    .locals 2

    .line 517
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->wakeIdle()V

    .line 518
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    .line 519
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 520
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setAlpha(F)V

    .line 522
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-eqz v0, :cond_1

    .line 523
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewPropertyAnimator;->cancel()V

    .line 524
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setAlpha(F)V

    .line 526
    :cond_1
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    if-eqz v0, :cond_2

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    instance-of v0, v0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_2

    .line 527
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 529
    :cond_2
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleProbe:Landroid/view/View;

    .line 530
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 531
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/inputmethodservice/InputMethodService;Z)V
    .locals 0

    .line 354
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 355
    if-nez p0, :cond_0

    return-void

    .line 356
    :cond_0
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 357
    if-nez p0, :cond_1

    return-void

    .line 358
    :cond_1
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->requestAccessPointVisibility(Landroid/view/View;Z)V

    .line 359
    return-void
.end method

.method private static requestAccessPointVisibility(Landroid/view/View;Z)V
    .locals 7

    .line 364
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    .line 365
    sget-wide v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    sub-long v2, v0, v2

    const-wide/16 v4, 0x32

    cmp-long v6, v2, v4

    if-gez v6, :cond_0

    return-void

    .line 366
    :cond_0
    sput-wide v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->lastAccessPointPost:J

    .line 367
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;

    invoke-direct {v0, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$4;-><init>(Landroid/view/View;Z)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 377
    return-void
.end method

.method private static resetFromEdit()V
    .locals 7

    .line 1174
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 1175
    if-nez v0, :cond_0

    return-void

    .line 1176
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v1

    .line 1177
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 1178
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    .line 1179
    const-string v4, "scale"

    const v5, 0x3f3851ec    # 0.72f

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v4, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    .line 1180
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

    .line 1181
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    .line 1182
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1183
    sput v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 1184
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleX(F)V

    .line 1185
    invoke-virtual {v0, v5}, Landroid/view/View;->setScaleY(F)V

    .line 1186
    invoke-static {v1, v0, v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1187
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-eqz v2, :cond_1

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v2, v2, Landroid/view/ViewGroup;

    if-eqz v2, :cond_1

    .line 1188
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V

    .line 1190
    :cond_1
    invoke-virtual {v1}, Landroid/view/View;->requestLayout()V

    .line 1191
    return-void
.end method

.method private static resetScale(Landroid/inputmethodservice/InputMethodService;)V
    .locals 3

    .line 310
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragging:Z

    .line 311
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaling:Z

    .line 312
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editing:Z

    .line 313
    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->armingEdit:Z

    .line 314
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->enterEditRunnable:Ljava/lang/Runnable;

    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 315
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeHandle()V

    .line 316
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeEditOverlay()V

    .line 317
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeIdleProbe()V

    .line 318
    sget v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/high16 v2, 0x3f800000    # 1.0f

    cmpl-float v1, v1, v2

    if-nez v1, :cond_0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    if-nez v1, :cond_0

    return-void

    .line 319
    :cond_0
    sput v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 320
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->scaledView:Landroid/view/View;

    .line 321
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 322
    if-nez p0, :cond_1

    return-void

    .line 323
    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 324
    if-nez p0, :cond_2

    return-void

    .line 325
    :cond_2
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object p0

    .line 326
    if-nez p0, :cond_3

    return-void

    .line 327
    :cond_3
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleX(F)V

    .line 328
    invoke-virtual {p0, v2}, Landroid/view/View;->setScaleY(F)V

    .line 329
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 330
    invoke-virtual {p0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 331
    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyGutter(Landroid/view/View;Z)V

    .line 332
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->restoreAreaBackground(Landroid/view/View;)V

    .line 333
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->removeCardShadow()V

    .line 334
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->clearAreaBackground(Landroid/view/View;)V

    .line 335
    return-void
.end method

.method private static restoreAreaBackground(Landroid/view/View;)V
    .locals 1

    .line 563
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaBackground:Landroid/graphics/drawable/Drawable;

    if-nez v0, :cond_0

    return-void

    .line 564
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaBackground:Landroid/graphics/drawable/Drawable;

    invoke-virtual {p0, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 565
    const/4 p0, 0x0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->baseAreaBackground:Landroid/graphics/drawable/Drawable;

    .line 566
    return-void
.end method

.method public static scale(Landroid/content/Context;)F
    .locals 2

    .line 207
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    const-string v0, "scale"

    const v1, 0x3f3851ec    # 0.72f

    invoke-interface {p0, v0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 208
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

    .line 298
    if-nez p1, :cond_0

    return-void

    .line 299
    :cond_0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;

    invoke-direct {v0, p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat$3;-><init>(Landroid/view/View;Landroid/view/View;F)V

    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 306
    return-void
.end method

.method private static scheduleIdleFade(Landroid/view/View;)V
    .locals 3

    .line 442
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleArea:Landroid/view/View;

    .line 443
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleFadeEnabled(Landroid/content/Context;)Z

    move-result p0

    if-nez p0, :cond_1

    .line 446
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_0

    .line 447
    const/4 p0, 0x0

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 448
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {p0, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 449
    const/high16 p0, 0x3f800000    # 1.0f

    const-wide/16 v0, 0x78

    invoke-static {p0, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 451
    :cond_0
    return-void

    .line 453
    :cond_1
    sget-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    if-eqz p0, :cond_2

    return-void

    .line 454
    :cond_2
    const/4 p0, 0x1

    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 455
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    const-wide/16 v1, 0x1388

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 456
    return-void
.end method

.method private static serviceWindow(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 1605
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 1606
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

    .line 422
    invoke-virtual {p0}, Landroid/view/View;->getContentDescription()Ljava/lang/CharSequence;

    move-result-object v0

    .line 423
    const/4 v1, 0x0

    if-eqz v0, :cond_2

    .line 424
    invoke-interface {v0}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v0

    .line 425
    array-length v2, p1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 426
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_1

    .line 427
    if-eqz p2, :cond_0

    const/16 v0, 0x8

    goto :goto_1

    :cond_0
    const/4 v0, 0x0

    .line 428
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v2

    if-eq v2, v0, :cond_2

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    goto :goto_2

    .line 425
    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 433
    :cond_2
    :goto_2
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 434
    check-cast p0, Landroid/view/ViewGroup;

    .line 435
    nop

    :goto_3
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v0

    if-ge v1, v0, :cond_3

    .line 436
    invoke-virtual {p0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    invoke-static {v0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 435
    add-int/lit8 v1, v1, 0x1

    goto :goto_3

    .line 439
    :cond_3
    return-void
.end method

.method public static setEnabled(Landroid/content/Context;Z)V
    .locals 1

    .line 197
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "enabled"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 198
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 199
    return-void
.end method

.method private static setOneHandedAccessPointHidden(Landroid/view/View;Z)V
    .locals 12

    .line 405
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 406
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v1, v1

    new-array v2, v1, [Ljava/lang/String;

    .line 407
    nop

    .line 408
    sget-object v3, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ONE_HANDED_LABELS:[Ljava/lang/String;

    array-length v4, v3

    const/4 v5, 0x0

    const/4 v6, 0x0

    const/4 v7, 0x0

    :goto_0
    if-ge v6, v4, :cond_1

    aget-object v8, v3, v6

    .line 409
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v9

    const-string v10, "string"

    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v9, v8, v10, v11}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v8

    .line 410
    if-eqz v8, :cond_0

    add-int/lit8 v9, v7, 0x1

    invoke-virtual {v0, v8}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object v8

    aput-object v8, v2, v7

    move v7, v9

    .line 408
    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_0

    .line 412
    :cond_1
    if-nez v7, :cond_2

    return-void

    .line 413
    :cond_2
    if-ge v7, v1, :cond_3

    .line 414
    new-array v0, v7, [Ljava/lang/String;

    .line 415
    invoke-static {v2, v5, v0, v5, v7}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    .line 416
    move-object v2, v0

    .line 418
    :cond_3
    invoke-static {p0, v2, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->setAccessPointVisibility(Landroid/view/View;[Ljava/lang/String;Z)V

    .line 419
    return-void
.end method

.method public static setScale(Landroid/content/Context;F)V
    .locals 1

    .line 212
    const/high16 v0, 0x3f800000    # 1.0f

    invoke-static {v0, p1}, Ljava/lang/Math;->min(FF)F

    move-result p1

    const v0, 0x3ecccccd    # 0.4f

    invoke-static {v0, p1}, Ljava/lang/Math;->max(FF)F

    move-result p1

    .line 213
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string v0, "scale"

    invoke-interface {p0, v0, p1}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 214
    const/high16 p0, -0x40800000    # -1.0f

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    .line 215
    return-void
.end method

.method private static settle(Landroid/view/View;Landroid/view/View;)V
    .locals 7

    .line 1534
    invoke-static {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->findKeyboardArea(Landroid/view/View;)Landroid/view/View;

    move-result-object v0

    .line 1535
    if-nez v0, :cond_0

    return-void

    .line 1536
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

    .line 1537
    :goto_0
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->freeRange(Landroid/view/View;Landroid/view/View;F)[F

    move-result-object v2

    .line 1538
    if-nez v2, :cond_2

    return-void

    .line 1539
    :cond_2
    const/4 v3, 0x1

    invoke-static {v0, p1, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v3

    .line 1540
    const/4 v4, 0x0

    invoke-static {v0, p1, v1, v2, v4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fractionFromWindow(Landroid/view/View;Landroid/view/View;F[FZ)F

    move-result v2

    .line 1546
    const v4, 0x3f6b851f    # 0.92f

    cmpl-float v5, v2, v4

    if-lez v5, :cond_3

    sget v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->dragStartY:F

    cmpg-float v4, v5, v4

    if-gez v4, :cond_3

    .line 1547
    nop

    .line 1548
    const/high16 v2, 0x3f800000    # 1.0f

    const/high16 v3, 0x3f000000    # 0.5f

    .line 1550
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    .line 1551
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v4

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "x_fraction_"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 1552
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

    .line 1553
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-interface {v3, p0, v2}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    .line 1554
    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1555
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyPosition(Landroid/view/View;Landroid/view/View;F)Z

    .line 1556
    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->ensureHandle(Landroid/view/View;Landroid/view/View;F)V

    .line 1559
    invoke-virtual {p1}, Landroid/view/View;->requestLayout()V

    .line 1560
    return-void
.end method

.method private static systemBarHeight(Landroid/view/View;)I
    .locals 4

    .line 810
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    return v1

    .line 811
    :cond_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->floatingWindow:Landroid/view/Window;

    invoke-virtual {v0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v0

    .line 812
    if-nez v0, :cond_1

    return v1

    .line 816
    :cond_1
    invoke-interface {v0}, Landroid/view/WindowManager;->getCurrentWindowMetrics()Landroid/view/WindowMetrics;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/WindowMetrics;->getWindowInsets()Landroid/view/WindowInsets;

    move-result-object v2

    .line 817
    invoke-static {}, Landroid/view/WindowInsets$Type;->navigationBars()I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/view/WindowInsets;->getInsets(I)Landroid/graphics/Insets;

    move-result-object v2

    iget v2, v2, Landroid/graphics/Insets;->bottom:I

    .line 818
    if-lez v2, :cond_2

    return v2

    .line 819
    :cond_2
    invoke-interface {v0}, Landroid/view/WindowManager;->getMaximumWindowMetrics()Landroid/view/WindowMetrics;

    move-result-object v2

    invoke-virtual {v2}, Landroid/view/WindowMetrics;->getBounds()Landroid/graphics/Rect;

    move-result-object v2

    invoke-virtual {v2}, Landroid/graphics/Rect;->height()I

    move-result v2

    .line 820
    invoke-interface {v0}, Landroid/view/WindowManager;->getCurrentWindowMetrics()Landroid/view/WindowMetrics;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/WindowMetrics;->getBounds()Landroid/graphics/Rect;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/Rect;->height()I

    move-result v0

    .line 821
    sub-int v0, v2, v0

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 822
    if-lez v0, :cond_3

    return v0

    .line 825
    :cond_3
    new-instance v0, Landroid/graphics/Rect;

    invoke-direct {v0}, Landroid/graphics/Rect;-><init>()V

    .line 826
    invoke-virtual {p0, v0}, Landroid/view/View;->getWindowVisibleDisplayFrame(Landroid/graphics/Rect;)V

    .line 827
    iget p0, v0, Landroid/graphics/Rect;->bottom:I

    sub-int/2addr v2, p0

    invoke-static {v1, v2}, Ljava/lang/Math;->max(II)I

    move-result p0

    return p0
.end method

.method private static touchSlop(Landroid/view/View;)I
    .locals 1

    .line 1408
    sget v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    if-gez v0, :cond_0

    .line 1409
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0}, Landroid/view/ViewConfiguration;->get(Landroid/content/Context;)Landroid/view/ViewConfiguration;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/ViewConfiguration;->getScaledTouchSlop()I

    move-result p0

    sput p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    .line 1411
    :cond_0
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->touchSlop:I

    return p0
.end method

.method private static unwatchAccessPoints()V
    .locals 2

    .line 387
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 388
    if-nez v0, :cond_0

    return-void

    .line 389
    :cond_0
    const/4 v1, 0x0

    sput-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 390
    invoke-virtual {v0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {v0, v1}, Landroid/view/ViewTreeObserver;->removeOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 391
    return-void
.end method

.method private static updateCardShadowBounds(Landroid/view/ViewGroup;Landroid/view/View;F)V
    .locals 5

    .line 589
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    if-nez v0, :cond_0

    return-void

    .line 590
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 591
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 592
    new-array v2, v0, [I

    .line 593
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 594
    const/4 v3, 0x0

    cmpl-float v3, p2, v3

    if-lez v3, :cond_1

    goto :goto_0

    :cond_1
    const/high16 p2, 0x3f800000    # 1.0f

    .line 595
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, p2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 596
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p2

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p1

    .line 597
    if-lez v3, :cond_5

    if-gtz p1, :cond_2

    goto :goto_2

    .line 598
    :cond_2
    const/4 p2, 0x0

    aget v4, v1, p2

    aget p2, v2, p2

    sub-int/2addr v4, p2

    .line 599
    const/4 p2, 0x1

    aget v1, v1, p2

    aget p2, v2, p2

    sub-int/2addr v1, p2

    .line 602
    const/high16 p2, 0x41200000    # 10.0f

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->density(Landroid/view/View;)F

    move-result p0

    mul-float p0, p0, p2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 603
    sub-int/2addr v4, p0

    .line 604
    sub-int/2addr v1, p0

    .line 605
    mul-int/lit8 p0, p0, 0x2

    add-int/2addr v3, p0

    .line 606
    add-int/2addr p1, p0

    .line 608
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    instance-of p0, p0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p0, :cond_3

    .line 609
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    check-cast p0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 610
    :cond_3
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v3, p1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 611
    :goto_1
    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p2, v3, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p2, p1, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p2, v4, :cond_4

    iget p2, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p2, v1, :cond_4

    .line 613
    return-void

    .line 615
    :cond_4
    iput v3, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 616
    iput p1, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 617
    iput v4, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 618
    iput v1, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 619
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->cardShadow:Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;

    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingCardShadow;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 620
    return-void

    .line 597
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateEditBounds(Landroid/view/ViewGroup;Landroid/view/View;)V
    .locals 4

    .line 1194
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    if-nez v0, :cond_0

    return-void

    .line 1195
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 1196
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1197
    new-array v0, v0, [I

    .line 1198
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 1199
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 1200
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 1201
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1202
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 1203
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget p1, v0, p1

    sub-int/2addr v3, p1

    .line 1204
    const/4 p1, 0x1

    aget v1, v1, p1

    aget p1, v0, p1

    sub-int/2addr v1, p1

    .line 1206
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p1, p1, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p1, :cond_3

    .line 1207
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    check-cast p1, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 1208
    :cond_3
    new-instance p1, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p1, v2, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 1209
    :goto_1
    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne v0, v2, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne v0, p0, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne v0, v3, :cond_4

    iget v0, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne v0, v1, :cond_4

    .line 1211
    return-void

    .line 1213
    :cond_4
    iput v2, p1, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 1214
    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 1215
    const/16 p0, 0x33

    iput p0, p1, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 1216
    iput v3, p1, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 1217
    iput v1, p1, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 1218
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->editOverlay:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEdit;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 1219
    return-void

    .line 1202
    :cond_5
    :goto_2
    return-void
.end method

.method private static updateHandleBounds(Landroid/view/ViewGroup;Landroid/view/View;I)V
    .locals 5

    .line 958
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    if-nez v0, :cond_0

    return-void

    .line 962
    :cond_0
    const/4 v0, 0x2

    new-array v1, v0, [I

    .line 963
    invoke-virtual {p1, v1}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 964
    new-array v0, v0, [I

    .line 965
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getLocationOnScreen([I)V

    .line 966
    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v2, 0x0

    cmpl-float p0, p0, v2

    if-lez p0, :cond_1

    sget p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 p0, 0x3f800000    # 1.0f

    .line 967
    :goto_0
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v2

    int-to-float v2, v2

    mul-float v2, v2, p0

    invoke-static {v2}, Ljava/lang/Math;->round(F)I

    move-result v2

    .line 968
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    move-result p1

    int-to-float p1, p1

    mul-float p1, p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 969
    if-lez v2, :cond_5

    if-gtz p0, :cond_2

    goto :goto_2

    .line 975
    :cond_2
    const/4 p1, 0x0

    aget v3, v1, p1

    aget p1, v0, p1

    sub-int/2addr v3, p1

    .line 976
    const/4 p1, 0x1

    aget v1, v1, p1

    aget p1, v0, p1

    sub-int/2addr v1, p1

    add-int/2addr v1, p0

    .line 978
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    instance-of p0, p0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz p0, :cond_3

    .line 979
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p0

    check-cast p0, Landroid/widget/FrameLayout$LayoutParams;

    goto :goto_1

    .line 980
    :cond_3
    new-instance p0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p0, v2, p2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 981
    :goto_1
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    int-to-float v0, p2

    const/high16 v4, 0x40000000    # 2.0f

    div-float/2addr v0, v4

    invoke-virtual {p1, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setBarCenterFromBottom(F)V

    .line 982
    iget p1, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    if-ne p1, v2, :cond_4

    iget p1, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    if-ne p1, p2, :cond_4

    iget p1, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    if-ne p1, v3, :cond_4

    iget p1, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    if-ne p1, v1, :cond_4

    .line 984
    return-void

    .line 986
    :cond_4
    iput v2, p0, Landroid/widget/FrameLayout$LayoutParams;->width:I

    .line 987
    iput p2, p0, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 988
    const/16 p1, 0x33

    iput p1, p0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 991
    iput v3, p0, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    .line 992
    iput v1, p0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 993
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->handle:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;

    invoke-virtual {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardHandle;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 994
    return-void

    .line 969
    :cond_5
    :goto_2
    return-void
.end method

.method private static visualRegion(Landroid/view/View;Landroid/graphics/Rect;)Z
    .locals 6

    .line 1395
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    const/4 v1, 0x0

    if-lez v0, :cond_2

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-gtz v0, :cond_0

    goto :goto_1

    .line 1396
    :cond_0
    const/4 v0, 0x2

    new-array v0, v0, [I

    .line 1397
    invoke-virtual {p0, v0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 1398
    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    const/4 v3, 0x0

    cmpl-float v2, v2, v3

    if-lez v2, :cond_1

    sget v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->appliedScale:F

    goto :goto_0

    :cond_1
    const/high16 v2, 0x3f800000    # 1.0f

    .line 1399
    :goto_0
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v3

    int-to-float v3, v3

    mul-float v3, v3, v2

    invoke-static {v3}, Ljava/lang/Math;->round(F)I

    move-result v3

    .line 1400
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    mul-float p0, p0, v2

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result p0

    .line 1401
    aget v2, v0, v1

    const/4 v4, 0x1

    aget v5, v0, v4

    aget v1, v0, v1

    add-int/2addr v1, v3

    aget v0, v0, v4

    add-int/2addr v0, p0

    invoke-virtual {p1, v2, v5, v1, v0}, Landroid/graphics/Rect;->set(IIII)V

    .line 1403
    invoke-virtual {p1}, Landroid/graphics/Rect;->isEmpty()Z

    move-result p0

    xor-int/2addr p0, v4

    return p0

    .line 1395
    :cond_2
    :goto_1
    return v1
.end method

.method private static wakeIdle()V
    .locals 3

    .line 459
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleScheduled:Z

    .line 460
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->idleHandler:Landroid/os/Handler;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->fadeOut:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 461
    const/high16 v0, 0x3f800000    # 1.0f

    const-wide/16 v1, 0x78

    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->animateIdleAlpha(FJ)V

    .line 462
    return-void
.end method

.method private static watchAccessPoints(Landroid/view/View;)V
    .locals 1

    .line 380
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    if-ne v0, p0, :cond_0

    return-void

    .line 381
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->unwatchAccessPoints()V

    .line 382
    sput-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->watchedDecor:Landroid/view/View;

    .line 383
    invoke-virtual {p0}, Landroid/view/View;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object p0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->layoutListener:Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;

    invoke-virtual {p0, v0}, Landroid/view/ViewTreeObserver;->addOnGlobalLayoutListener(Landroid/view/ViewTreeObserver$OnGlobalLayoutListener;)V

    .line 384
    return-void
.end method

.method private static windowOriginShift(Landroid/view/Window;Landroid/view/WindowManager$LayoutParams;)[I
    .locals 1

    .line 860
    nop

    .line 861
    const/4 p1, 0x0

    if-eqz p0, :cond_0

    invoke-virtual {p0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 862
    invoke-virtual {p0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;

    move-result-object p0

    invoke-interface {p0}, Landroid/view/WindowManager;->getCurrentWindowMetrics()Landroid/view/WindowMetrics;

    move-result-object p0

    invoke-virtual {p0}, Landroid/view/WindowMetrics;->getWindowInsets()Landroid/view/WindowInsets;

    move-result-object p0

    .line 863
    invoke-static {}, Landroid/view/WindowInsets$Type;->statusBars()I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/view/WindowInsets;->getInsets(I)Landroid/graphics/Insets;

    move-result-object p0

    iget p0, p0, Landroid/graphics/Insets;->top:I

    goto :goto_0

    .line 865
    :cond_0
    const/4 p0, 0x0

    :goto_0
    filled-new-array {p1, p0}, [I

    move-result-object p0

    return-object p0
.end method

.method private static xFraction(Landroid/content/Context;)F
    .locals 3

    .line 1580
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "x_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1581
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f000000    # 0.5f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1580
    return p0
.end method

.method private static yFraction(Landroid/content/Context;)F
    .locals 3

    .line 1585
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->preferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "y_fraction_"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 1586
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->orientation(Landroid/content/Context;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const/high16 v1, 0x3f800000    # 1.0f

    invoke-interface {v0, p0, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result p0

    .line 1585
    return p0
.end method
