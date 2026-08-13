.class public final Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
.super Landroidx/autofill/inline/common/BundledStyle$Builder;
.source "InlineSuggestionUi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/autofill/inline/common/BundledStyle$Builder<",
        "Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;",
        ">;"
    }
.end annotation


# direct methods
.method constructor <init>()V
    .locals 1

    .line 539
    const-string v0, "style_v1"

    invoke-direct {p0, v0}, Landroidx/autofill/inline/common/BundledStyle$Builder;-><init>(Ljava/lang/String;)V

    .line 540
    return-void
.end method


# virtual methods
.method public bridge synthetic build()Landroidx/autofill/inline/common/BundledStyle;
    .locals 1

    .line 533
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->build()Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;

    move-result-object v0

    return-object v0
.end method

.method public build()Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;
    .locals 2

    .line 644
    new-instance v0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;

    iget-object v1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    invoke-direct {v0, v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;-><init>(Landroid/os/Bundle;)V

    return-object v0
.end method

.method public setChipStyle(Landroidx/autofill/inline/common/ViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "chipStyle"    # Landroidx/autofill/inline/common/ViewStyle;

    .line 568
    invoke-virtual {p1}, Landroidx/autofill/inline/common/ViewStyle;->assertIsValid()V

    .line 569
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "chip_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/ViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 570
    return-object p0
.end method

.method public setEndIconStyle(Landroidx/autofill/inline/common/ImageViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "endIconStyle"    # Landroidx/autofill/inline/common/ImageViewStyle;

    .line 612
    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->assertIsValid()V

    .line 613
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "end_icon_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 614
    return-object p0
.end method

.method public setLayoutDirection(I)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 2
    .param p1, "layoutDirection"    # I

    .line 556
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "layout_direction"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 557
    return-object p0
.end method

.method public setSingleIconChipIconStyle(Landroidx/autofill/inline/common/ImageViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "iconStyle"    # Landroidx/autofill/inline/common/ImageViewStyle;

    .line 636
    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->assertIsValid()V

    .line 637
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "single_icon_chip_icon_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 638
    return-object p0
.end method

.method public setSingleIconChipStyle(Landroidx/autofill/inline/common/ViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "chipStyle"    # Landroidx/autofill/inline/common/ViewStyle;

    .line 624
    invoke-virtual {p1}, Landroidx/autofill/inline/common/ViewStyle;->assertIsValid()V

    .line 625
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "single_icon_chip_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/ViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 626
    return-object p0
.end method

.method public setStartIconStyle(Landroidx/autofill/inline/common/ImageViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "startIconStyle"    # Landroidx/autofill/inline/common/ImageViewStyle;

    .line 602
    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->assertIsValid()V

    .line 603
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "start_icon_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/ImageViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 604
    return-object p0
.end method

.method public setSubtitleStyle(Landroidx/autofill/inline/common/TextViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "subtitleStyle"    # Landroidx/autofill/inline/common/TextViewStyle;

    .line 588
    invoke-virtual {p1}, Landroidx/autofill/inline/common/TextViewStyle;->assertIsValid()V

    .line 589
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "subtitle_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/TextViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 590
    return-object p0
.end method

.method public setTitleStyle(Landroidx/autofill/inline/common/TextViewStyle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;
    .locals 3
    .param p1, "titleStyle"    # Landroidx/autofill/inline/common/TextViewStyle;

    .line 578
    invoke-virtual {p1}, Landroidx/autofill/inline/common/TextViewStyle;->assertIsValid()V

    .line 579
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Style$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "title_style"

    invoke-virtual {p1}, Landroidx/autofill/inline/common/TextViewStyle;->getBundle()Landroid/os/Bundle;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 580
    return-object p0
.end method
