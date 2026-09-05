.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;
.super Ljava/lang/Object;
.source "RimeSyncCore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "CanonicalEntry"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final commits:I

.field public final key:Ljava/lang/String;

.field public final phrase:Ljava/lang/String;

.field public final source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;


# direct methods
.method constructor <init>(I)V
    .locals 1

    .line 219
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 220
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->key:Ljava/lang/String;

    .line 221
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->code:Ljava/lang/String;

    .line 222
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->phrase:Ljava/lang/String;

    .line 223
    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 224
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->commits:I

    .line 225
    return-void
.end method

.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;)V
    .locals 0

    .line 211
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 212
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->key:Ljava/lang/String;

    .line 213
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->code:Ljava/lang/String;

    .line 214
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->phrase:Ljava/lang/String;

    .line 215
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 216
    iget p1, p4, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->commits:I

    .line 217
    return-void
.end method
