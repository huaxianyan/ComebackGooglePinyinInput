.class public final Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat;
.super Ljava/lang/Object;
.source "ThemeSettingsInsetsCompat.java"

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static attachSelector(Landroid/app/Activity;)V
    .locals 3

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x15

    if-lt v0, v1, :done

    const v0, 0x7f0f0418

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :done

    new-instance v1, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;

    invoke-direct {v1, v0}, Lcom/google/android/inputmethod/pinyin/ThemeSettingsInsetsCompat$SystemBarsListener;-><init>(Landroid/view/View;)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setOnApplyWindowInsetsListener(Landroid/view/View$OnApplyWindowInsetsListener;)V

    invoke-virtual {v0}, Landroid/view/View;->requestApplyInsets()V

    :done
    return-void
.end method
