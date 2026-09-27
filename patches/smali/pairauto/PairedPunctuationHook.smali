.class public final Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;
.super Ljava/lang/Object;
.source "PairedPunctuationHook.java"


# Shared completion step for the IMEs that do not run the processor chain.
#
# The Chinese keyboards push every soft-key event through
# PairedPunctuationProcessor, so the replacement of the opening symbol happens
# inside the processor framework. The English keyboards cannot do that:
# EnglishIme extends LatinIme, which extends AbstractIme, and AbstractIme never
# reads the "<processors>" element of an IME definition. Only ProcessorBasedIme
# reads it, so an <include href="@xml/processors_*" /> entry under an English
# <ime> would be silently ignored.
#
# Those IMEs therefore call this helper from their own handle() entry point,
# before the stock LatinIme implementation sees the event. Both paths read the
# same preference and the same character table, so a single switch turns the
# completion on or off for Chinese and English at once.
#
# Returns true when the event was consumed. The caller must then report the
# event as handled and must not forward it to the stock implementation.
#
# TEMPORARY DIAGNOSTIC BUILD: each guard that rejects an event logs a marker
# through PairedPunctuationHook->log. Remove the markers before release.

.method public static log(Ljava/lang/String;)V
    .locals 1

    const-string v0, "PairautoHook"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method


.method public static a(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z
    .locals 7

    const/4 v0, 0x0

    const-string v5, "enter"

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->log(Ljava/lang/String;)V

    if-nez p0, :bad_context

    if-nez p1, :bad_delegate

    if-nez p2, :bad_event

    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "enable_paired_punctuation_completion"

    const/4 v3, 0x1

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-nez v1, :bad_pref

    iget-object v1, p2, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->a:[Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    if-nez v1, :bad_array

    array-length v2, v1

    if-gtz v2, :bad_empty

    const/4 v2, 0x0

    aget-object v1, v1, v2

    if-nez v1, :bad_key

    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    sget-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->COMMIT:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    if-eq v2, v3, :bad_intent

    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Ljava/lang/Object;

    instance-of v3, v2, Ljava/lang/String;

    if-nez v3, :bad_payload

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    const/4 v4, 0x1

    if-eq v3, v4, :bad_length

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-nez v3, :bad_pair

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v5, "hit"

    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->log(Ljava/lang/String;)V

    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-interface {p1, v2, v3, v4}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->commitText(Ljava/lang/CharSequence;ZI)V

    const/4 v2, -0x1

    const/4 v3, -0x1

    invoke-interface {p1, v2, v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->offsetSelection(II)V

    const/4 v0, 0x1

    return v0

    :bad_context
    const-string v5, "exit:no-context"

    goto :log_bad

    :bad_delegate
    const-string v5, "exit:no-delegate"

    goto :log_bad

    :bad_event
    const-string v5, "exit:no-event"

    goto :log_bad

    :bad_pref
    const-string v5, "exit:pref-off"

    goto :log_bad

    :bad_array
    const-string v5, "exit:no-array"

    goto :log_bad

    :bad_empty
    const-string v5, "exit:empty-array"

    goto :log_bad

    :bad_key
    const-string v5, "exit:no-keydata"

    goto :log_bad

    :bad_intent
    invoke-virtual {v2}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v5

    goto :log_bad

    :bad_payload
    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    goto :log_bad

    :bad_length
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    goto :log_bad

    :bad_pair
    invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v5

    :log_bad
    invoke-static {v5}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->log(Ljava/lang/String;)V

    return v0
.end method
