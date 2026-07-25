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

    # The clipboard candidate is a faithful paste operation. Only its visible
    # label is shortened below; the payload always remains the complete text.
    move-object v0, p0

    move-object v1, p0

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v2

    const/16 v3, 0x12

    if-gt v2, v3, :truncate

    goto :normalize

    :truncate
    const/4 v2, 0x0

    const/16 v3, 0x12

    invoke-virtual {v1, v2, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "..."

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :normalize
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

    sget-boolean v1, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

    if-nez v1, :unchanged

    if-eqz p0, :copy

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :scan
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :copy

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

    return-object v1

    :unchanged
    return-object p0
.end method

.method public static candidatesUpdated()V
    .locals 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->injected:Z

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

    check-cast v0, Landroid/widget/TextView;

    if-eqz v0, :decorate_done

    # Fixed candidate views are recycled. Restore only the native candidate
    # label state that the former chip renderer changed.
    const/4 v1, 0x0

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setCompoundDrawables(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setMinHeight(I)V

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

    # Restore the standard right separator and hide the clipboard-only left
    # separator before inspecting the recycled view's new Candidate.
    const v2, 0x7f0f0013

    invoke-virtual {p0, v2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewById(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :find_left_separator

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    :find_left_separator
    const-string v3, "compat_clipboard_left_separator"

    invoke-virtual {p0, v3}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v3

    if-eqz v3, :inspect_candidate

    const/16 v4, 0x8

    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V

    :inspect_candidate
    if-eqz p1, :decorate_done

    iget-object v4, p1, Lcom/google/android/apps/inputmethod/libs/framework/core/Candidate;->a:Ljava/lang/Object;

    instance-of v5, v4, Ljava/lang/String;

    if-eqz v5, :decorate_done

    check-cast v4, Ljava/lang/String;

    const-string v5, "compat_clipboard:"

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :decorate_done

    # Clipboard text now uses the untouched native candidate typography and
    # transparent key surface. Tags drive centering without visual heuristics.
    const-string v4, "compat_clipboard_candidate"

    invoke-virtual {v0, v4}, Landroid/widget/TextView;->setTag(Ljava/lang/Object;)V

    if-eqz v3, :keep_native_right_separator

    invoke-virtual {v3, v1}, Landroid/view/View;->setVisibility(I)V

    :keep_native_right_separator
    if-eqz v2, :decorate_done

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    :decorate_done
    return-void
.end method

.method public static centerSingleClipboardCandidate(Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;)V
    .locals 7

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
    const v0, 0x800003

    const/4 v1, 0x1

    if-ne v2, v1, :apply_gravity

    if-eqz v6, :apply_gravity

    move v0, v1

    :apply_gravity
    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->setGravity(I)V

    # Overlay the dismiss control at the native expand-arrow position. It is a
    # sibling above SoftKeyView, so it receives a normal click without changing
    # the keyboard's existing TOGGLE_SHOW_MORE_CANDIDATES key definition.
    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/FixedSizeCandidatesHolderView;->getParent()Landroid/view/ViewParent;

    move-result-object v2

    instance-of v4, v2, Landroid/view/View;

    if-eqz v4, :center_done

    check-cast v2, Landroid/view/View;

    move-object v5, v2

    const-string v4, "compat_clipboard_dismiss"

    invoke-virtual {v2, v4}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :center_done

    if-eqz v6, :hide_dismiss

    const/4 v4, 0x0

    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V

    const v4, 0x7f0f0149

    invoke-virtual {v5, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :attach_dismiss

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

    const v4, 0x7f0f0149

    invoke-virtual {v5, v4}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :center_done

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    :center_done
    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 4

    if-eqz p1, :click_done

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v0

    const-string v1, "compat_clipboard_dismiss"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :click_done

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

    if-eqz v2, :append

    const/4 v2, 0x0

    iput-boolean v2, p0, Lcom/google/android/apps/inputmethod/libs/framework/core/ClipboardCandidateCompat;->pendingCandidateReset:Z

    if-eqz v0, :clear_candidates

    const/4 v3, 0x1

    invoke-virtual {v1, v3}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    goto :append

    :clear_candidates
    invoke-virtual {v1, v2}, Lcom/google/android/apps/inputmethod/libs/framework/core/InputBundle;->textCandidatesUpdated(Z)V

    goto :done

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
