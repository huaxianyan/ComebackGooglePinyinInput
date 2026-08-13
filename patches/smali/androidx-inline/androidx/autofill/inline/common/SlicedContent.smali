.class public abstract Landroidx/autofill/inline/common/SlicedContent;
.super Ljava/lang/Object;
.source "SlicedContent.java"

# interfaces
.implements Landroidx/autofill/inline/UiVersions$Content;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/common/SlicedContent$Builder;
    }
.end annotation


# static fields
.field static final INLINE_SLICE_URI:Landroid/net/Uri;


# instance fields
.field protected final mSlice:Landroid/app/slice/Slice;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 41
    const-string v0, "inline.slice"

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    sput-object v0, Landroidx/autofill/inline/common/SlicedContent;->INLINE_SLICE_URI:Landroid/net/Uri;

    return-void
.end method

.method protected constructor <init>(Landroid/app/slice/Slice;)V
    .locals 0
    .param p1, "slice"    # Landroid/app/slice/Slice;

    .line 54
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 55
    iput-object p1, p0, Landroidx/autofill/inline/common/SlicedContent;->mSlice:Landroid/app/slice/Slice;

    .line 56
    return-void
.end method

.method public static getVersion(Landroid/app/slice/Slice;)Ljava/lang/String;
    .locals 1
    .param p0, "slice"    # Landroid/app/slice/Slice;

    .line 91
    invoke-virtual {p0}, Landroid/app/slice/Slice;->getSpec()Landroid/app/slice/SliceSpec;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/slice/SliceSpec;->getType()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method


# virtual methods
.method public abstract getAttributionIntent()Landroid/app/PendingIntent;
.end method

.method public final getSlice()Landroid/app/slice/Slice;
    .locals 1

    .line 64
    iget-object v0, p0, Landroidx/autofill/inline/common/SlicedContent;->mSlice:Landroid/app/slice/Slice;

    return-object v0
.end method

.method public abstract isValid()Z
.end method
