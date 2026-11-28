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

.field private activePointer:I

.field private dragging:Z

.field private final frame:Landroid/view/View;

.field private listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .line 36
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

    .line 55
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 49
    const/4 v0, -0x1

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 52
    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    .line 56
    invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object p1

    const v0, 0x7f04007b

    const/4 v1, 0x1

    invoke-virtual {p1, v0, p0, v1}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    .line 57
    const p1, 0x7f0f015c

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    .line 59
    const p1, 0x7f0f01c5

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 60
    if-eqz p1, :cond_0

    .line 61
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$1;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$1;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 68
    :cond_0
    const p1, 0x7f0f001b

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 69
    if-eqz p1, :cond_1

    .line 70
    new-instance v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;

    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$2;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 79
    :cond_1
    new-instance p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;

    invoke-direct {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$3;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)V

    .line 85
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {v0, p1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 86
    :cond_2
    const v0, 0x7f0f01a4

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 87
    if-eqz v0, :cond_3

    invoke-virtual {v0, p1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 89
    :cond_3
    const/4 p1, 0x0

    :goto_0
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->SCALE_IDS:[I

    array-length v0, v0

    if-ge p1, v0, :cond_5

    .line 90
    nop

    .line 91
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->SCALE_IDS:[I

    aget v0, v0, p1

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->findViewById(I)Landroid/view/View;

    move-result-object v0

    .line 92
    if-nez v0, :cond_4

    goto :goto_1

    .line 93
    :cond_4
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;

    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$4;-><init>(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;I)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 89
    :goto_1
    add-int/lit8 p1, p1, 0x1

    goto :goto_0

    .line 100
    :cond_5
    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;)Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;
    .locals 0

    .line 24
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    return-object p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 24
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->onDragTouch(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method static synthetic access$200(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;ILandroid/view/MotionEvent;)Z
    .locals 0

    .line 24
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->onScaleTouch(ILandroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method private endDrag(Landroid/view/MotionEvent;)Z
    .locals 2

    .line 142
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    const/4 v1, 0x1

    if-nez v0, :cond_0

    return v1

    .line 143
    :cond_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    .line 144
    if-ltz v0, :cond_1

    invoke-direct {p0, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;IZ)V

    .line 145
    :cond_1
    const/4 p1, 0x0

    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    .line 146
    const/4 p1, -0x1

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    .line 147
    return v1
.end method

.method private onDragTouch(Landroid/view/MotionEvent;)Z
    .locals 4

    .line 117
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x1

    packed-switch v0, :pswitch_data_0

    .line 137
    :pswitch_0
    return v2

    .line 132
    :pswitch_1
    return v2

    .line 125
    :pswitch_2
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    if-nez v0, :cond_0

    return v2

    .line 126
    :cond_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    .line 127
    if-ltz v0, :cond_1

    invoke-direct {p0, p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;IZ)V

    .line 128
    :cond_1
    return v2

    .line 135
    :pswitch_3
    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->endDrag(Landroid/view/MotionEvent;)Z

    move-result p1

    return p1

    .line 119
    :pswitch_4
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    const/4 v3, -0x1

    if-ne v0, v3, :cond_3

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-eq v0, v3, :cond_2

    goto :goto_0

    .line 120
    :cond_2
    invoke-virtual {p1, v1}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    .line 121
    iput-boolean v2, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    .line 122
    invoke-direct {p0, p1, v1, v1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportDrag(Landroid/view/MotionEvent;IZ)V

    .line 123
    return v2

    .line 119
    :cond_3
    :goto_0
    return v2

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_3
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private onScaleTouch(ILandroid/view/MotionEvent;)Z
    .locals 5

    .line 151
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v1, -0x1

    const/4 v2, 0x0

    const/4 v3, 0x1

    packed-switch v0, :pswitch_data_0

    .line 182
    :pswitch_0
    return v3

    .line 167
    :pswitch_1
    return v3

    .line 161
    :pswitch_2
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-eq v0, p1, :cond_0

    return v3

    .line 162
    :cond_0
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    invoke-virtual {p2, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    .line 163
    if-ltz v0, :cond_1

    invoke-direct {p0, p1, p2, v0, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;IZ)V

    .line 164
    :cond_1
    return v3

    .line 170
    :pswitch_3
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-eq v0, p1, :cond_2

    return v3

    .line 171
    :cond_2
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    invoke-virtual {p2, v0}, Landroid/view/MotionEvent;->findPointerIndex(I)I

    move-result v0

    .line 172
    if-ltz v0, :cond_3

    invoke-direct {p0, p1, p2, v0, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;IZ)V

    goto :goto_0

    .line 173
    :cond_3
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v0

    const/4 v4, 0x3

    if-ne v0, v4, :cond_4

    .line 176
    invoke-direct {p0, p1, p2, v2, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;IZ)V

    .line 178
    :cond_4
    :goto_0
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 179
    iput v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    .line 180
    return v3

    .line 155
    :pswitch_4
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    if-ne v0, v1, :cond_6

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    if-ne v0, v1, :cond_6

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->dragging:Z

    if-eqz v0, :cond_5

    goto :goto_1

    .line 156
    :cond_5
    invoke-virtual {p2, v2}, Landroid/view/MotionEvent;->getPointerId(I)I

    move-result v0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activePointer:I

    .line 157
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->activeCorner:I

    .line 158
    invoke-direct {p0, p1, p2, v2, v2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->reportScale(ILandroid/view/MotionEvent;IZ)V

    .line 159
    return v3

    .line 155
    :cond_6
    :goto_1
    return v3

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_3
        :pswitch_0
        :pswitch_1
    .end packed-switch
.end method

.method private rawX(Landroid/view/MotionEvent;I)F
    .locals 1

    .line 198
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getX(I)F

    move-result p2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawX()F

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result p1

    sub-float/2addr v0, p1

    add-float/2addr p2, v0

    return p2
.end method

.method private rawY(Landroid/view/MotionEvent;I)F
    .locals 1

    .line 202
    invoke-virtual {p1, p2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p2

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getRawY()F

    move-result v0

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result p1

    sub-float/2addr v0, p1

    add-float/2addr p2, v0

    return p2
.end method

.method private reportDrag(Landroid/view/MotionEvent;IZ)V
    .locals 2

    .line 187
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    if-nez v0, :cond_0

    return-void

    .line 188
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->rawX(Landroid/view/MotionEvent;I)F

    move-result v1

    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->rawY(Landroid/view/MotionEvent;I)F

    move-result p1

    invoke-interface {v0, v1, p1, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;->onDrag(FFZ)V

    .line 189
    return-void
.end method

.method private reportScale(ILandroid/view/MotionEvent;IZ)V
    .locals 2

    .line 192
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    if-nez v0, :cond_0

    return-void

    .line 193
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    invoke-direct {p0, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->rawX(Landroid/view/MotionEvent;I)F

    move-result v1

    invoke-direct {p0, p2, p3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->rawY(Landroid/view/MotionEvent;I)F

    move-result p2

    invoke-interface {v0, p1, v1, p2, p4}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;->onScale(IFFZ)V

    .line 194
    return-void
.end method


# virtual methods
.method fitFrame()V
    .locals 2

    .line 108
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    .line 109
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    .line 110
    const/4 v1, -0x1

    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 111
    iput v1, v0, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 112
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    invoke-virtual {v1, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 113
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->frame:Landroid/view/View;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 114
    return-void
.end method

.method setListener(Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;)V
    .locals 0

    .line 103
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView;->listener:Lcom/google/android/inputmethod/pinyin/FloatingKeyboardEditView$Listener;

    .line 104
    return-void
.end method
