.class final Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ControllerDelegate;
.super Ljava/lang/Object;
.implements Lcom/google/android/apps/inputmethod/libs/dataservice/preference/IDictionarySyncControllerDelegate;

.field private final controller:Lbdz;

.method constructor <init>(Lbdz;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ControllerDelegate;->controller:Lbdz;
    return-void
.end method

.method public onSyncStatusUpdated(IZ)V
    .locals 1

    const/4 v0, 0x3
    if-ne p1, v0, :check_finished

    invoke-static {}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->notifyClearStarted()V
    return-void

    :check_finished
    const/4 v0, 0x4
    if-ne p1, v0, :done

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat$ControllerDelegate;->controller:Lbdz;
    invoke-virtual {v0}, Lbdz;->onDestroy()V
    invoke-static {v0, p2}, Lcom/google/android/inputmethod/pinyin/DictionaryOperationsCompat;->notifyClearFinished(Lbdz;Z)V

    :done
    return-void
.end method
