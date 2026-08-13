.class public final enum Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;
.super Ljava/lang/Enum;
.source "HeaderPlacement.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field public static final enum CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field public static final enum EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field public static final enum LEADING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field public static final enum PERSISTENT_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

.field public static final enum TRAILING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;
    .locals 3

    .line 4
    const/4 v0, 0x5

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->LEADING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v2, 0x2

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->TRAILING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v2, 0x3

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->PERSISTENT_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const/4 v2, 0x4

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 3

    .line 5
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const-string v1, "EXCLUSIVE_CONTENT"

    const/4 v2, 0x0

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->EXCLUSIVE_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 6
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const-string v1, "CENTER_CONTENT"

    const/4 v2, 0x1

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->CENTER_CONTENT:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 7
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const-string v1, "LEADING_ACTION"

    const/4 v2, 0x2

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->LEADING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 8
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const-string v1, "TRAILING_ACTION"

    const/4 v2, 0x3

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->TRAILING_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 9
    new-instance v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    const-string v1, "PERSISTENT_ACTION"

    const/4 v2, 0x4

    invoke-direct {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;-><init>(Ljava/lang/String;I)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->PERSISTENT_ACTION:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    .line 4
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->$values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

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

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;
    .locals 1

    .line 4
    const-class v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;
    .locals 1

    .line 4
    sget-object v0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->$VALUES:[Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlacement;

    return-object v0
.end method
