.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$IdentityConflictException;
.super Ljava/io/IOException;
.source "RimeSyncCore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "IdentityConflictException"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 17
    const-string v0, "Bridge snapshot user identity changed"

    invoke-direct {p0, v0}, Ljava/io/IOException;-><init>(Ljava/lang/String;)V

    return-void
.end method
