.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;
.super Ljava/lang/Object;
.source "RimeSyncSafStore.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;->listSnapshots()Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;)V
    .locals 0

    .line 72
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)I
    .locals 0

    .line 74
    iget-object p1, p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->deviceDirectoryName:Ljava/lang/String;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->deviceDirectoryName:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result p1

    return p1
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 72
    check-cast p1, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    check-cast p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;

    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$1;->compare(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;)I

    move-result p1

    return p1
.end method
