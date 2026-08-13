.class public abstract Landroidx/autofill/inline/common/BundledStyle;
.super Ljava/lang/Object;
.source "BundledStyle.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/common/BundledStyle$Builder;
    }
.end annotation


# instance fields
.field protected final mBundle:Landroid/os/Bundle;


# direct methods
.method protected constructor <init>(Landroid/os/Bundle;)V
    .locals 0
    .param p1, "bundle"    # Landroid/os/Bundle;

    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    iput-object p1, p0, Landroidx/autofill/inline/common/BundledStyle;->mBundle:Landroid/os/Bundle;

    .line 43
    return-void
.end method


# virtual methods
.method public assertIsValid()V
    .locals 3

    .line 73
    invoke-virtual {p0}, Landroidx/autofill/inline/common/BundledStyle;->isValid()Z

    move-result v0

    if-eqz v0, :cond_0

    .line 76
    return-void

    .line 74
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Invalid style, missing bundle key "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {p0}, Landroidx/autofill/inline/common/BundledStyle;->getStyleKey()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public final getBundle()Landroid/os/Bundle;
    .locals 1

    .line 53
    iget-object v0, p0, Landroidx/autofill/inline/common/BundledStyle;->mBundle:Landroid/os/Bundle;

    return-object v0
.end method

.method protected abstract getStyleKey()Ljava/lang/String;
.end method

.method public isValid()Z
    .locals 3

    .line 63
    iget-object v0, p0, Landroidx/autofill/inline/common/BundledStyle;->mBundle:Landroid/os/Bundle;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroidx/autofill/inline/common/BundledStyle;->mBundle:Landroid/os/Bundle;

    invoke-virtual {p0}, Landroidx/autofill/inline/common/BundledStyle;->getStyleKey()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v1, 0x1

    :cond_0
    return v1
.end method
