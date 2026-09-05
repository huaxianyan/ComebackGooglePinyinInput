"""Patch the native factory with a synchronous data refresh / main-thread notification contract."""
from pathlib import Path

FACTORY = "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory;"
TYPE = "Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$MutableDictionaryType;"


def patch_native_dictionary_refresh(decoded: Path, replace_once) -> None:
    directory = decoded / "smali/com/google/android/apps/inputmethod/libs/hmm"
    path = directory / "AbstractHmmEngineFactory.smali"
    text = path.read_text(encoding="utf-8")
    marker = ".method public final notifyMutableDictionaryDataChanged("
    start = text.index(marker)
    end = text.index(".end method", start) + len(".end method")
    # Preserve the asynchronous legacy entry. Its Runnable now shares the refresh implementation.
    notification = f'''{marker}{TYPE})V
    .locals 2
    iget-object v0, p0, {FACTORY}->mHandlerOnMainThread:Landroid/os/Handler;
    new-instance v1, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;
    invoke-direct {{v1, p0, p1}}, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;-><init>({FACTORY}{TYPE})V
    invoke-virtual {{v0, v1}}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    return-void
.end method

.method public final refreshMutableDictionaryData({TYPE})V
    .locals 5
    invoke-virtual {{p0, p1}}, {FACTORY}->getMutableDictionaryFileName({TYPE})Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :done
    iget-object v1, p0, {FACTORY}->mContext:Landroid/content/Context;
    invoke-virtual {{p0, p1}}, {FACTORY}->getMutableDictionaryDataType({TYPE})I
    move-result v3
    invoke-virtual {{p0, p1}}, {FACTORY}->getMutableDictionaryTokenCategory({TYPE})I
    move-result v4
    move-object v0, p0
    invoke-virtual/range {{v0 .. v4}}, {FACTORY}->enrollMutableDictionary(Landroid/content/Context;Ljava/lang/String;II)V
    invoke-static {{}}, Landroid/os/Looper;->myLooper()Landroid/os/Looper;
    move-result-object v0
    iget-object v1, p0, {FACTORY}->mHandlerOnMainThread:Landroid/os/Handler;
    invoke-virtual {{v1}}, Landroid/os/Handler;->getLooper()Landroid/os/Looper;
    move-result-object v2
    if-ne v0, v2, :post
    invoke-virtual {{p0}}, {FACTORY}->notifyDataChanged()V
    goto :done
    :post
    new-instance v0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryDataNotification;
    invoke-direct {{v0, p0}}, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryDataNotification;-><init>({FACTORY})V
    invoke-virtual {{v1, v0}}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :done
    return-void
.end method'''
    if "refreshMutableDictionaryData(" in text:
        raise ValueError("factory refresh patch already applied")
    path.write_text(text[:start] + notification + text[end:], encoding="utf-8")
    runnable = f''' .class Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.field private final factory:{FACTORY}
.field private final dictionaryType:{TYPE}
.method constructor <init>({FACTORY}{TYPE})V
    .locals 0
    invoke-direct {{p0}}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;->factory:{FACTORY}
    iput-object p2, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;->dictionaryType:{TYPE}
    return-void
.end method
.method public run()V
    .locals 2
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;->factory:{FACTORY}
    iget-object v1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/AbstractHmmEngineFactory$1;->dictionaryType:{TYPE}
    invoke-virtual {{v0, v1}}, {FACTORY}->refreshMutableDictionaryData({TYPE})V
    return-void
.end method
'''
    # Native writers must publish refreshed data before handing the shared lock to a reader.
    # The importer already closes its accessors before this notification site.
    replace_once(
        directory / "userdictionary/UserDictImportTask.smali",
        f"invoke-virtual {{v4, v5}}, {FACTORY}->notifyMutableDictionaryDataChanged({TYPE})V",
        f"invoke-virtual {{v4, v5}}, {FACTORY}->refreshMutableDictionaryData({TYPE})V",
    )
    replace_once(
        directory / "SaveDictionaryTask.smali",
        f"    .line 29\n"
        f"    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->mEngineFactory:{FACTORY}\n\n"
        f"    invoke-virtual {{v0, p1}}, {FACTORY}->notifyMutableDictionaryDataChanged({TYPE})V\n\n"
        f"    .line 30\n"
        f"    invoke-virtual {{v1}}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V",
        f"    invoke-virtual {{v1}}, Lcom/google/android/apps/inputmethod/libs/hmm/DictionaryAccessor;->close()V\n\n"
        f"    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/SaveDictionaryTask;->mEngineFactory:{FACTORY}\n\n"
        f"    invoke-virtual {{v0, p1}}, {FACTORY}->refreshMutableDictionaryData({TYPE})V",
    )
    (directory / "AbstractHmmEngineFactory$1.smali").write_text(runnable.lstrip(), encoding="utf-8")
    (directory / "MutableDictionaryDataNotification.smali").write_text(f'''.class final Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryDataNotification;
.super Ljava/lang/Object;
.implements Ljava/lang/Runnable;
.field private final factory:{FACTORY}
.method constructor <init>({FACTORY})V
    .locals 0
    invoke-direct {{p0}}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryDataNotification;->factory:{FACTORY}
    return-void
.end method
.method public run()V
    .locals 1
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/libs/hmm/MutableDictionaryDataNotification;->factory:{FACTORY}
    invoke-virtual {{v0}}, {FACTORY}->notifyDataChanged()V
    return-void
.end method
''', encoding="utf-8")
