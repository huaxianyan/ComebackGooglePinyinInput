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

.field public final key:Ljava/lang/String;

.field public final phrase:Ljava/lang/String;

.field public final source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;)V
    .locals 0

    .line 174
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 175
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->key:Ljava/lang/String;

    .line 176
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->code:Ljava/lang/String;

    .line 177
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->phrase:Ljava/lang/String;

    .line 178
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncCore$CanonicalEntry;->source:Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    .line 179
    return-void
.end method
