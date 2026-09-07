.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$IdentityConflictException;
.super Ljava/lang/IllegalArgumentException;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "IdentityConflictException"
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 155
    const-string v0, "selected directory belongs to a different Bridge identity"

    invoke-direct {p0, v0}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    .line 156
    return-void
.end method
