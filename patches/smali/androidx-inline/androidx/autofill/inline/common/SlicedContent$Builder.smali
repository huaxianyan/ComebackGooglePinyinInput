.class public abstract Landroidx/autofill/inline/common/SlicedContent$Builder;
.super Ljava/lang/Object;
.source "SlicedContent.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/common/SlicedContent;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x409
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "<T:",
        "Landroidx/autofill/inline/common/SlicedContent;",
        ">",
        "Ljava/lang/Object;"
    }
.end annotation


# instance fields
.field protected final mSliceBuilder:Landroid/app/slice/Slice$Builder;


# direct methods
.method protected constructor <init>(Ljava/lang/String;)V
    .locals 4
    .param p1, "version"    # Ljava/lang/String;

    .line 106
    .local p0, "this":Landroidx/autofill/inline/common/SlicedContent$Builder;, "Landroidx/autofill/inline/common/SlicedContent$Builder<TT;>;"
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 107
    new-instance v0, Landroid/app/slice/Slice$Builder;

    sget-object v1, Landroidx/autofill/inline/common/SlicedContent;->INLINE_SLICE_URI:Landroid/net/Uri;

    new-instance v2, Landroid/app/slice/SliceSpec;

    const/4 v3, 0x1

    invoke-direct {v2, p1, v3}, Landroid/app/slice/SliceSpec;-><init>(Ljava/lang/String;I)V

    invoke-direct {v0, v1, v2}, Landroid/app/slice/Slice$Builder;-><init>(Landroid/net/Uri;Landroid/app/slice/SliceSpec;)V

    iput-object v0, p0, Landroidx/autofill/inline/common/SlicedContent$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    .line 108
    return-void
.end method


# virtual methods
.method public abstract build()Landroidx/autofill/inline/common/SlicedContent;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()TT;"
        }
    .end annotation
.end method
