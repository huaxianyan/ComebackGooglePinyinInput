.class public final Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;
.super Ljava/lang/Object;
.source "ImeSurfaceRendererCompat.java"

# Narrow renderer: only image themes in the normal (non-expanded-candidate)
# state use shared-coordinate slices. Built-in themes retain the stable
# keyboard-area fallback used before active-surface experiments.

.field private static imageOriginal:Landroid/graphics/drawable/Drawable;
.field private static imageView:Landroid/view/View;

.method private static cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    .locals 2
    if-eqz p0, :done
    move-object v1, p0
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable(Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object p0
    invoke-virtual {p0}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;
    move-result-object p0
    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getState()[I
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z
    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getLevel()I
    move-result v0
    invoke-virtual {p0, v0}, Landroid/graphics/drawable/Drawable;->setLevel(I)Z
    :done
    return-object p0
.end method

.method public static copyForPlatform(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    .locals 5
    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    if-eqz v0, :ordinary
    check-cast p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v1
    iget v2, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->offsetY:I
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->totalHeight:I
    new-instance v4, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    invoke-direct {v4, v0, v1, v2, v3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    return-object v4
    :ordinary
    invoke-static {p0, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object p0
    return-object p0
.end method

.method public static schedule(Landroid/view/View;)V
    .locals 3
    if-eqz p0, :done
    new-instance v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat$SyncRunnable;
    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat$SyncRunnable;-><init>(Landroid/view/View;)V
    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z
    const-wide/16 v1, 0x12c
    invoke-virtual {p0, v0, v1, v2}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z
    :done
    return-void
.end method

.method public static syncNow(Landroid/view/View;)V
    .locals 12
    if-eqz p0, :done
    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v0
    const-string v1, "ime-navigation-frame"
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v1
    if-eqz v1, :done
    invoke-virtual {v1}, Landroid/view/View;->getHeight()I
    move-result v2
    if-lez v2, :done

    # Expanded candidates intentionally do not own or refresh the navigation
    # surface. Keep the last stable normal-state surface and native bounds.
    const v3, 0x7f0f01a2
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :image
    invoke-virtual {v3}, Landroid/view/View;->isShown()Z
    move-result v4
    if-nez v4, :platform

    :image
    const v3, 0x7f0f0154
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :restore_image
    invoke-virtual {v3}, Landroid/view/View;->isShown()Z
    move-result v4
    if-eqz v4, :restore_image
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I
    move-result v4
    if-lez v4, :restore_image
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v5
    if-eqz v5, :restore_image
    instance-of v6, v5, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    if-eqz v6, :new_image_source
    sget-object v5, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;
    sget-object v6, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageView:Landroid/view/View;
    if-eq v6, v3, :have_image_source
    goto :restore_image
    :new_image_source
    sput-object v3, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageView:Landroid/view/View;
    sput-object v5, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;
    :have_image_source
    if-eqz v5, :restore_image
    add-int v6, v4, v2
    invoke-virtual {v3}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v7

    # Upper and lower image Views share one logical height.
    invoke-static {v5, v7}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v8
    new-instance v9, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    const/4 v10, 0x0
    invoke-direct {v9, v8, v10, v6}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;II)V
    invoke-virtual {v3, v9}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Preserve only the normal image-theme body shadow selected by the user.
    const/4 v10, 0x0
    const v11, 0x7f0f0156
    invoke-virtual {v0, v11}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v11
    instance-of v9, v11, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    if-eqz v9, :image_overlay_ready
    check-cast v11, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    iget-object v11, v11, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;->a:Landroid/view/View;
    if-eqz v11, :image_overlay_ready
    invoke-virtual {v11}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v10
    invoke-static {v10, v7}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v10
    :image_overlay_ready
    invoke-static {v5, v7}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v8
    new-instance v9, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    invoke-direct {v9, v8, v10, v4, v6}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    invoke-virtual {v1, v9}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v3}, Landroid/view/View;->invalidate()V
    invoke-virtual {v1}, Landroid/view/View;->invalidate()V
    goto :platform

    :restore_image
    sget-object v3, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageView:Landroid/view/View;
    sget-object v4, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;
    if-eqz v3, :clear_image_state
    if-eqz v4, :clear_image_state
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v5
    instance-of v5, v5, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    if-eqz v5, :clear_image_state
    invoke-virtual {v3, v4}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :clear_image_state
    const/4 v3, 0x0
    sput-object v3, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageView:Landroid/view/View;
    sput-object v3, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;

    # Built-in themes extend only the normal native key-body surface. Do not
    # follow candidate expansion or any candidate/header container.
    const v3, 0x7f0f0156
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    instance-of v4, v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    if-eqz v4, :fallback_area
    check-cast v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    iget-object v3, v3, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;->a:Landroid/view/View;
    if-eqz v3, :fallback_area
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v4
    if-nez v4, :set_builtin

    :fallback_area
    const v3, 0x7f0f0153
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :platform
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v4
    if-eqz v4, :platform

    :set_builtin
    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-static {v4, v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v4
    invoke-virtual {v1, v4}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1}, Landroid/view/View;->invalidate()V

    :platform
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat;->schedule(Landroid/view/View;)V
    :done
    return-void
.end method
