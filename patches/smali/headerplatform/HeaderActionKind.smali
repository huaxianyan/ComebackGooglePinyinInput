.class public final enum Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;
.super Ljava/lang/Enum;
.source "HeaderActionKind.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

.field public static final enum NEXT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

.field public static final enum PREVIOUS:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;
    .locals 3

    .line 4
    const/4 v0, 0x2

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->PREVIOUS:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->NEXT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 5
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    const-string v1, "PREVIOUS"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->PREVIOUS:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    .line 6
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    const-string v1, "NEXT"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->NEXT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    .line 4
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->$values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

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

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;
    .locals 1

    .line 4
    const-class v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;
    .locals 1

    .line 4
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderActionKind;

    return-object v0
.end method
