.class public Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;
.super Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;
.implements Ljava/lang/Runnable;
.source "EnglishT9MultiTapIme.java"


# English 9-key keyboard with an optional multi-tap letter-selection mode.
#
# This class backs the single English 9-key keyboard. It is a subclass of the
# original English9KeyIme and adds nothing unless the user turns on the
# "multi-tap letter selection" preference:
#
#   * option off (the shipped default) - every overridden entry point delegates
#     to English9KeyIme, so the keyboard is byte-for-byte the stock behaviour,
#     including word candidates, auto-correction and punctuation candidates.
#   * option on - digit keys are consumed and turned into the Nth letter of the
#     group, where N is the number of taps on the same key inside the configured
#     window. The pending letter is written as composing text through the native
#     IImeActionDelegate, so the editor draws its standard composing underline
#     while the run is still open; when the run ends the letter is finished and
#     the underline disappears. Word association stays off in this mode.
#
# Cycling replaces the composing letter in place instead of deleting and
# re-committing it, so no KEYCODE_DEL round trip and no cursor assumption are
# needed. Native key sound and vibration are produced by the touch pipeline
# before the event reaches the IME, so they stay unchanged.

.field private static final LETTERS:[Ljava/lang/String;

.field private lastKeyCode:I

.field private tapCount:I

.field private lastTapTime:J

.field private uppercase:Z

.field private handler:Landroid/os/Handler;

.field private composing:Z


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
    .locals 2

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;-><init>()V

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->handler:Landroid/os/Handler;

    return-void
.end method


# With multi-tap off the stock English 9-key suggestion behaviour stays in
# place; with it on the keyboard commits single letters and never associates
# words, so suggestions and auto-correction are switched off.
.method public computeShouldShowSuggestions(Landroid/view/inputmethod/EditorInfo;)Z
    .locals 2

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->enabled()Z

    move-result v0

    if-eqz v0, :compat_stock_suggestions

    const/4 v0, 0x0

    return v0

    :compat_stock_suggestions
    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->computeShouldShowSuggestions(Landroid/view/inputmethod/EditorInfo;)Z

    move-result v0

    return v0
.end method


.method public computeShouldEnableAutoCorrection(Landroid/view/inputmethod/EditorInfo;)Z
    .locals 2

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->enabled()Z

    move-result v0

    if-eqz v0, :compat_stock_correction

    const/4 v0, 0x0

    return v0

    :compat_stock_correction
    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/EnglishIme;->computeShouldEnableAutoCorrection(Landroid/view/inputmethod/EditorInfo;)Z

    move-result v0

    return v0
.end method


# The inherited English 9-key implementation appends its punctuation reading
# text candidates whenever no word candidate is active. Multi-tap does not
# associate anything, so it leaves the candidate list untouched; with the option
# off the stock behaviour is kept.
.method public requestCandidates(I)V
    .locals 2

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->enabled()Z

    move-result v0

    if-eqz v0, :compat_stock_candidates

    return-void

    :compat_stock_candidates
    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->requestCandidates(I)V

    return-void
.end method


.method public onActivate(Landroid/view/inputmethod/EditorInfo;)V
    .locals 1

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->finishRun()V

    const/4 v0, 0x0

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    iput v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->onActivate(Landroid/view/inputmethod/EditorInfo;)V

    return-void
.end method


.method public onDeactivate()V
    .locals 0

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->finishRun()V

    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/english/ime/EnglishIme;->onDeactivate()V

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

    # p0 and p1 live in v16/v17, which iget/iput (22c) and invoke (35c) cannot
    # address. Keep low-register aliases for the whole method instead.
    move-object/from16 v11, p0

    move-object/from16 v1, p1

    # Multi-tap is an option of this 9-key keyboard. With the option off every
    # event is handed to the original English9KeyIme unchanged.
    invoke-direct {v11}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->enabled()Z

    move-result v3

    if-eqz v3, :compat_delegate

    const/4 v3, 0x0

    iget-object v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->a:[Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    aget-object v0, v0, v3

    iget v2, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:I

    const/16 v3, 0x9

    if-lt v2, v3, :compat_delegate

    const/16 v3, 0x10

    if-gt v2, v3, :compat_delegate

    iget-object v10, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    sget-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->DECODE:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    if-ne v10, v3, :compat_delegate

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v4

    iget v12, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    if-ne v2, v12, :compat_reset_run

    iget-wide v6, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastTapTime:J

    sub-long v6, v4, v6

    invoke-direct {v11}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->intervalMs()I

    move-result v10

    int-to-long v8, v10

    cmp-long v10, v6, v8

    if-gtz v10, :compat_reset_run

    iget v12, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    add-int/lit8 v12, v12, 0x1

    goto :compat_store_run

    :compat_reset_run
    const/4 v12, 0x1

    :compat_store_run
    iput v12, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    iput v2, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastKeyCode:I

    iput-wide v4, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->lastTapTime:J

    sget-object v13, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->LETTERS:[Ljava/lang/String;

    add-int/lit8 v3, v2, -0x9

    aget-object v13, v13, v3

    invoke-virtual {v13}, Ljava/lang/String;->length()I

    move-result v14

    add-int/lit8 v15, v12, -0x1

    rem-int v15, v15, v14

    invoke-virtual {v13, v15}, Ljava/lang/String;->charAt(I)C

    move-result v13

    iget-boolean v15, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->uppercase:Z

    if-eqz v15, :compat_lowercase

    invoke-static {v13}, Ljava/lang/Character;->toUpperCase(C)C

    move-result v13

    :compat_lowercase
    # A new tap run finishes the previously pending letter first, so tapping a
    # different key commits the old letter. A repeated tap on the same key keeps
    # the run open and only replaces the composing letter in place.
    const/4 v14, 0x1

    if-ne v12, v14, :compat_compose

    invoke-direct {v11}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->finishRun()V

    :compat_compose
    const/4 v14, 0x1

    iput-boolean v14, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->composing:Z

    invoke-static {v13}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v13

    iget-object v14, v11, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mImeDelegate:Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;

    const/4 v15, 0x1

    invoke-interface {v14, v13, v15}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->setComposingText(Ljava/lang/CharSequence;I)V

    iget-object v14, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->handler:Landroid/os/Handler;

    invoke-virtual {v14, v11}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    invoke-direct {v11}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->intervalMs()I

    move-result v14

    int-to-long v8, v14

    iget-object v15, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->handler:Landroid/os/Handler;

    invoke-virtual {v15, v11, v8, v9}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    const/4 v0, 0x1

    return v0

    :compat_delegate
    invoke-direct {v11}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->finishRun()V

    const/4 v3, 0x0

    iput v3, v11, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->tapCount:I

    invoke-super {v11, v1}, Lcom/google/android/apps/inputmethod/libs/english/ime/English9KeyIme;->handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z

    move-result v0

    return v0
.end method


# Timer entry point: the tap window for the current key has expired, so the
# pending letter stops being composing text and its underline disappears.
.method public run()V
    .locals 0

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->finishRun()V

    return-void
.end method


.method private finishRun()V
    .locals 1

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->composing:Z

    if-eqz v0, :compat_finish_done

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->composing:Z

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/EnglishT9MultiTapIme;->handler:Landroid/os/Handler;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mImeDelegate:Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;

    invoke-interface {v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->finishComposingText()V

    :compat_finish_done
    return-void
.end method


# Master opt-in of multi-tap letter selection. An absent key means off, which is
# the shipped default: the keyboard then behaves exactly like the stock English
# 9-key.
.method private enabled()Z
    .locals 3

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mContext:Landroid/content/Context;

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "en_t9_multitap_enabled"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

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

    # Clamp to 100..2000 ms. The branch must skip the assignment when the value
    # is already in range: if-ge for the lower bound, if-le for the upper bound.
    const/16 v1, 0x64

    if-ge v0, v1, :compat_interval_low

    move v0, v1

    :compat_interval_low
    const/16 v1, 0x7d0

    if-le v0, v1, :compat_interval_high

    move v0, v1

    :compat_interval_high
    return v0
.end method
