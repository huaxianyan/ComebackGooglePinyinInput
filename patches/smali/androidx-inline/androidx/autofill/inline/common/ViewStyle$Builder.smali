.class public final Landroidx/autofill/inline/common/ViewStyle$Builder;
.super Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
.source "ViewStyle.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/common/ViewStyle;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/autofill/inline/common/ViewStyle$BaseBuilder<",
        "Landroidx/autofill/inline/common/ViewStyle;",
        "Landroidx/autofill/inline/common/ViewStyle$Builder;",
        ">;"
    }
.end annotation


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 219
    const-string v0, "view_style"

    invoke-direct {p0, v0}, Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;-><init>(Ljava/lang/String;)V

    .line 220
    return-void
.end method


# virtual methods
.method public bridge synthetic build()Landroidx/autofill/inline/common/BundledStyle;
    .locals 1

    .line 216
    invoke-virtual {p0}, Landroidx/autofill/inline/common/ViewStyle$Builder;->build()Landroidx/autofill/inline/common/ViewStyle;

    move-result-object v0

    return-object v0
.end method

.method public build()Landroidx/autofill/inline/common/ViewStyle;
    .locals 2

    .line 235
    new-instance v0, Landroidx/autofill/inline/common/ViewStyle;

    iget-object v1, p0, Landroidx/autofill/inline/common/ViewStyle$Builder;->mBundle:Landroid/os/Bundle;

    invoke-direct {v0, v1}, Landroidx/autofill/inline/common/ViewStyle;-><init>(Landroid/os/Bundle;)V

    return-object v0
.end method

.method protected bridge synthetic getThis()Landroidx/autofill/inline/common/ViewStyle$BaseBuilder;
    .locals 1

    .line 216
    invoke-virtual {p0}, Landroidx/autofill/inline/common/ViewStyle$Builder;->getThis()Landroidx/autofill/inline/common/ViewStyle$Builder;

    move-result-object v0

    return-object v0
.end method

.method protected getThis()Landroidx/autofill/inline/common/ViewStyle$Builder;
    .locals 0

    .line 229
    return-object p0
.end method
