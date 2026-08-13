.class public final Lcom/google/android/inputmethod/pinyin/CandidateFrameRateCompat;
.super Ljava/lang/Object;


# Direct method references to View.setRequestedFrameRate() are deliberately
# avoided so API 17-35 ART never has to resolve an API 36-only member.

# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static requestForAnimation(Landroid/view/View;Z)V
    .locals 6

    if-eqz p0, :done

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x24

    if-lt v0, v1, :done

    :try_start
    const-class v0, Landroid/view/View;

    const-string v1, "setRequestedFrameRate"

    const/4 v2, 0x1

    new-array v3, v2, [Ljava/lang/Class;

    sget-object v4, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    invoke-virtual {v0, v1, v3}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    new-array v1, v2, [Ljava/lang/Object;

    if-eqz p1, :release

    const/high16 p1, -0x3f800000    # -4.0f, REQUESTED_FRAME_RATE_CATEGORY_HIGH

    goto :box

    :release
    const/high16 p1, -0x40800000    # -1.0f, REQUESTED_FRAME_RATE_CATEGORY_NO_PREFERENCE

    :box
    invoke-static {p1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object p1

    aput-object p1, v1, v5

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end
    .catch Ljava/lang/ReflectiveOperationException; {:try_start .. :try_end} :done
    .catch Ljava/lang/RuntimeException; {:try_start .. :try_end} :done

    :done
    return-void
.end method
