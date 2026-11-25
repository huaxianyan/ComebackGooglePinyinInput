.class Lcom/google/android/inputmethod/pinyin/QuickBar$1;
.super Ljava/lang/Object;
.source "QuickBar.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/QuickBar;->createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 159
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 1

    .line 162
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$context:Landroid/content/Context;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    invoke-static {p1, v0}, Lcom/google/android/inputmethod/pinyin/QuickBar;->access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;)V

    .line 163
    return-void
.end method
