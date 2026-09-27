.class public final Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;
.super Ljava/lang/Object;
.source "PairedPunctuationProcessor.java"

# interfaces
.implements Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessor;


# static fields
.field public static final a:Ljava/lang/String; = "enable_paired_punctuation_completion"


# instance fields
.field private a:Z

.field private a:Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;


# direct methods
.method public constructor <init>()V
    .locals 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Z

    return-void
.end method

.method private static a(Ljava/lang/String;)Ljava/lang/String;
    .locals 1

    const-string v0, "("

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, ")"

    return-object v0

    :cond_0
    const-string v0, "["

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const-string v0, "]"

    return-object v0

    :cond_1
    const-string v0, "{"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "}"

    return-object v0

    :cond_2
    const-string v0, "<"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    const-string v0, ">"

    return-object v0

    :cond_3
    const-string v0, "（"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const-string v0, "）"

    return-object v0

    :cond_4
    const-string v0, "［"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    const-string v0, "］"

    return-object v0

    :cond_5
    const-string v0, "｛"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    const-string v0, "｝"

    return-object v0

    :cond_6
    const-string v0, "〈"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const-string v0, "〉"

    return-object v0

    :cond_7
    const-string v0, "《"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8

    const-string v0, "》"

    return-object v0

    :cond_8
    const-string v0, "【"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_9

    const-string v0, "】"

    return-object v0

    :cond_9
    const-string v0, "〔"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_a

    const-string v0, "〕"

    return-object v0

    :cond_a
    const-string v0, "‘"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    const-string v0, "’"

    return-object v0

    :cond_b
    const-string v0, "“"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_c

    const-string v0, "”"

    return-object v0

    :cond_c
    const/4 v0, 0x0

    return-object v0
.end method


# virtual methods
.method public doProcess(Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;)Z
    .locals 9

    const/4 v6, 0x0

    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Z

    if-eqz v0, :cond_fail

    if-eqz p1, :cond_fail

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;

    if-nez v0, :cond_type

    :cond_fail
    return v6

    :cond_type
    iget-object v0, p1, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;->a:Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$b;

    sget-object v1, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$b;->HANDLE_EVENT:Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$b;

    if-eq v0, v1, :cond_event

    return v6

    :cond_event
    iget-object v0, p1, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/Event;

    if-nez v0, :cond_keys

    return v6

    :cond_keys
    iget-object v1, v0, Lcom/google/android/apps/inputmethod/libs/framework/core/Event;->a:[Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;

    if-nez v1, :cond_count

    return v6

    :cond_count
    array-length v2, v1

    if-gtz v2, :cond_key

    return v6

    :cond_key
    aget-object v1, v1, v6

    if-nez v1, :cond_intent

    return v6

    :cond_intent
    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    sget-object v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;->COMMIT:Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData$a;

    if-eq v2, v3, :cond_object

    return v6

    :cond_object
    iget-object v2, v1, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyData;->a:Ljava/lang/Object;

    instance-of v3, v2, Ljava/lang/String;

    if-nez v3, :cond_length

    return v6

    :cond_length
    check-cast v2, Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v3

    const/4 v4, 0x1

    if-eq v3, v4, :cond_pair

    return v6

    :cond_pair
    invoke-static {v2}, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v3

    if-nez v3, :cond_build

    return v6

    :cond_build
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;

    sget-object v4, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$a;->NONE:Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$a;

    const/4 v5, 0x0

    const/4 v7, 0x1

    invoke-static {v2, v4, v5, v7, p0}, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;->a(Ljava/lang/CharSequence;Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage$a;ZILjava/lang/Object;)Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;

    move-result-object v2

    invoke-interface {v3, v2}, Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;->processMessage(Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;)Z

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;

    const/4 v3, -0x1

    const/4 v8, -0x1

    invoke-static {v3, v8, p0}, Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;->a(IILjava/lang/Object;)Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;

    move-result-object v3

    invoke-interface {v2, v3}, Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;->processMessage(Lcom/google/android/apps/inputmethod/libs/framework/ime/ProcessMessage;)Z

    const/4 v0, 0x1

    return v0
.end method

.method public initialize(Landroid/content/Context;Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;Lcom/google/android/apps/inputmethod/libs/framework/core/metadata/ImeDef;)V
    .locals 3

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Lcom/google/android/apps/inputmethod/libs/framework/ime/IImeProcessorDelegate;

    if-nez p1, :cond_context

    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Z

    return-void

    :cond_context
    invoke-static {p1}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "enable_paired_punctuation_completion"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/pairauto/PairedPunctuationProcessor;->a:Z

    return-void
.end method

.method public shouldHandle(Lcom/google/android/apps/inputmethod/libs/framework/core/Event;)Z
    .locals 1

    const/4 v0, 0x0

    return v0
.end method
