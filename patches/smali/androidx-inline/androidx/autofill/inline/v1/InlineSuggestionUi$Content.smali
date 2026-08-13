.class public final Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;
.super Landroidx/autofill/inline/common/SlicedContent;
.source "InlineSuggestionUi.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Landroidx/autofill/inline/v1/InlineSuggestionUi;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Content"
.end annotation

.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Landroidx/autofill/inline/v1/InlineSuggestionUi$Content$Builder;
    }
.end annotation


# static fields
.field static final HINT_INLINE_ATTRIBUTION_INTENT:Ljava/lang/String; = "inline_attribution"

.field static final HINT_INLINE_CONTENT_DESCRIPTION:Ljava/lang/String; = "inline_content_description"

.field static final HINT_INLINE_END_ICON:Ljava/lang/String; = "inline_end_icon"

.field static final HINT_INLINE_START_ICON:Ljava/lang/String; = "inline_start_icon"

.field static final HINT_INLINE_SUBTITLE:Ljava/lang/String; = "inline_subtitle"

.field static final HINT_INLINE_TITLE:Ljava/lang/String; = "inline_title"


# instance fields
.field private mAttributionIntent:Landroid/app/PendingIntent;

.field private mContentDescription:Ljava/lang/CharSequence;

.field private mEndIcon:Landroid/graphics/drawable/Icon;

.field private mStartIcon:Landroid/graphics/drawable/Icon;

.field private mSubtitle:Ljava/lang/CharSequence;

.field private mTitle:Ljava/lang/CharSequence;


# direct methods
.method constructor <init>(Landroid/app/slice/Slice;)V
    .locals 4
    .param p1, "slice"    # Landroid/app/slice/Slice;

    .line 678
    invoke-direct {p0, p1}, Landroidx/autofill/inline/common/SlicedContent;-><init>(Landroid/app/slice/Slice;)V

    .line 679
    invoke-virtual {p1}, Landroid/app/slice/Slice;->getItems()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_2

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/slice/SliceItem;

    .line 680
    .local v1, "sliceItem":Landroid/app/slice/SliceItem;
    invoke-static {v1}, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->itemType(Landroid/app/slice/SliceItem;)Ljava/lang/String;

    move-result-object v2

    .line 681
    .local v2, "itemType":Ljava/lang/String;
    if-nez v2, :cond_0

    .line 682
    goto :goto_0

    .line 684
    :cond_0
    invoke-virtual {v2}, Ljava/lang/String;->hashCode()I

    move-result v3

    sparse-switch v3, :sswitch_data_0

    :cond_1
    goto :goto_1

    :sswitch_0
    const-string v3, "inline_end_icon"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x3

    goto :goto_2

    :sswitch_1
    const-string v3, "inline_attribution"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x4

    goto :goto_2

    :sswitch_2
    const-string v3, "inline_title"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x0

    goto :goto_2

    :sswitch_3
    const-string v3, "inline_start_icon"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x2

    goto :goto_2

    :sswitch_4
    const-string v3, "inline_content_description"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x5

    goto :goto_2

    :sswitch_5
    const-string v3, "inline_subtitle"

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/4 v3, 0x1

    goto :goto_2

    :goto_1
    const/4 v3, -0x1

    :goto_2
    packed-switch v3, :pswitch_data_0

    goto :goto_3

    .line 701
    :pswitch_0
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getText()Ljava/lang/CharSequence;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mContentDescription:Ljava/lang/CharSequence;

    .line 702
    goto :goto_3

    .line 698
    :pswitch_1
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getAction()Landroid/app/PendingIntent;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mAttributionIntent:Landroid/app/PendingIntent;

    .line 699
    goto :goto_3

    .line 695
    :pswitch_2
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getIcon()Landroid/graphics/drawable/Icon;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mEndIcon:Landroid/graphics/drawable/Icon;

    .line 696
    goto :goto_3

    .line 692
    :pswitch_3
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getIcon()Landroid/graphics/drawable/Icon;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mStartIcon:Landroid/graphics/drawable/Icon;

    .line 693
    goto :goto_3

    .line 689
    :pswitch_4
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getText()Ljava/lang/CharSequence;

    move-result-object v3

    invoke-interface {v3}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mSubtitle:Ljava/lang/CharSequence;

    .line 690
    goto :goto_3

    .line 686
    :pswitch_5
    invoke-virtual {v1}, Landroid/app/slice/SliceItem;->getText()Ljava/lang/CharSequence;

    move-result-object v3

    invoke-interface {v3}, Ljava/lang/CharSequence;->toString()Ljava/lang/String;

    move-result-object v3

    iput-object v3, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mTitle:Ljava/lang/CharSequence;

    .line 687
    nop

    .line 706
    .end local v1    # "sliceItem":Landroid/app/slice/SliceItem;
    .end local v2    # "itemType":Ljava/lang/String;
    :goto_3
    goto/16 :goto_0

    .line 707
    :cond_2
    return-void

    :sswitch_data_0
    .sparse-switch
        -0x6abe4902 -> :sswitch_5
        -0x4ba4ed70 -> :sswitch_4
        -0x8a61864 -> :sswitch_3
        0x2b761132 -> :sswitch_2
        0x3ccd73d9 -> :sswitch_1
        0x76e72843 -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method private static itemType(Landroid/app/slice/SliceItem;)Ljava/lang/String;
    .locals 3
    .param p0, "sliceItem"    # Landroid/app/slice/SliceItem;

    .line 773
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getFormat()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->hashCode()I

    move-result v1

    sparse-switch v1, :sswitch_data_0

    :cond_0
    goto :goto_0

    :sswitch_0
    const-string v1, "image"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x0

    goto :goto_1

    :sswitch_1
    const-string v1, "text"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x1

    goto :goto_1

    :sswitch_2
    const-string v1, "action"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    const/4 v0, 0x2

    goto :goto_1

    :goto_0
    const/4 v0, -0x1

    :goto_1
    const/4 v1, 0x0

    packed-switch v0, :pswitch_data_0

    .line 803
    return-object v1

    .line 797
    :pswitch_0
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getAction()Landroid/app/PendingIntent;

    move-result-object v0

    if-eqz v0, :cond_6

    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_attribution"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 799
    return-object v2

    .line 785
    :pswitch_1
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getText()Ljava/lang/CharSequence;

    move-result-object v0

    invoke-static {v0}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 786
    return-object v1

    .line 788
    :cond_1
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_title"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 789
    return-object v2

    .line 790
    :cond_2
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_subtitle"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    .line 791
    return-object v2

    .line 792
    :cond_3
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_content_description"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 793
    return-object v2

    .line 775
    :pswitch_2
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getIcon()Landroid/graphics/drawable/Icon;

    move-result-object v0

    if-nez v0, :cond_4

    .line 776
    return-object v1

    .line 778
    :cond_4
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_start_icon"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    .line 779
    return-object v2

    .line 780
    :cond_5
    invoke-virtual {p0}, Landroid/app/slice/SliceItem;->getHints()Ljava/util/List;

    move-result-object v0

    const-string v2, "inline_end_icon"

    invoke-interface {v0, v2}, Ljava/util/List;->contains(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    .line 781
    return-object v2

    .line 805
    :cond_6
    return-object v1

    nop

    :sswitch_data_0
    .sparse-switch
        -0x54d081ca -> :sswitch_2
        0x36452d -> :sswitch_1
        0x5faa95b -> :sswitch_0
    .end sparse-switch

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method


# virtual methods
.method public getAttributionIntent()Landroid/app/PendingIntent;
    .locals 1

    .line 759
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mAttributionIntent:Landroid/app/PendingIntent;

    return-object v0
.end method

.method public getContentDescription()Ljava/lang/CharSequence;
    .locals 1

    .line 750
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mContentDescription:Ljava/lang/CharSequence;

    return-object v0
.end method

.method public getEndIcon()Landroid/graphics/drawable/Icon;
    .locals 1

    .line 742
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mEndIcon:Landroid/graphics/drawable/Icon;

    return-object v0
.end method

.method public getStartIcon()Landroid/graphics/drawable/Icon;
    .locals 1

    .line 734
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mStartIcon:Landroid/graphics/drawable/Icon;

    return-object v0
.end method

.method public getSubtitle()Ljava/lang/CharSequence;
    .locals 1

    .line 726
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mSubtitle:Ljava/lang/CharSequence;

    return-object v0
.end method

.method public getTitle()Ljava/lang/CharSequence;
    .locals 1

    .line 718
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mTitle:Ljava/lang/CharSequence;

    return-object v0
.end method

.method isSingleIconOnly()Z
    .locals 1

    .line 710
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mStartIcon:Landroid/graphics/drawable/Icon;

    if-eqz v0, :cond_0

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mTitle:Ljava/lang/CharSequence;

    if-nez v0, :cond_0

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mSubtitle:Ljava/lang/CharSequence;

    if-nez v0, :cond_0

    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mEndIcon:Landroid/graphics/drawable/Icon;

    if-nez v0, :cond_0

    const/4 v0, 0x1

    goto :goto_0

    :cond_0
    const/4 v0, 0x0

    :goto_0
    return v0
.end method

.method public isValid()Z
    .locals 2

    .line 768
    iget-object v0, p0, Landroidx/autofill/inline/v1/InlineSuggestionUi$Content;->mSlice:Landroid/app/slice/Slice;

    invoke-static {v0}, Landroidx/autofill/inline/common/SlicedContent;->getVersion(Landroid/app/slice/Slice;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "androidx.autofill.inline.ui.version:v1"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method
