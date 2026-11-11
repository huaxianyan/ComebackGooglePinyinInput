.class public final enum Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;
.super Ljava/lang/Enum;
.source "DictionarySafetyKind.java"


# annotations
.annotation system Ldalvik/annotation/Signature;
    value = {
        "Ljava/lang/Enum<",
        "Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;",
        ">;"
    }
.end annotation


# static fields
.field private static final synthetic $VALUES:[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

.field public static final enum CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

.field public static final enum ENGLISH:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;


# instance fields
.field public final directoryName:Ljava/lang/String;

.field public final engineFactoryClass:Ljava/lang/String;

.field public final fileName:Ljava/lang/String;

.field public final preferencesName:Ljava/lang/String;


# direct methods
.method private static synthetic $values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;
    .locals 3

    .line 7
    const/4 v0, 0x2

    new-array v0, v0, [Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    const/4 v2, 0x0

    aput-object v1, v0, v2

    sget-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->ENGLISH:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    const/4 v2, 0x1

    aput-object v1, v0, v2

    return-object v0
.end method

.method static constructor <clinit>()V
    .locals 8

    .line 9
    new-instance v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    const-string v5, "dictionary-safety"

    const-string v6, "dictionary_safety"

    const-string v1, "CHINESE"

    const/4 v2, 0x0

    const-string v3, "bdt"

    const-string v4, "user_dict_3_3"

    invoke-direct/range {v0 .. v6}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->CHINESE:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    .line 10
    new-instance v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    const-string v6, "dictionary-safety-en"

    const-string v7, "dictionary_safety_en"

    const-string v2, "ENGLISH"

    const/4 v3, 0x1

    const-string v4, "agb"

    const-string v5, "user_dict_3_3_english"

    invoke-direct/range {v1 .. v7}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;-><init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    sput-object v1, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->ENGLISH:Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    .line 7
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->$values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    move-result-object v0

    sput-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    return-void
.end method

.method private constructor <init>(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ")V"
        }
    .end annotation

    .line 22
    invoke-direct {p0, p1, p2}, Ljava/lang/Enum;-><init>(Ljava/lang/String;I)V

    .line 23
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->engineFactoryClass:Ljava/lang/String;

    .line 24
    iput-object p4, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->fileName:Ljava/lang/String;

    .line 25
    iput-object p5, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->directoryName:Ljava/lang/String;

    .line 26
    iput-object p6, p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->preferencesName:Ljava/lang/String;

    .line 27
    return-void
.end method

.method public static valueOf(Ljava/lang/String;)Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;
    .locals 1

    .line 7
    const-class v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-static {v0, p0}, Ljava/lang/Enum;->valueOf(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/Enum;

    move-result-object p0

    check-cast p0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    return-object p0
.end method

.method public static values()[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;
    .locals 1

    .line 7
    sget-object v0, Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->$VALUES:[Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    invoke-virtual {v0}, [Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;->clone()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, [Lcom/google/android/inputmethod/pinyin/dictsafety/DictionarySafetyKind;

    return-object v0
.end method
