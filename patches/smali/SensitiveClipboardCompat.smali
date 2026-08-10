.class public final Lcom/google/android/inputmethod/pinyin/SensitiveClipboardCompat;
.super Ljava/lang/Object;
.source "SensitiveClipboardCompat.java"


# static fields
.field private static final EXTRA_IS_SENSITIVE:Ljava/lang/String; = "android.content.extra.IS_SENSITIVE"

.field private static final MAX_MASK_CODE_UNITS:I = 0x20


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isPasswordEditor(Landroid/view/inputmethod/EditorInfo;)Z
    .registers 1

    .line 33
    if-nez p0, :cond_4

    .line 34
    const/4 p0, 0x0

    return p0

    .line 36
    :cond_4
    iget p0, p0, Landroid/view/inputmethod/EditorInfo;->inputType:I

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/SensitiveClipboardCompat;->isPasswordInputType(I)Z

    move-result p0

    return p0
.end method

.method public static isPasswordInputType(I)Z
    .registers 5

    .line 41
    and-int/lit8 v0, p0, 0xf

    .line 42
    and-int/lit16 p0, p0, 0xff0

    .line 43
    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_12

    .line 44
    const/16 v0, 0x80

    if-eq p0, v0, :cond_10

    const/16 v0, 0xe0

    if-ne p0, v0, :cond_11

    :cond_10
    const/4 v1, 0x1

    :cond_11
    return v1

    .line 46
    :cond_12
    const/4 v3, 0x2

    if-ne v0, v3, :cond_1a

    const/16 v0, 0x10

    if-ne p0, v0, :cond_1a

    const/4 v1, 0x1

    :cond_1a
    return v1
.end method

.method public static isSourceSensitive(Landroid/content/ClipDescription;)Z
    .registers 4

    .line 24
    const/4 v0, 0x0

    if-eqz p0, :cond_1a

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x18

    if-ge v1, v2, :cond_a

    goto :goto_1a

    .line 27
    :cond_a
    invoke-virtual {p0}, Landroid/content/ClipDescription;->getExtras()Landroid/os/PersistableBundle;

    move-result-object p0

    .line 28
    if-eqz p0, :cond_19

    const-string v1, "android.content.extra.IS_SENSITIVE"

    invoke-virtual {p0, v1, v0}, Landroid/os/PersistableBundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    if-eqz p0, :cond_19

    const/4 v0, 0x1

    :cond_19
    return v0

    .line 25
    :cond_1a
    :goto_1a
    return v0
.end method

.method public static makeOpaqueKey(Ljava/lang/String;J)Ljava/lang/String;
    .registers 8

    .line 63
    :try_start_0
    const-string v0, "SHA-256"

    invoke-static {v0}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v0

    .line 64
    const-string v1, "UTF-8"

    invoke-virtual {p0, v1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/security/MessageDigest;->digest([B)[B

    move-result-object v0

    .line 65
    new-instance v1, Ljava/lang/StringBuilder;

    array-length v2, v0

    mul-int/lit8 v2, v2, 0x2

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 66
    const/4 v2, 0x0

    :goto_19
    array-length v3, v0

    if-ge v2, v3, :cond_33

    .line 67
    aget-byte v3, v0, v2

    and-int/lit16 v3, v3, 0xff

    .line 68
    const/16 v4, 0x10

    if-ge v3, v4, :cond_29

    .line 69
    const/16 v4, 0x30

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 71
    :cond_29
    invoke-static {v3}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 66
    add-int/lit8 v2, v2, 0x1

    goto :goto_19

    .line 73
    :cond_33
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0
    :try_end_37
    .catch Ljava/security/NoSuchAlgorithmException; {:try_start_0 .. :try_end_37} :catch_42
    .catch Ljava/io/UnsupportedEncodingException; {:try_start_0 .. :try_end_37} :catch_38

    goto :goto_4b

    .line 76
    :catch_38
    move-exception v0

    .line 77
    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v0

    goto :goto_4c

    .line 74
    :catch_42
    move-exception v0

    .line 75
    invoke-virtual {p0}, Ljava/lang/String;->hashCode()I

    move-result v0

    invoke-static {v0}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v0

    .line 78
    :goto_4b
    nop

    .line 79
    :goto_4c
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    const/16 v1, 0x1f

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, p1, p2}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static mask(Ljava/lang/String;)Ljava/lang/String;
    .registers 4

    .line 51
    const/4 v0, 0x0

    if-nez p0, :cond_5

    const/4 p0, 0x0

    goto :goto_9

    :cond_5
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    :goto_9
    const/16 v1, 0x20

    invoke-static {p0, v1}, Ljava/lang/Math;->min(II)I

    move-result p0

    .line 52
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, p0}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 53
    nop

    :goto_15
    if-ge v0, p0, :cond_1f

    .line 54
    const/16 v2, 0x2022

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 53
    add-int/lit8 v0, v0, 0x1

    goto :goto_15

    .line 56
    :cond_1f
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method
