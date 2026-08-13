.class public final Landroidx/autofill/inline/Renderer;
.super Ljava/lang/Object;
.source "Renderer.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "Renderer"


# direct methods
.method private constructor <init>()V
    .locals 0

    .line 114
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 115
    return-void
.end method

.method public static getAttributionIntent(Landroid/app/slice/Slice;)Landroid/app/PendingIntent;
    .locals 5
    .param p0, "content"    # Landroid/app/slice/Slice;

    .line 97
    invoke-static {p0}, Landroidx/autofill/inline/common/SlicedContent;->getVersion(Landroid/app/slice/Slice;)Ljava/lang/String;

    move-result-object v0

    .line 98
    .local v0, "contentVersion":Ljava/lang/String;
    invoke-static {v0}, Landroidx/autofill/inline/VersionUtils;->isVersionSupported(Ljava/lang/String;)Z

    move-result v1

    const-string v2, "Renderer"

    const/4 v3, 0x0

    if-nez v1, :cond_0

    .line 99
    const-string v1, "Content version unsupported."

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 100
    return-object v3

    .line 102
    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    packed-switch v1, :pswitch_data_0

    :cond_1
    goto :goto_0

    :pswitch_0
    const-string v1, "androidx.autofill.inline.ui.version:v1"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const/4 v1, 0x0

    goto :goto_1

    :goto_0
    const/4 v1, -0x1

    :goto_1
    packed-switch v1, :pswitch_data_1

    .line 110
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Renderer does not support the content version: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 111
    return-object v3

    .line 104
    :pswitch_1
    invoke-static {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->fromSlice(Landroid/app/slice/Slice;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;

    move-result-object v1

    .line 105
    .local v1, "contentV1":Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;
    if-nez v1, :cond_2

    .line 106
    return-object v3

    .line 108
    :cond_2
    invoke-static {v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->getAttributionIntent(Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;)Landroid/app/PendingIntent;

    move-result-object v2

    return-object v2

    :pswitch_data_0
    .packed-switch -0x48dded27
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x0
        :pswitch_1
    .end packed-switch
.end method

.method public static getSupportedInlineUiVersionsAsBundle()Landroid/os/Bundle;
    .locals 1

    .line 46
    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    .line 47
    .local v0, "bundle":Landroid/os/Bundle;
    invoke-static {v0}, Landroidx/autofill/inline/VersionUtils;->writeSupportedVersions(Landroid/os/Bundle;)V

    .line 48
    return-object v0
.end method

.method public static render(Landroid/content/Context;Landroid/app/slice/Slice;Landroid/os/Bundle;)Landroid/view/View;
    .locals 6
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "content"    # Landroid/app/slice/Slice;
    .param p2, "styles"    # Landroid/os/Bundle;

    .line 62
    invoke-static {p1}, Landroidx/autofill/inline/common/SlicedContent;->getVersion(Landroid/app/slice/Slice;)Ljava/lang/String;

    move-result-object v0

    .line 63
    .local v0, "contentVersion":Ljava/lang/String;
    invoke-static {v0}, Landroidx/autofill/inline/VersionUtils;->isVersionSupported(Ljava/lang/String;)Z

    move-result v1

    const-string v2, "Renderer"

    const/4 v3, 0x0

    if-nez v1, :cond_0

    .line 64
    const-string v1, "Content version unsupported."

    invoke-static {v2, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 65
    return-object v3

    .line 67
    :cond_0
    invoke-static {p2, v0}, Landroidx/autofill/inline/VersionUtils;->readStyleByVersion(Landroid/os/Bundle;Ljava/lang/String;)Landroid/os/Bundle;

    move-result-object v1

    .line 68
    .local v1, "styleForSliceVersion":Landroid/os/Bundle;
    if-nez v1, :cond_1

    .line 69
    const-string v4, "Cannot find a style with the same version as the slice."

    invoke-static {v2, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 70
    return-object v3

    .line 72
    :cond_1
    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v4

    packed-switch v4, :pswitch_data_0

    :cond_2
    goto :goto_0

    :pswitch_0
    const-string v4, "androidx.autofill.inline.ui.version:v1"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_2

    const/4 v4, 0x0

    goto :goto_1

    :goto_0
    const/4 v4, -0x1

    :goto_1
    packed-switch v4, :pswitch_data_1

    .line 82
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Renderer does not support the style/content version: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v2, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 83
    return-object v3

    .line 74
    :pswitch_1
    invoke-static {v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->fromBundle(Landroid/os/Bundle;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;

    move-result-object v2

    .line 76
    .local v2, "style":Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;
    invoke-static {p1}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->fromSlice(Landroid/app/slice/Slice;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;

    move-result-object v4

    .line 77
    .local v4, "contentV1":Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;
    if-eqz v2, :cond_4

    if-nez p1, :cond_3

    goto :goto_2

    .line 80
    :cond_3
    invoke-static {p0, v4, v2}, Landroidx/autofill/inline/v1/InlineSuggestionUi;->render(Landroid/content/Context;Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;Landroidx/autofill/inline/v1/InlineSuggestionUi$Style;)Landroid/view/View;

    move-result-object v3

    return-object v3

    .line 78
    :cond_4
    :goto_2
    return-object v3

    nop

    :pswitch_data_0
    .packed-switch -0x48dded27
        :pswitch_0
    .end packed-switch

    :pswitch_data_1
    .packed-switch 0x0
        :pswitch_1
    .end packed-switch
.end method
