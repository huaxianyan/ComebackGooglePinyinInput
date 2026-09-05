.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;
.super Ljava/lang/Object;
.source "RimeSyncSafStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "DocumentInfo"
.end annotation


# instance fields
.field public final displayName:Ljava/lang/String;

.field public final documentId:Ljava/lang/String;

.field public final mimeType:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 408
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 409
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->documentId:Ljava/lang/String;

    .line 410
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->displayName:Ljava/lang/String;

    .line 411
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSafStore$DocumentInfo;->mimeType:Ljava/lang/String;

    .line 412
    return-void
.end method
