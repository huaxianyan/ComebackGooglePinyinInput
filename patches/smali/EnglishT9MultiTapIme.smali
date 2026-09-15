.class public Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;
.super Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;
.source "EnglishT9MultiTapIme.java"


# English T9 multi-tap keyboard.
#
# The original English9KeyIme.handle() already maps a digit keycode to the first
# letter of its group and forwards the rewritten key data to EnglishIme. This
# subclass keeps that contract but remembers how often the same digit key was
# tapped inside a bounded window, so repeated taps cycle through the whole group
# instead of always producing the first letter.
#
# Letters are committed with KeyData$a.COMMIT so the keyboard never composes a
# word, and computeShouldShowSuggestions() returns false, which is the "no word
# association" mode requested for this keyboard. Native key sound and vibration
# are produced by the touch pipeline before the event reaches the IME, so they
# stay unchanged.

.field private static final LETTERS:[Ljava/lang/String;

.field private lastKeyCode:I

.field private tapCount:I

.field private lastTapTime:J

.field private uppercase:Z


.method static constructor <clinit>()V
    .locals 3

    const/16 v0, 0x8

    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "abc"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "def"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "ghi"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "jkl"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "mno"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "pqrs"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "tuv"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "wxyz"

    aput-object v2, v0, v1

    sput-object v0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->LETTERS:[Ljava/lang/String;

    return-void
.end method


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;-><init>()V

    return-void
.end method


.method public computeShouldShowSuggestions(Landroid/view/inputmethod/EditorInfo;)Z
    .locals 1

    const/4 v0, 0x0

    return v0
.end method


.method public computeShouldEnableAutoCorrection(Landroid/view/inputmethod/EditorInfo;)Z
    .locals 1

    const/4 v0, 0x0

    return v0
.end method


# The inherited English 9-key implementation appends its punctuation reading
# text candidates whenever no word candidate is active. This keyboard does not
# associate anything, so it leaves the candidate list to the framework.
.method public requestCandidates(I)V
    .locals 0

    return-void
.end method


.method public onActivate(Landroid/view/inputmethod/EditorInfo;)V
    .locals 1

    const/4 v0, 0x0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->onActivate(Landroid/view/inputmethod/EditorInfo;)V

    return-void
.end method


.method public onKeyboardStateChanged(JJ)V
    .locals 4

    invoke-super {p0, p1, p2, p3, p4}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->onKeyboardStateChanged(JJ)V

    const-wide/16 v0, 0x1

    and-long v2, p1, v0

    const-wide/16 v0, 0x0

    cmp-long v2, v2, v0

    if-eqz v2, :compat_shift_off

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->uppercase:Z

    return-void

    :compat_shift_off
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->uppercase:Z

    return-void
.end method


.method public handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z
    .locals 16

    iget-object v0, p1, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->a:[Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    iget v2, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:I

    const/16 v3, 0x9

    if-lt v2, v3, :compat_delegate

    const/16 v3, 0x10

    if-gt v2, v3, :compat_delegate

    iget-object v10, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    sget-object v11, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->DECODE:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    if-ne v10, v11, :compat_delegate

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    iget v12, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    if-ne v2, v12, :compat_reset_run

    iget-wide v6, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastTapTime:J

    sub-long v6, v4, v6

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->intervalMs()I

    move-result v10

    int-to-long v8, v10

    cmp-long v10, v6, v8

    if-gtz v10, :compat_reset_run

    iget v12, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    add-int/lit8 v12, v12, 0x1

    goto :compat_store_run

    :compat_reset_run
    const/4 v12, 0x1

    :compat_store_run
    iput v12, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    iput v2, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    iput-wide v4, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastTapTime:J

    sget-object v13, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->LETTERS:[Ljava/lang/String;

    add-int/lit8 v3, v2, -0x9

    aget-object v13, v13, v3

    invoke-virtual {v13}, Ljava/lang/String;->length()I

    move-result v14

    add-int/lit8 v15, v12, -0x1

    rem-int v15, v15, v14

    invoke-virtual {v13, v15}, Ljava/lang/String;->charAt(I)C

    move-result v13

    iget-boolean v15, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->uppercase:Z

    if-eqz v15, :compat_lowercase

    invoke-static {v13}, Ljava/lang/Character;->toUpperCase(C)C

    move-result v13

    :compat_lowercase
    invoke-static {v13}, Ljava/lang/Character;->toLowerCase(C)C

    move-result v15

    add-int/lit8 v15, v15, -0x61

    const/16 v14, 0x1d

    add-int/2addr v15, v14

    const/4 v14, 0x1

    if-le v12, v14, :compat_commit

    const/16 v14, 0x43

    const/4 v3, 0x0

    invoke-direct {p0, v14, v3}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->sendKey(ILjava/lang/String;)V

    :compat_commit
    invoke-static {v13}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v13

    invoke-direct {p0, v15, v13}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->sendKey(ILjava/lang/String;)V

    const/4 v0, 0x1

    return v0

    :compat_delegate
    const/4 v3, 0x0

    iput v3, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z

    move-result v0

    return v0
.end method


.method private intervalMs()I
    .locals 4

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "en_t9_multitap_interval_ms"

    const-string v2, "600"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v0

    const/16 v1, 0x64

    if-lt v0, v1, :compat_interval_low

    move v0, v1

    :compat_interval_low
    const/16 v1, 0x7d0

    if-gt v0, v1, :compat_interval_high

    move v0, v1

    :compat_interval_high
    return v0
.end method


.method private sendKey(ILjava/lang/String;)V
    .locals 3

    new-instance v0, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->COMMIT:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    invoke-direct {v0, p1, v1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;-><init>(ILcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;Ljava/lang/Object;)V

    invoke-static {v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->b(Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;)Lcom/google/android/apps/inputmethod/libs/framework/core/Event;

    move-result-object v0

    invoke-super {p0, v0}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z

    move-result v0

    return-void
.end method
