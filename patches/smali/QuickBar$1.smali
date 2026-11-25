.class Lcom/google/android/inputmethod/pinyin/QuickBar$1;
.super Ljava/lang/Object;
.source "QuickBar.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/QuickBar;->createButton(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$context:Landroid/content/Context;

.field final synthetic val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

.field final synthetic val$nativeBar:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 278
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$context:Landroid/content/Context;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$nativeBar:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .locals 2

    .line 281
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$context:Landroid/content/Context;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$entry:Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$1;->val$nativeBar:Landroid/view/View;

    invoke-static {p1, v0, v1}, Lcom/google/android/inputmethod/pinyin/QuickBar;->access$000(Landroid/content/Context;Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;Landroid/view/View;)V

    .line 282
    return-void
.end method
