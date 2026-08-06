.class public final Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field private final preference:Laxf;

.method public constructor <init>(Laxf;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->preference:Laxf;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 1
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->preference:Laxf;
    invoke-virtual {v0}, Laxf;->d()V
    return-void
.end method
