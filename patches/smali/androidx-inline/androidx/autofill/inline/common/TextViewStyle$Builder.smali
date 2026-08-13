.class public final Landroidx/autofill/inline/common/TextViewStyle$Builder;
.super Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
.source "TextViewStyle.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/common/TextViewStyle;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/autofill/inline/common/ViewStyle$BaseBuilder<",
        "Landroidx/autofill/inline/common/TextViewStyle;",
        "Landroidx/autofill/inline/common/TextViewStyle$Builder;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 102
    const-string v0, "text_view_style"

    invoke-direct {p0, v0}, Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;-><init>(Ljava/lang/String;)V

    .line 103
    return-void
.end method


# virtual methods
.method public bridge synthetic build()Landroidx/autofill/inline/common/BundledStyle;
    .locals 1

    .line 100
    invoke-virtual {p0}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->build()Landroidx/autofill/inline/common/TextViewStyle;

    move-result-object v0

    return-object v0
.end method

.method public build()Landroidx/autofill/inline/common/TextViewStyle;
    .locals 2

    .line 173
    new-instance v0, Landroidx/autofill/inline/common/TextViewStyle;

    iget-object v1, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    invoke-direct {v0, v1}, Landroidx/autofill/inline/common/TextViewStyle;-><init>(Landroid/os/Bundle;)V

    return-object v0
.end method

.method protected getThis()Landroidx/autofill/inline/common/TextViewStyle$Builder;
    .locals 0

    .line 112
    return-object p0
.end method

.method protected bridge synthetic getThis()Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
    .locals 1

    .line 100
    invoke-virtual {p0}, Landroidx/autofill/inline/common/TextViewStyle$Builder;->getThis()Landroidx/autofill/inline/common/TextViewStyle$Builder;

    move-result-object v0

    return-object v0
.end method

.method public setTextColor(I)Landroidx/autofill/inline/common/TextViewStyle$Builder;
    .locals 2
    .param p1, "textColor"    # I

    .line 149
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_color"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 150
    return-object p0
.end method

.method public setTextSize(F)Landroidx/autofill/inline/common/TextViewStyle$Builder;
    .locals 2
    .param p1, "textSize"    # F

    .line 123
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_size"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    .line 124
    return-object p0
.end method

.method public setTextSize(IF)Landroidx/autofill/inline/common/TextViewStyle$Builder;
    .locals 2
    .param p1, "unit"    # I
    .param p2, "size"    # F

    .line 136
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_size_unit"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 137
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_size"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putFloat(Ljava/lang/String;F)V

    .line 138
    return-object p0
.end method

.method public setTypeface(Ljava/lang/String;I)Landroidx/autofill/inline/common/TextViewStyle$Builder;
    .locals 2
    .param p1, "fontFamily"    # Ljava/lang/String;
    .param p2, "fontStyle"    # I

    .line 164
    const-string v0, "fontFamily should not be null"

    invoke-static {p1, v0}, Landroidx/core/util/Preconditions;->checkNotNull(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 165
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_font_family"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 166
    iget-object v0, p0, Landroidx/autofill/inline/common/TextViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "text_font_style"

    invoke-virtual {v0, v1, p2}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 167
    return-object p0
.end method
