.class Lcom/google/android/inputmethod/pinyin/NativeImportProbe$1;
.super Ljava/lang/Object;
.source "NativeImportProbe.java"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->run(Landroid/content/Context;Landroid/net/Uri;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$importer:Ljava/lang/Object;

.field final synthetic val$write:Ljava/lang/reflect/Method;


# direct methods
.method constructor <init>(Ljava/lang/reflect/Method;Ljava/lang/Object;)V
    .locals 0
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 64
    iput-object p1, p0, Lcom/google/android/inputmethod/pinyin/NativeImportProbe$1;->val$write:Ljava/lang/reflect/Method;

    iput-object p2, p0, Lcom/google/android/inputmethod/pinyin/NativeImportProbe$1;->val$importer:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .locals 3

    .line 66
    const-string p1, "NativeProbe"

    if-eqz p3, :cond_1

    array-length p2, p3

    const/4 v0, 0x1

    if-eq p2, v0, :cond_0

    goto :goto_0

    .line 67
    :cond_0
    const-string p2, "native"

    const/4 v1, 0x0

    aget-object v2, p3, v1

    invoke-static {p2, v2}, Lcom/google/android/inputmethod/pinyin/NativeImportProbe;->access$000(Ljava/lang/String;Ljava/lang/Object;)V

    .line 69
    :try_start_0
    iget-object p2, p0, Lcom/google/android/inputmethod/pinyin/NativeImportProbe$1;->val$write:Ljava/lang/reflect/Method;

    iget-object v2, p0, Lcom/google/android/inputmethod/pinyin/NativeImportProbe$1;->val$importer:Ljava/lang/Object;

    aget-object p3, p3, v1

    new-array v0, v0, [Ljava/lang/Object;

    aput-object p3, v0, v1

    invoke-virtual {p2, v2, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p2

    .line 70
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "importer.write returned "

    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p3

    invoke-static {p1, p3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 71
    return-object p2

    .line 72
    :catchall_0
    move-exception p2

    .line 73
    const-string p3, "importer.write threw"

    invoke-static {p1, p3, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 74
    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p1

    .line 66
    :cond_1
    :goto_0
    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p1
.end method
