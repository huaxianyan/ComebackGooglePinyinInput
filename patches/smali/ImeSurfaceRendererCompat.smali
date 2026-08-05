.class public final Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;
.super Ljava/lang/Object;
.source "ImeSurfaceRendererCompat.java"

# Coordinates the non-interactive navigation surface with the active keyboard
# surface. Image drawables use one logical height and two clipped slices.

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

    # ConstantState creates theme Drawables in their default state. Expanded
    # candidate backgrounds can have a different live state, so preserve it
    # before composing the clone into the navigation surface.
    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getState()[I
    move-result-object v0
    invoke-virtual {p0, v0}, Landroid/graphics/drawable/Drawable;->setState([I)Z
    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getLevel()I
    move-result v0
    invoke-virtual {p0, v0}, Landroid/graphics/drawable/Drawable;->setLevel(I)Z

    :done
    return-object p0
.end method

.method private static imageBottomWithOverlay(Landroid/view/View;Landroid/graphics/drawable/Drawable;ILandroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    .locals 12

    const v0, 0x7f0f0154
    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v0
    if-eqz v0, :none
    invoke-virtual {v0}, Landroid/view/View;->isShown()Z
    move-result v1
    if-eqz v1, :none
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I
    move-result v1
    if-lez v1, :none
    invoke-virtual {v0}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v2
    instance-of v3, v2, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    if-eqz v3, :remember
    sget-object v2, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;
    goto :source_ready

    :remember
    sput-object v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageView:Landroid/view/View;
    sput-object v2, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageOriginal:Landroid/graphics/drawable/Drawable;

    :source_ready
    if-eqz v2, :none
    invoke-static {v2, p3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v4
    invoke-static {p1, p3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v5

    # Expanded-candidate opacity is authored as an additional translucent
    # layer over the native keyboard-body shadow, not as a replacement for it.
    # Keep both live states independent while recreating that same stack.
    const/4 v9, 0x0
    const v6, 0x7f0f0156
    invoke-virtual {p0, v6}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v6
    instance-of v7, v6, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    if-eqz v7, :overlay_ready
    check-cast v6, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;
    iget-object v6, v6, Lcom/google/android/apps/inputmethod/libs/framework/core/KeyboardViewHolder;->a:Landroid/view/View;
    if-eqz v6, :overlay_ready
    invoke-virtual {v6}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v6
    invoke-static {v6, p3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v9

    :overlay_ready
    # The visible expanded page is painted by four row Views. Their shared
    # non-content row background is the visual surface behind candidate cells.
    const/4 v10, 0x0
    const v6, 0x7f0f02bd
    invoke-virtual {p0, v6}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v6
    instance-of v7, v6, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableCandidatesHolderView;
    if-eqz v7, :row_ready
    check-cast v6, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableCandidatesHolderView;
    iget-object v7, v6, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableCandidatesHolderView;->a:Lavs;
    if-nez v7, :have_page
    iget-object v7, v6, Lcom/google/android/apps/inputmethod/libs/framework/keyboard/widget/PageableCandidatesHolderView;->b:Lavs;
    :have_page
    if-eqz v7, :row_ready
    invoke-virtual {v7}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v6
    if-lez v6, :row_ready
    add-int/lit8 v6, v6, -0x1
    invoke-virtual {v7, v6}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v6
    if-eqz v6, :row_ready
    invoke-virtual {v6}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v6
    invoke-static {v6, p3}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v10

    :row_ready
    add-int v6, v1, p2
    move v8, v1
    new-instance v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    move-object v1, v4
    move-object v2, v9
    move-object v3, v5
    move v4, v8
    move v5, v6
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    iput-object v10, v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay3:Landroid/graphics/drawable/Drawable;
    if-eqz v10, :return_slice
    invoke-virtual {v10, v0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
    :return_slice
    return-object v0

    :none
    const/4 v0, 0x0
    return-object v0
.end method

.method public static copyForPlatform(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    .locals 7

    instance-of v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    if-eqz v0, :ordinary
    check-cast p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->source:Landroid/graphics/drawable/Drawable;
    invoke-static {v0, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay:Landroid/graphics/drawable/Drawable;
    invoke-static {v1, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v1
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay2:Landroid/graphics/drawable/Drawable;
    invoke-static {v2, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v2
    iget-object v6, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay3:Landroid/graphics/drawable/Drawable;
    invoke-static {v6, p1}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v6
    iget v3, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->offsetY:I
    iget v4, p0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->totalHeight:I
    move v5, v4
    move v4, v3
    move-object v3, v2
    move-object v2, v1
    move-object v1, v0
    new-instance v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    invoke-direct/range {v0 .. v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;Landroid/graphics/drawable/Drawable;II)V
    iput-object v6, v0, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;->overlay3:Landroid/graphics/drawable/Drawable;
    if-eqz v6, :platform_ready
    invoke-virtual {v6, v0}, Landroid/graphics/drawable/Drawable;->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
    :platform_ready
    return-object v0

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

    # Expanded candidates own the active visual surface while shown. This
    # changes only the bottom visual; candidate interaction bounds are native.
    const v3, 0x7f0f01a2
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :image
    invoke-virtual {v3}, Landroid/view/View;->isShown()Z
    move-result v4
    if-eqz v4, :image
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v4
    if-eqz v4, :image
    invoke-virtual {v1}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object v5
    invoke-static {v0, v4, v2, v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->imageBottomWithOverlay(Landroid/view/View;Landroid/graphics/drawable/Drawable;ILandroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v6
    if-nez v6, :candidate_background_ready
    invoke-static {v4, v5}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v6
    :candidate_background_ready
    invoke-virtual {v1, v6}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V
    invoke-virtual {v1}, Landroid/view/View;->invalidate()V
    goto :platform

    :image
    # keyboard_background_frame is an app-owned, explicit ID. It is visible
    # only for image themes and spans the complete native keyboard area.
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

    invoke-static {v5, v7}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->cloneDrawable(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v8
    new-instance v9, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;
    const/4 v10, 0x0
    invoke-direct {v9, v8, v10, v6}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceSliceDrawable;-><init>(Landroid/graphics/drawable/Drawable;II)V
    invoke-virtual {v3, v9}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # The image opacity/shadow slider is implemented by the native body
    # background, separately from keyboard_background_frame. Preserve it as
    # an overlay on the navigation slice.
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

    # Normal non-image keyboards use the current native body surface.
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
    if-nez v4, :set_normal

    :fallback_area
    const v3, 0x7f0f0153
    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    if-eqz v3, :done
    invoke-virtual {v3}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v4
    if-eqz v4, :done

    :set_normal
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
