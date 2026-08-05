.class public final Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat;
.super Ljava/lang/Object;
.source "ImeNavigationColorCompat.java"

.method public static schedule(Landroid/view/View;)V
    .locals 3

    if-eqz p0, :done

    new-instance v0, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat$SyncRunnable;
    invoke-direct {v0, p0}, Lcom/google/android/inputmethod/pinyin/ImeNavigationColorCompat$SyncRunnable;-><init>(Landroid/view/View;)V
    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    const-wide/16 v1, 0x12c
    invoke-virtual {p0, v0, v1, v2}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    :done
    return-void
.end method

.method public static syncNow(Landroid/view/View;)V
    .locals 6

    if-eqz p0, :done

    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v3
    instance-of v1, v3, Landroid/view/ViewGroup;
    if-eqz v1, :done
    check-cast v3, Landroid/view/ViewGroup;

    # The owned InputView frame is the sole theme source. Never infer the
    # current theme from a framework DecorView child index.
    const-string v2, "ime-navigation-frame"
    invoke-virtual {v3, v2}, Landroid/view/ViewGroup;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v2
    if-eqz v2, :done

    invoke-virtual {v3}, Landroid/view/View;->isLayoutRequested()Z
    move-result v1
    if-nez v1, :done
    invoke-virtual {v2}, Landroid/view/View;->isLayoutRequested()Z
    move-result v1
    if-nez v1, :done
    invoke-virtual {v2}, Landroid/view/View;->isLaidOut()Z
    move-result v1
    if-eqz v1, :done
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I
    move-result v4
    if-lez v4, :done

    # Framework may place its opaque navigation-color View before a trailing
    # navigation-control ViewGroup. Scan direct children from topmost to
    # bottommost and update only a stable, non-ViewGroup, bottom/full-width
    # View whose height exactly matches our owned frame.
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v1
    add-int/lit8 v1, v1, -0x1

    :candidate_loop
    if-ltz v1, :done
    invoke-virtual {v3, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v0
    if-eq v0, v2, :next_candidate

    instance-of v5, v0, Landroid/view/ViewGroup;
    if-nez v5, :next_candidate
    invoke-virtual {v0}, Landroid/view/View;->isLayoutRequested()Z
    move-result v5
    if-nez v5, :next_candidate
    invoke-virtual {v0}, Landroid/view/View;->isLaidOut()Z
    move-result v5
    if-eqz v5, :next_candidate
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I
    move-result v5
    if-ne v5, v4, :next_candidate
    invoke-virtual {v0}, Landroid/view/View;->getBottom()I
    move-result v5
    invoke-virtual {v3}, Landroid/view/View;->getHeight()I
    move-result p0
    if-ne v5, p0, :next_candidate
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I
    move-result v5
    invoke-virtual {v3}, Landroid/view/View;->getWidth()I
    move-result p0
    if-ne v5, p0, :next_candidate

    invoke-virtual {v2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v5
    if-eqz v5, :show
    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;
    move-result-object p0
    invoke-static {v5, p0}, Lcom/google/android/inputmethod/pinyin/ImeSurfaceRendererCompat;->copyForPlatform(Landroid/graphics/drawable/Drawable;Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;
    move-result-object v5
    invoke-virtual {v0, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :show
    const/4 v5, 0x0
    invoke-virtual {v0, v5}, Landroid/view/View;->setVisibility(I)V
    invoke-virtual {v0}, Landroid/view/View;->invalidate()V
    return-void

    :next_candidate
    add-int/lit8 v1, v1, -0x1
    goto :candidate_loop

    :done
    return-void
.end method
