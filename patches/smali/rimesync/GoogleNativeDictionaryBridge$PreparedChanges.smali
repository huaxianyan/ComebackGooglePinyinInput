.class final Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;
.super Ljava/lang/Object;
.source "GoogleNativeDictionaryBridge.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "PreparedChanges"
.end annotation


# instance fields
.field final adds:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;"
        }
    .end annotation
.end field

.field final deletes:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>(Ljava/util/List;Ljava/util/List;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$GoogleEntry;",
            ">;",
            "Ljava/util/List<",
            "Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$Change;",
            ">;)V"
        }
    .end annotation

    .line 536
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 537
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->deletes:Ljava/util/List;

    .line 538
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/GoogleNativeDictionaryBridge$PreparedChanges;->adds:Ljava/util/List;

    .line 539
    return-void
.end method
