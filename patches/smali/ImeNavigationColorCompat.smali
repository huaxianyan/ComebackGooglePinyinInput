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
    .locals 4

    if-eqz p0, :done

    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;

    move-result-object v3

    instance-of v1, v3, Landroid/view/ViewGroup;

    if-eqz v1, :done

    check-cast v3, Landroid/view/ViewGroup;

    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-lez v1, :done

    const/4 v2, 0x0

    invoke-virtual {v3, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    add-int/lit8 v1, v1, -0x1

    invoke-virtual {v3, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup;

    if-nez v1, :done

    invoke-virtual {v3}, Landroid/view/View;->isLayoutRequested()Z

    move-result v1

    if-nez v1, :done

    invoke-virtual {v0}, Landroid/view/View;->isLayoutRequested()Z

    move-result v1

    if-nez v1, :done

    invoke-virtual {v0}, Landroid/view/View;->isLaidOut()Z

    move-result v1

    if-eqz v1, :done

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v1

    if-lez v1, :done

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/EdgeToEdgeCompat;->getTappableElementBottomInset(Landroid/view/View;)I

    move-result p0

    if-ne v1, p0, :done

    invoke-virtual {v0}, Landroid/view/View;->getBottom()I

    move-result p0

    invoke-virtual {v3}, Landroid/view/View;->getHeight()I

    move-result v1

    if-ne p0, v1, :done

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result p0

    invoke-virtual {v3}, Landroid/view/View;->getWidth()I

    move-result v1

    if-ne p0, v1, :done

    invoke-virtual {v2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    if-eqz v1, :show

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v2

    if-eqz v2, :set_background

    invoke-virtual {v0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {v2, p0}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable(Landroid/content/res/Resources;)Landroid/graphics/drawable/Drawable;

    move-result-object v1

    invoke-virtual {v1}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object v1

    :set_background
    invoke-virtual {v0, v1}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    :show
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v0}, Landroid/view/View;->invalidate()V

    :done
    return-void
.end method
