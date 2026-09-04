.class public Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;
.super Ljava/io/IOException;
.source "GoogleNativeDictionaryBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x9
    name = "NativeOperationException"
.end annotation


# instance fields
.field public final failureKind:I


# direct methods
.method constructor <init>(ILjava/lang/String;)V
    .locals 0

    .line 364
    invoke-direct {p0, p2}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    .line 365
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$NativeOperationException;->failureKind:I

    .line 366
    return-void
.end method
