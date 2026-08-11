.class final Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;
.super Ljava/lang/Object;
.source "InlineAutofillClipHost.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x1a
    name = "SiblingState"
.end annotation


# instance fields
.field final alpha:F

.field final importantForAccessibility:I


# direct methods
.method constructor <init>(FI)V
    .locals 0

    .line 305
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 306
    iput p1, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;->alpha:F

    .line 307
    iput p2, p0, Lcom/google/android/inputmethod/pinyin/InlineAutofillClipHost$SiblingState;->importantForAccessibility:I

    .line 308
    return-void
.end method
