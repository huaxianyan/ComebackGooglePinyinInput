.class public final Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;
.super Ljava/lang/Object;
.source "ImeThemeDiagnosticsCompat.java"

# Debug-only, privacy-limited diagnostics. Records View geometry/state,
# structural class names and Drawable classes; never records text or tags.

.method private static appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V
    .locals 3

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez p2, :present

    const-string v0, "=null;"
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    return-void

    :present
    const-string v0, "="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, " geo["
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getLeft()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v0, ","
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getTop()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v0, "]["
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getRight()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v0, ","
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getBottom()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v0, "] vis="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getVisibility()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " attached="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->isAttachedToWindow()Z
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string v0, " laid="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->isLaidOut()Z
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
    const-string v0, " req="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->isLayoutRequested()Z
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    instance-of v0, p2, Landroid/view/ViewGroup;
    if-eqz v0, :background
    move-object v0, p2
    check-cast v0, Landroid/view/ViewGroup;
    const-string v1, " children="
    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    :background
    const-string v0, " bg="
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {p2}, Landroid/view/View;->getBackground()Landroid/graphics/drawable/Drawable;
    move-result-object v0
    if-nez v0, :background_present
    const-string v0, "null"
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :end

    :background_present
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
    move-result-object v0
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
    move-result-object v0
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :end
    const-string v0, ";"
    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    return-void
.end method

.method public static dump(Landroid/view/View;Ljava/lang/String;)V
    .locals 8

    if-eqz p0, :done

    :try_start
    new-instance v0, Ljava/lang/StringBuilder;
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v1, ";"
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "input"
    invoke-static {v0, v1, p0}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V

    invoke-virtual {p0}, Landroid/view/View;->getRootView()Landroid/view/View;
    move-result-object v2
    const-string v1, "root"
    invoke-static {v0, v1, v2}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V

    instance-of v1, v2, Landroid/view/ViewGroup;
    if-eqz v1, :known_views
    move-object v3, v2
    check-cast v3, Landroid/view/ViewGroup;
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v4
    const/4 v5, 0x0

    :child_loop
    if-ge v5, v4, :known_views
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "child"
    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7, v6}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V
    add-int/lit8 v5, v5, 0x1
    goto :child_loop

    :known_views
    const-string v1, "ime-navigation-frame"
    invoke-virtual {v2, v1}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;
    move-result-object v3
    const-string v1, "themeFrame"
    invoke-static {v0, v1, v3}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V

    const v1, 0x7f0f0153
    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v3
    const-string v1, "keyboardArea"
    invoke-static {v0, v1, v3}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V

    instance-of v1, v3, Landroid/view/ViewGroup;
    if-eqz v1, :emit
    check-cast v3, Landroid/view/ViewGroup;
    invoke-virtual {v3}, Landroid/view/ViewGroup;->getChildCount()I
    move-result v4
    const/4 v5, 0x0

    :area_child_loop
    if-ge v5, v4, :emit
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;
    move-result-object v6
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V
    const-string v1, "areaChild"
    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7
    invoke-static {v0, v7, v6}, Lcom/google/android/inputmethod/pinyin/ImeThemeDiagnosticsCompat;->appendView(Ljava/lang/StringBuilder;Ljava/lang/String;Landroid/view/View;)V
    add-int/lit8 v5, v5, 0x1
    goto :area_child_loop

    :emit
    const-string v1, "GooglePinyinImeSync"
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :done

    :done
    return-void
.end method
