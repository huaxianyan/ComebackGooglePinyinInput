.class public final Lcom/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener;
.super Ljava/lang/Object;
.implements Landroid/animation/ValueAnimator$AnimatorUpdateListener;

.field private final view:Lcom/google/android/inputmethod/pinyin/Md3SliderView;

.method public constructor <init>(Lcom/google/android/inputmethod/pinyin/Md3SliderView;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener;->view:Lcom/google/android/inputmethod/pinyin/Md3SliderView;
    return-void
.end method

.method public onAnimationUpdate(Landroid/animation/ValueAnimator;)V
    .locals 2
    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;
    move-result-object v0
    check-cast v0, Ljava/lang/Float;
    invoke-virtual {v0}, Ljava/lang/Float;->floatValue()F
    move-result v0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SliderView$InteractionUpdateListener;->view:Lcom/google/android/inputmethod/pinyin/Md3SliderView;
    invoke-virtual {v1, v0}, Lcom/google/android/inputmethod/pinyin/Md3SliderView;->updateInteraction(F)V
    return-void
.end method
