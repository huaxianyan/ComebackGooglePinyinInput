.class public final Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;
.super Landroidx/autofill/inline/common/BundledStyle;
.source "InlineSuggestionUi.java"

# interfaces
.implements Landroidx/autofill/inline/UiVersions$Style;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/v1/InlineSuggestionUi;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Style"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    }
.end annotation


# static fields
.field private static final KEY_CHIP_STYLE:Ljava/lang/String; = "chip_style"

.field private static final KEY_END_ICON_STYLE:Ljava/lang/String; = "end_icon_style"

.field private static final KEY_LAYOUT_DIRECTION:Ljava/lang/String; = "layout_direction"

.field private static final KEY_SINGLE_ICON_CHIP_ICON_STYLE:Ljava/lang/String; = "single_icon_chip_icon_style"

.field private static final KEY_SINGLE_ICON_CHIP_STYLE:Ljava/lang/String; = "single_icon_chip_style"

.field private static final KEY_START_ICON_STYLE:Ljava/lang/String; = "start_icon_style"

.field private static final KEY_STYLE_V1:Ljava/lang/String; = "style_v1"

.field private static final KEY_SUBTITLE_STYLE:Ljava/lang/String; = "subtitle_style"

.field private static final KEY_TITLE_STYLE:Ljava/lang/String; = "title_style"


# direct methods
.method constructor <init>(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "bundle"    # Landroid/os/Bundle;

    .line 350
    invoke-direct {p0, p1}, Landroidx/autofill/inline/common/BundledStyle;-><init>(Landroid/os/Bundle;)V

    .line 351
    return-void
.end method


# virtual methods
.method public applyStyle(Landroid/view/View;Landroid/widget/ImageView;)V
    .locals 2
    .param p1, "singleIconChipView"    # Landroid/view/View;
    .param p2, "singleIconView"    # Landroid/widget/ImageView;

    .line 369
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->isValid()Z

    move-result v0

    if-nez v0, :cond_0

    .line 370
    return-void

    .line 374
    :cond_0
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getLayoutDirection()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/view/View;->setLayoutDirection(I)V

    .line 377
    invoke-virtual {p2}, Landroid/widget/ImageView;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-eq v0, v1, :cond_2

    .line 378
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getSingleIconChipIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;

    move-result-object v0

    .line 379
    .local v0, "singleIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    if-nez v0, :cond_1

    .line 380
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getStartIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;

    move-result-object v0

    .line 382
    :cond_1
    if-eqz v0, :cond_2

    .line 383
    invoke-virtual {v0, p2}, Landroidx/autofill/inline/common/ImageViewStyle;->applyStyleOnImageViewIfValid(Landroid/widget/ImageView;)V

    .line 387
    .end local v0    # "singleIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    :cond_2
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getSingleIconChipStyle()Landroidx/autofill/inline/common/ViewStyle;

    move-result-object v0

    .line 388
    .local v0, "chipViewStyle":Landroidx/autofill/inline/common/ViewStyle;
    if-nez v0, :cond_3

    .line 389
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getChipStyle()Landroidx/autofill/inline/common/ViewStyle;

    move-result-object v0

    .line 391
    :cond_3
    if-eqz v0, :cond_4

    .line 392
    invoke-virtual {v0, p1}, Landroidx/autofill/inline/common/ViewStyle;->applyStyleOnViewIfValid(Landroid/view/View;)V

    .line 394
    :cond_4
    return-void
.end method

.method public applyStyle(Landroid/view/View;Landroid/widget/ImageView;Landroid/widget/TextView;Landroid/widget/TextView;Landroid/widget/ImageView;)V
    .locals 2
    .param p1, "chipView"    # Landroid/view/View;
    .param p2, "startIconView"    # Landroid/widget/ImageView;
    .param p3, "titleView"    # Landroid/widget/TextView;
    .param p4, "subtitleView"    # Landroid/widget/TextView;
    .param p5, "endIconView"    # Landroid/widget/ImageView;

    .line 403
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->isValid()Z

    move-result v0

    if-nez v0, :cond_0

    .line 404
    return-void

    .line 408
    :cond_0
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getLayoutDirection()I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/view/View;->setLayoutDirection(I)V

    .line 411
    invoke-virtual {p2}, Landroid/widget/ImageView;->getVisibility()I

    move-result v0

    const/16 v1, 0x8

    if-eq v0, v1, :cond_1

    .line 412
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getStartIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;

    move-result-object v0

    .line 413
    .local v0, "startIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    if-eqz v0, :cond_1

    .line 414
    invoke-virtual {v0, p2}, Landroidx/autofill/inline/common/ImageViewStyle;->applyStyleOnImageViewIfValid(Landroid/widget/ImageView;)V

    .line 418
    .end local v0    # "startIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    :cond_1
    invoke-virtual {p3}, Landroid/widget/TextView;->getVisibility()I

    move-result v0

    if-eq v0, v1, :cond_2

    .line 419
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getTitleStyle()Landroidx/autofill/inline/common/TextViewStyle;

    move-result-object v0

    .line 420
    .local v0, "titleStyle":Landroidx/autofill/inline/common/TextViewStyle;
    if-eqz v0, :cond_2

    .line 421
    invoke-virtual {v0, p3}, Landroidx/autofill/inline/common/TextViewStyle;->applyStyleOnTextViewIfValid(Landroid/widget/TextView;)V

    .line 425
    .end local v0    # "titleStyle":Landroidx/autofill/inline/common/TextViewStyle;
    :cond_2
    invoke-virtual {p4}, Landroid/widget/TextView;->getVisibility()I

    move-result v0

    if-eq v0, v1, :cond_3

    .line 426
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getSubtitleStyle()Landroidx/autofill/inline/common/TextViewStyle;

    move-result-object v0

    .line 427
    .local v0, "subtitleStyle":Landroidx/autofill/inline/common/TextViewStyle;
    if-eqz v0, :cond_3

    .line 428
    invoke-virtual {v0, p4}, Landroidx/autofill/inline/common/TextViewStyle;->applyStyleOnTextViewIfValid(Landroid/widget/TextView;)V

    .line 432
    .end local v0    # "subtitleStyle":Landroidx/autofill/inline/common/TextViewStyle;
    :cond_3
    invoke-virtual {p5}, Landroid/widget/ImageView;->getVisibility()I

    move-result v0

    if-eq v0, v1, :cond_4

    .line 433
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getEndIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;

    move-result-object v0

    .line 434
    .local v0, "endIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    if-eqz v0, :cond_4

    .line 435
    invoke-virtual {v0, p5}, Landroidx/autofill/inline/common/ImageViewStyle;->applyStyleOnImageViewIfValid(Landroid/widget/ImageView;)V

    .line 439
    .end local v0    # "endIconViewStyle":Landroidx/autofill/inline/common/ImageViewStyle;
    :cond_4
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->getChipStyle()Landroidx/autofill/inline/common/ViewStyle;

    move-result-object v0

    .line 440
    .local v0, "chipViewStyle":Landroidx/autofill/inline/common/ViewStyle;
    if-eqz v0, :cond_5

    .line 441
    invoke-virtual {v0, p1}, Landroidx/autofill/inline/common/ViewStyle;->applyStyleOnViewIfValid(Landroid/view/View;)V

    .line 443
    :cond_5
    return-void
.end method

.method public getChipStyle()Landroidx/autofill/inline/common/ViewStyle;
    .locals 2

    .line 472
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "chip_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 473
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/ViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/ViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getEndIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;
    .locals 2

    .line 508
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "end_icon_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 509
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/ImageViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/ImageViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getLayoutDirection()I
    .locals 3

    .line 459
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "layout_direction"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;I)I

    move-result v0

    .line 460
    .local v0, "layoutDirection":I
    if-eqz v0, :cond_0

    const/4 v1, 0x1

    if-eq v0, v1, :cond_0

    .line 462
    const/4 v0, 0x0

    .line 464
    :cond_0
    return v0
.end method

.method public getSingleIconChipIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;
    .locals 2

    .line 526
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "single_icon_chip_icon_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 527
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/ImageViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/ImageViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getSingleIconChipStyle()Landroidx/autofill/inline/common/ViewStyle;
    .locals 2

    .line 517
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "single_icon_chip_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 518
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/ViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/ViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getStartIconStyle()Landroidx/autofill/inline/common/ImageViewStyle;
    .locals 2

    .line 499
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "start_icon_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 500
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/ImageViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/ImageViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method protected getStyleKey()Ljava/lang/String;
    .locals 1

    .line 360
    const-string v0, "style_v1"

    return-object v0
.end method

.method public getSubtitleStyle()Landroidx/autofill/inline/common/TextViewStyle;
    .locals 2

    .line 490
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "subtitle_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 491
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/TextViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/TextViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getTitleStyle()Landroidx/autofill/inline/common/TextViewStyle;
    .locals 2

    .line 481
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;->mBundle:Landroid/os/Bundle;

    const-string v1, "title_style"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    .line 482
    .local v0, "styleBundle":Landroid/os/Bundle;
    if-nez v0, :cond_0

    const/4 v1, 0x0

    goto :goto_0

    :cond_0
    new-instance v1, Landroidx/autofill/inline/common/TextViewStyle;

    invoke-direct {v1, v0}, Landroidx/autofill/inline/common/TextViewStyle;-><init>(Landroid/os/Bundle;)V

    :goto_0
    return-object v1
.end method

.method public getVersion()Ljava/lang/String;
    .locals 1

    .line 452
    const-string v0, "androidx.autofill.inline.ui.version:v1"

    return-object v0
.end method
