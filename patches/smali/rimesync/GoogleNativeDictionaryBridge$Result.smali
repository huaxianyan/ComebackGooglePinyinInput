.class public final Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;
.super Ljava/lang/Object;
.source "GoogleNativeDictionaryBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Result"
.end annotation


# instance fields
.field public final addedCount:I

.field public final deletedCount:I

.field public final persisted:Z

.field public final totalEntryCount:I


# direct methods
.method constructor <init>(IIIZ)V
    .locals 0

    .line 511
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 512
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->totalEntryCount:I

    .line 513
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->addedCount:I

    .line 514
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->deletedCount:I

    .line 515
    iput-boolean p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Result;->persisted:Z

    .line 516
    return-void
.end method
