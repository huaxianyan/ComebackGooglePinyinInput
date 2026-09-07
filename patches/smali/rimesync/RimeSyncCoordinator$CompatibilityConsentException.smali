.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator$CompatibilityConsentException;
.super Ljava/io/IOException;
.source "RimeSyncCoordinator.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCoordinator;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CompatibilityConsentException"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 134
    const-string v0, "compatibility policy approval is required"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    return-void
.end method
