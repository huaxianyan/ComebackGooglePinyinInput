.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryBackupText$Entry;
.super Ljava/lang/Object;
.source "DictionaryBackupText.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryBackupText;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Entry"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final count:I

.field public final phrase:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryBackupText$Entry;->phrase:Ljava/lang/String;

    .line 30
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryBackupText$Entry;->code:Ljava/lang/String;

    .line 31
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryBackupText$Entry;->count:I

    .line 32
    return-void
.end method
