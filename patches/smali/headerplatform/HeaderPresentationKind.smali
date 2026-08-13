.class public final enum Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
.super Ljava/lang/Enum;
.source "HeaderPresentationKind.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

.field public static final enum NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

.field public static final enum NATIVE_CANDIDATE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

.field public static final enum REMOTE_SURFACE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 3

    .line 4
    const/4 v0, 0x3

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_CANDIDATE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->REMOTE_SURFACE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 5
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const-string v1, "NATIVE_CANDIDATE"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_CANDIDATE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    .line 6
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const-string v1, "REMOTE_SURFACE"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->REMOTE_SURFACE:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    .line 7
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    const-string v1, "NATIVE_ACTION"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->NATIVE_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    .line 4
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->$values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;I)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 4
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 1

    .line 4
    const-class v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;
    .locals 1

    .line 4
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPresentationKind;

    return-object v0
.end method
