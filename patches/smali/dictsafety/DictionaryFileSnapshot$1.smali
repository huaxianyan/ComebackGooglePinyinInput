.class Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot$1;
.super Ljava/lang/Object;
.source "DictionaryFileSnapshot.java"

# interfaces
.implements Ljava/util/Comparator;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;->snapshots()Ljava/util/List;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Object;",
        "Ljava/util/Comparator<",
        "Ljava/io/File;",
        ">;"
    }
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;)V
    .locals 0

    .line 161
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot$1;->this$0:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public compare(Ljava/io/File;Ljava/io/File;)I
    .locals 2

    .line 163
    invoke-virtual {p2}, Ljava/io/File;->lastModified()J

    move-result-wide v0

    invoke-virtual {p1}, Ljava/io/File;->lastModified()J

    move-result-wide p1

    sub-long/2addr v0, p1

    invoke-static {v0, v1}, Ljava/lang/Long;->signum(J)I

    move-result p1

    return p1
.end method

.method public bridge synthetic compare(Ljava/lang/Object;Ljava/lang/Object;)I
    .locals 0

    .line 161
    check-cast p1, Ljava/io/File;

    check-cast p2, Ljava/io/File;

    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionaryFileSnapshot$1;->compare(Ljava/io/File;Ljava/io/File;)I

    move-result p1

    return p1
.end method
