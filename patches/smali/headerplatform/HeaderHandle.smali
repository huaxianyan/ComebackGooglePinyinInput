.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;
.super Ljava/lang/Object;
.source "HeaderHandle.java"


# instance fields
.field private final token:J


# direct methods
.method constructor <init>(J)V
    .locals 3

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 8
    const-wide/16 v0, 0x0

    cmp-long v2, p1, v0

    if-lez v2, :cond_0

    .line 9
    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;->token:J

    .line 10
    return-void

    .line 8
    :cond_0
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "token must be positive"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method


# virtual methods
.method public getToken()J
    .locals 2

    .line 12
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;->token:J

    return-wide v0
.end method
