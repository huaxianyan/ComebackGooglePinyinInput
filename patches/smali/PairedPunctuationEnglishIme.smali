.class public Lcom/google/android/inputmethod/pinyin/PairedPunctuationEnglishIme;
.super Lcom/google/android/apps/inputmethod/libs/english/ime/EnglishIme;
.source "PairedPunctuationEnglishIme.java"


# English QWERTY keyboard with the shared paired-symbol completion.
#
# The completion step for English keyboards cannot live in the processor
# framework: EnglishIme extends LatinIme, which extends AbstractIme, and only
# ProcessorBasedIme reads the "<processors>" element of an IME definition. An
# <include href="@xml/processors_*" /> entry under an English <ime> would be
# ignored, so the work happens here instead, at the single entry point every
# soft-key event passes through.
#
# The class overrides nothing but handle(). Every other call - word candidates,
# auto-correction, gestures, shift state, the stock punctuation handling - is
# inherited unchanged, so the only difference from EnglishIme is the extra
# completion step. The IME definition therefore only swaps the class name and
# keeps its string id, label and keyboard group.
#
# With the preference off the helper returns false without touching the event,
# and the keyboard is byte-for-byte the stock English QWERTY.

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/english/ime/EnglishIme;-><init>()V

    return-void
.end method


.method public handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z
    .locals 2

    const-string v0, "qwerty-handle"

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->log(Ljava/lang/String;)V

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mContext:Landroid/content/Context;

    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/ime/AbstractIme;->mImeDelegate:Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;

    invoke-static {v0, v1, p1}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->a(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z

    move-result v0

    if-eqz v0, :compat_stock

    const/4 v0, 0x1

    return v0

    :compat_stock
    invoke-super {p0, p1}, Lcom/google/android/apps/inputmethod/libs/english/ime/EnglishIme;->handle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z

    move-result v0

    return v0
.end method
