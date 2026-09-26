.class Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;
.super Ljava/lang/Object;
.source "RimeSyncLegacySettingsCompat.java"

# interfaces
.implements Landroid/content/DialogInterface$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->showPreviewDialog(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

.field final synthetic val$preview:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 583
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;->val$preview:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/content/DialogInterface;I)V
    .locals 1

    .line 585
    invoke-interface {p1}, Landroid/content/DialogInterface;->dismiss()V

    .line 586
    iget-object p1, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;->this$0:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;

    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;->val$preview:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    iget-object p2, p2, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->confirmationToken:Ljava/lang/String;

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller$11;->val$preview:Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;

    iget-boolean v0, v0, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncSettingsCompat$Result;->requiresDeletionConfirmation:Z

    invoke-static {p1, p2, v0}, Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;->access$1600(Lcom/google/android/inputmethod/pinyin/rimesync/RimeSyncLegacySettingsCompat$Controller;Ljava/lang/String;Z)V

    .line 588
    return-void
.end method
