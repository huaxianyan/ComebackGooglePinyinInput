.class public final Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;
.super Ljava/lang/Object;
.source "PairedPunctuationHook.java"


# Shared completion step for the IMEs that do not run the processor chain.
#
# The Chinese keyboards push every soft-key event through
# PairedPunctuationProcessor, so the replacement of the opening symbol happens
# inside the processor framework. The English keyboards cannot do that:
# EnglishIme extends LatinIme, which extends AbstractIme, and only
# ProcessorBasedIme reads the "<processors>" element of an IME definition, so an
# <include href="@xml/processors_*" /> entry under an English <ime> would be
# silently ignored.
#
# Those IMEs therefore call this helper from their own handle() entry point,
# before the stock implementation sees the event. Both paths read the same
# preference and the same character table, so a single switch turns the
# completion on or off for Chinese and English at once.
#
# The context does not come from AbstractIme.mContext. On-device logging shows
# that field is still null when handle() runs, while mImeDelegate is live and the
# stock keyboard types normally. The Chinese processors never relied on the
# field either: ProcessorBasedIme passes the argument it receives in
# initialize() straight through. The English IME subclasses do the same here,
# which is why a(Context) below stores the context that initialize() handed
# them.
#
# Guard polarity follows PairedPunctuationProcessor: every check jumps to the
# common exit when the expected condition does NOT hold.
#
# Not every event carries a key: the framework dispatches a soft-key event when
# the keyboard becomes ready, and that one has no intent at all. A missing value
# is a plain decline, so the guards test the values and never call a method on
# them.
#
# Returns true when the event was consumed. The caller must then report the
# event as handled and must not forward it to the stock implementation.

.field public static a:Landroid/content/Context;


# Stores the context the IME received from the framework. Called from the
# initialize() override of every English IME that uses this hook.
.method public static a(Landroid/content/Context;)V
    .locals 0

    sput-object p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->a:Landroid/content/Context;

    return-void
.end method


.method public static a(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z
    .locals 5

    const/4 v0, 0x0

    # Prefer the context captured in initialize(); keep the argument, which is
    # AbstractIme.mContext and therefore null on this path, as the fallback.
    sget-object v1, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationHook;->a:Landroid/content/Context;

    if-eqz v1, :context_ready

    move-object p0, v1

    :context_ready
    if-eqz p0, :done

    if-eqz p1, :done

    if-eqz p2, :done

    invoke-static {p0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "enable_paired_punctuation_completion"

    const/4 v3, 0x1

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :done

    iget-object v1, p2, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->a:[Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    if-eqz v1, :done

    array-length v2, v1

    if-lez v2, :done

    const/4 v2, 0x0

    aget-object v1, v1, v2

    if-eqz v1, :done

    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    sget-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->COMMIT:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    if-ne v2, v3, :done

    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Ljava/lang/Object;

    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :done

    check-cast v2, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    const/4 v4, 0x1

    if-ne v3, v4, :done

    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :done

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    const/4 v4, 0x1

    invoke-interface {p1, v2, v3, v4}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->commitText(Ljava/lang/CharSequence;ZI)V

    const/4 v2, -0x1

    const/4 v3, -0x1

    invoke-interface {p1, v2, v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/IImeDelegate;->offsetSelection(II)V

    const/4 v0, 0x1

    :done
    return v0
.end method
