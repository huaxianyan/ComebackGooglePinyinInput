.class public final Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;
.super Landroid/widget/ImageView;
.source "HeaderMenuBackgroundView.java"

# interfaces
.implements Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;


# instance fields
.field private final borderKey:Ljava/lang/String;

.field private final borderedAlpha:F

.field private preferences:Landroid/content/SharedPreferences;


# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 3

    .line 17
    invoke-direct {p0, p1, p2}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 18
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->getAlpha()F

    move-result p2

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->borderedAlpha:F

    .line 19
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p2

    .line 20
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    .line 19
    const-string v1, "pref_key_enable_key_border"

    const-string v2, "string"

    invoke-virtual {p2, v1, v2, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/content/Context;->getString(I)Ljava/lang/String;

    move-result-object p1

    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->borderKey:Ljava/lang/String;

    .line 21
    return-void
.end method

.method private updateOpacity()V
    .locals 3

    .line 43
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->borderKey:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    iget v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->borderedAlpha:F

    goto :goto_0

    :cond_0
    const/high16 v0, 0x3f800000    # 1.0f

    :goto_0
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->setAlpha(F)V

    .line 44
    return-void
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .locals 1

    .line 24
    invoke-super {p0}, Landroid/widget/ImageView;->onAttachedToWindow()V

    .line 25
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    .line 26
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->registerOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    .line 27
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->updateOpacity()V

    .line 28
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 1

    .line 31
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_0

    .line 32
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->unregisterOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    .line 33
    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->preferences:Landroid/content/SharedPreferences;

    .line 35
    :cond_0
    invoke-super {p0}, Landroid/widget/ImageView;->onDetachedFromWindow()V

    .line 36
    return-void
.end method

.method public onSharedPreferenceChanged(Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .locals 0

    .line 39
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->borderKey:Ljava/lang/String;

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_0

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/HeaderMenuBackgroundView;->updateOpacity()V

    .line 40
    :cond_0
    return-void
.end method
