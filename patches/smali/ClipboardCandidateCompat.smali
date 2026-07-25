.class public final Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;
.super Ljava/lang/Object;
.source "ClipboardCandidateCompat.java"

# interfaces
.implements Ljava/lang/Runnable;
.implements Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;
.implements Landroid/view/View$OnClickListener;


# static fields
.field private static final PAYLOAD_PREFIX:Ljava/lang/String; = "compat_clipboard:"

.field private static final MAX_AGE_MS:J = 0x1d4c0L

.field private static current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

.field private static candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

.field private static candidateKey:Ljava/lang/String;

.field private static dismissedKey:Ljava/lang/String;

.field private static injected:Z


# instance fields
.field private final service:Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

.field private final clipboard:Landroid/content/ClipboardManager;

.field private final handler:Landroid/os/Handler;

.field private pendingCandidateReset:Z

.field private pendingIdleRestore:Z

.field private normalCandidatesActive:Z


# direct methods
.method private constructor <init>(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/content/ClipboardManager;)V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->service:Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    iput-object p2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->clipboard:Landroid/content/ClipboardManager;

    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->handler:Landroid/os/Handler;

    return-void
.end method

.method private static isEditorAllowed(Landroid/view/inputmethod/EditorInfo;)Z
    .locals 5

    const/4 v0, 0x0

    if-eqz p0, :blocked

    iget-object v1, p0, Landroid/view/inputmethod/EditorInfo;->privateImeOptions:Ljava/lang/String;

    if-eqz v1, :check_type

    const-string v2, "disableAutoPaste"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :blocked

    :check_type
    iget v1, p0, Landroid/view/inputmethod/EditorInfo;->inputType:I

    and-int/lit8 v2, v1, 0xf

    const/4 v3, 0x1

    if-ne v2, v3, :check_number

    and-int/lit16 v1, v1, 0xff0

    const/16 v2, 0x80

    if-eq v1, v2, :blocked

    const/16 v2, 0x90

    if-eq v1, v2, :blocked

    const/16 v2, 0xe0

    if-eq v1, v2, :blocked

    return v3

    :check_number
    const/4 v4, 0x2

    if-ne v2, v4, :allowed

    and-int/lit16 v1, v1, 0xff0

    const/16 v2, 0x10

    if-ne v1, v2, :allowed

    return v0

    :allowed
    return v3

    :blocked
    return v0
.end method

.method private static isSensitive(Landroid/content/ClipDescription;)Z
    .locals 3

    const/4 v0, 0x0

    if-eqz p0, :done

    invoke-virtual {p0}, Landroid/content/ClipDescription;->getExtras()Landroid/os/PersistableBundle;

    move-result-object v1

    if-eqz v1, :done

    const-string v2, "android.content.extra.IS_SENSITIVE"

    invoke-virtual {v1, v2, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :done
    return v0
.end method

.method private static makeKey(Ljava/lang/String;J)Ljava/lang/String;
    .locals 2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 v1, 0x1f

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method private static makeCandidate(Ljava/lang/String;)Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;
    .locals 6

    # The clipboard candidate is a faithful paste operation. Its normalized
    # visible label is ellipsized by the measured View; payload stays complete.
    move-object v0, p0

    move-object v1, p0

    # Keep the complete normalized label and let TextView ellipsize against its
    # measured clipboard slot. Character-count truncation can cross the actual
    # right divider on narrow screens and with wide glyphs.
    const-string v2, "[\\r\\n\\t]+"

    const-string v3, " "

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;

    invoke-direct {v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;-><init>()V

    iput-object v1, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;->a:Ljava/lang/CharSequence;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "剪贴板 "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    iput-object v1, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;->a:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "compat_clipboard:"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    iput-object v0, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;->a:Ljava/lang/Object;

    invoke-virtual {v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate$a;->a()Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    move-result-object v0

    return-object v0
.end method

.method public static start(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/view/inputmethod/EditorInfo;)V
    .locals 4

    invoke-static {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->stop(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V

    invoke-static {p1}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->isEditorAllowed(Landroid/view/inputmethod/EditorInfo;)Z

    move-result v0

    if-eqz v0, :done

    const-string v0, "clipboard"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/content/ClipboardManager;

    if-eqz v0, :done

    new-instance v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    invoke-direct {v1, p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;-><init>(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;Landroid/content/ClipboardManager;)V

    sput-object v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    invoke-virtual {v0, v1}, Landroid/content/ClipboardManager;->addPrimaryClipChangedListener(Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;)V

    invoke-direct {v1}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->refresh()V

    const/4 v0, 0x1

    iput-boolean v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    iget-object v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->handler:Landroid/os/Handler;

    const-wide/16 v2, 0x1c2

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :done
    return-void
.end method

.method public static stop(Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;)V
    .locals 2

    sget-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-eqz v0, :clear

    iget-object v1, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->service:Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    if-ne v1, p0, :done

    iget-object v1, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->handler:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    iget-object v1, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->clipboard:Landroid/content/ClipboardManager;

    invoke-virtual {v1, v0}, Landroid/content/ClipboardManager;->removePrimaryClipChangedListener(Landroid/content/ClipboardManager$OnPrimaryClipChangedListener;)V

    :clear
    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    :done
    return-void
.end method

.method private refresh()V
    .locals 10

    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    iget-object v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->clipboard:Landroid/content/ClipboardManager;

    invoke-virtual {v2}, Landroid/content/ClipboardManager;->getPrimaryClip()Landroid/content/ClipData;

    move-result-object v2

    if-eqz v2, :done

    invoke-virtual {v2}, Landroid/content/ClipData;->getItemCount()I

    move-result v3

    if-lez v3, :done

    invoke-virtual {v2}, Landroid/content/ClipData;->getDescription()Landroid/content/ClipDescription;

    move-result-object v3

    invoke-static {v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->isSensitive(Landroid/content/ClipDescription;)Z

    move-result v4

    if-nez v4, :done

    const-wide/16 v4, 0x0

    if-eqz v3, :read_text

    invoke-virtual {v3}, Landroid/content/ClipDescription;->getTimestamp()J

    move-result-wide v4

    :read_text
    const-wide/16 v6, 0x0

    cmp-long v3, v4, v6

    if-lez v3, :item

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v6

    sub-long/2addr v6, v4

    const-wide/32 v8, 0x1d4c0

    cmp-long v3, v6, v8

    if-lez v3, :item

    goto :done

    :item
    invoke-virtual {v2, v1}, Landroid/content/ClipData;->getItemAt(I)Landroid/content/ClipData$Item;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/ClipData$Item;->getText()Ljava/lang/CharSequence;

    move-result-object v2

    if-eqz v2, :done

    invoke-interface {v2}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    if-eqz v3, :done

    const/16 v6, 0x2710

    if-gt v3, v6, :done

    invoke-static {v2, v4, v5}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->makeKey(Ljava/lang/String;J)Ljava/lang/String;

    move-result-object v3

    sget-object v4, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->dismissedKey:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :done

    sput-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    invoke-static {v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->makeCandidate(Ljava/lang/String;)Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    move-result-object v0

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    :done
    return-void
.end method

.method public static decorateCandidates(Ljava/util/List;)Ljava/util/List;
    .locals 5

    sget-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    if-eqz v0, :unchanged

    if-eqz p0, :copy

    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-nez v1, :copy

    # A real engine candidate cycle always wins. Clipboard is an idle-state
    # affordance, never candidate zero while composing text.
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :scan
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :ordinary_candidates

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    iget-object v2, v2, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;->a:Ljava/lang/Object;

    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :scan

    check-cast v2, Ljava/lang/String;

    const-string v3, "compat_clipboard:"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :scan

    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-eqz v1, :return_existing

    const/4 v2, 0x0

    iput-boolean v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    iput-boolean v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->normalCandidatesActive:Z

    :return_existing
    return-object p0

    :ordinary_candidates
    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-eqz v1, :unchanged

    iput-boolean v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    const/4 v0, 0x1

    iput-boolean v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->normalCandidatesActive:Z

    return-object p0

    :copy
    new-instance v1, Ljava/util/ArrayList;

    if-eqz p0, :empty

    invoke-direct {v1, p0}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    goto :add

    :empty
    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    :add
    const/4 v2, 0x0

    invoke-virtual {v1, v2, v0}, Ljava/util/ArrayList;->add(ILjava/lang/Object;)V

    const/4 v0, 0x1

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    sget-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-eqz v3, :return_copy

    iput-boolean v2, v3, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    iput-boolean v2, v3, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->normalCandidatesActive:Z

    :return_copy
    return-object v1

    :unchanged
    return-object p0
.end method

.method public static candidatesUpdated()V
    .locals 4

    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-eqz v1, :done

    const/4 v0, 0x1

    iput-boolean v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    iget-object v0, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->handler:Landroid/os/Handler;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const-wide/16 v2, 0x64

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    :done
    return-void
.end method

.method public static handleSelection(Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;)Z
    .locals 4

    const/4 v0, 0x0

    if-eqz p1, :not_compat

    iget-object v1, p1, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;->a:Ljava/lang/Object;

    instance-of v2, v1, Ljava/lang/String;

    if-eqz v2, :not_compat

    check-cast v1, Ljava/lang/String;

    const-string v2, "compat_clipboard:"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :not_compat

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v1

    sget-object v2, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    sput-object v2, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->dismissedKey:Ljava/lang/String;

    const/4 v2, 0x0

    sput-object v2, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    sput-object v2, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    const/4 v2, 0x1

    invoke-virtual {p0, v1, v0, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->commitText(Ljava/lang/CharSequence;ZI)V

    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    return v2

    :not_compat
    return v0
.end method

.method public static decorateView(Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;)V
    .locals 8

    const v0, 0x7f0f0183

    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/AutoSizeTextView;

    if-eqz v0, :decorate_done

    # Fixed candidate views are recycled. Restore native label state before
    # checking whether this slot is the idle clipboard candidate.
    const/4 v1, 0x0

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setCompoundDrawables(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setMinHeight(I)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    const v2, 0x7fffffff

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setMaxWidth(I)V

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setElevation(F)V

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setTranslationZ(F)V

    const/16 v2, 0x11

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const v3, 0x7f0d0200

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v3

    const v4, 0x7f0d0201

    invoke-virtual {v2, v4}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v4

    invoke-virtual {v0, v3, v1, v4, v1}, Landroid/widget/TextView;->setPadding(IIII)V

    const v3, 0x7f0d0214

    invoke-virtual {v2, v3}, Landroid/content/res/Resources;->getDimension(I)F

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTag(Ljava/lang/Object;)V

    const v2, 0x7f0f0013

    invoke-virtual {p0, v2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewById(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :find_clipboard_left_separator

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    :find_clipboard_left_separator
    const-string v5, "compat_clipboard_left_separator"

    invoke-virtual {p0, v5}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v5

    if-eqz v5, :find_clipboard_right_separator

    const/16 v6, 0x8

    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :find_clipboard_right_separator
    const-string v6, "compat_clipboard_right_separator"

    invoke-virtual {p0, v6}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v6

    if-eqz v6, :inspect_candidate

    const/16 v7, 0x8

    invoke-virtual {v6, v7}, Landroid/view/View;->setVisibility(I)V

    :inspect_candidate
    if-eqz p1, :decorate_done

    iget-object v3, p1, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;->a:Ljava/lang/Object;

    instance-of v4, v3, Ljava/lang/String;

    if-eqz v4, :decorate_done

    check-cast v3, Ljava/lang/String;

    const-string v4, "compat_clipboard:"

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :decorate_done

    const-string v3, "compat_clipboard_candidate"

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setTag(Ljava/lang/Object;)V

    sget-object v3, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    # Keep native 21sp typography: cap the visible label at 200dp and disable
    # AutoSizeTextView's horizontal shrinking so overflow is ellipsized instead.
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->getResources()Landroid/content/res/Resources;

    move-result-object v3

    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v3

    iget v3, v3, Landroid/util/DisplayMetrics;->density:F

    const/high16 v4, 0x43480000    # 200.0f

    mul-float/2addr v3, v4

    float-to-int v3, v3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setMaxWidth(I)V

    const/high16 v3, 0x3f800000    # 1.0f

    invoke-virtual {v0, v3}, Lavk;->a(F)V

    # Two dedicated, identical header-style dividers live in the wrap-sized
    # candidate. Do not overlap the native last-candidate divider: the native
    # holder may hide it later, while these tagged views remain deterministic.
    if-eqz v2, :show_clipboard_left_separator

    const/16 v3, 0x8

    invoke-virtual {v2, v3}, Landroid/view/View;->setVisibility(I)V

    :show_clipboard_left_separator
    if-eqz v5, :show_clipboard_right_separator

    invoke-virtual {v5, v1}, Landroid/view/View;->setVisibility(I)V

    :show_clipboard_right_separator
    if-eqz v6, :sync_dismiss_color

    invoke-virtual {v6, v1}, Landroid/view/View;->setVisibility(I)V

    :sync_dismiss_color
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->getRootView()Landroid/view/View;

    move-result-object v3

    const-string v4, "compat_clipboard_dismiss_symbol"

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v3

    instance-of v4, v3, Landroid/widget/TextView;

    if-eqz v4, :decorate_done

    check-cast v3, Landroid/widget/TextView;

    invoke-virtual {v0}, Landroid/widget/TextView;->getTextColors()Landroid/content/res/ColorStateList;

    move-result-object v4

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(Landroid/content/res/ColorStateList;)V

    :decorate_done
    return-void
.end method

.method private static syncSeparatorAppearance(Landroid/view/View;Landroid/view/View;)V
    .locals 4

    instance-of v0, p0, Landroid/widget/ImageView;

    if-eqz v0, :sync_separator_done

    instance-of v0, p1, Landroid/widget/ImageView;

    if-eqz v0, :sync_separator_done

    check-cast p0, Landroid/widget/ImageView;

    check-cast p1, Landroid/widget/ImageView;

    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    if-eqz v0, :copy_separator_state

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v1

    if-eqz v1, :use_source_drawable

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    :use_source_drawable
    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    :copy_separator_state
    invoke-virtual {p0}, Landroid/widget/ImageView;->getImageTintList()Landroid/content/res/ColorStateList;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageTintList(Landroid/content/res/ColorStateList;)V

    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v0

    invoke-virtual {p1}, Landroid/widget/ImageView;->getDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    if-eqz v0, :copy_separator_alpha

    if-eqz v1, :copy_separator_alpha

    invoke-virtual {v0}, Landroid/graphics/drawable/Drawable;->getColorFilter()Landroid/graphics/ColorFilter;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/graphics/drawable/Drawable;->setColorFilter(Landroid/graphics/ColorFilter;)V

    :copy_separator_alpha
    invoke-virtual {p0}, Landroid/widget/ImageView;->getImageAlpha()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setImageAlpha(I)V

    invoke-virtual {p0}, Landroid/widget/ImageView;->getAlpha()F

    move-result v0

    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setAlpha(F)V

    invoke-virtual {p0}, Landroid/widget/ImageView;->getDrawableState()[I

    move-result-object v0

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/widget/ImageView;->setImageState([IZ)V

    :sync_separator_done
    return-void
.end method

.method private static alignDismissToRightColumn(Landroid/view/View;Landroid/view/View;)V
    .locals 8

    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v0

    # QWERTY delete is the preferred geometric reference. Nine-key layouts use
    # their right-panel cursor key; the prime-header voice key is a final fallback.
    const v1, 0x7f0f00b4

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :find_cursor_reference

    invoke-virtual {v1}, Landroid/view/View;->isShown()Z

    move-result v2

    if-eqz v2, :find_cursor_reference

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v2

    if-lez v2, :find_cursor_reference

    goto :have_reference

    :find_cursor_reference
    const v1, 0x7f0f00e5

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :find_voice_reference

    invoke-virtual {v1}, Landroid/view/View;->isShown()Z

    move-result v2

    if-eqz v2, :find_voice_reference

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v2

    if-lez v2, :find_voice_reference

    goto :have_reference

    :find_voice_reference
    const v1, 0x7f0f00e1

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    if-eqz v1, :align_done

    invoke-virtual {v1}, Landroid/view/View;->isShown()Z

    move-result v2

    if-eqz v2, :align_done

    invoke-virtual {v1}, Landroid/view/View;->getWidth()I

    move-result v2

    if-lez v2, :align_done

    :have_reference
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    iget v3, v3, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v3, :use_measured_dismiss_width

    goto :have_dismiss_width

    :use_measured_dismiss_width
    invoke-virtual {p1}, Landroid/view/View;->getMeasuredWidth()I

    move-result v3

    if-lez v3, :use_laid_out_dismiss_width

    goto :have_dismiss_width

    :use_laid_out_dismiss_width
    invoke-virtual {p1}, Landroid/view/View;->getWidth()I

    move-result v3

    if-lez v3, :align_done

    :have_dismiss_width
    const/4 v4, 0x2

    new-array v5, v4, [I

    new-array v6, v4, [I

    invoke-virtual {v1, v5}, Landroid/view/View;->getLocationInWindow([I)V

    invoke-virtual {p0, v6}, Landroid/view/View;->getLocationInWindow([I)V

    const/4 v4, 0x0

    aget v5, v5, v4

    div-int/lit8 v2, v2, 0x2

    add-int/2addr v5, v2

    aget v6, v6, v4

    sub-int/2addr v5, v6

    div-int/lit8 v3, v3, 0x2

    sub-int/2addr v5, v3

    invoke-virtual {p0}, Landroid/view/View;->getPaddingLeft()I

    move-result v2

    sub-int/2addr v5, v2

    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    instance-of v3, v2, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v3, :align_done

    check-cast v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, 0x3

    iput v3, v2, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    iput v5, v2, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    iput v4, v2, Landroid/widget/FrameLayout$LayoutParams;->rightMargin:I

    invoke-virtual {p1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :align_done
    return-void
.end method

.method public static centerSingleClipboardCandidate(Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;)V
    .locals 8

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getChildCount()I

    move-result v0

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v6, 0x0

    :scan_children
    if-ge v1, v0, :choose_gravity

    invoke-virtual {p0, v1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getChildAt(I)Landroid/view/View;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/View;->getVisibility()I

    move-result v5

    if-eqz v5, :visible_child

    goto :next_child

    :visible_child
    add-int/lit8 v2, v2, 0x1

    move-object v3, v4

    const v5, 0x7f0f0183

    invoke-virtual {v4, v5}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v5

    if-eqz v5, :next_child

    invoke-virtual {v5}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v5

    const-string v4, "compat_clipboard_candidate"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :next_child

    const/4 v6, 0x1

    :next_child
    add-int/lit8 v1, v1, 0x1

    goto :scan_children

    :choose_gravity
    # This runs after the holder's last-column decoration. Reassert the two
    # clipboard dividers and suppress the native divider deterministically.
    if-eqz v6, :select_gravity

    if-eqz v3, :select_gravity

    const v4, 0x7f0f0013

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    move-object v7, v4

    if-eqz v4, :find_rendered_separator_source

    const/16 v5, 0x8

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :find_rendered_separator_source
    # Prefer the original show-more key's divider: unlike injected candidate
    # children, it is guaranteed to have passed through the live theme engine.
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v4

    const v5, 0x7f0f0149

    invoke-virtual {v4, v5}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :force_left_separator

    const-string v5, ".divider.vertical.for-candidate-key"

    invoke-virtual {v4, v5}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :force_left_separator

    move-object v7, v4

    :force_left_separator
    const-string v4, "compat_clipboard_left_separator"

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :force_right_separator

    invoke-static {v7, v4}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->syncSeparatorAppearance(Landroid/view/View;Landroid/view/View;)V

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :force_right_separator
    const-string v4, "compat_clipboard_right_separator"

    invoke-virtual {v3, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :select_gravity

    invoke-static {v7, v4}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->syncSeparatorAppearance(Landroid/view/View;Landroid/view/View;)V

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :select_gravity
    const v0, 0x800003

    const/4 v1, 0x1

    if-ne v2, v1, :apply_gravity

    if-eqz v6, :apply_gravity

    move v0, v1

    :apply_gravity
    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->setGravity(I)V

    # Constrain the clipboard holder between two equal 45dp side slots. This
    # makes TextView's END ellipsis stop before the right divider and keeps the
    # visible paste area geometrically centered despite the dismiss control.
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v1, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v1, :find_dismiss_parent

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, 0x0

    if-eqz v6, :apply_side_margins

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const v2, 0x7f0d0206

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result v1

    :apply_side_margins
    iget v2, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    iget v3, v0, Landroid/widget/FrameLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v0, v1, v2, v1, v3}, Landroid/widget/FrameLayout$LayoutParams;->setMargins(IIII)V

    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :find_dismiss_parent
    # Overlay the dismiss control at the native expand-arrow position. It is a
    # sibling above SoftKeyView, so it receives a normal click without changing
    # the keyboard's existing TOGGLE_SHOW_MORE_CANDIDATES key definition.
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v4, v2, Landroid/view/View;

    if-eqz v4, :center_done

    check-cast v2, Landroid/view/View;

    move-object v7, v2

    const-string v4, "compat_clipboard_dismiss"

    invoke-virtual {v2, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :center_done

    if-eqz v6, :hide_dismiss

    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V

    const-string v4, "compat_clipboard_left_reserve"

    invoke-virtual {v7, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :find_show_more

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v4}, Landroid/view/View;->bringToFront()V

    :find_show_more
    const v4, 0x7f0f0149

    invoke-virtual {v7, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :attach_dismiss

    # Copy the native show-more key's measured outer width. It includes the
    # divider column plus the 45dp key host, matching the voice/right key axis.
    invoke-virtual {v4}, Landroid/view/View;->getMeasuredWidth()I

    move-result v5

    if-gtz v5, :apply_native_show_more_width

    invoke-virtual {v4}, Landroid/view/View;->getWidth()I

    move-result v5

    :apply_native_show_more_width
    if-lez v5, :hide_native_show_more

    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    iput v5, v0, Landroid/view/ViewGroup$LayoutParams;->width:I

    invoke-virtual {v2, v0}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :hide_native_show_more
    invoke-static {v7, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->alignDismissToRightColumn(Landroid/view/View;Landroid/view/View;)V

    const/4 v5, 0x4

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :attach_dismiss
    sget-object v4, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    invoke-virtual {v2, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v2}, Landroid/view/View;->bringToFront()V

    goto :center_done

    :hide_dismiss
    const/16 v4, 0x8

    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V

    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const-string v4, "compat_clipboard_left_reserve"

    invoke-virtual {v7, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :restore_show_more

    const/16 v5, 0x8

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :restore_show_more
    const v4, 0x7f0f0149

    invoke-virtual {v7, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :center_done

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :center_done
    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 5

    if-eqz p1, :click_done

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v0

    const-string v1, "compat_clipboard_dismiss"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :click_done

    # Reuse Google Pinyin's own feedback controller so the close action obeys
    # keyboard sound, vibration, duration and volume preferences exactly.
    new-instance v4, Laue;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-direct {v4, v3}, Laue;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v4, p1, v3}, Laue;->a(Landroid/view/View;Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;)V

    invoke-virtual {v4}, Laue;->a()V

    sget-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->dismissedKey:Ljava/lang/String;

    const/4 v0, 0x0

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    sput-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidateKey:Ljava/lang/String;

    const/4 v1, 0x0

    sput-boolean v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    const/16 v2, 0x8

    invoke-virtual {p1, v2}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {p1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v3, v2, Landroid/view/View;

    if-eqz v3, :notify_dismiss

    check-cast v2, Landroid/view/View;

    const-string v3, "compat_clipboard_left_reserve"

    invoke-virtual {v2, v3}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v3

    if-eqz v3, :restore_arrow_after_click

    const/16 v0, 0x8

    invoke-virtual {v3, v0}, Landroid/view/View;->setVisibility(I)V

    :restore_arrow_after_click
    const v3, 0x7f0f0149

    invoke-virtual {v2, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :notify_dismiss

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    :notify_dismiss
    iget-object v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->service:Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    invoke-virtual {v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->a()Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;

    move-result-object v2

    if-eqz v2, :click_done

    invoke-virtual {v2, v1}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    :click_done
    return-void
.end method

.method public onPrimaryClipChanged()V
    .locals 4

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->refresh()V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingCandidateReset:Z

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->handler:Landroid/os/Handler;

    invoke-virtual {v0, p0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const-wide/16 v1, 0x96

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method public run()V
    .locals 4

    sget-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->current:Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;

    if-ne v0, p0, :done

    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->service:Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;

    invoke-virtual {v1}, Lcom/google/android/apps/inputmethod/libs/framework/core/GoogleInputMethodService;->a()Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;

    move-result-object v1

    if-eqz v1, :done

    sget-object v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->candidate:Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;

    iget-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingCandidateReset:Z

    if-eqz v2, :idle_restore

    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingCandidateReset:Z

    # A clipboard change while composing updates the retained idle candidate but
    # must not clear or replace the engine's active candidate cycle.
    iget-boolean v3, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->normalCandidatesActive:Z

    if-nez v3, :done

    if-eqz v0, :clear_candidates

    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    goto :append

    :clear_candidates
    invoke-virtual {v1, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    goto :done

    :idle_restore
    iget-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    if-eqz v2, :done

    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingIdleRestore:Z

    iput-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->normalCandidatesActive:Z

    :append
    if-eqz v0, :done

    const/4 v2, 0x0

    sput-boolean v2, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    invoke-static {v0}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v0

    const/4 v3, 0x0

    invoke-virtual {v1, v0, v3, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->appendTextCandidates(Ljava/util/List;Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;Z)V

    :done
    return-void
.end method
