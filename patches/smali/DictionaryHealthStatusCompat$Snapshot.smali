.class public final Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;
.super Ljava/lang/Object;
.source "DictionaryHealthStatusCompat.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Snapshot"
.end annotation


# instance fields
.field public final details:Ljava/lang/String;

.field public final status:I

.field public final summary:Ljava/lang/String;


# direct methods
.method constructor <init>(ILjava/lang/String;Ljava/lang/String;)V
    .locals 0

    .line 28
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 29
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;->status:I

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;->summary:Ljava/lang/String;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Snapshot;->details:Ljava/lang/String;

    .line 30
    return-void
.end method
