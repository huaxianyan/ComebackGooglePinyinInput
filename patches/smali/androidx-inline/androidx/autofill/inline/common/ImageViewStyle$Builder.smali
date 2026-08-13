.class public final Landroidx/autofill/inline/common/ImageViewStyle$Builder;
.super Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
.source "ImageViewStyle.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/common/ImageViewStyle;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/autofill/inline/common/ViewStyle$BaseBuilder<",
        "Landroidx/autofill/inline/common/ImageViewStyle;",
        "Landroidx/autofill/inline/common/ImageViewStyle$Builder;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 108
    const-string v0, "image_view_style"

    invoke-direct {p0, v0}, Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;-><init>(Ljava/lang/String;)V

    .line 109
    return-void
.end method


# virtual methods
.method public bridge synthetic build()Landroidx/autofill/inline/common/BundledStyle;
    .locals 1

    .line 105
    invoke-virtual {p0}, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->build()Landroidx/autofill/inline/common/ImageViewStyle;

    move-result-object v0

    return-object v0
.end method

.method public build()Landroidx/autofill/inline/common/ImageViewStyle;
    .locals 2

    .line 174
    new-instance v0, Landroidx/autofill/inline/common/ImageViewStyle;

    iget-object v1, p0, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    invoke-direct {v0, v1}, Landroidx/autofill/inline/common/ImageViewStyle;-><init>(Landroid/os/Bundle;)V

    return-object v0
.end method

.method protected getThis()Landroidx/autofill/inline/common/ImageViewStyle$Builder;
    .locals 0

    .line 118
    return-object p0
.end method

.method protected bridge synthetic getThis()Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
    .locals 1

    .line 105
    invoke-virtual {p0}, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->getThis()Landroidx/autofill/inline/common/ImageViewStyle$Builder;

    move-result-object v0

    return-object v0
.end method

.method public setMaxHeight(I)Landroidx/autofill/inline/common/ImageViewStyle$Builder;
    .locals 2
    .param p1, "maxHeight"    # I

    .line 154
    iget-object v0, p0, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "image_max_height"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 155
    return-object p0
.end method

.method public setMaxWidth(I)Landroidx/autofill/inline/common/ImageViewStyle$Builder;
    .locals 2
    .param p1, "maxWidth"    # I

    .line 142
    iget-object v0, p0, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "image_max_width"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putInt(Ljava/lang/String;I)V

    .line 143
    return-object p0
.end method

.method public setScaleType(Landroid/widget/ImageView$ScaleType;)Landroidx/autofill/inline/common/ImageViewStyle$Builder;
    .locals 3
    .param p1, "scaleType"    # Landroid/widget/ImageView$ScaleType;

    .line 129
    const-string v0, "scaleType should not be null"

    invoke-static {p1, v0}, Landroidx/core/util/Preconditions;->checkNotNull(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 130
    iget-object v0, p0, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "image_scale_type"

    invoke-virtual {p1}, Landroid/widget/ImageView$ScaleType;->name()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v1, v2}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    .line 131
    return-object p0
.end method

.method public setTintList(Landroid/content/res/ColorStateList;)Landroidx/autofill/inline/common/ImageViewStyle$Builder;
    .locals 2
    .param p1, "imageTintList"    # Landroid/content/res/ColorStateList;

    .line 166
    const-string v0, "imageTintList should not be null"

    invoke-static {p1, v0}, Landroidx/core/util/Preconditions;->checkNotNull(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 167
    iget-object v0, p0, Landroidx/autofill/inline/common/ImageViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    const-string v1, "image_tint_list"

    invoke-virtual {v0, v1, p1}, Landroid/os/Bundle;->putParcelable(Ljava/lang/String;Landroid/os/Parcelable;)V

    .line 168
    return-object p0
.end method
