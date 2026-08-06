.class public final Lcom/google/android/inputmethod/pinyin/Md3SettingsCompat;
.super Ljava/lang/Object;


# direct methods
.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apply(Landroid/preference/PreferenceFragment;)V
    .locals 7

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-lt v0, v1, :done

    if-eqz p0, :done

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getActivity()Landroid/app/Activity;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getPreferenceScreen()Landroid/preference/PreferenceScreen;

    move-result-object v1

    if-eqz v1, :style_list

    invoke-virtual {v0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    const-string v3, "md3_preference"

    const-string v4, "layout"

    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v3, v4, v5}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v3

    const-string v4, "md3_preference_category"

    const-string v5, "layout"

    invoke-virtual {v0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v4, v5, v0}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    if-eqz v3, :style_list

    if-eqz v0, :style_list

    const-string v4, "md3_switch_widget"

    const-string v5, "layout"

    invoke-virtual {v1}, Landroid/preference/Preference;->getContext()Landroid/content/Context;

    move-result-object v6

    invoke-virtual {v6}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v2, v4, v5, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :style_list

    invoke-static {v1, v3, v0, v4}, Lcom/google/android/inputmethod/pinyin/Md3SettingsCompat;->decorateGroup(Landroid/preference/PreferenceGroup;III)V

    :style_list
    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getView()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :done

    invoke-virtual {p0}, Landroid/preference/PreferenceFragment;->getListView()Landroid/widget/ListView;

    move-result-object v0

    invoke-static {v0}, Lcom/google/android/inputmethod/pinyin/Md3SettingsCompat;->styleList(Landroid/widget/ListView;)V

    :done
    return-void
.end method

.method public static apply(Landroid/app/Activity;)V
    .locals 2

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x23

    if-lt v0, v1, :done

    if-eqz p0, :done

    const v0, 0x102000a

    invoke-virtual {p0, v0}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object p0

    instance-of v0, p0, Landroid/widget/ListView;

    if-eqz v0, :done

    check-cast p0, Landroid/widget/ListView;

    invoke-static {p0}, Lcom/google/android/inputmethod/pinyin/Md3SettingsCompat;->styleList(Landroid/widget/ListView;)V

    :done
    return-void
.end method

.method private static decorateGroup(Landroid/preference/PreferenceGroup;III)V
    .locals 5

    invoke-virtual {p0}, Landroid/preference/PreferenceGroup;->getPreferenceCount()I

    move-result v0

    const/4 v1, 0x0

    :loop
    if-ge v1, v0, :done

    invoke-virtual {p0, v1}, Landroid/preference/PreferenceGroup;->getPreference(I)Landroid/preference/Preference;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    const-string v4, "android.preference."

    invoke-virtual {v3, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    instance-of v4, v2, Landroid/preference/PreferenceCategory;

    if-eqz v4, :checkbox

    if-eqz v3, :recurse

    invoke-virtual {v2, p2}, Landroid/preference/Preference;->setLayoutResource(I)V

    goto :recurse

    :checkbox
    instance-of v4, v2, Landroid/preference/CheckBoxPreference;

    if-eqz v4, :list

    invoke-virtual {v2, p1}, Landroid/preference/Preference;->setLayoutResource(I)V

    invoke-virtual {v2, p3}, Landroid/preference/Preference;->setWidgetLayoutResource(I)V

    goto :recurse

    :list
    instance-of v4, v2, Landroid/preference/ListPreference;

    if-nez v4, :dialog_row

    instance-of v4, v2, Landroid/preference/DialogPreference;

    if-eqz v4, :ordinary

    :dialog_row
    invoke-virtual {v2, p1}, Landroid/preference/Preference;->setLayoutResource(I)V

    goto :recurse

    :ordinary
    if-eqz v3, :recurse

    invoke-virtual {v2, p1}, Landroid/preference/Preference;->setLayoutResource(I)V

    :recurse
    instance-of v3, v2, Landroid/preference/PreferenceGroup;

    if-eqz v3, :next

    check-cast v2, Landroid/preference/PreferenceGroup;

    invoke-static {v2, p1, p2, p3}, Lcom/google/android/inputmethod/pinyin/Md3SettingsCompat;->decorateGroup(Landroid/preference/PreferenceGroup;III)V

    :next
    add-int/lit8 v1, v1, 0x1

    goto :loop

    :done
    return-void
.end method

.method private static styleList(Landroid/widget/ListView;)V
    .locals 8

    if-eqz p0, :done

    invoke-virtual {p0}, Landroid/widget/ListView;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    const/high16 v2, 0x41000000    # 8.0f

    mul-float v2, v2, v1

    float-to-int v2, v2

    const/high16 v3, 0x41800000    # 16.0f

    mul-float v3, v3, v1

    float-to-int v3, v3

    const/high16 v4, 0x41c00000    # 24.0f

    mul-float v4, v4, v1

    float-to-int v4, v4

    invoke-virtual {p0, v2, v2, v2, v4}, Landroid/widget/ListView;->setPadding(IIII)V

    const/4 v1, 0x0

    invoke-virtual {p0, v1}, Landroid/widget/ListView;->setClipToPadding(Z)V

    new-instance v4, Landroid/graphics/drawable/ColorDrawable;

    const/4 v5, 0x0

    invoke-direct {v4, v5}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {p0, v4}, Landroid/widget/ListView;->setDivider(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {p0, v2}, Landroid/widget/ListView;->setDividerHeight(I)V

    const-string v4, "settings_md3_surface"

    const-string v6, "color"

    invoke-virtual {p0}, Landroid/widget/ListView;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-virtual {v7}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v4, v6, v7}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-eqz v4, :selector

    invoke-virtual {v0, v4}, Landroid/content/res/Resources;->getColor(I)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/widget/ListView;->setBackgroundColor(I)V

    :selector
    invoke-virtual {p0}, Landroid/widget/ListView;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v4, "bg_settings_md3_preference_row"

    const-string v6, "drawable"

    invoke-virtual {p0}, Landroid/widget/ListView;->getContext()Landroid/content/Context;

    move-result-object v7

    invoke-virtual {v7}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v0, v4, v6, v7}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    if-eqz v0, :done

    invoke-virtual {p0, v0}, Landroid/widget/ListView;->setSelector(I)V

    :done
    return-void
.end method
