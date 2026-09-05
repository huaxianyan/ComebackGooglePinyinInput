.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
.super Ljava/lang/Object;
.source "RimeUserDbSnapshot.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Entry"
.end annotation


# instance fields
.field public final code:Ljava/lang/String;

.field public final commits:I

.field public final dee:D

.field public final phrase:Ljava/lang/String;

.field public final tick:J


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;IDJ)V
    .locals 2

    .line 218
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 219
    if-eqz p1, :cond_1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_1

    if-eqz p2, :cond_1

    invoke-virtual {p2}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_1

    .line 222
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    invoke-virtual {p1, v0}, Ljava/lang/String;->charAt(I)C

    move-result v0

    const/16 v1, 0x20

    if-ne v0, v1, :cond_0

    goto :goto_0

    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_0
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    .line 223
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    .line 224
    iput p3, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    .line 225
    const-wide p1, 0x40c3880000000000L    # 10000.0

    invoke-static {p1, p2, p4, p5}, Ljava/lang/Math;->min(DD)D

    move-result-wide p1

    iput-wide p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    .line 226
    iput-wide p6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    .line 227
    return-void

    .line 220
    :cond_1
    new-instance p1, Ljava/lang/IllegalArgumentException;

    const-string p2, "Rime entry key must not be empty"

    invoke-direct {p1, p2}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw p1
.end method

.method static synthetic access$000(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
    .locals 0
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 211
    invoke-static {p0, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$100(Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;J)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
    .locals 0

    .line 211
    invoke-direct {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->atTick(J)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-result-object p0

    return-object p0
.end method

.method private atTick(J)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
    .locals 11

    .line 238
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    cmp-long v2, v0, p1

    if-ltz v2, :cond_0

    return-object p0

    .line 239
    :cond_0
    new-instance v3, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    iget v6, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    iget-wide v7, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    long-to-double v7, v7

    long-to-double p1, p1

    invoke-static {v7, v8}, Ljava/lang/Double;->isNaN(D)Z

    invoke-static {p1, p2}, Ljava/lang/Double;->isNaN(D)Z

    sub-double/2addr v7, p1

    const-wide/high16 p1, 0x4069000000000000L    # 200.0

    div-double/2addr v7, p1

    .line 240
    invoke-static {v7, v8}, Ljava/lang/Math;->exp(D)D

    move-result-wide p1

    mul-double v7, v0, p1

    iget-wide v9, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    invoke-direct/range {v3 .. v10}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;IDJ)V

    .line 239
    return-object v3
.end method

.method private static parse(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;
    .locals 17
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/io/IOException;
        }
    .end annotation

    .line 245
    move/from16 v1, p3

    .line 246
    nop

    .line 247
    nop

    .line 248
    const-string v0, " "

    move-object/from16 v2, p2

    invoke-virtual {v2, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    .line 250
    :try_start_0
    array-length v2, v0

    const/4 v3, 0x0

    const-wide/16 v4, 0x0

    const-wide/16 v6, 0x0

    move-wide v13, v4

    move-wide v15, v6

    const/4 v8, 0x0

    const/4 v12, 0x0

    :goto_0
    if-ge v8, v2, :cond_4

    aget-object v9, v0, v8

    .line 251
    const/16 v10, 0x3d

    invoke-virtual {v9, v10}, Ljava/lang/String;->indexOf(I)I

    move-result v10

    .line 252
    if-lez v10, :cond_3

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v11

    add-int/lit8 v11, v11, -0x1

    if-ne v10, v11, :cond_0

    goto :goto_1

    .line 253
    :cond_0
    invoke-virtual {v9, v3, v10}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v11

    .line 254
    add-int/lit8 v10, v10, 0x1

    invoke-virtual {v9, v10}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v9

    .line 255
    const-string v10, "c"

    invoke-virtual {v10, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_1

    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v12

    goto :goto_1

    .line 256
    :cond_1
    const-string v10, "d"

    invoke-virtual {v10, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_2

    invoke-static {v9}, Ljava/lang/Double;->parseDouble(Ljava/lang/String;)D

    move-result-wide v13

    goto :goto_1

    .line 257
    :cond_2
    const-string v10, "t"

    invoke-virtual {v10, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_3

    invoke-static {v9}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide v15
    :try_end_0
    .catch Ljava/lang/RuntimeException; {:try_start_0 .. :try_end_0} :catch_0

    .line 250
    :cond_3
    :goto_1
    add-int/lit8 v8, v8, 0x1

    goto :goto_0

    .line 261
    :cond_4
    nop

    .line 262
    invoke-static {v13, v14}, Ljava/lang/Double;->isNaN(D)Z

    move-result v0

    if-nez v0, :cond_5

    invoke-static {v13, v14}, Ljava/lang/Double;->isInfinite(D)Z

    move-result v0

    if-nez v0, :cond_5

    cmpg-double v0, v13, v4

    if-ltz v0, :cond_5

    cmp-long v0, v15, v6

    if-ltz v0, :cond_5

    .line 265
    new-instance v9, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;

    move-object/from16 v10, p0

    move-object/from16 v11, p1

    invoke-direct/range {v9 .. v16}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;-><init>(Ljava/lang/String;Ljava/lang/String;IDJ)V

    return-object v9

    .line 263
    :cond_5
    const-string v0, "entry value is out of range"

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->access$200(ILjava/lang/String;)Ljava/io/IOException;

    move-result-object v0

    throw v0

    .line 259
    :catch_0
    move-exception v0

    .line 260
    const-string v0, "invalid entry value"

    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot;->access$200(ILjava/lang/String;)Ljava/io/IOException;

    move-result-object v0

    goto :goto_3

    :goto_2
    throw v0

    :goto_3
    goto :goto_2
.end method


# virtual methods
.method public key()Ljava/lang/String;
    .locals 2

    .line 230
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->code:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const/16 v1, 0x9

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->phrase:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public pack()Ljava/lang/String;
    .locals 3

    .line 234
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "c="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->commits:I

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " d="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->dee:D

    invoke-static {v1, v2}, Ljava/lang/Double;->toString(D)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, " t="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    iget-wide v1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeUserDbSnapshot$Entry;->tick:J

    invoke-virtual {v0, v1, v2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method
