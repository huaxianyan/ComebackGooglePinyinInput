.class public final Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
.super Landroidx/autofill/inline/common/SlicedContent$Builder;
.source "InlineSuggestionUi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Builder"
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Landroidx/autofill/inline/common/SlicedContent$Builder<",
        "Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;",
        ">;"
    }
.end annotation


# instance fields
.field private final mAttributionIntent:Landroid/app/PendingIntent;

.field private mContentDescription:Ljava/lang/CharSequence;

.field private mEndIcon:Landroid/graphics/drawable/Icon;

.field private mHints:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private mStartIcon:Landroid/graphics/drawable/Icon;

.field private mSubtitle:Ljava/lang/CharSequence;

.field private mTitle:Ljava/lang/CharSequence;


# direct methods
.method constructor <init>(Landroid/app/PendingIntent;)V
    .locals 1
    .param p1, "attributionIntent"    # Landroid/app/PendingIntent;

    .line 835
    const-string v0, "androidx.autofill.inline.ui.version:v1"

    invoke-direct {p0, v0}, Landroidx/autofill/inline/common/SlicedContent$Builder;-><init>(Ljava/lang/String;)V

    .line 836
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mAttributionIntent:Landroid/app/PendingIntent;

    .line 837
    return-void
.end method


# virtual methods
.method public bridge synthetic build()Landroidx/autofill/inline/common/SlicedContent;
    .locals 1

    .line 811
    invoke-virtual {p0}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->build()Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;

    move-result-object v0

    return-object v0
.end method

.method public build()Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;
    .locals 5

    .line 917
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mTitle:Ljava/lang/CharSequence;

    if-nez v0, :cond_1

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mStartIcon:Landroid/graphics/drawable/Icon;

    if-nez v0, :cond_1

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mEndIcon:Landroid/graphics/drawable/Icon;

    if-nez v0, :cond_1

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSubtitle:Ljava/lang/CharSequence;

    if-eqz v0, :cond_0

    goto :goto_0

    .line 918
    :cond_0
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Title, subtitle, start icon, end icon are all null. Please set value for at least one of them"

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 922
    :cond_1
    :goto_0
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mTitle:Ljava/lang/CharSequence;

    if-nez v0, :cond_3

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSubtitle:Ljava/lang/CharSequence;

    if-nez v0, :cond_2

    goto :goto_1

    .line 923
    :cond_2
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Cannot set the subtitle without setting the title."

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0

    .line 926
    :cond_3
    :goto_1
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mAttributionIntent:Landroid/app/PendingIntent;

    if-eqz v0, :cond_b

    .line 929
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mStartIcon:Landroid/graphics/drawable/Icon;

    const/4 v1, 0x0

    if-eqz v0, :cond_4

    .line 930
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mStartIcon:Landroid/graphics/drawable/Icon;

    .line 931
    const-string v3, "inline_start_icon"

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 930
    invoke-virtual {v0, v2, v1, v3}, Landroid/app/slice/Slice$Builder;->addIcon(Landroid/graphics/drawable/Icon;Ljava/lang/String;Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 933
    :cond_4
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mTitle:Ljava/lang/CharSequence;

    if-eqz v0, :cond_5

    .line 934
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mTitle:Ljava/lang/CharSequence;

    .line 935
    const-string v3, "inline_title"

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 934
    invoke-virtual {v0, v2, v1, v3}, Landroid/app/slice/Slice$Builder;->addText(Ljava/lang/CharSequence;Ljava/lang/String;Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 937
    :cond_5
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSubtitle:Ljava/lang/CharSequence;

    if-eqz v0, :cond_6

    .line 938
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSubtitle:Ljava/lang/CharSequence;

    .line 939
    const-string v3, "inline_subtitle"

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 938
    invoke-virtual {v0, v2, v1, v3}, Landroid/app/slice/Slice$Builder;->addText(Ljava/lang/CharSequence;Ljava/lang/String;Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 941
    :cond_6
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mEndIcon:Landroid/graphics/drawable/Icon;

    if-eqz v0, :cond_7

    .line 942
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mEndIcon:Landroid/graphics/drawable/Icon;

    .line 943
    const-string v3, "inline_end_icon"

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 942
    invoke-virtual {v0, v2, v1, v3}, Landroid/app/slice/Slice$Builder;->addIcon(Landroid/graphics/drawable/Icon;Ljava/lang/String;Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 945
    :cond_7
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mAttributionIntent:Landroid/app/PendingIntent;

    if-eqz v0, :cond_8

    .line 946
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mAttributionIntent:Landroid/app/PendingIntent;

    new-instance v3, Landroid/app/slice/Slice$Builder;

    iget-object v4, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    invoke-direct {v3, v4}, Landroid/app/slice/Slice$Builder;-><init>(Landroid/app/slice/Slice$Builder;)V

    .line 948
    const-string v4, "inline_attribution"

    invoke-static {v4}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v4

    .line 947
    invoke-virtual {v3, v4}, Landroid/app/slice/Slice$Builder;->addHints(Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    move-result-object v3

    .line 948
    invoke-virtual {v3}, Landroid/app/slice/Slice$Builder;->build()Landroid/app/slice/Slice;

    move-result-object v3

    .line 946
    invoke-virtual {v0, v2, v3, v1}, Landroid/app/slice/Slice$Builder;->addAction(Landroid/app/PendingIntent;Landroid/app/slice/Slice;Ljava/lang/String;)Landroid/app/slice/Slice$Builder;

    .line 951
    :cond_8
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mContentDescription:Ljava/lang/CharSequence;

    if-eqz v0, :cond_9

    .line 952
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v2, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mContentDescription:Ljava/lang/CharSequence;

    .line 953
    const-string v3, "inline_content_description"

    invoke-static {v3}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v3

    .line 952
    invoke-virtual {v0, v2, v1, v3}, Landroid/app/slice/Slice$Builder;->addText(Ljava/lang/CharSequence;Ljava/lang/String;Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 955
    :cond_9
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mHints:Ljava/util/List;

    if-eqz v0, :cond_a

    .line 956
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    iget-object v1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mHints:Ljava/util/List;

    invoke-virtual {v0, v1}, Landroid/app/slice/Slice$Builder;->addHints(Ljava/util/List;)Landroid/app/slice/Slice$Builder;

    .line 958
    :cond_a
    new-instance v0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;

    iget-object v1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSliceBuilder:Landroid/app/slice/Slice$Builder;

    invoke-virtual {v1}, Landroid/app/slice/Slice$Builder;->build()Landroid/app/slice/Slice;

    move-result-object v1

    invoke-direct {v0, v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;-><init>(Landroid/app/slice/Slice;)V

    return-object v0

    .line 927
    :cond_b
    new-instance v0, Ljava/lang/IllegalStateException;

    const-string v1, "Attribution intent cannot be null."

    invoke-direct {v0, v1}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw v0
.end method

.method public setContentDescription(Ljava/lang/CharSequence;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .param p1, "contentDescription"    # Ljava/lang/CharSequence;

    .line 899
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mContentDescription:Ljava/lang/CharSequence;

    .line 900
    return-object p0
.end method

.method public setEndIcon(Landroid/graphics/drawable/Icon;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .param p1, "endIcon"    # Landroid/graphics/drawable/Icon;

    .line 887
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mEndIcon:Landroid/graphics/drawable/Icon;

    .line 888
    return-object p0
.end method

.method public setHints(Ljava/util/List;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;)",
            "Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;"
        }
    .end annotation

    .line 910
    .local p1, "hints":Ljava/util/List;, "Ljava/util/List<Ljava/lang/String;>;"
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mHints:Ljava/util/List;

    .line 911
    return-object p0
.end method

.method public setStartIcon(Landroid/graphics/drawable/Icon;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .param p1, "startIcon"    # Landroid/graphics/drawable/Icon;

    .line 872
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mStartIcon:Landroid/graphics/drawable/Icon;

    .line 873
    return-object p0
.end method

.method public setSubtitle(Ljava/lang/CharSequence;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .param p1, "subtitle"    # Ljava/lang/CharSequence;

    .line 857
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mSubtitle:Ljava/lang/CharSequence;

    .line 858
    return-object p0
.end method

.method public setTitle(Ljava/lang/CharSequence;)Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    .locals 0
    .param p1, "title"    # Ljava/lang/CharSequence;

    .line 846
    iput-object p1, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;->mTitle:Ljava/lang/CharSequence;

    .line 847
    return-object p0
.end method
