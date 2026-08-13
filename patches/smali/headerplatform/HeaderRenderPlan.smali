.class public final Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;
.super Ljava/lang/Object;
.source "HeaderRenderPlan.java"


# static fields
.field private static final IDLE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

.field private static final NATIVE_OWNED:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;


# instance fields
.field private final center:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

.field private final leading:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

.field private final nativeOwned:Z

.field private final renderGeneration:J

.field private final trailing:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;


# direct methods
.method static constructor <clinit>()V
    .locals 8

    .line 5
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v4, 0x0

    const-wide/16 v5, 0x0

    const/4 v1, 0x1

    const/4 v2, 0x0

    const/4 v3, 0x0

    invoke-direct/range {v0 .. v6}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->NATIVE_OWNED:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    .line 7
    new-instance v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    const/4 v5, 0x0

    const-wide/16 v6, 0x0

    const/4 v2, 0x0

    invoke-direct/range {v1 .. v7}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->IDLE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    return-void
.end method

.method public constructor <init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;)V
    .locals 7

    .line 18
    const-wide/16 v5, 0x0

    move-object v0, p0

    move v1, p1

    move-object v2, p2

    move-object v3, p3

    move-object v4, p4

    invoke-direct/range {v0 .. v6}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;-><init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V

    .line 19
    return-void
.end method

.method public constructor <init>(ZLcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;J)V
    .locals 0

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 23
    iput-boolean p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->nativeOwned:Z

    .line 24
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->center:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 25
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->leading:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 26
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->trailing:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    .line 27
    iput-wide p5, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->renderGeneration:J

    .line 28
    return-void
.end method

.method public static idle()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;
    .locals 1

    .line 31
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->IDLE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    return-object v0
.end method

.method public static nativeOwned()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;
    .locals 1

    .line 30
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->NATIVE_OWNED:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    return-object v0
.end method


# virtual methods
.method public getCenter()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
    .locals 1

    .line 33
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->center:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    return-object v0
.end method

.method public getLeading()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
    .locals 1

    .line 34
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->leading:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    return-object v0
.end method

.method public getRenderGeneration()J
    .locals 2

    .line 36
    iget-wide v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->renderGeneration:J

    return-wide v0
.end method

.method public getTrailing()Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;
    .locals 1

    .line 35
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->trailing:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    return-object v0
.end method

.method public isIdle()Z
    .locals 1

    .line 38
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->nativeOwned:Z

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->center:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->leading:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->trailing:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderContribution;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isNativeOwned()Z
    .locals 1

    .line 32
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;->nativeOwned:Z

    return v0
.end method
