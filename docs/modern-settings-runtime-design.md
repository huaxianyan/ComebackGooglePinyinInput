# Modern settings runtime design

## Decision

The API 35+ settings surface will be rebuilt with official Compose Material 3
components. It will not simulate Material 3 by drawing over legacy
`android.preference` or `android.widget` controls.

`targetSdkVersion` selects platform behavior compatibility; it does not replace
legacy UI widgets. Material 3 is supplied by the official AndroidX Compose
libraries and must be packaged with the reconstructed application.

## Why Compose, not Material Components Views

A source-built Material Components Views prototype successfully loaded genuine
`com.google.android.material.slider.Slider`, `MaterialSwitch`, and
`MaterialToolbar` classes. However, the original APK embeds old
`android.support`/AppCompat resources in the application `0x7f` resource
namespace. Modern AppCompat and Material Components define many of the same
resource names. The first complete resource merge produced duplicate definitions
including `navigationMode`, `actionBarSize`, `tintMode`, and `fontStyle`.

Deleting the old definitions or allowing modern dependencies to overwrite them
would change resources consumed by the legacy IME and the API 17-34 fallback.
That is not an acceptable migration boundary.

The Compose Material 3 dependency graph does not bring the AppCompat widget
resource surface. A complete merge with all patched legacy resources found one
collision: AndroidX Core and the legacy support resources both declared
`fontStyle` with exactly the same `normal=0` and `italic=1` values. The host
normalizer removes only the standalone legacy declaration and lets AndroidX Core
provide the canonical declaration. The existing legacy DEX styleable arrays are
not regenerated.

## Proven host model

The first host prototype established all of the following on the Pixel 10 Pro:

- real `androidx.compose.material3` controls compile and render;
- the reconstructed application retains `minSdkVersion=17` and
  `targetSdkVersion=36`;
- all 6,633 legacy public resources retain their original numeric IDs;
- the patched legacy application remains `classes.dex`;
- Compose and AndroidX occupy `classes2.dex` and later;
- API 17-20 can start the legacy main DEX without AndroidX MultiDex;
- the Compose activity is routed only on API 35+;
- AndroidX Startup, ProfileInstaller, and `appComponentFactory` automatic process
  entry points are removed, so old processes do not load modern classes;
- the original IME service, application, backup agent, activities, receivers,
  assets, and native libraries remain in the combined APK;
- the additional `libandroidx.graphics.path.so` has `PT_LOAD` alignment
  `0x4000` and satisfies 16 KiB offset/virtual-address congruence;
- the installed `base.apk` matched the built APK byte-for-byte.

The isolated audit identity is
`com.google.android.inputmethod.pinyin.materialcomposehostaudit`. It must never
be published as a formal build.

## Resource and DEX invariants

The original DEX contains embedded `0x7f` resource IDs. The modern host therefore
uses AAPT2 `--stable-ids`, generated from apktool's `res/values/public.xml`.
Every host build must verify all expected `(type, name, ID)` tuples against
`aapt2 dump resources`.

DEX ordering is intentional:

```text
classes.dex      patched legacy application and IME
classes2+.dex    source-built Compose/AndroidX runtime
```

No AndroidX component may be initialized from the manifest before the guarded
modern settings activity starts.

## Migration boundary

The first production implementation will route settings as follows:

```text
API 17-34   existing Preference settings
API 35+     Compose Material 3 settings
```

The Compose UI will use a typed `SettingsRepository`. UI state must not directly
reinterpret legacy stored values. Each setting requires an audited contract for:

- key and storage type;
- absent/unset state;
- default value;
- dependency and enabled state;
- allowed values and display mapping;
- `callChangeListener`-equivalent validation;
- preview or side-effect callback;
- reset behavior.

In particular, system default and numeric zero are separate domain states. They
must never be represented by passing a negative persistence sentinel directly to
a Slider.

### Confirmed Slider contracts

The first source audit recovered these exact contracts from the original
Preference subclasses and resources:

- sound volume key `sound_volume` stores a `float`; an absent key selects the
  per-device default, whose unmatched fallback is `-1.0` (system default), while
  an explicitly stored `0.0` is numeric zero;
- vibration key `vibration_duration` stores a string; absent selects the
  per-device default (unmatched fallback `-1`), explicit zero milliseconds is
  encoded as `"0"`, and positive `N` milliseconds is encoded as `N + 1`;
- keyboard height values are `0.9, 0.95, 1.0, 1.05, 1.1`, default `1.0`;
- slide sensitivity values are `3.0, 1.5, 1.0, 0.8, 0.5`, default `1.0`;
- handwriting timeout values are `3000, 2000, 1500, 1000, 700, 400, 100`,
  default `1000`;
- handwriting stroke width values are `0.4, 0.6, 0.8, 1.0, 1.2, 1.5, 2`,
  default `1.0`;
- long-press delay is a stored millisecond string from 100 through 700 in 10 ms
  increments, default 300.

`SliderSettingContracts` models absent and explicit values separately. Unit tests
specifically prohibit collapsing absent/system-default volume or vibration into
explicit numeric zero.

`LegacySettingsRepository` now implements the first read-only bridge. It opens
the same `${packageName}_preferences` file selected by the platform
`PreferenceManager`, distinguishes key absence with `contains()`, and reproduces
the original first-match device override parser over `Build.HARDWARE`, `MODEL`,
`BRAND`, and `MANUFACTURER`. This stage contains no `SharedPreferences.Editor`
and cannot mutate settings.

The first read-only Compose screen binds this snapshot to official Material 3
`Switch`, `Slider`, `AssistChip`, `TopAppBar`, `LazyColumn`, and section
components. Every control is non-interactive in this stage. Volume and vibration
with a negative device default render a separate “system default” chip and no
numeric Slider, so the UI cannot conflate system default with explicit zero.
The current Chinese labels are prototype-only; production routing requires
legacy resource-backed localization before writes are enabled.

## Next implementation stage

1. Make the host assembly a single reproducible build command from the original
   APK.
2. Add binary host gates for resource IDs, manifest auto-start exclusions, DEX
   order, signatures, ZIP alignment, and native ELF alignment.
3. Introduce a read-only `SettingsRepository` inventory and tests.
4. Implement one low-risk settings section with official Compose Material 3
   rows, Switch, and Slider.
5. Add writes only after exact storage/default/callback equivalence is proven.
6. Validate light/dark mode, dynamic color, RTL, font scaling, TalkBack,
   landscape, narrow screens, and multi-window behavior.
