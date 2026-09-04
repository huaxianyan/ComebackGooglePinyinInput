.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;
.super Ljava/lang/Object;
.source "RimeSyncSafStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "SnapshotDocument"
.end annotation


# instance fields
.field public final bridgeOwned:Z

.field public final deviceDirectoryName:Ljava/lang/String;

.field public final uri:Landroid/net/Uri;


# direct methods
.method constructor <init>(Ljava/lang/String;Landroid/net/Uri;Z)V
    .locals 0

    .line 350
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 351
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->deviceDirectoryName:Ljava/lang/String;

    .line 352
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->uri:Landroid/net/Uri;

    .line 353
    iput-boolean p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$SnapshotDocument;->bridgeOwned:Z

    .line 354
    return-void
.end method
