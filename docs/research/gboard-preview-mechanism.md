# Gboard「点击主题立即出预览」机制调研

调研目标：弄清 Gboard 主题列表里，用户**点一下某个主题，键盘预览几乎立刻出现**是怎么实现的，作为 Google 拼音动态配色功能的参考。

逆向对象：本机 Gboard 线上版（`com.google.android.inputmethod.latin`）解码产物，位于
`work/research/gboard-current-public/decoded-base/`。

---

## 一、结论速览

Gboard 的「立即出预览」不是渲染一个假的示意图，而是**真的实例化一组键盘视图（KeyboardViewHolder），离屏渲染成 Bitmap，再贴到列表项上**。

三条关键设计：

1. **内存 Bitmap 缓存 + 同步取用**：预览图存在 `Lmrw`（以「主题键」为 key 的内存 Bitmap 缓存）里。点击时先**同步阻塞取值**（`wfi.bd(Future)`），命中即毫秒级返回 —— 这就是「立即」的来源。
2. **缓存 miss 才异步生成**：真正生成时，用 `Lwud.h / Lwfi.bf` 把渲染任务挂到后台线程，生成完成后通过回调 `Lhqn.b(String, Drawable)` 回填到列表项。
3. **点击后先给「占位图」**：`Lhqs.a()` 立刻返回一个 `LayerDrawable` 占位（圆角矩形 + 0.85 比例），列表项先显示占位，等真图回来再替换。用户感知就是「马上有反应」。

对我们的启示：**预览不必等主题包真正安装**，只要能把「主题键 → 键盘视图」渲染出来即可。这正好和「不重启、现有系统动态色可直接读取」的方向一致。

---

## 二、点击链路（完整调用栈）

### 2.1 列表项点击

`ThemeListingFragment.f(Bundle)` 构建列表：每个主题条目包装成 `Ljty(String 名称, Ljuo 提供器, String 描述)`，按分组装进 `Ljtz`，交给 adapter `Ljua`（继承 `Ljp` = ListAdapter）。

`Ljtz.p(Lkn;I)`（onBindViewHolder，`jtz.smali:1013`）里挂点击监听：

```smali
new-instance v1, Lfiw;
const/16 v5, 0x13                       # 0x13 = 19 → 分支 pswitch_0
invoke-direct {v1, p0, v3, p1, v5, v6}, Lfiw;-><init>(Ljtz;Ljtt;Lkn;I[S)V
invoke-virtual {v7, v1}, Landroid/view/View;->setOnClickListener(...)
```

`Lfiw` 是通用 lambda 合成类，`onClick` 是个大 switch。`0x13` 落到 `:pswitch_0`：

```smali
:pswitch_0
    iget-object p1, p0, Lfiw;->a:Ljava/lang/Object;   # Lkn
    check-cast p1, Lkn;
    invoke-virtual {p1}, Lkn;->b()I                   # getBindingAdapterPosition()
    move-result p1
    iget-object v0, p0, Lfiw;->c:Ljava/lang/Object;   # Ljtz
    check-cast v0, Ljtz;
    iget-object v1, v0, Ljtz;->j:Ljtr;                # 列表控制器
    iget-object p0, p0, Lfiw;->b:Ljava/lang/Object;   # Ljtt 条目
    invoke-interface {p0, v1, v0, p1}, Ljtt;->f(Ljtr;Ljtz;I)V
```

即点击 → `Ljtt.f(控制器, 分组, 位置)`。`Ljtt` 的实现类是 `Ljtv`（每个主题项一个）。

### 2.2 条目回调 → 控制器

`Ljtv.f(Ljtr;Ljtz;I)`（`jtv.smali:256`）：

```smali
invoke-virtual {p1}, Ljtr;->k()V                       # 取消上一次未完成的预览
...
invoke-virtual {v1..v6}, Ljtr;->g(Ljava/lang/String;ILjuo;Ljtz;I)V
```

`Ljtr.g`（`jtr.smali:1553`）是核心：

```smali
invoke-virtual {p3}, Ljuo;->p()Z
invoke-static {v0}, Ljto;->a(Z)F                       # 0.85f / 1.0f 比例（是否深色）
invoke-virtual {p3}, Ljuo;->j()Lqub;                   # 主题键
invoke-virtual {p3, v1}, Ljuo;->a(Landroid/content/Context;)I   # 主题资源 id
new-instance v2, Ljtp;                                 # 回调实现
invoke-direct/range {v2 .. v9}, Ljtp;-><init>(Ljtr;Ljtz;ILjtu;String;ILjuo;)V
invoke-static {v1, v10, v11, v2, v0}, Ljto;->d(Landroid/content/Context;Lqub;ILhqn;F)V
```

### 2.3 异步调度

`Ljto.d`（`jto.smali:359`）把参数装进 `Ljtj`（`BiFunction`），然后调 `Ljto.c`（`jto.smali:285`）：

```smali
invoke-static {p0}, Looz;->F(Landroid/content/Context;)Looz;   # 主题服务
invoke-interface {v0}, Lonu;->d()Lwwf;
invoke-static {v1}, Lwvy;->w(Lwwf;)Lwvy;
new-instance v2, Lihs;  const/16 v3, 0x11                     # 0x11 = 17 → pswitch_2
invoke-virtual {v1, v2, p0}, Lwvy;->y(Lwum;Ljava/util/concurrent/Executor;)Lwvy;  # 在主线程 Executor 上跑
new-instance v0, Ljtl;
invoke-direct {v0, p1}, Ljtl;-><init>(Ljava/util/function/BiFunction;)V
sget-object p1, Lmyq;->b:Lmyq;
invoke-static {p0, v0, p1}, Lwfi;->bf(Lwwf;Lwvr;Ljava/util/concurrent/Executor;)V
```

`Lihs.pswitch_2`（`ihs.smali:579`）负责真正取尺寸：

```smali
invoke-interface {v1}, Lont;->g()Lcom/google/android/libraries/inputmethod/metadata/ImeDef;
invoke-static {v3, v2}, Lgfe;->G(Landroid/content/Context;ImeDef;)I   # 预览宽高
invoke-static {v2}, Lsvf;->c(I)Lsux;
invoke-interface {v0, v3, v1, v4}, Lonu;->h(Lrlz;Ljava/lang/String;[Lsux;)Lwwf;   # 返回异步任务
```

### 2.4 生成预览 Bitmap —— `Lhqs`

`Ljto.b`（`jto.smali:229`）构造渲染器：

```smali
invoke-static {p0, p1, p2}, Lgfe;->I(Landroid/content/Context;Lqub;I)Lhpz;   # Builder
invoke-virtual {p1, p3}, Lhpz;->d(I)V
invoke-virtual {p1}, Lhpz;->a()Lqxj;
invoke-static {p0, p2}, Lpbp;->e(Landroid/content/Context;I)I               # 高度
invoke-static/range {v0..v5}, Lgfe;->K(Landroid/content/Context;ILqtq;FII)Lhqs;
```

`Lgfe.K`（`gfe.smali:957`）里有关键 trace 与异步 Bitmap 任务：

```smali
const-string p0, "keyboard_preview"                     # trace 名
invoke-static {v1, p0}, Lmru;->a(Landroid/content/Context;Ljava/lang/String;)Lmrr;
invoke-virtual {p0}, Lmrr;->c()V
invoke-virtual {p0}, Lmrr;->b()V                        # 开始耗时统计
new-instance p1, Lfeb;  const/16 v0, 0x10               # Supplier
new-instance v7, Lmrw;                                  # ★ 异步 Bitmap 生成器（带缓存）
invoke-direct {v7, p1, p0}, Lmrw;-><init>(Ljava/util/function/Supplier;Lmrx;)V
...
new-instance v0, Lhqs;
invoke-direct/range {v0 .. v10}, Lhqs;-><init>(Landroid/content/Context;Lqtq;FIIFLmrw;ZZZ)V
return-object v0
```

### 2.5 「立即」的来源 —— 同步取缓存

`Lhqs`（对应源码类 `KeyboardPreviewRenderer`）字段：

```
.field public final g:Lmrw;                                        # Bitmap 缓存
.field public final k:[Lcom/google/android/libraries/inputmethod/keyboard/impl/KeyboardViewHolder;
```

`k` 说明它**确实持有真实键盘视图** —— 预览是真的键盘渲染，不是示意图。

`Lhqs.f(ImeDef, String, Lont, Lpky, Lufg, Lhqn)`（`hqs.smali:1083`）：

```smali
invoke-virtual {v2, v1, v8}, Lhqs;->b(Lhqr;Lpky;)Ljava/lang/String;   # 算缓存 key
new-instance v0, Lwvb;
iget-object v3, v2, Lhqs;->g:Lmrw;                     # 缓存
invoke-virtual {v3, v11, v0}, Lmrw;->b(Ljava/lang/String;Lwwi;)Lwwf;
invoke-static {v0}, Lwfi;->bd(Ljava/util/concurrent/Future;)Ljava/lang/Object;   # ★ 同步阻塞取！
check-cast v0, Landroid/graphics/Bitmap;
:goto_0
    if-nez v0, :cond_1                                 # 缓存未命中
    ... 走后台生成 ...
:cond_1
    invoke-virtual {v2, v1, v0}, Lhqs;->e(Lhqr;Landroid/graphics/Bitmap;)V   # 命中：直接回填
```

命中缓存 → `Lhqs.e`（`hqs.smali:1038`）立刻包成 `BitmapDrawable` 并回调：

```smali
new-instance v1, Landroid/graphics/drawable/BitmapDrawable;
invoke-direct {v1, p0, p2}, Landroid/graphics/drawable/BitmapDrawable;-><init>(Resources;Bitmap)V
iget-object p0, p1, Lhqr;->d:Lhqn;
invoke-interface {p0, v0, v1}, Lhqn;->b(String;Drawable;)V      # ★ 回调
```

缓存未命中则走后台渲染（`hqs.smali:1228-1366`），用 `Lokl`（键盘视图构建器）+ `Lhqr.a(...)` 生成，完成后 `Lwfi.bf` 回填到 `Lmyq.b`(Executor)。同时 `Lhqs.a()` 先返回占位 `LayerDrawable`（圆角矩形，宽 = `e * c`，比例 0.85）。

### 2.6 回填到列表

回调实现 `Ljtp.b(String, Drawable)`（`jtp.smali`）：

```smali
iget-object p1, p0, Ljtp;->a:Ljtr;
iget-boolean v0, p1, Ljtr;->k:Z
if-nez v0, :cond_0
    iget v4, p0, Ljtp;->c:I
    iget-object v3, p0, Ljtp;->d:Ljtu;
    invoke-virtual {p0, v4, v3}, Ljtz;->E(ILjtu;)V   # 更新条目状态为「已选中」
    iget v1, p0, Ljtp;->f:I
    iget-object v0, p0, Ljtp;->g:Ljuo;
    iget-object v2, p0, Ljtp;->e:Ljava/lang/String;
    invoke-virtual {p1, v2, v1, v0, p2}, Ljtr;->n(String;ILjuo;Drawable)V   # ★ 显示预览
:cond_0
```

`Ljtr.n`（`jtr.smali:2191`）把 Drawable 贴到列表项并更新选中态。

---

## 三、对我们的可借鉴点

| Gboard 的做法 | 我们能不能用 | 说明 |
|---|---|---|
| 预览 = 真键盘视图离屏渲染 | **可以** | 我们已有 `KeyboardViewHolder` 等价物（原版键盘视图类），渲染通路现成 |
| 内存 Bitmap 缓存（key = 主题键） | **可以** | 纯 Java，AndroidX-free 可实现；用 `LruCache` 或自建 `HashMap` |
| 点击后先给占位图 | **可以** | `LayerDrawable` + `ShapeDrawable`，平台类，无依赖 |
| 同步阻塞取缓存换「立即」体验 | **可以** | `Future.get()` 即可，但要注意别在主线程做首次渲染 |
| 异步生成 + 回调回填 | **可以** | 用 `Handler` + 后台 `Thread` 即可，不需要 RxJava |
| `Lmru` trace（`keyboard_preview`） | 可选 | 性能诊断用，非必需 |

**关键结论**：Gboard 的「立即出预览」本质是**缓存 + 占位 + 异步回填**三件套，与动态配色无关，是纯渲染工程。我们如果做动态配色主题，**预览环节可以完全复用这套思路**，而且不需要引入任何新依赖。

---

## 四、与动态配色功能的关系

- Gboard 的**预览机制**与**动态配色**是两条独立链路：
  - 预览机制：`ThemeListingFragment` → `Ljtr.g` → `Ljto.c` → `Lhqs.f` → 缓存/渲染 → `Ljtr.n`
  - 动态配色：`Ljuo` 主题提供器负责产出「主题键 → 颜色规格」，其中 System Auto 提供器（`Ljuo.h/g/f/d`）负责系统动态色
- 我们要做的动态配色主题，落地形态是一个**新的 `Ljuo` 提供器**（对应系统动态色），列表项和预览链路**原样复用**。
- 因此：**预览不需要自己重写**。只要把动态色主题接进 `Ljuo` 体系，列表项点一下就自动有预览。

---

## 五、遗留与下一步

1. **未定位 `Ljuo` 的 System Auto 实现细节**：本次聚焦预览链路，`Ljuo.h/g/f/d` 四个静态工厂（分别对应浅色/深色/默认等系统主题）内部如何取系统动态色，尚未逐行展开。若有需要，下一步可继续。
2. **`Lmrw` 缓存实现未展开**：只知道它是「key → Bitmap」的内存缓存（对应源码类名可从 `Lhqs.m` 的 `KeyboardPreviewRenderer.java` 推断）。具体是不是 `LruCache`、容量多大，未确认。
3. **真机实测仍被阻塞**：设备 `10.77.7.79:15037` 持续 `offline`，三项真机实测（读系统色 / 代码造主题包 / 最小样式表）需要转发服务恢复后才能进行。
