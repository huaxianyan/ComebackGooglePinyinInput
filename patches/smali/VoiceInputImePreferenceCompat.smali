.class public final Lcom/google/android/inputmethod/pinyin/VoiceInputImePreferenceCompat;
.super Ljava/lang/Object;

.method private constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static bind(Landroid/preference/PreferenceFragment;)V
    .locals 14
    if-eqz p0, :done
    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getPreferenceScreen()Landroid/preference/PreferenceScreen;
    move-result-object v1
    const-string v2, "voice_input_ime_package"
    invoke-virtual {v1, v2}, Landroid/preference/PreferenceGroup;->findPreference(Ljava/lang/CharSequence;)Landroid/preference/Preference;
    move-result-object v1
    instance-of v2, v1, Landroid/preference/ListPreference;
    if-eqz v2, :done
    check-cast v1, Landroid/preference/ListPreference;
    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V
    new-instance v3, Ljava/util/ArrayList;
    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V
    const-string v4, "自动选择"
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    const-string v4, "auto"
    invoke-virtual {v3, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    const-string v4, "input_method"
    invoke-virtual {v0, v4}, Landroid/app/Activity;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Landroid/view/inputmethod/InputMethodManager;
    invoke-virtual {v4}, Landroid/view/inputmethod/InputMethodManager;->getEnabledInputMethodList()Ljava/util/List;
    move-result-object v4
    invoke-interface {v4}, Ljava/util/List;->iterator()Ljava/util/Iterator;
    move-result-object v5
    :ime_loop
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z
    move-result v6
    if-eqz v6, :ime_done
    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Landroid/view/inputmethod/InputMethodInfo;
    const/4 v7, 0x0
    invoke-virtual {v6}, Landroid/view/inputmethod/InputMethodInfo;->getSubtypeCount()I
    move-result v8
    :subtype_loop
    if-ge v7, v8, :ime_loop
    invoke-virtual {v6, v7}, Landroid/view/inputmethod/InputMethodInfo;->getSubtypeAt(I)Landroid/view/inputmethod/InputMethodSubtype;
    move-result-object v9
    invoke-virtual {v9}, Landroid/view/inputmethod/InputMethodSubtype;->getMode()Ljava/lang/String;
    move-result-object v10
    const-string v11, "voice"
    invoke-virtual {v11, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v10
    if-eqz v10, :next_subtype
    invoke-virtual {v6}, Landroid/view/inputmethod/InputMethodInfo;->getPackageName()Ljava/lang/String;
    move-result-object v10
    invoke-virtual {v0}, Landroid/app/Activity;->getPackageManager()Landroid/content/pm/PackageManager;
    move-result-object v11
    invoke-virtual {v6, v11}, Landroid/view/inputmethod/InputMethodInfo;->loadLabel(Landroid/content/pm/PackageManager;)Ljava/lang/CharSequence;
    move-result-object v11
    invoke-virtual {v2, v11}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    invoke-virtual {v3, v10}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    goto :ime_loop
    :next_subtype
    add-int/lit8 v7, v7, 0x1
    goto :subtype_loop
    :ime_done
    invoke-virtual {v2}, Ljava/util/ArrayList;->size()I
    move-result v5
    new-array v5, v5, [Ljava/lang/CharSequence;
    invoke-virtual {v2, v5}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/lang/CharSequence;
    invoke-virtual {v1, v5}, Landroid/preference/ListPreference;->setEntries([Ljava/lang/CharSequence;)V
    invoke-virtual {v3}, Ljava/util/ArrayList;->size()I
    move-result v5
    new-array v5, v5, [Ljava/lang/CharSequence;
    invoke-virtual {v3, v5}, Ljava/util/ArrayList;->toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    move-result-object v5
    check-cast v5, [Ljava/lang/CharSequence;
    invoke-virtual {v1, v5}, Landroid/preference/ListPreference;->setEntryValues([Ljava/lang/CharSequence;)V
    invoke-static {v0}, Landroid/preference/PreferenceManager;->getDefaultSharedPreferences(Landroid/content/Context;)Landroid/content/SharedPreferences;
    move-result-object v0
    const-string v2, "voice_input_ime_package"
    const-string v4, "auto"
    invoke-interface {v0, v2, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    invoke-virtual {v3, v0}, Ljava/util/ArrayList;->contains(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :fallback
    invoke-virtual {v1, v0}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V
    goto :done
    :fallback
    invoke-virtual {v1, v4}, Landroid/preference/ListPreference;->setValue(Ljava/lang/String;)V
    :done
    return-void
.end method
