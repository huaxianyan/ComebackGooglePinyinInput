.class public final Landroidx/autofill/inline/common/TextViewStyle;
.super Landroidx/autofill/inline/common/ViewStyle;
.source "TextViewStyle.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/common/TextViewStyle$Builder;
    }
.end annotation


# static fields
.field private static final KEY_TEXT_COLOR:Ljava/lang/String; = "text_color"

.field private static final KEY_TEXT_FONT_FAMILY:Ljava/lang/String; = "text_font_family"

.field private static final KEY_TEXT_FONT_STYLE:Ljava/lang/String; = "text_font_style"

.field private static final KEY_TEXT_SIZE:Ljava/lang/String; = "text_size"

.field private static final KEY_TEXT_SIZE_UNIT:Ljava/lang/String; = "text_size_unit"

.field private static final KEY_TEXT_VIEW_STYLE:Ljava/lang/String; = "text_view_style"


# direct methods
.method public constructor <init>(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "bundle"    # Landroid/os/Bundle;

    .line 54
    invoke-direct {p0, p1}, Landroidx/autofill/inline/common/ViewStyle;-><init>(Landroid/os/Bundle;)V

    .line 55
    return-void
.end method


# virtual methods
.method public applyStyleOnTextViewIfValid(Landroid/widget/TextView;)V
    .locals 4
    .param p1, "textView"    # Landroid/widget/TextView;

    .line 64
    invoke-virtual {p0}, Landroidx/autofill/inline/common/TextViewStyle;->isValid()Z

    move-result v0

    if-nez v0, :cond_0

    .line 65
    return-void

    .line 67
    :cond_0
    invoke-super {p0, p1}, Landroidx/autofill/inline/common/ViewStyle;->applyStyleOnViewIfValid(Landroid/view/View;)V

    .line 68
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_color"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 69
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 71
    :cond_1
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_size"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 72
    const/4 v0, 0x2

    .line 73
    .local v0, "unit":I
    iget-object v2, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    const-string v3, "text_size_unit"

    invoke-virtual {v2, v3}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 74
    iget-object v2, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    invoke-virtual {v2, v3}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v0

    .line 76
    :cond_2
    iget-object v2, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    invoke-virtual {v2, v1}, Landroid/os/Bundle;->getFloat(Ljava/lang/String;)F

    move-result v1

    invoke-virtual {p1, v0, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 78
    .end local v0    # "unit":I
    :cond_3
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_font_family"

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 79
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    invoke-virtual {v0, v1}, Landroid/os/Bundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 80
    .local v0, "fontFamily":Ljava/lang/String;
    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_4

    .line 81
    iget-object v1, p0, Landroidx/autofill/inline/common/TextViewStyle;->mBundle:Landroid/os/Bundle;

    .line 82
    const-string v2, "text_font_style"

    invoke-virtual {v1, v2}, Landroid/os/Bundle;->getInt(Ljava/lang/String;)I

    move-result v1

    invoke-static {v0, v1}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v1

    .line 81
    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 85
    .end local v0    # "fontFamily":Ljava/lang/String;
    :cond_4
    return-void
.end method

.method protected getStyleKey()Ljava/lang/String;
    .locals 1

    .line 94
    const-string v0, "text_view_style"

    return-object v0
.end method
