.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;
.super Landroid/widget/FrameLayout;
.source "FloatingKeyboardEditView.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;
    }
.end annotation


# static fields
.field private static final ID_EXIT:I = 0x7f0f001b

.field private static final ID_FRAME:I = 0x7f0f015c

.field private static final ID_MOVE:I = 0x7f0f01a4

.field private static final ID_RESET:I = 0x7f0f01c5

.field private static final LAYOUT:I = 0x7f04007b

.field private static final SCALE_IDS:[I


# instance fields
.field private activeCorner:I

.field private dragging:Z

.field private final frame:Landroid/view/View;

.field private listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 35
    const v0, 0x7f0f001f

    const v1, 0x7f0f001d

    const v2, 0x7f0f001e

    const v3, 0x7f0f0020

    filled-new-array {v2, v3, v0, v1}, [I

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->SCALE_IDS:[I

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 2

    .line 52
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 48
    const/4 v0, -0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 53
    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f04007b

    const/4 v1, 0x1

    invoke-virtual {p1, v0, p0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    .line 54
    const p1, 0x7f0f015c

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    .line 56
    const p1, 0x7f0f01c5

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 57
    if-eqz p1, :cond_0

    .line 58
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$1;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$1;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 65
    :cond_0
    const p1, 0x7f0f001b

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 66
    if-eqz p1, :cond_1

    .line 67
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 76
    :cond_1
    new-instance p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;

    invoke-direct {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    .line 82
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {v0, p1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 83
    :cond_2
    const v0, 0x7f0f01a4

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 84
    if-eqz v0, :cond_3

    invoke-virtual {v0, p1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 86
    :cond_3
    const/4 p1, 0x0

    :goto_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->SCALE_IDS:[I

    array-length v0, v0

    if-ge p1, v0, :cond_5

    .line 87
    nop

    .line 88
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->SCALE_IDS:[I

    aget v0, v0, p1

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 89
    if-nez v0, :cond_4

    goto :goto_1

    .line 90
    :cond_4
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;I)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 86
    :goto_1
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 97
    :cond_5
    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;
    .locals 0

    .line 23
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    return-object p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 23
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->onDragTouch(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;ILandroid/view/MotionEvent;)Z
    .locals 0

    .line 23
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->onScaleTouch(ILandroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method private onDragTouch(Landroid/view/MotionEvent;)Z
    .locals 3

    .line 114
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    packed-switch v0, :pswitch_data_0

    .line 128
    return v2

    .line 120
    :pswitch_0
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    if-eqz v0, :cond_0

    invoke-direct {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;Z)V

    .line 121
    :cond_0
    return v2

    .line 124
    :pswitch_1
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    if-eqz v0, :cond_1

    invoke-direct {p0, p1, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;Z)V

    .line 125
    :cond_1
    iput-boolean v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    .line 126
    return v2

    .line 116
    :pswitch_2
    iput-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    .line 117
    invoke-direct {p0, p1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;Z)V

    .line 118
    return v2

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private onScaleTouch(ILandroid/view/MotionEvent;)Z
    .locals 3

    .line 133
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    packed-switch v0, :pswitch_data_0

    .line 147
    return v2

    .line 139
    :pswitch_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-ne v0, p1, :cond_0

    invoke-direct {p0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;Z)V

    .line 140
    :cond_0
    return v2

    .line 143
    :pswitch_1
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-ne v0, p1, :cond_1

    invoke-direct {p0, p1, p2, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;Z)V

    .line 144
    :cond_1
    const/4 p1, -0x1

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 145
    return v2

    .line 135
    :pswitch_2
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 136
    invoke-direct {p0, p1, p2, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;Z)V

    .line 137
    return v2

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private reportDrag(Landroid/view/MotionEvent;Z)V
    .locals 2

    .line 152
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    invoke-interface {v0, v1, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;->onDrag(FFZ)V

    .line 153
    :cond_0
    return-void
.end method

.method private reportScale(ILandroid/view/MotionEvent;Z)V
    .locals 2

    .line 156
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    if-eqz v0, :cond_0

    .line 157
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result v1

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    invoke-interface {v0, p1, v1, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;->onScale(IFFZ)V

    .line 159
    :cond_0
    return-void
.end method


# virtual methods
.method setFrameBounds(Landroid/graphics/Rect;)V
    .locals 1

    .line 105
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    if-nez p1, :cond_0

    return-void

    .line 106
    :cond_0
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    .line 107
    const/4 v0, -0x1

    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 108
    iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 109
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {v0, p1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 110
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    .line 111
    return-void
.end method

.method setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;)V
    .locals 0

    .line 100
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    .line 101
    return-void
.end method
