.class public final Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;
.super Ljava/lang/Object;
.implements Landroid/view/View$OnClickListener;

.field private final preference:Laxf;
.field private final row:Landroid/view/View;

.method public constructor <init>(Laxf;Landroid/view/View;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->preference:Laxf;
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->row:Landroid/view/View;
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 2
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->preference:Laxf;
    invoke-virtual {v0}, Laxf;->d()V
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3InlineSliderResetClickListener;->row:Landroid/view/View;
    invoke-virtual {v0, v1}, Laxf;->e(Landroid/view/View;)V
    return-void
.end method
