.class public final Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;
.super Ljava/lang/Object;
.source "GoogleNativeDictionaryBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "GoogleEntry"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final count:I

.field public final key:Ljava/lang/String;

.field public final phrase:Ljava/lang/String;

.field private final source:Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ILcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;)V
    .locals 0

    .line 429
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 430
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->key:Ljava/lang/String;

    .line 431
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->code:Ljava/lang/String;

    .line 432
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->phrase:Ljava/lang/String;

    .line 433
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->count:I

    .line 434
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->source:Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    .line 435
    return-void
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;)Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;
    .locals 0

    .line 421
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;->source:Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryAccessorInterface$Entry;

    return-object p0
.end method
