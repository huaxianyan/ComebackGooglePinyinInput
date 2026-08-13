.class public abstract Landroidx/autofill/inline/common/BundledStyle$Builder;
.super Ljava/lang/Object;
.source "BundledStyle.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/common/BundledStyle;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Landroidx/autofill/inline/common/BundledStyle;",
        ">",
        "Ljava/lang/Object;"
    }
.end annotation


# instance fields
.field protected final mBundle:Landroid/os/Bundle;


# direct methods
.method protected constructor <init>(Ljava/lang/String;)V
    .locals 2
    .param p1, "style"    # Ljava/lang/String;

    .line 94
    .local p0, "this":Landroidx/autofill/inline/common/BundledStyle$Builder;, "Landroidx/autofill/inline/common/BundledStyle$Builder<TT;>;"
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 91
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    iput-object v0, p0, Landroidx/autofill/inline/common/BundledStyle$Builder;->mBundle:Landroid/os/Bundle;

    .line 95
    iget-object v0, p0, Landroidx/autofill/inline/common/BundledStyle$Builder;->mBundle:Landroid/os/Bundle;

    const/4 v1, 0x1

    invoke-virtual {v0, p1, v1}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    .line 96
    return-void
.end method


# virtual methods
.method public abstract build()Landroidx/autofill/inline/common/BundledStyle;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()TT;"
        }
    .end annotation
.end method
