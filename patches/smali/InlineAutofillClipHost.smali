.class public final Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;
.super Landroid/widget/FrameLayout;
.source "InlineAutofillClipHost.java"

# interfaces
.implements Landroid/view/View$OnLayoutChangeListener;
.implements Landroid/view/ViewTreeObserver$OnScrollChangedListener;
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;
    }
.end annotation


# static fields
.field private static final HOSTS:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList<",
            "Ljava/lang/ref/WeakReference<",
            "Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;",
            ">;>;"
        }
    .end annotation
.end field

.field private static nativeCandidatesActive:Z


# instance fields
.field private final childLocation:[I

.field private final childRect:Landroid/graphics/Rect;

.field private final hiddenSiblings:Ljava/util/IdentityHashMap;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/IdentityHashMap<",
            "Landroid/view/View;",
            "Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;",
            ">;"
        }
    .end annotation
.end field

.field private final hostRect:Landroid/graphics/Rect;

.field private observingScroll:Z

.field private final row:Landroid/widget/LinearLayout;

.field private final scrollView:Landroid/widget/HorizontalScrollView;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 26
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    return-void
.end method

.method public constructor <init>(Landroid/content/Context;)V
    .locals 1

    .line 40
    const/4 v0, 0x0

    invoke-direct {p0, p1, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 41
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 3

    .line 44
    invoke-direct {p0, p1, p2}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 32
    new-instance p2, Ljava/util/IdentityHashMap;

    invoke-direct {p2}, Ljava/util/IdentityHashMap;-><init>()V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hiddenSiblings:Ljava/util/IdentityHashMap;

    .line 34
    new-instance p2, Landroid/graphics/Rect;

    invoke-direct {p2}, Landroid/graphics/Rect;-><init>()V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hostRect:Landroid/graphics/Rect;

    .line 35
    new-instance p2, Landroid/graphics/Rect;

    invoke-direct {p2}, Landroid/graphics/Rect;-><init>()V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childRect:Landroid/graphics/Rect;

    .line 36
    const/4 p2, 0x2

    new-array v0, p2, [I

    iput-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    .line 45
    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setClipChildren(Z)V

    .line 46
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setClipToPadding(Z)V

    .line 47
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setClickable(Z)V

    .line 48
    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setFocusable(Z)V

    .line 49
    invoke-virtual {p0, v1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setSaveEnabled(Z)V

    .line 51
    new-instance v2, Landroid/widget/HorizontalScrollView;

    invoke-direct {v2, p1}, Landroid/widget/HorizontalScrollView;-><init>(Landroid/content/Context;)V

    iput-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    .line 52
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, v0}, Landroid/widget/HorizontalScrollView;->setClipChildren(Z)V

    .line 53
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, v0}, Landroid/widget/HorizontalScrollView;->setClipToPadding(Z)V

    .line 54
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, v1}, Landroid/widget/HorizontalScrollView;->setFillViewport(Z)V

    .line 55
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, v1}, Landroid/widget/HorizontalScrollView;->setHorizontalScrollBarEnabled(Z)V

    .line 56
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, v1}, Landroid/widget/HorizontalScrollView;->setHorizontalFadingEdgeEnabled(Z)V

    .line 57
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v2, p2}, Landroid/widget/HorizontalScrollView;->setOverScrollMode(I)V

    .line 58
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {p2, v1}, Landroid/widget/HorizontalScrollView;->setFocusable(Z)V

    .line 60
    new-instance p2, Landroid/widget/LinearLayout;

    invoke-direct {p2, p1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    .line 61
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 62
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    const/16 p2, 0x10

    invoke-virtual {p1, p2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 63
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setClipChildren(Z)V

    .line 64
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v0}, Landroid/widget/LinearLayout;->setClipToPadding(Z)V

    .line 65
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v1, -0x2

    const/4 v2, -0x1

    invoke-direct {v0, v1, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, p2, v0}, Landroid/widget/HorizontalScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 67
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p2, v2, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, p1, p2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 69
    invoke-virtual {p0, p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->addOnLayoutChangeListener(Landroid/view/View$OnLayoutChangeListener;)V

    .line 70
    return-void
.end method

.method private applyCandidatePriority(Z)V
    .locals 1

    .line 198
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v0

    if-eqz v0, :cond_1

    if-nez p1, :cond_1

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->isAvailable()Z

    move-result p1

    if-nez p1, :cond_0

    goto :goto_0

    .line 203
    :cond_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hideSiblings()V

    .line 204
    const/4 p1, 0x0

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setVisibility(I)V

    .line 205
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->bringToFront()V

    .line 206
    invoke-virtual {p0, p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->post(Ljava/lang/Runnable;)Z

    .line 207
    return-void

    .line 199
    :cond_1
    :goto_0
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->restoreSiblings()V

    .line 200
    const/16 p1, 0x8

    invoke-virtual {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setVisibility(I)V

    .line 201
    return-void
.end method

.method public static declared-synchronized areNativeCandidatesActive()Z
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 83
    :try_start_0
    sget-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->nativeCandidatesActive:Z
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    monitor-exit v0

    return v1

    .line 83
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method public static declared-synchronized clearAllHosts()V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 98
    :try_start_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->pruneHosts()V

    .line 99
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/ref/WeakReference;

    .line 100
    invoke-virtual {v2}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    .line 101
    if-eqz v2, :cond_0

    .line 102
    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearInlineViews()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 104
    :cond_0
    goto :goto_0

    .line 105
    :cond_1
    monitor-exit v0

    return-void

    .line 97
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw v1

    :goto_2
    goto :goto_1
.end method

.method private clearRowOnly()V
    .locals 4

    .line 188
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    const/4 v2, 0x0

    if-lt v0, v1, :cond_0

    .line 189
    const/4 v0, 0x0

    :goto_0
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v1}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v1

    if-ge v0, v1, :cond_0

    .line 190
    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v1

    const/4 v3, 0x0

    invoke-static {v1, v3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 189
    add-int/lit8 v0, v0, 0x1

    goto :goto_0

    .line 193
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 194
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v0, v2, v2}, Landroid/widget/HorizontalScrollView;->scrollTo(II)V

    .line 195
    return-void
.end method

.method public static declared-synchronized findCurrentHost()Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;
    .locals 4

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 87
    :try_start_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->pruneHosts()V

    .line 88
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I

    move-result v1

    add-int/lit8 v1, v1, -0x1

    :goto_0
    if-ltz v1, :cond_1

    .line 89
    sget-object v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v2, v1}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/ref/WeakReference;

    invoke-virtual {v2}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    .line 90
    if-eqz v2, :cond_0

    invoke-virtual {v2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->isAvailable()Z

    move-result v3
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v3, :cond_0

    .line 91
    monitor-exit v0

    return-object v2

    .line 88
    :cond_0
    add-int/lit8 v1, v1, -0x1

    goto :goto_0

    .line 94
    :cond_1
    monitor-exit v0

    const/4 v0, 0x0

    return-object v0

    .line 86
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw v1

    :goto_2
    goto :goto_1
.end method

.method private hideSiblings()V
    .locals 7

    .line 210
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 211
    instance-of v1, v0, Landroid/view/ViewGroup;

    if-nez v1, :cond_0

    .line 212
    return-void

    .line 214
    :cond_0
    check-cast v0, Landroid/view/ViewGroup;

    .line 215
    const/4 v1, 0x0

    :goto_0
    invoke-virtual {v0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v2

    if-ge v1, v2, :cond_3

    .line 216
    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 217
    if-eq v2, p0, :cond_2

    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hiddenSiblings:Ljava/util/IdentityHashMap;

    invoke-virtual {v3, v2}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_1

    .line 218
    goto :goto_1

    .line 220
    :cond_1
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hiddenSiblings:Ljava/util/IdentityHashMap;

    new-instance v4, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;

    .line 221
    invoke-virtual {v2}, Landroid/view/View;->getAlpha()F

    move-result v5

    invoke-virtual {v2}, Landroid/view/View;->getImportantForAccessibility()I

    move-result v6

    invoke-direct {v4, v5, v6}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;-><init>(FI)V

    .line 220
    invoke-virtual {v3, v2, v4}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 222
    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setAlpha(F)V

    .line 223
    const/4 v3, 0x4

    invoke-virtual {v2, v3}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 215
    :cond_2
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 225
    :cond_3
    return-void
.end method

.method public static declared-synchronized onCandidates(Ljava/util/List;)V
    .locals 1
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "*>;)V"
        }
    .end annotation

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 73
    if-eqz p0, :cond_0

    :try_start_0
    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-nez p0, :cond_0

    const/4 p0, 0x1

    goto :goto_0

    .line 72
    :catchall_0
    move-exception p0

    goto :goto_1

    .line 73
    :cond_0
    const/4 p0, 0x0

    :goto_0
    sput-boolean p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->nativeCandidatesActive:Z

    .line 74
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->updateHostsForCandidatePriority()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 75
    monitor-exit v0

    return-void

    .line 72
    :goto_1
    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw p0
.end method

.method public static declared-synchronized onCandidatesCleared()V
    .locals 2

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 78
    const/4 v1, 0x0

    :try_start_0
    sput-boolean v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->nativeCandidatesActive:Z

    .line 79
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->updateHostsForCandidatePriority()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 80
    monitor-exit v0

    return-void

    .line 77
    :catchall_0
    move-exception v1

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    throw v1
.end method

.method private static pruneHosts()V
    .locals 2

    .line 118
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 119
    :cond_0
    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    .line 120
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_0

    .line 121
    invoke-interface {v0}, Ljava/util/Iterator;->remove()V

    goto :goto_0

    .line 124
    :cond_1
    return-void
.end method

.method private static declared-synchronized register(Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 127
    :try_start_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->pruneHosts()V

    .line 128
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_1

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/ref/WeakReference;

    .line 129
    invoke-virtual {v2}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v2
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-ne v2, p0, :cond_0

    .line 130
    monitor-exit v0

    return-void

    .line 132
    :cond_0
    goto :goto_0

    .line 133
    :cond_1
    :try_start_1
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    new-instance v2, Ljava/lang/ref/WeakReference;

    invoke-direct {v2, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    invoke-virtual {v1, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 134
    monitor-exit v0

    return-void

    .line 126
    :catchall_0
    move-exception p0

    :try_start_2
    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method private restoreSiblings()V
    .locals 4

    .line 228
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hiddenSiblings:Ljava/util/IdentityHashMap;

    invoke-virtual {v0}, Ljava/util/IdentityHashMap;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_0

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/util/Map$Entry;

    .line 229
    invoke-interface {v1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 230
    invoke-interface {v1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;

    .line 231
    iget v3, v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;->alpha:F

    invoke-virtual {v2, v3}, Landroid/view/View;->setAlpha(F)V

    .line 232
    iget v1, v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;->importantForAccessibility:I

    invoke-virtual {v2, v1}, Landroid/view/View;->setImportantForAccessibility(I)V

    .line 233
    goto :goto_0

    .line 234
    :cond_0
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hiddenSiblings:Ljava/util/IdentityHashMap;

    invoke-virtual {v0}, Ljava/util/IdentityHashMap;->clear()V

    .line 235
    return-void
.end method

.method private static declared-synchronized unregister(Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V
    .locals 3

    const-class v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    monitor-enter v0

    .line 137
    :try_start_0
    sget-object v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v1}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v1

    .line 138
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 139
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/ref/WeakReference;

    invoke-virtual {v2}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    .line 140
    if-eqz v2, :cond_0

    if-ne v2, p0, :cond_1

    .line 141
    :cond_0
    invoke-interface {v1}, Ljava/util/Iterator;->remove()V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 143
    :cond_1
    goto :goto_0

    .line 144
    :cond_2
    monitor-exit v0

    return-void

    .line 136
    :catchall_0
    move-exception p0

    :try_start_1
    monitor-exit v0
    :try_end_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    goto :goto_2

    :goto_1
    throw p0

    :goto_2
    goto :goto_1
.end method

.method private static updateHostsForCandidatePriority()V
    .locals 3

    .line 108
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->pruneHosts()V

    .line 109
    sget-object v0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->HOSTS:Ljava/util/ArrayList;

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/ref/WeakReference;

    .line 110
    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;

    .line 111
    if-eqz v1, :cond_0

    .line 112
    sget-boolean v2, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->nativeCandidatesActive:Z

    invoke-direct {v1, v2}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->applyCandidatePriority(Z)V

    .line 114
    :cond_0
    goto :goto_0

    .line 115
    :cond_1
    return-void
.end method

.method private updateRemoteClipBounds()V
    .locals 10

    .line 280
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1e

    if-lt v0, v1, :cond_3

    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getVisibility()I

    move-result v0

    if-nez v0, :cond_3

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hostRect:Landroid/graphics/Rect;

    .line 281
    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getGlobalVisibleRect(Landroid/graphics/Rect;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_2

    .line 284
    :cond_0
    const/4 v0, 0x0

    const/4 v1, 0x0

    :goto_0
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v2}, Landroid/widget/LinearLayout;->getChildCount()I

    move-result v2

    if-ge v1, v2, :cond_2

    .line 285
    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v1}, Landroid/widget/LinearLayout;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    .line 286
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    invoke-virtual {v2, v3}, Landroid/view/View;->getLocationOnScreen([I)V

    .line 287
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childRect:Landroid/graphics/Rect;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    aget v4, v4, v0

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    const/4 v6, 0x1

    aget v5, v5, v6

    iget-object v7, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    aget v7, v7, v0

    .line 290
    invoke-virtual {v2}, Landroid/view/View;->getWidth()I

    move-result v8

    add-int/2addr v7, v8

    iget-object v8, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    aget v8, v8, v6

    .line 291
    invoke-virtual {v2}, Landroid/view/View;->getHeight()I

    move-result v9

    add-int/2addr v8, v9

    .line 287
    invoke-virtual {v3, v4, v5, v7, v8}, Landroid/graphics/Rect;->set(IIII)V

    .line 292
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childRect:Landroid/graphics/Rect;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->hostRect:Landroid/graphics/Rect;

    invoke-virtual {v3, v4}, Landroid/graphics/Rect;->intersect(Landroid/graphics/Rect;)Z

    move-result v3

    if-nez v3, :cond_1

    .line 293
    new-instance v3, Landroid/graphics/Rect;

    invoke-direct {v3, v0, v0, v0, v0}, Landroid/graphics/Rect;-><init>(IIII)V

    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 294
    goto :goto_1

    .line 296
    :cond_1
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childRect:Landroid/graphics/Rect;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    aget v4, v4, v0

    neg-int v4, v4

    iget-object v5, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childLocation:[I

    aget v5, v5, v6

    neg-int v5, v5

    invoke-virtual {v3, v4, v5}, Landroid/graphics/Rect;->offset(II)V

    .line 297
    new-instance v3, Landroid/graphics/Rect;

    iget-object v4, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->childRect:Landroid/graphics/Rect;

    invoke-direct {v3, v4}, Landroid/graphics/Rect;-><init>(Landroid/graphics/Rect;)V

    invoke-static {v2, v3}, Lcom/google/android/inputmethod/pinyin/InlineAutofillCompat;->applyRemoteClip(Landroid/view/View;Landroid/graphics/Rect;)V

    .line 284
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 299
    :cond_2
    return-void

    .line 282
    :cond_3
    :goto_2
    return-void
.end method


# virtual methods
.method public clearInlineViews()V
    .locals 1

    .line 181
    invoke-virtual {p0, p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->removeCallbacks(Ljava/lang/Runnable;)Z

    .line 182
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearRowOnly()V

    .line 183
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->restoreSiblings()V

    .line 184
    const/16 v0, 0x8

    invoke-virtual {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->setVisibility(I)V

    .line 185
    return-void
.end method

.method public isAvailable()Z
    .locals 3

    .line 147
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getWindowToken()Landroid/os/IBinder;

    move-result-object v0

    const/4 v1, 0x0

    if-nez v0, :cond_0

    .line 148
    return v1

    .line 150
    :cond_0
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    .line 151
    instance-of v2, v0, Landroid/view/View;

    if-eqz v2, :cond_1

    check-cast v0, Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->isShown()Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v1, 0x1

    :cond_1
    return v1
.end method

.method protected onAttachedToWindow()V
    .locals 2

    .line 239
    invoke-super {p0}, Landroid/widget/FrameLayout;->onAttachedToWindow()V

    .line 240
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->register(Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V

    .line 241
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v0}, Landroid/widget/HorizontalScrollView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 242
    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 243
    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->addOnScrollChangedListener(Landroid/view/ViewTreeObserver$OnScrollChangedListener;)V

    .line 244
    const/4 v0, 0x1

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->observingScroll:Z

    .line 246
    :cond_0
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->areNativeCandidatesActive()Z

    move-result v0

    invoke-direct {p0, v0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->applyCandidatePriority(Z)V

    .line 247
    return-void
.end method

.method protected onDetachedFromWindow()V
    .locals 2

    .line 251
    iget-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->observingScroll:Z

    if-eqz v0, :cond_1

    .line 252
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->scrollView:Landroid/widget/HorizontalScrollView;

    invoke-virtual {v0}, Landroid/widget/HorizontalScrollView;->getViewTreeObserver()Landroid/view/ViewTreeObserver;

    move-result-object v0

    .line 253
    invoke-virtual {v0}, Landroid/view/ViewTreeObserver;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 254
    invoke-virtual {v0, p0}, Landroid/view/ViewTreeObserver;->removeOnScrollChangedListener(Landroid/view/ViewTreeObserver$OnScrollChangedListener;)V

    .line 256
    :cond_0
    const/4 v0, 0x0

    iput-boolean v0, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->observingScroll:Z

    .line 258
    :cond_1
    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->unregister(Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;)V

    .line 259
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearInlineViews()V

    .line 260
    invoke-super {p0}, Landroid/widget/FrameLayout;->onDetachedFromWindow()V

    .line 261
    return-void
.end method

.method public onLayoutChange(Landroid/view/View;IIIIIIII)V
    .locals 0

    .line 266
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->updateRemoteClipBounds()V

    .line 267
    return-void
.end method

.method public onScrollChanged()V
    .locals 0

    .line 271
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->updateRemoteClipBounds()V

    .line 272
    return-void
.end method

.method public run()V
    .locals 0

    .line 276
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->updateRemoteClipBounds()V

    .line 277
    return-void
.end method

.method public setInlineViews(Ljava/util/List;)V
    .locals 6
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/util/List<",
            "+",
            "Landroid/view/View;",
            ">;)V"
        }
    .end annotation

    .line 155
    invoke-direct {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->clearRowOnly()V

    .line 156
    invoke-virtual {p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    const/high16 v1, 0x40800000    # 4.0f

    mul-float v0, v0, v1

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result v0

    const/4 v1, 0x1

    invoke-static {v1, v0}, Ljava/lang/Math;->max(II)I

    move-result v0

    .line 157
    nop

    .line 158
    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    const/4 v1, 0x0

    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_5

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    .line 159
    if-nez v2, :cond_0

    .line 160
    goto :goto_0

    .line 162
    :cond_0
    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    .line 163
    instance-of v4, v3, Landroid/view/ViewGroup;

    if-eqz v4, :cond_1

    .line 164
    check-cast v3, Landroid/view/ViewGroup;

    invoke-virtual {v3, v2}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    .line 166
    :cond_1
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    .line 167
    if-eqz v3, :cond_2

    iget v4, v3, Landroid/view/ViewGroup$LayoutParams;->width:I

    goto :goto_1

    :cond_2
    const/4 v4, -0x2

    .line 168
    :goto_1
    if-eqz v3, :cond_3

    iget v3, v3, Landroid/view/ViewGroup$LayoutParams;->height:I

    goto :goto_2

    :cond_3
    const/4 v3, -0x1

    .line 169
    :goto_2
    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v5, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 170
    if-lez v1, :cond_4

    .line 171
    iput v0, v5, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    .line 173
    :cond_4
    iget-object v3, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->row:Landroid/widget/LinearLayout;

    invoke-virtual {v3, v2, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 174
    add-int/lit8 v1, v1, 0x1

    .line 175
    goto :goto_0

    .line 176
    :cond_5
    invoke-static {}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->areNativeCandidatesActive()Z

    move-result p1

    invoke-direct {p0, p1}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->applyCandidatePriority(Z)V

    .line 177
    invoke-virtual {p0, p0}, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;->post(Ljava/lang/Runnable;)Z

    .line 178
    return-void
.end method
