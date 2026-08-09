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

The first Compose screen binds this snapshot to official Material 3 `Switch`,
`Slider`, `AssistChip`, `TopAppBar`, `LazyColumn`, and section components. Volume
and vibration with a negative device default render a separate “system default”
chip and no numeric Slider, so the UI cannot conflate system default with
explicit zero.

The first narrowly scoped write stage enables only keyboard height and slide
sensitivity. Both use the same typed enumerated write path, persist the exact
legacy String from the audited ordered value arrays, reject out-of-range indices,
and publish one SharedPreferences update only when a drag finishes. During the
drag, the visible localized label is derived from the transient snapped index,
so UI feedback is immediate without increasing persistence frequency. Slider
endpoints apply Compose `WindowInsets.safeGestures` horizontal padding in
addition to the page margin; this keeps the official Slider gesture target out
of gesture-navigation Back edges without hard-coding a device inset or replacing
Material 3 pointer handling. Sound, vibration, long-press, and handwriting
controls remain read-only. This stage has
no Boolean, Float, integer, remove, clear, reset, or preview write path.

The staged volume and vibration control group follows the information hierarchy
confirmed in Gboard's current `FontSizeSliderPreference`—title, live summary,
decrease/Slider/increase controls, and a full-width system-default action—while
retaining this project's accepted rule that an unknown negative system sentinel
has no truthful Slider position. See `docs/gboard-font-size-slider-research.md`.

The prototype has been split into lifecycle, screen, adjustment-control, pure
state, persistence, controller, and platform-preview modules. All modern-only UI
text now uses prefixed Android resources with English and Simplified Chinese
translations; existing setting titles are resolved from the legacy localized
resources with modern fallbacks. A static gate rejects hard-coded Chinese text in
Kotlin and verifies translation-key parity.

The nullable adjustment flow is defined by a pure `AdjustmentStateReducer` over
`SystemDefault`, `EditingDraft(value, touched)`, and `Explicit(value)`. Unit tests
fix invalid-transition, explicit-zero, cancel, restore, range, and dependency-off
semantics. Compose saves this state with an explicit Saver, while persistence and
one-shot previews remain outside the reducer and composition.

The first handwriting write stage enables the original timeout and stroke-width
`SeekBarListPreference` contracts through the existing typed enumerated String
path. Their localized labels and exact values update while dragging; only the
snapped final index is written on release. There is no reset button, preview,
new storage type, or additional persistence implementation, matching the legacy
controls.

The Boolean stages currently cover nineteen visible Preference contracts plus
one mirrored persistence key:
`enable_double_space_period`, `enable_scrub_move`,
`show_english_keyboard`, `enable_emoji_alt_physical_key`,
`chinese_english_mixed_input`, `chinese_digits_mixed_input`,
`enable_suggest_emojis`, `enable_spatial_model`, `enable_sc_tc_conversion`,
`enable_chinese_prediction`, `auto_space`, `block_offensive_words`,
`pref_key_auto_correction`, `show_suggestions`, `next_word_prediction`, and
`enable_auto_capitalization`. Each records key presence separately from its
visible value and writes only after a user switch action. The
traditional-Chinese fallback is `false`; the other currently migrated Boolean
fallbacks are `true`. `next_word_prediction` retains its value while
`show_suggestions` is off, but the UI is disabled and repository writes are
rejected until the parent is enabled. The `enable_gesture_input` parent writes
both itself and `enable_gesture_input_persistent`, reproducing the original
`SettingsActivity` listener; its two child settings retain values while disabled
and reject writes until the parent is on. See
`modern-settings-preference-inventory.md` for deferred capability, dependency,
listener, and navigation boundaries.

The capability-gated keyboard stage reproduces `AbstractSettingsActivity` and
`ais` without calling legacy classes from Compose. Popup-on-keypress and the
one-handed selector are shown exactly when the current `is_tablet` Boolean
resource is false. Voice input scans only enabled IMEs, requires the original
`com.google.android` package-prefix check and an enabled/implicit subtype whose
mode equals lowercase `voice`, and treats lookup failure as unavailable. Hidden
controls have no composition node and Repository writes are rejected. The
one-handed selector preserves String values `0`/`1`/`2`, default `0`, original
localized order and ordinary SharedPreferences notifications; static audit of
`AutoSyncedListPreference` found no mirrored key or additional business callback.
The separate `supports_one_handed_mode` runtime resource is not incorrectly used
as the settings-page visibility gate. Phone-device acceptance confirms the
resolved visibility, key-popup effect, `0`/`1`/`2` one-handed layouts and
persistence, portrait/landscape geometry, and no existing input regression. The
`is_tablet=true` runtime branch remains explicitly pending for the large-screen
test matrix.

The language/emoji switch-key stage keeps stored state distinct from effective
Preference state. `show_emoji_switch_key` is absent-default `false` and visible
only on API 19+ phones. When checked, its reversed dependency disables the
`UncheckDisabledCheckBoxPreference` language row and displays that row unchecked,
but does not overwrite the retained `show_language_switch_key` Boolean (default
`true`). The Settings Activity has no IME Window token, so the reconstructed
`ajy.d()` fallback reports switching available only when this package has more
than one enabled subtype or another enabled `com.google.*` IME exposes a
non-auxiliary enabled subtype. If available, `switch_to_other_imes` remains
visible and requires both effective language switching and
`show_english_keyboard`; if unavailable, it is omitted and the language row
instead also requires `show_english_keyboard`. UI and Repository use one pure
rule reducer, hidden/disabled writes are rejected, and no dependency transition
fabricates a child write.

Device acceptance has not closed this stage. On the current Pixel, Gboard and
other IMEs are enabled but the first modern build omitted `switch_to_other_imes`.
The same row was available on target 28 and a value saved there continues to
work after upgrading, while the target 36 legacy settings page no longer permits
editing it. Static comparison identifies the target-30+ package-visibility
boundary: the inherited manifest did not declare visibility for IME services, so
settings-side `InputMethodManager` enumeration could not reliably observe the
enabled targets. The MD3 host now adds a narrowly scoped
`android.view.InputMethod` intent under `<queries>`; it does not request
`QUERY_ALL_PACKAGES`, and the published target-36 release remains unchanged.
Device validation confirms that this restores the row: its value persists, and
actual language-key presses include or exclude other IMEs as selected. The
previously observed switch surface was confirmed to be the in-keyboard globe
key, not SystemUI. With emoji and language keys off and the English keyboard
then disabled, the query-fixed host correctly shows no globe key on the Chinese
keyboard. The staged audit application ID therefore closes the behavior matrix;
formal release still requires an upgrade-retention check under the final
application ID.

The fuzzy-Pinyin stage adds the default-off `fuzzy_pinyin` parent and a guarded
full-screen Compose detail route. The route retains the original order of all
twelve Boolean options, their six-true/six-false defaults, stored values while
the parent is off, and the explicit accessibility descriptions previously
provided by `CheckBoxPreferenceWithContentDescription`. Both UI navigation and
Repository writes enforce the parent dependency. Toolbar and system Back return
to the main settings screen, while `rememberSaveable` retains the route across
configuration recreation. Official Material 3 Switch/ListItem/TopAppBar and
official auto-mirrored Material icons are used; predictive-Back animation remains
outside this isolated stage. Device acceptance confirms the complete dependency
and default matrix, retained child values, both Back paths, configuration
recreation, actual fuzzy-candidate activation/restoration, and no Full Pinyin,
flyPY, Chinese-glide, or English-glide regression.

The first ListPreference stage migrates `pinyin_scheme` to an official Material
3 `ListItem`, `AlertDialog`, and radio-button single-choice group. It reads the
original localized `entries_pinyin_scheme` array and writes only the exact
corresponding String value. Key absence resolves to the legacy `quanpin` default;
all seven values retain their original order, unsupported stored values are
rejected rather than silently remapped, choosing a different option commits once,
and Back/outside/cancel dismissal does not write. Device acceptance confirms
persistence, Full Pinyin and flyPY phrase input, unchanged glide behavior, and
visual alignment with the page's existing 24 dp content edge.

The long-press stage models absent default `300 ms` separately from explicit
`"300"` with `DefaultableSetting`. Its official discrete Slider covers exactly
`100..700 ms` in `10 ms` steps and persists the original String only on release.
The full-width “使用默认值” action is disabled while the key is absent and removes
the key when an explicit value exists. There is no preview side effect, and
misaligned or out-of-range values are rejected by the typed contract.

This stage also enables the two parent Boolean switches. In system-default state,
“设置自定义值” opens a process/configuration-safe draft at zero without writing;
Apply remains disabled until the user explicitly operates the Slider or a step
button. Cancel discards the draft. Explicit volume uses the original Float
`percent / 100f`; explicit vibration uses the original zero/`N + 1` String
encoding. “使用系统默认” removes the corresponding key. Slider release and step
buttons commit once and invoke the original sound-effect or positive-duration
vibration preview semantics. Dependency-off state retains explicit values while
disabling the complete adjustment group.

Host packaging preserves the original English model's random-access contract:
`res/raw/main_en_d3_20160715.gzip` and `res/raw/metadata.json` must both remain
uncompressed (`ZIP_STORED`). AGP's default compression of the JSON metadata
silently disabled English candidates and glide because the legacy model loader
uses `openRawResourceFd()`. `androidResources.noCompress += "json"` restores the
original apktool contract, and APK-level verification prevents recurrence. The
corrected Compose host passes device acceptance with suggestions on/off,
independent English glide, the shared gesture parent, and Chinese regression.

For device testing, `build_modern_settings_host.py --audit-launcher` can add a
launcher entry labelled “Material 3 设置审计” to an isolated audit package. The
activity is always guarded by `@bool/modern_settings_runtime_enabled`: false in
base resources and true only in `values-v35`, so API 17–34 cannot launch or load
the Compose activity. Formal host builds omit the audit launcher and will route
from the legacy settings entry point instead.
Section and title strings are still prototype-only, but enum value labels now
come from the original localized `entries_*` arrays (for example low, normal,
high) while their exact stored values remain separate in the contract. A
negative system-default value still has no Slider because it has no truthful
numeric position. If its parent switch is off, the supporting text now explains
that dependency rather than repeating the enabled-state description. The
activity refreshes its read-only snapshot in `onResume()` so returning from a
legacy settings surface cannot leave stale state. Production routing still
requires all remaining labels to be resource-backed before writes are enabled.

## Confirmed information architecture

The prototype single list is not the production hierarchy. It made early
contract auditing cheap, but retaining every migrated row in one screen would
make discovery, code ownership, and device acceptance progressively worse. The
confirmed production tree is:

```text
Settings home
├─ Input
│  ├─ general input rows
│  ├─ Chinese input
│  │  └─ Fuzzy Pinyin
│  └─ English input
├─ Keyboard
│  ├─ Appearance and layout
│  ├─ Keys and switching
│  ├─ Key feedback
│  └─ Handwriting
├─ Dictionary and backup
└─ Other
```

The home screen contains navigation rows and summaries, not live switches or
sliders. Input retains the original general/Chinese/English semantic categories,
but Chinese and English become child routes so they no longer form one long
list. The gesture parent remains a general-input row while its Chinese preview
and auto-commit children remain on the Chinese route; shared Repository rules,
not visual co-location, enforce that dependency. Fuzzy Pinyin remains a child
of Chinese input.

Keyboard uses four child routes:

- Appearance and layout: theme, one-handed mode, and keyboard height;
- Keys and switching: popup, voice, English keyboard, emoji/language/other-IME
  switching, physical-key symbol behavior, slide sensitivity, and long press;
- Key feedback: sound/volume and vibration/duration;
- Handwriting: recognition timeout and stroke width.

Handwriting intentionally moves below Keyboard rather than retaining the legacy
top-level header: it is a keyboard input form in the modern user model, and two
sliders do not justify a home-screen destination. This navigation change does
not alter either handwriting key, storage type, default, preview, or Slider
contract.

Dictionary and backup remains one domain with user-dictionary, backup/restore,
and shortcuts sections. Its Compose page now owns typed presentation state but
continues to delegate dictionary inspection, SAF directory validation, native
export, backup listing, confirmation, and native merge import to the existing
primary-DEX compatibility implementation. The selected directory is accepted
only after persistent read/write grant confirmation and the existing asynchronous
create/read/rename/delete validator succeeds. Interval and retention retain the
exact integer lists and fallback values; invalid writes are rejected. The
shortcuts Boolean retains its original key/default/dependency, while its editor
continues through the system user-dictionary Activity.

Contact suggestions and clearing remain behind an explicit same-package legacy
Dictionary fragment entry. This is intentional: their permission controller,
confirmation dialog, and destructive task lifecycle have not been duplicated in
Compose, and no destructive clear test is authorized in this stage. The first
device-tested Intent supplied only `:android:show_fragment`, so the framework
created the right class but `CommonPreferenceFragment` rejected the missing XML
name with `Preference xml file not specified`. The accepted V3 Intent also
supplies `PREFERENCE_FRAGMENT=setting_dictionary`; device testing confirms the
legacy page, both target rows, and Back navigation without a new crash. Other now owns
launcher visibility plus a nested About route that reuses the original terms and
privacy URLs, existing license Activity, and package version. Theme and
remaining dictionary operations remain specialized targets; moving their entry
rows does not authorize reimplementing legacy side effects as generic writes.

Navigation uses an explicit, saveable route stack rather than accumulating
independent page Booleans. Toolbar Back and system Back pop one route; Back on
Home finishes the Activity. The fixed, argument-free tree does not require a
Navigation Compose dependency. Page composables remain stateless projections of
shared Controller/Repository state, so cross-page dependencies retain values
and write gates exactly as before.

Hierarchy V1 implements this route tree with a saveable encoded path and a pure
`SettingsRouteStack`. Unit tests cover root behavior, nested
Input/Chinese/Fuzzy navigation, one-level popping, rejection of Home as a child,
and safe fallback for a stale restored route. Device acceptance confirms the
original route tree, both Back paths, configuration restoration, and cross-page
dependencies. Dictionary/backup is no longer a placeholder, and Other now has a
nested About route. Device acceptance covers read-only health refresh, settings
dialogs, route/Back behavior, Google Drive SAF backup and native merge import,
terms/privacy/licenses/version, and the corrected legacy-operations entry. The
mechanical extraction leaves `SettingsScreen.kt` responsible only for route
dispatch, Back, and the top-level Scaffold; home, Input, Keyboard, Handwriting,
Fuzzy Pinyin, Dictionary, and shared controls have separate source ownership.
The verifier rejects concrete setting controls returning to the top-level
screen.

## Next implementation stage

1. Device-test the read-only health callback and refresh lifecycle without
   reading dictionary contents.
2. Test SAF cancellation and validation failure first, then a user-selected
   writable directory, while preserving prior grants until validation succeeds.
3. Test interval/retention persistence and automatic-backup enable/disable;
   separately authorize and test immediate backup and merge import.
4. Keep contact suggestions and clearing on the legacy controller until their
   exact permission/destructive-task lifecycle has an isolated audit package
   and explicit authorization.
5. Validate About URLs, licenses, route restoration, toolbar/system Back,
   light/dark mode, dynamic color, RTL, font scaling, TalkBack, landscape,
   narrow screens, and multi-window behavior.
