.class public final Lcom/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener;
.super Ljava/lang/Object;
.source "Md3SwitchView.java"

# interfaces
.implements Landroid/animation/ValueAnimator$AnimatorUpdateListener;

# instance fields
.field private final view:Lcom/google/android/inputmethod/pinyin/Md3SwitchView;

# direct methods
.method public constructor <init>(Lcom/google/android/inputmethod/pinyin/Md3SwitchView;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener;->view:Lcom/google/android/inputmethod/pinyin/Md3SwitchView;
    return-void
.end method

# virtual methods
.method public onAnimationUpdate(Landroid/animation/ValueAnimator;)V
    .locals 2
    invoke-virtual {p1}, Landroid/animation/ValueAnimator;->getAnimatedValue()Ljava/lang/Object;
    move-result-object p1
    check-cast p1, Ljava/lang/Float;
    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F
    move-result v0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/Md3SwitchView$AnimatorUpdateListener;->view:Lcom/google/android/inputmethod/pinyin/Md3SwitchView;
    invoke-static {v1, v0}, Lcom/google/android/inputmethod/pinyin/Md3SwitchView;->updatePosition(Lcom/google/android/inputmethod/pinyin/Md3SwitchView;F)V
    return-void
.end method
