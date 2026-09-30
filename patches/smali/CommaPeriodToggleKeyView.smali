.class public final Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;
.super Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;
.source "CommaPeriodToggleKeyView.java"

# interfaces
.implements Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;
.implements Landroid/view/ViewTreeObserver$OnPreDrawListener;


# static fields


# instance fields
.field private lastFreedWeight:F

.field private preferences:Landroid/content/SharedPreferences;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .locals 0

    invoke-direct {p0, p1}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 0

    invoke-direct {p0, p1, p2}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .locals 0

    invoke-direct {p0, p1, p2, p3}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    return-void
.end method

# Resolve an explicit slot id by name against this package, then look it up
# from the top of the keyboard, because the slot is a sibling of this view
# rather than one of its descendants.
.method private static findSlot(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;
    .locals 4

    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "id"

    invoke-virtual {v0, p1, v2, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    const/4 v2, 0x0

    if-nez v1, :cond_0

    return-object v2

    :cond_0
    move-object v0, p0

    :goto_0
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    instance-of v3, v3, Landroid/view/View;

    if-nez v3, :cond_1

    goto :goto_1

    :cond_1
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    check-cast v3, Landroid/view/View;

    move-object v0, v3

    goto :goto_0

    :goto_1
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0
.end method

# Read both switches and hand the freed weight to the space bar. The container
# that wraps the language key and the space bar keeps its own weight, so the
# language key (fixed at 100 inside it) and every other key keep their width.
# Returns true when the space bar weight actually changed, so the pre-draw
# callback knows whether a fresh layout pass is required.
.method private applyWeights()Z
    .locals 7

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    if-nez v0, :cond_0

    const/4 v0, 0x0

    return v0

    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    const-string v1, "show_comma_key"

    const/4 v2, 0x1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    const-string v3, "show_period_key"

    invoke-interface {v0, v3, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    const/4 v0, 0x0

    if-eqz v1, :cond_1

    goto :goto_0

    :cond_1
    const/high16 v4, 0x42c80000    # 100.0f

    add-float/2addr v0, v4

    :goto_0
    if-eqz v3, :cond_2

    goto :goto_1

    :cond_2
    const/high16 v4, 0x42c80000    # 100.0f

    add-float/2addr v0, v4

    :goto_1
    iget v1, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->lastFreedWeight:F

    cmpl-float v1, v1, v0

    if-eqz v1, :cond_3

    goto :goto_2

    :cond_3
    const/4 v0, 0x0

    return v0

    :goto_2
    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->setFreedWeight(F)V

    const/4 v0, 0x1

    return v0
.end method

.method private setFreedWeight(F)V
    .locals 4

    const-string v0, "key_pos_space"

    invoke-static {p0, v0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->findSlot(Landroid/view/View;Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    if-nez v0, :cond_0

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->lastFreedWeight:F

    return-void

    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    instance-of v2, v1, Landroid/widget/LinearLayout$LayoutParams;

    if-nez v2, :cond_1

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->lastFreedWeight:F

    return-void

    :cond_1
    check-cast v1, Landroid/widget/LinearLayout$LayoutParams;

    # The current weight already carries whatever we added last time, so undo
    # that first to recover the declared base weight, then add the new total.
    iget v2, v1, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    iget v3, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->lastFreedWeight:F

    sub-float/2addr v2, v3

    add-float/2addr v2, p1

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    iput p1, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->lastFreedWeight:F

    return-void
.end method


# virtual methods
.method protected onAttachedToWindow()V
    .locals 1

    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->onAttachedToWindow()V

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->registerOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->addOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 2

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnPreDrawListener(Landroid/view/ViewTreeObserver$OnPreDrawListener;)V

    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    invoke-interface {v0, p0}, Landroid/content/SharedPreferences;->unregisterOnSharedPreferenceChangeListener(Landroid/content/SharedPreferences$OnSharedPreferenceChangeListener;)V

    const/4 v0, 0x0

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->preferences:Landroid/content/SharedPreferences;

    :cond_1
    invoke-super {p0}, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/SoftKeyView;->onDetachedFromWindow()V

    return-void
.end method

.method public onPreDraw()Z
    .locals 1

    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->applyWeights()Z

    move-result v0

    if-eqz v0, :cond_0

    # The weights just changed, so let this draw pass be cancelled and the
    # following one pick up the new layout.
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->requestLayout()V

    const/4 v0, 0x0

    return v0

    :cond_0
    const/4 v0, 0x1

    return v0
.end method

.method public onSharedPreferenceChanged(Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .locals 0

    const-string p1, "show_comma_key"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    const-string p1, "show_period_key"

    invoke-virtual {p1, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1

    # A switch flipped: drop out of layout so the next draw pass re-reads them.
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/CommaPeriodToggleKeyView;->requestLayout()V

    :cond_1
    return-void
.end method
