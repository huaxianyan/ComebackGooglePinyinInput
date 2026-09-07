.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;
.super Ljava/lang/Object;
.source "RimeSyncStateStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Profile"
.end annotation


# instance fields
.field public final bridgeUserId:Ljava/lang/String;

.field public final deviceDirectoryName:Ljava/lang/String;

.field public final generation:J

.field private final hashSalt:[B

.field public final lastSuccess:J

.field public final nativeActualCount:I

.field public final nativeExpectedCount:I

.field private final nativeFailureFingerprint:[B

.field public final nativeFailureKind:I

.field public final nativeFailureRepeated:Z

.field public final nativeMissingCount:I

.field public final phase:I

.field public final protocolVersion:I

.field public final rootUri:Ljava/lang/String;

.field public final snapshotFileName:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;[BIJIJIII[BZI)V
    .locals 0

    .line 655
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 656
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->rootUri:Ljava/lang/String;

    .line 657
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->deviceDirectoryName:Ljava/lang/String;

    .line 658
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->snapshotFileName:Ljava/lang/String;

    .line 659
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->bridgeUserId:Ljava/lang/String;

    .line 660
    invoke-virtual {p5}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->hashSalt:[B

    .line 661
    iput p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->protocolVersion:I

    .line 662
    iput-wide p7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->generation:J

    .line 663
    iput p9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->phase:I

    .line 664
    iput-wide p10, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->lastSuccess:J

    .line 665
    iput p12, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeExpectedCount:I

    .line 666
    iput p13, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeActualCount:I

    .line 667
    iput p14, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeMissingCount:I

    .line 668
    if-nez p15, :cond_0

    .line 669
    const/4 p1, 0x0

    goto :goto_0

    :cond_0
    invoke-virtual {p15}, [B->clone()Ljava/lang/Object;

    move-result-object p1

    check-cast p1, [B

    :goto_0
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureFingerprint:[B

    .line 670
    move/from16 p1, p16

    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureRepeated:Z

    .line 671
    move/from16 p1, p17

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureKind:I

    .line 672
    return-void
.end method

.method static synthetic access$000(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B
    .locals 0

    .line 634
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->hashSalt:[B

    return-object p0
.end method

.method static synthetic access$300(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;)[B
    .locals 0

    .line 634
    iget-object p0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncStateStore$Profile;->nativeFailureFingerprint:[B

    return-object p0
.end method
