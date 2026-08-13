.class public interface abstract Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderModule;
.super Ljava/lang/Object;
.source "HeaderModule.java"


# virtual methods
.method public abstract getDefaultPriority()I
.end method

.method public abstract getModuleId()Ljava/lang/String;
.end method

.method public abstract onAttach(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderPlatformContext;)V
.end method

.method public abstract onDetach()V
.end method

.method public abstract onFinishInput(J)V
.end method

.method public abstract onHeaderAvailable(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderHandle;)V
.end method

.method public abstract onHeaderUnavailable(J)V
.end method

.method public abstract onNativeCandidateStateChanged(Z)V
.end method

.method public abstract onStartInput(Lcom/google/android/inputmethod/pinyin/headerplatform/HeaderEditorContext;J)V
.end method

.method public abstract onThemeChanged(J)V
.end method
