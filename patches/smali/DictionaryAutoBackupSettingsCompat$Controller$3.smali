.class Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;
.super Ljava/lang/Object;
.source "DictionaryAutoBackupSettingsCompat.java"

# interfaces
.implements Lcom/google/android/inputmethod/pinyin/DictionaryHealthStatusCompat$Callback;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->loadDictionaryStatus()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

.field final synthetic val$generation:I


# direct methods
.method constructor <init>(Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;I)V
    .registers 3

    .line 184
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iput p2, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->val$generation:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onLoaded(Ljava/lang/String;)V
    .registers 4

    .line 186
    iget v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->val$generation:I

    iget-object v1, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget v1, v1, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusGeneration:I

    if-ne v0, v1, :cond_35

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->fragment:Landroid/preference/PreferenceFragment;

    if-eqz v0, :cond_35

    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    if-nez v0, :cond_15

    goto :goto_35

    .line 188
    :cond_15
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    const/4 v1, 0x0

    iput-boolean v1, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->statusLoading:Z

    .line 189
    iget-object v0, p0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller$3;->this$0:Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;

    iget-object v0, v0, Lcom/google/android/inputmethod/pinyin/DictionaryAutoBackupSettingsCompat$Controller;->dictionaryStatus:Landroid/preference/Preference;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "\n\u70b9\u51fb\u91cd\u65b0\u68c0\u67e5"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/preference/Preference;->setSummary(Ljava/lang/CharSequence;)V

    .line 190
    return-void

    .line 187
    :cond_35
    :goto_35
    return-void
.end method
