.class public final Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;
.super Ljava/lang/Object;
.source "QuickBar.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/QuickBar;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x19
    name = "Entry"
.end annotation


# instance fields
.field final action:I

.field final iconName:Ljava/lang/String;

.field final id:Ljava/lang/String;

.field final label:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V
    .locals 0

    .line 41
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->id:Ljava/lang/String;

    .line 43
    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->iconName:Ljava/lang/String;

    .line 44
    iput-object p3, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->label:Ljava/lang/String;

    .line 45
    iput p4, p0, Lcom/google/android/inputmethod/pinyin/QuickBar$Entry;->action:I

    .line 46
    return-void
.end method
