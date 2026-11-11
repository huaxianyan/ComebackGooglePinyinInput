.class public final Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;
.super Ljava/lang/Object;
.source "DictionarySafetyStore.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "StoredSnapshot"
.end annotation


# instance fields
.field public final file:Ljava/io/File;

.field public final snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;


# direct methods
.method constructor <init>(Ljava/io/File;Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;)V
    .locals 0

    .line 186
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 187
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->file:Ljava/io/File;

    .line 188
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyStore$StoredSnapshot;->snapshot:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetySnapshot;

    .line 189
    return-void
.end method
