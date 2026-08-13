.class public final Landroidx/autofill/inline/UiVersions;
.super Ljava/lang/Object;
.source "UiVersions.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/UiVersions$StylesBuilder;,
        Landroidx/autofill/inline/UiVersions$Style;,
        Landroidx/autofill/inline/UiVersions$Content;,
        Landroidx/autofill/inline/UiVersions$InlineUiVersion;
    }
.end annotation


# static fields
.field public static final INLINE_UI_VERSION_1:Ljava/lang/String; = "androidx.autofill.inline.ui.version:v1"

.field private static final UI_VERSIONS:Ljava/util/Set;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 59
    new-instance v0, Ljava/util/HashSet;

    const-string v1, "androidx.autofill.inline.ui.version:v1"

    filled-new-array {v1}, [Ljava/lang/String;

    move-result-object v1

    .line 60
    invoke-static {v1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/HashSet;-><init>(Ljava/util/Collection;)V

    sput-object v0, Landroidx/autofill/inline/UiVersions;->UI_VERSIONS:Ljava/util/Set;

    .line 59
    return-void
.end method

.method private constructor <init>()V
    .locals 0

    .line 82
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 83
    return-void
.end method

.method public static getUiVersions()Ljava/util/Set;
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/Set<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 66
    sget-object v0, Landroidx/autofill/inline/UiVersions;->UI_VERSIONS:Ljava/util/Set;

    return-object v0
.end method

.method public static getVersions(Landroid/os/Bundle;)Ljava/util/List;
    .locals 1
    .param p0, "versionedBundle"    # Landroid/os/Bundle;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Landroid/os/Bundle;",
            ")",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 79
    invoke-static {p0}, Landroidx/autofill/inline/VersionUtils;->getSupportedVersions(Landroid/os/Bundle;)Ljava/util/List;

    move-result-object v0

    return-object v0
.end method

.method public static newStylesBuilder()Landroidx/autofill/inline/UiVersions$StylesBuilder;
    .locals 1

    .line 130
    new-instance v0, Landroidx/autofill/inline/UiVersions$StylesBuilder;

    invoke-direct {v0}, Landroidx/autofill/inline/UiVersions$StylesBuilder;-><init>()V

    return-object v0
.end method
