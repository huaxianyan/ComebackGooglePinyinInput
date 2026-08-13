.class public final Landroidx/autofill/inline/UiVersions$StylesBuilder;
.super Ljava/lang/Object;
.source "UiVersions.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/UiVersions;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "StylesBuilder"
.end annotation


# instance fields
.field private final mStyles:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Landroidx/autofill/inline/UiVersions$Style;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method constructor <init>()V
    .locals 1

    .line 144
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 145
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    iput-object v0, p0, Landroidx/autofill/inline/UiVersions$StylesBuilder;->mStyles:Ljava/util/List;

    .line 146
    return-void
.end method


# virtual methods
.method public addStyle(Landroidx/autofill/inline/UiVersions$Style;)Landroidx/autofill/inline/UiVersions$StylesBuilder;
    .locals 3
    .param p1, "style"    # Landroidx/autofill/inline/UiVersions$Style;

    .line 156
    invoke-interface {p1}, Landroidx/autofill/inline/UiVersions$Style;->getVersion()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroidx/autofill/inline/VersionUtils;->isVersionSupported(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 160
    iget-object v0, p0, Landroidx/autofill/inline/UiVersions$StylesBuilder;->mStyles:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 161
    return-object p0

    .line 157
    :cond_0
    new-instance v0, Ljava/lang/IllegalArgumentException;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Unsupported style version: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    .line 158
    invoke-interface {p1}, Landroidx/autofill/inline/UiVersions$Style;->getVersion()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v0, v1}, Ljava/lang/IllegalArgumentException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public build()Landroid/os/Bundle;
    .locals 2

    .line 172
    iget-object v0, p0, Landroidx/autofill/inline/UiVersions$StylesBuilder;->mStyles:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_0

    .line 175
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 176
    .local v0, "bundle":Landroid/os/Bundle;
    iget-object v1, p0, Landroidx/autofill/inline/UiVersions$StylesBuilder;->mStyles:Ljava/util/List;

    invoke-static {v1, v0}, Landroidx/autofill/inline/VersionUtils;->writeStylesToBundle(Ljava/util/List;Landroid/os/Bundle;)V

    .line 177
    return-object v0

    .line 173
    .end local v0    # "bundle":Landroid/os/Bundle;
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Please put at least one style in the builder"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method
