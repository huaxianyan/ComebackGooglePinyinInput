.class public final Lcom/google/android/inputmethod/pinyin/Md3InlineSliderCompat;
.super Ljava/lang/Object;

.method private constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static bindReset(Laxf;Landroid/view/View;)V
    .locals 5

    invoke-virtual {p1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v0
    const-string v1, "md3_slider_reset"
    const-string v2, "id"
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v3
    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;
    move-result-object v3
    invoke-virtual {v0, v1, v2, v3}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I
    move-result v0
    if-eqz v0, :done

    invoke-virtual {p1, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v0
    if-eqz v0, :done

    instance-of v1, p0, Laxh;
    if-eqz v1, :hide

    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V
    const/4 v1, 0x1
    invoke-virtual {v0, v1}, Landroid/view/View;->setClickable(Z)V
    invoke-virtual {v0, v1}, Landroid/view/View;->setFocusable(Z)V
    new-instance v1, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;
    invoke-direct {v1, p0, p1}, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;-><init>(Laxf;Landroid/view/View;)V
    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    goto :done

    :hide
    const/16 v1, 0x8
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V
    const/4 v1, 0x0
    invoke-virtual {v0, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :done
    return-void
.end method
