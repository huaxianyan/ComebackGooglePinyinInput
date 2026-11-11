.class final Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "ExportFile"
.end annotation


# instance fields
.field final entryCount:I

.field final sha256:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;I)V
    .locals 0

    .line 312
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 313
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->sha256:Ljava/lang/String;

    .line 314
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupCompat$ExportFile;->entryCount:I

    .line 315
    return-void
.end method
