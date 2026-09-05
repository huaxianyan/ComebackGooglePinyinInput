.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;
.super Ljava/lang/Object;
.source "RimeSyncCore.java"

# interfaces
.implements Ljava/lang/Comparable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "DeviceSnapshot"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/lang/Comparable<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;",
        ">;"
    }
.end annotation


# instance fields
.field public final bridgeOwned:Z

.field public final snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

.field public final stableId:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;ZLcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;)V
    .locals 0

    .line 172
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 173
    if-eqz p1, :cond_0

    if-eqz p3, :cond_0

    .line 176
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->stableId:Ljava/lang/String;

    .line 177
    iput-boolean p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->bridgeOwned:Z

    .line 178
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;

    .line 179
    return-void

    .line 174
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime device snapshot is invalid"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public compareTo(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;)I
    .locals 1

    .line 182
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->stableId:Ljava/lang/String;

    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->stableId:Ljava/lang/String;

    invoke-virtual {v0, p1}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p1

    return p1
.end method

.method public bridge synthetic compareTo(Ljava/lang/Object;)I
    .locals 0

    .line 166
    check-cast p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;->compareTo(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$DeviceSnapshot;)I

    move-result p1

    return p1
.end method
