.class public final Lcom/google/android/inputmethod/pinyin/PagerFrameRateCompat;
.super Ljava/lang/Object;


# Keep the legacy FourDirectionalView patch API-neutral and scope frame-rate
# requests to the symbol/emoji/emoticon pager shared by the three non-prime
# pages. Candidate and other pageable holders must retain their own scheduling.

# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static requestForMotion(Landroid/view/View;Z)V
    .locals 1

    instance-of v0, p0, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableRecentSubCategorySoftKeyListHolderView;

    if-eqz v0, :done

    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/ViewFrameRateCompat;->requestHigh(Landroid/view/View;Z)V

    :done
    return-void
.end method
