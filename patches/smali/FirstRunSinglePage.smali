.class public final Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;
.super Lapr;
.source "FirstRunSinglePage.java"

# interfaces
.implements Landroid/view/View$OnClickListener;

# instance fields
.field private helper:Lajy;
.field private enableAction:Landroid/view/View;
.field private enableDone:Landroid/view/View;
.field private selectAction:Landroid/view/View;
.field private selectDone:Landroid/view/View;
.field private finishAction:Landroid/view/View;

# direct methods
.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .locals 1

    invoke-direct {p0, p1, p2}, Lapr;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    new-instance v0, Lajy;

    invoke-direct {v0, p1}, Lajy;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->helper:Lajy;

    return-void
.end method

.method private find(Ljava/lang/String;)Landroid/view/View;
    .locals 4

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "id"

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v3

    if-eqz v3, :missing

    invoke-virtual {p0, v3}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->findViewById(I)Landroid/view/View;

    move-result-object v0

    return-object v0

    :missing
    const/4 v0, 0x0

    return-object v0
.end method

.method private static showState(Landroid/view/View;Landroid/view/View;Z)V
    .locals 2

    const/16 v0, 0x8

    const/4 v1, 0x0

    if-eqz p2, :incomplete

    if-eqz p0, :hide_action_done

    invoke-virtual {p0, v0}, Landroid/view/View;->setVisibility(I)V

    :hide_action_done
    if-eqz p1, :done

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    goto :done

    :incomplete
    if-eqz p0, :show_action_done

    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V

    :show_action_done
    if-eqz p1, :done

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    :done
    return-void
.end method

.method private refresh()V
    .locals 4

    invoke-static {}, Lajy;->a()V

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->helper:Lajy;

    invoke-virtual {v0}, Lajy;->a()Z

    move-result v1

    iget-object v2, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableAction:Landroid/view/View;

    iget-object v3, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableDone:Landroid/view/View;

    invoke-static {v2, v3, v1}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->showState(Landroid/view/View;Landroid/view/View;Z)V

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->helper:Lajy;

    invoke-virtual {v0}, Lajy;->b()Z

    move-result v0

    iget-object v2, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectAction:Landroid/view/View;

    iget-object v3, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectDone:Landroid/view/View;

    invoke-static {v2, v3, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->showState(Landroid/view/View;Landroid/view/View;Z)V

    iget-object v2, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectAction:Landroid/view/View;

    if-eqz v2, :finish_state

    invoke-virtual {v2, v1}, Landroid/view/View;->setEnabled(Z)V

    :finish_state
    if-eqz v1, :not_ready

    if-eqz v0, :not_ready

    const/4 v0, 0x1

    goto :set_finish

    :not_ready
    const/4 v0, 0x0

    :set_finish
    iget-object v1, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->finishAction:Landroid/view/View;

    if-eqz v1, :done

    invoke-virtual {v1, v0}, Landroid/view/View;->setEnabled(Z)V

    :done
    return-void
.end method

# virtual methods
.method public a()Ljava/lang/CharSequence;
    .locals 1

    const/4 v0, 0x0

    return-object v0
.end method

.method public a()V
    .locals 0

    return-void
.end method

.method public a()Z
    .locals 2

    invoke-static {}, Lajy;->a()V

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->helper:Lajy;

    invoke-virtual {v0}, Lajy;->a()Z

    move-result v1

    if-eqz v1, :not_complete

    invoke-virtual {v0}, Lajy;->b()Z

    move-result v0

    return v0

    :not_complete
    const/4 v0, 0x0

    return v0
.end method

.method public onFinishInflate()V
    .locals 5

    invoke-super {p0}, Lapr;->onFinishInflate()V

    const-string v0, "first_run_single_enable_action"

    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->find(Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableAction:Landroid/view/View;

    const-string v0, "first_run_single_enable_done"

    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->find(Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableDone:Landroid/view/View;

    const-string v0, "first_run_single_select_action"

    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->find(Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectAction:Landroid/view/View;

    const-string v0, "first_run_single_select_done"

    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->find(Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectDone:Landroid/view/View;

    const-string v0, "first_run_single_finish"

    invoke-direct {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->find(Ljava/lang/String;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->finishAction:Landroid/view/View;

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableAction:Landroid/view/View;

    if-eqz v0, :select_listener

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :select_listener
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectAction:Landroid/view/View;

    if-eqz v0, :finish_listener

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :finish_listener
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->finishAction:Landroid/view/View;

    if-eqz v0, :refresh_state

    invoke-virtual {v0, p0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :refresh_state
    const v0, 0x7f0f0045

    invoke-virtual {p0, v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->findViewById(I)Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/widget/TextView;

    if-eqz v1, :refresh

    check-cast v0, Landroid/widget/TextView;

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getContext()Landroid/content/Context;

    move-result-object v2

    invoke-virtual {v2}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const-string v3, "first_run_single_page_title"

    const-string v4, "string"

    invoke-virtual {v1, v3, v4, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->getText(I)Ljava/lang/CharSequence;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :refresh
    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->refresh()V

    return-void
.end method

.method public onWindowFocusChanged(Z)V
    .locals 0

    invoke-super {p0, p1}, Lapr;->onWindowFocusChanged(Z)V

    if-eqz p1, :done

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->refresh()V

    :done
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->enableAction:Landroid/view/View;

    if-ne p1, v0, :check_select

    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.settings.INPUT_METHOD_SETTINGS"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/content/Context;->startActivity(Landroid/content/Intent;)V

    return-void

    :check_select
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->selectAction:Landroid/view/View;

    if-ne p1, v0, :check_finish

    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->helper:Lajy;

    iget-object v0, v0, Lajy;->a:Landroid/view/inputmethod/InputMethodManager;

    invoke-virtual {v0}, Landroid/view/inputmethod/InputMethodManager;->showInputMethodPicker()V

    return-void

    :check_finish
    iget-object v0, p0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->finishAction:Landroid/view/View;

    if-ne p1, v0, :done

    invoke-direct {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->refresh()V

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->a()Z

    move-result v0

    if-eqz v0, :done

    invoke-virtual {p0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/FirstRunSinglePage;->getContext()Landroid/content/Context;

    move-result-object v0

    instance-of v1, v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;

    if-eqz v1, :done

    check-cast v0, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;

    invoke-virtual {v0}, Lcom/google/android/apps/inputmethod/pinyin/firstrun/PinyinFirstRunActivity;->completeGuide()V

    :done
    return-void
.end method
