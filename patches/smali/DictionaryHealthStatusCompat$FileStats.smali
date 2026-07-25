.class final Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "FileStats"
.end annotation


# instance fields
.field final backup:Z

.field final backupBytes:J

.field final main:Z

.field final mainBytes:J

.field final modified:J

.field final temporary:Z

.field final unreadable:Z


# direct methods
.method constructor <init>(ZJJZJZZ)V
    .registers 11

    .line 171
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 172
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->main:Z

    iput-wide p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->mainBytes:J

    iput-wide p4, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->modified:J

    iput-boolean p6, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backup:Z

    iput-wide p7, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->backupBytes:J

    .line 173
    iput-boolean p9, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->temporary:Z

    iput-boolean p10, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$FileStats;->unreadable:Z

    .line 174
    return-void
.end method
