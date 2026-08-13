.class Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;
.super Ljava/lang/Object;
.source "HeaderPlatformHostView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->onHeaderRenderPlanChanged(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;

.field final synthetic val$plan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 109
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;->val$plan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    .line 110
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;->this$0:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView$1;->val$plan:Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;

    invoke-static {v0, v1}, Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;->access$000(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformHostView;Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderRenderPlan;)V

    return-void
.end method
