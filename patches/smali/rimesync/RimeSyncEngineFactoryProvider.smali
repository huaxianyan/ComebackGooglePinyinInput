.class public final Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncEngineFactoryProvider;
.super Ljava/lang/Object;
.source "RimeSyncEngineFactoryProvider.java"


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static get(Landroid/content/Context;)Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;
    .locals 1

    invoke-static {p0}, Lbdt;->a(Landroid/content/Context;)Lbdt;

    move-result-object v0

    return-object v0
.end method
