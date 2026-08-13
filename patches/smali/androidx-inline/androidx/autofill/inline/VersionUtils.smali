.class public final Landroidx/autofill/inline/VersionUtils;
.super Ljava/lang/Object;
.source "VersionUtils.java"


# static fields
.field private static final KEY_INLINE_UI_VERSIONS:Ljava/lang/String; = "androidx.autofill.inline.ui.version:key"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 116
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 118
    return-void
.end method

.method public static getSupportedVersions(Landroid/os/Bundle;)Ljava/util/List;
    .locals 5
    .param p0, "bundleWithSupportedVersions"    # Landroid/os/Bundle;
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

    .line 63
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 64
    .local v0, "ret":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    const-string v1, "androidx.autofill.inline.ui.version:key"

    invoke-virtual {p0, v1}, Landroid/os/Bundle;->getStringArrayList(Ljava/lang/String;)Ljava/util/ArrayList;

    move-result-object v1

    .line 66
    .local v1, "versions":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    if-eqz v1, :cond_1

    .line 67
    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_1

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 68
    .local v3, "version":Ljava/lang/String;
    invoke-static {v3}, Landroidx/autofill/inline/VersionUtils;->isVersionSupported(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_0

    .line 69
    invoke-interface {v0, v3}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 71
    .end local v3    # "version":Ljava/lang/String;
    :cond_0
    goto :goto_0

    .line 73
    :cond_1
    return-object v0
.end method

.method public static isVersionSupported(Ljava/lang/String;)Z
    .locals 1
    .param p0, "version"    # Ljava/lang/String;

    .line 49
    invoke-static {}, Landroidx/autofill/inline/UiVersions;->getUiVersions()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0, p0}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static readStyleByVersion(Landroid/os/Bundle;Ljava/lang/String;)Landroid/os/Bundle;
    .locals 1
    .param p0, "versionedStylesBundle"    # Landroid/os/Bundle;
    .param p1, "version"    # Ljava/lang/String;

    .line 113
    invoke-virtual {p0, p1}, Landroid/os/Bundle;->getBundle(Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v0

    return-object v0
.end method

.method public static writeStylesToBundle(Ljava/util/List;Landroid/os/Bundle;)V
    .locals 5
    .param p1, "bundle"    # Landroid/os/Bundle;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Landroidx/autofill/inline/UiVersions$Style;",
            ">;",
            "Landroid/os/Bundle;",
            ")V"
        }
    .end annotation

    .line 98
    .local p0, "styles":Ljava/util/List;, "Ljava/util/List<Landroidx/autofill/inline/UiVersions$Style;>;"
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 99
    .local v0, "versions":Ljava/util/ArrayList;, "Ljava/util/ArrayList<Ljava/lang/String;>;"
    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_0

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroidx/autofill/inline/UiVersions$Style;

    .line 100
    .local v2, "style":Landroidx/autofill/inline/UiVersions$Style;
    invoke-interface {v2}, Landroidx/autofill/inline/UiVersions$Style;->getVersion()Ljava/lang/String;

    move-result-object v3

    .line 101
    .local v3, "version":Ljava/lang/String;
    invoke-interface {v2}, Landroidx/autofill/inline/UiVersions$Style;->getVersion()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 102
    invoke-interface {v2}, Landroidx/autofill/inline/UiVersions$Style;->getBundle()Landroid/os/Bundle;

    move-result-object v4

    invoke-virtual {p1, v3, v4}, Landroid/os/Bundle;->putBundle(Ljava/lang/String;Landroid/os/Bundle;)V

    .line 103
    .end local v2    # "style":Landroidx/autofill/inline/UiVersions$Style;
    .end local v3    # "version":Ljava/lang/String;
    goto :goto_0

    .line 104
    :cond_0
    const-string v1, "androidx.autofill.inline.ui.version:key"

    invoke-virtual {p1, v1, v0}, Landroid/os/Bundle;->putStringArrayList(Ljava/lang/String;Ljava/util/ArrayList;)V

    .line 105
    return-void
.end method

.method public static writeSupportedVersions(Landroid/os/Bundle;)V
    .locals 2
    .param p0, "bundle"    # Landroid/os/Bundle;

    .line 84
    new-instance v0, Ljava/util/ArrayList;

    .line 85
    invoke-static {}, Landroidx/autofill/inline/UiVersions;->getUiVersions()Ljava/util/Set;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(Ljava/util/Collection;)V

    .line 84
    const-string v1, "androidx.autofill.inline.ui.version:key"

    invoke-virtual {p0, v1, v0}, Landroid/os/Bundle;->putStringArrayList(Ljava/lang/String;Ljava/util/ArrayList;)V

    .line 86
    return-void
.end method
