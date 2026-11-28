.class public final Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;
.super Ljava/lang/Object;
.source "FloatingKeyboardProbe.java"

# interfaces
.implements Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper$Delegate;


# static fields
.field private static final TAG:Ljava/lang/String; = "FloatingProbe"

.field private static helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

.field private static popup:Landroid/view/View;


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 42
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000()Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;
    .locals 1

    .line 35
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    return-object v0
.end method

.method static synthetic access$100(Landroid/view/View;)V
    .locals 0

    .line 35
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->inspectEditor(Landroid/view/View;)V

    return-void
.end method

.method public static apply(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V
    .locals 6

    .line 47
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardCompat;->applyInsets(Landroid/inputmethodservice/InputMethodService;Landroid/inputmethodservice/InputMethodService$Insets;)V

    .line 48
    instance-of p1, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    const-string v0, "FloatingProbe"

    if-nez p1, :cond_0

    .line 49
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "service is "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 50
    return-void

    .line 52
    :cond_0
    move-object p1, p0

    check-cast p1, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    .line 53
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->windowOf(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;

    move-result-object p0

    .line 54
    if-nez p0, :cond_1

    const/4 p0, 0x0

    goto :goto_0

    :cond_1
    invoke-virtual {p0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object p0

    .line 55
    :goto_0
    if-nez p0, :cond_2

    return-void

    .line 56
    :cond_2
    invoke-virtual {p0}, Landroid/view/View;->isLaidOut()Z

    move-result v1

    if-eqz v1, :cond_b

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v1

    if-eqz v1, :cond_b

    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v1

    if-nez v1, :cond_3

    goto/16 :goto_6

    .line 57
    :cond_3
    invoke-virtual {p0}, Landroid/view/View;->isAttachedToWindow()Z

    move-result v1

    if-nez v1, :cond_4

    return-void

    .line 61
    :cond_4
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 62
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result v2

    mul-int/lit8 v1, v1, 0x3

    div-int/lit8 v1, v1, 0x4

    if-ge v2, v1, :cond_5

    return-void

    .line 65
    :cond_5
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    if-nez v1, :cond_9

    .line 66
    invoke-virtual {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getPopupViewManager()Lcom/google/android/apps/inputmethod/libs/framework/core/IPopupViewManager;

    move-result-object v1

    .line 67
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "popupManager="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    const-string v3, "null"

    if-nez v1, :cond_6

    move-object v4, v3

    goto :goto_1

    .line 68
    :cond_6
    :try_start_1
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    :goto_1
    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    .line 67
    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 69
    if-nez v1, :cond_7

    return-void

    .line 70
    :cond_7
    invoke-virtual {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getMetrics()Lcom/google/android/apps/inputmethod/libs/framework/core/IMetrics;

    move-result-object v2

    .line 71
    new-instance v4, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    new-instance v5, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;

    invoke-direct {v5}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;-><init>()V

    invoke-direct {v4, p1, v5, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;-><init>(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper$Delegate;Lcom/google/android/apps/inputmethod/libs/framework/core/IMetrics;)V

    sput-object v4, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    .line 72
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "metrics="

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    if-nez v2, :cond_8

    goto :goto_2

    :cond_8
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    :goto_2
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 73
    sget-object v2, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    iput-object v1, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/IPopupViewManager;

    .line 74
    const-string v1, "helper created; showing the stock editor"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 75
    invoke-static {p1, p0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->showEditor(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/view/View;)V

    goto :goto_3

    .line 76
    :cond_9
    sget-object p0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    if-eqz p0, :cond_a

    .line 77
    const/4 p0, 0x2

    new-array p0, p0, [I

    .line 78
    sget-object p1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    invoke-virtual {p1, p0}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 79
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "editor frame "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "x"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    sget-object v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, " at "

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const/4 v1, 0x0

    aget v1, p0, v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, ","

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const/4 v1, 0x1

    aget p0, p0, v1

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_4

    .line 76
    :cond_a
    :goto_3
    nop

    .line 84
    :goto_4
    goto :goto_5

    .line 82
    :catchall_0
    move-exception p0

    .line 83
    const-string p1, "stock editor failed"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 85
    :goto_5
    return-void

    .line 56
    :cond_b
    :goto_6
    return-void
.end method

.method private static dump(Landroid/view/ViewGroup;I)V
    .locals 6

    .line 158
    new-instance v0, Ljava/lang/String;

    mul-int/lit8 v1, p1, 0x2

    new-array v1, v1, [C

    invoke-direct {v0, v1}, Ljava/lang/String;-><init>([C)V

    const/16 v1, 0x20

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v0

    .line 159
    nop

    :goto_0
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v2, v1, :cond_2

    .line 160
    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    .line 161
    nop

    .line 162
    invoke-virtual {v1}, Landroid/view/View;->getId()I

    move-result v3

    const/4 v4, -0x1

    if-eq v3, v4, :cond_0

    .line 164
    :try_start_0
    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v1}, Landroid/view/View;->getId()I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/content/res/Resources;->getResourceEntryName(I)Ljava/lang/String;

    move-result-object v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 166
    goto :goto_1

    .line 165
    :catchall_0
    move-exception v3

    .line 168
    :cond_0
    const-string v3, ""

    :goto_1
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, " "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 169
    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    const-string v4, "x"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 168
    const-string v4, "FloatingProbe"

    invoke-static {v4, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 170
    instance-of v3, v1, Landroid/view/ViewGroup;

    if-eqz v3, :cond_1

    const/4 v3, 0x4

    if-ge p1, v3, :cond_1

    check-cast v1, Landroid/view/ViewGroup;

    add-int/lit8 v3, p1, 0x1

    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->dump(Landroid/view/ViewGroup;I)V

    .line 159
    :cond_1
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 172
    :cond_2
    return-void
.end method

.method private static findByName(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;
    .locals 2

    .line 139
    invoke-virtual {p0}, Landroid/view/View;->getId()I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_1

    .line 141
    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {p0}, Landroid/view/View;->getId()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->getResourceEntryName(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v0, :cond_0

    .line 142
    return-object p0

    .line 145
    :cond_0
    goto :goto_0

    .line 144
    :catchall_0
    move-exception v0

    .line 147
    :cond_1
    :goto_0
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_3

    .line 148
    check-cast p0, Landroid/view/ViewGroup;

    .line 149
    const/4 v0, 0x0

    :goto_1
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_3

    .line 150
    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->findByName(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v1

    .line 151
    if-eqz v1, :cond_2

    return-object v1

    .line 149
    :cond_2
    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    .line 154
    :cond_3
    const/4 p0, 0x0

    return-object p0
.end method

.method private static inspectEditor(Landroid/view/View;)V
    .locals 4

    .line 120
    const-string v0, "keyboard_editing_overlay"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->findByName(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    .line 121
    const-string v1, "FloatingProbe"

    if-nez v0, :cond_1

    .line 122
    const-string v0, "no overlay found in the whole tree"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 123
    instance-of v0, p0, Landroid/view/ViewGroup;

    if-eqz v0, :cond_0

    check-cast p0, Landroid/view/ViewGroup;

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->dump(Landroid/view/ViewGroup;I)V

    .line 124
    :cond_0
    return-void

    .line 126
    :cond_1
    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    .line 127
    invoke-virtual {v0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object p0

    .line 128
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "overlay="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 129
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "x"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, " alpha="

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 130
    invoke-virtual {v0}, Landroid/view/View;->getAlpha()F

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " background="

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 128
    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 132
    instance-of v0, p0, Landroid/graphics/drawable/ColorDrawable;

    if-eqz v0, :cond_2

    .line 133
    check-cast p0, Landroid/graphics/drawable/ColorDrawable;

    invoke-virtual {p0}, Landroid/graphics/drawable/ColorDrawable;->getColor()I

    move-result p0

    .line 134
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "overlay colour #"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-static {p0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 136
    :cond_2
    return-void
.end method

.method private static showEditor(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/view/View;)V
    .locals 3

    .line 91
    invoke-virtual {p1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 92
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->getPackageName()Ljava/lang/String;

    move-result-object p0

    .line 91
    const-string v1, "keyboard_area"

    const-string v2, "id"

    invoke-virtual {v0, v1, v2, p0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    .line 93
    if-nez p0, :cond_0

    .line 94
    const-string p0, "FloatingProbe"

    const-string p1, "keyboard_area missing, cannot anchor the editor"

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 95
    return-void

    .line 99
    :cond_0
    invoke-virtual {p0}, Landroid/view/View;->getTop()I

    move-result v0

    .line 102
    new-instance v1, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;

    invoke-direct {v1, p0, v0}, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe$1;-><init>(Landroid/view/View;I)V

    invoke-virtual {p1, v1}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 116
    return-void
.end method

.method private static windowOf(Landroid/inputmethodservice/InputMethodService;)Landroid/view/Window;
    .locals 0

    .line 175
    invoke-virtual {p0}, Landroid/inputmethodservice/InputMethodService;->getWindow()Landroid/app/Dialog;

    move-result-object p0

    .line 176
    if-nez p0, :cond_0

    const/4 p0, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object p0

    :goto_0
    return-object p0
.end method


# virtual methods
.method public onExitEditingKeyboard()V
    .locals 2

    .line 196
    const-string v0, "FloatingProbe"

    const-string v1, "onExitEditingKeyboard"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 197
    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    if-eqz v0, :cond_0

    sget-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->helper:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;

    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardEditingViewHelper;->a()V

    .line 198
    :cond_0
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/FloatingKeyboardProbe;->popup:Landroid/view/View;

    .line 199
    return-void
.end method

.method public resetKeyboard()V
    .locals 2

    .line 191
    const-string v0, "FloatingProbe"

    const-string v1, "resetKeyboard"

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 192
    return-void
.end method

.method public updateKeyboardPosition(II)V
    .locals 2

    .line 181
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "updateKeyboardPosition x="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " y="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "FloatingProbe"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 182
    return-void
.end method

.method public updateKeyboardScale(IIF)V
    .locals 2

    .line 186
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "updateKeyboardScale x="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " y="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string p2, " factor="

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "FloatingProbe"

    invoke-static {p2, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 187
    return-void
.end method
