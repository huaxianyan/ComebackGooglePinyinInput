# Modern settings Preference inventory

This document is the staged migration ledger for the API-35+ official Compose
Material 3 settings runtime. It distinguishes confirmed legacy contracts from
items whose availability, dependency, listener, or navigation semantics still
need reconstruction. It does not authorize formal routing by itself.

## Evidence sources

Confirmed against the reproducibly decoded original host and patched baseline:

- `res/xml/settings.xml` and `res/xml/setting_*.xml`;
- `res/values/arrays.xml`, `bools.xml`, `strings.xml`, and `public.xml`;
- `DefaultPreferenceValueParser` and `Lamx` persistence behavior;
- `CommonPreferenceFragment`, `AbstractSettingsActivity`, and
  `SettingsActivity` initialization/listener Smali;
- custom Preference widget classes named below.

All persistent settings use `${packageName}_preferences`. Key absence remains a
separate state even where the visible Boolean value equals its fallback.

## Migrated and device-accepted

- `enable_sound_on_keypress`: Boolean, fallback `false`;
- `sound_volume`: Float, absent means per-device/system default;
- `enable_vibrate_on_keypress`: Boolean, fallback `true`;
- `vibration_duration`: String, absent means per-device/system default;
- `keyboard_height_ratio`: enumerated String;
- `keyboard_slide_sensitivity_ratio`: enumerated String;
- `key_long_press_delay`: String `100..700`, step `10`, absent default `300`;
- `handwriting_timeout_ms`: enumerated String;
- `handwriting_stroke_width_scale`: enumerated String.

## First plain Boolean batch

These four entries are plain `CheckBoxPreference` instances. They have no XML
dependency, custom Preference subclass, `OnPreferenceChangeListener`, dynamic
availability removal, or preview callback. Their exact Boolean fallback is
`true` in the legacy defaults table.

| Key | Legacy page | Legacy presentation | Migration |
| --- | --- | --- | --- |
| `enable_double_space_period` | Input | title + summary | writable |
| `enable_scrub_move` | Input | title + summary | writable |
| `show_english_keyboard` | Keyboard | title | writable |
| `enable_emoji_alt_physical_key` | Keyboard | title + summary | writable |

Compose records both `value` and `SharedPreferences.contains(key)`. A user
switch action writes one Boolean. No reset action is added because the original
plain checkbox provides none.

## Second plain Boolean batch

The following Input-page entries satisfy the same plain-Preference boundary and
have exact Boolean fallback `true`:

| Key | Legacy presentation | Migration |
| --- | --- | --- |
| `chinese_english_mixed_input` | title + summary | writable |
| `chinese_digits_mixed_input` | title + summary | writable |
| `enable_suggest_emojis` | title + summary | writable |
| `enable_spatial_model` | title + summary | writable |

Their resource IDs are consumed directly by the decode processors or settings
reader, but no settings-Activity listener or secondary write is attached. Each
modern switch therefore performs exactly the original single Boolean write.

## Third plain Boolean batch

The next independent Input-page entries are also direct Boolean contracts:

| Key | Fallback | Legacy presentation | Migration |
| --- | --- | --- | --- |
| `enable_sc_tc_conversion` | `false` | title | writable |
| `enable_chinese_prediction` | `true` | title + summary | writable |
| `auto_space` | `true` | title + summary | writable |
| `block_offensive_words` | `true` | title + summary | writable |

Each key is read by its native-era decode/spacing/Latin settings path, but none
has an Activity-side change listener, custom Preference widget, XML dependency,
or secondary persistence operation. The modern hierarchy preserves the original
category boundary: traditional conversion, Chinese prediction, and automatic
spacing remain under “Chinese input”; offensive-word blocking remains under
“English input”. Automatic spacing mentions English words but is located in the
original Chinese category because it applies to mixed input there.

On the accepted audit device, the current legacy English input path exposes no
candidate words, so the actual offensive-word filtering effect cannot be
observed. This is recorded as an existing capability boundary rather than
claimed as functional acceptance; its UI and Boolean persistence are still
auditable independently.

The actual candidate trigger for `enable_suggest_emojis` is accepted. The
actual candidate trigger for `chinese_digits_mixed_input` remains deliberately
unverified and low priority; its Boolean UI/persistence contract passed, and no
native decoder behavior is changed in this branch.

## English Boolean dependency batch

The original English category is now structurally restored with:

| Key | Fallback | Dependency | Migration |
| --- | --- | --- | --- |
| `pref_key_auto_correction` | `true` | none | writable |
| `show_suggestions` | `true` | none | writable |
| `next_word_prediction` | `true` | `show_suggestions` | writable |
| `enable_auto_capitalization` | `true` | none | writable |
| `block_offensive_words` | `true` | none | already writable |

`pref_key_auto_correction` is the literal value of the legacy
`pref_key_latin_auto_correction` resource; it must not be replaced with the
separate framework-era `spell_correction` key/default pair. The child
`next_word_prediction` value is retained when `show_suggestions` is off, while
its Switch is disabled and repository writes are rejected until the parent is
on. Turning the parent back on exposes the retained child state.

The audit device currently presents no English candidate words and English
QWERTY glide input does not produce words. This is not an absent design:
`keyboard_en_qwerty.xml` binds `EnglishGestureMotionEventHandler` and
`keyboard_en_9key.xml` binds `English9KeyGestureMotionEventHandler` to the same
`enable_gesture_input` key, and both handler classes are present. Formal
`v2.0.0` A/B testing confirms that English candidates work when
`show_suggestions` is on, while English glide works independently whether that
suggestion switch is on or off. The Compose audit host still has neither after
explicitly cycling both switches, so this is an audit-runtime regression rather
than an absent or historical feature.

Static comparison rules out missing payload: both APKs have byte-identical
English/Latin/HmmGesture Smali, English keyboard XML, all 76 shared assets, and
all five ARM64 native libraries. A fresh, non-Compose package rebuilt from
formal v2.0.0 with the same isolated application-ID model and audit debug
certificate also passes English candidates and glide, ruling out fresh data,
package isolation, and signing identity.

The remaining APK comparison identifies the causal packaging defect: formal
v2.0.0 stores `res/raw/metadata.json` uncompressed, while AGP deflated it in the
Compose host. The English model path uses `openRawResourceFd()`, which requires
an uncompressed entry; `main_en_d3_20160715.gzip` remained stored, but its
metadata became inaccessible. The reconstructed host therefore declares JSON
`noCompress`, and the verifier requires both English raw entries to be
`ZIP_STORED`. Corrected-host device acceptance confirms English candidates
follow `show_suggestions`, English glide remains available when suggestions are
off, the gesture parent controls both English and Chinese glide, and Chinese
input remains unaffected. The English runtime and its settings dependencies are
therefore accepted together.

## Gesture dependency and mirrored-write group

The glide-typing parent has a non-obvious Activity callback:

| Role | Key | Fallback |
| --- | --- | --- |
| visible parent | `enable_gesture_input` | `true` |
| mirrored persistent key | `enable_gesture_input_persistent` | `true` |
| dynamic preview child | `enable_incremental_gesture_input` | `true` |
| auto-commit child | `enable_gesture_auto_commit` | `false` |

The original `SettingsActivity.onSharedPreferenceChanged()` listens for the
visible parent key and mirrors its checked value into the persistent key. The
modern repository reproduces the same final contract by writing both Booleans
in one editor transaction; the parent must not use the generic single-key
path. Both children depend on the visible parent, retain their stored values
while disabled, and reject repository writes while the parent is off.

The original hierarchy keeps the parent in the general Input area and the two
children in the Chinese-input category. Compose preserves that placement rather
than moving controls solely for visual convenience.

## Plain-looking entries that are not yet safe to migrate

### Dynamic availability

`AbstractSettingsActivity.initializePreferenceItems()` conditionally removes
legacy rows based on runtime capability checks:

- `enable_popup_on_keypress`;
- `enable_voice_input`;
- `enable_vibrate_on_keypress` and `vibration_duration`;
- `one_handed_mode`.

The vibration controls now reproduce the original `ais.c(Context)` gate: the
platform vibrator service must resolve to a `Vibrator` and `hasVibrator()` must
be true. The API-35+ implementation uses typed `getSystemService(Vibrator::class.java)`;
both vibration rows are omitted otherwise, retained values are not changed, and
Repository writes/default restoration are rejected while unavailable. The pure
truth table is unit-tested; current hardware acceptance and a later no-vibrator
runtime matrix remain separate boundaries. The remaining `ais` predicates are
reconstructed and implemented exactly:

- popup-on-keypress and one-handed mode are removed when `@bool/is_tablet` is
  true (`sw600dp`), rather than being guessed from display dimensions;
- voice input is present only when the enabled IME list contains a package whose
  name starts with `com.google.android` and one of its enabled (including
  implicit) subtypes has mode exactly `voice`; lookup exceptions mean hidden;
- capability-hidden settings remain stored but both UI and Repository reject
  new writes.

`supports_one_handed_mode` is a separate IME runtime gate and is deliberately
not substituted for the settings-page `is_tablet` predicate. Phone-device
acceptance confirms capability visibility, key-popup behavior, all three
one-handed values and persistence, portrait/landscape geometry, and existing
input regressions. The `is_tablet=true` runtime branch remains part of the later
large-screen matrix.

### Dependencies or custom state machines

- fuzzy-Pinyin parent/detail group is now implemented: the detail route depends
  on `fuzzy_pinyin`, and Repository writes for all twelve children are rejected
  while the parent is off;
- the emoji/language switch-key group is now reconstructed and implemented as a
  multi-parent state machine. `show_emoji_switch_key` is Boolean, defaults to
  `false`, is shown only on API 19+ phones, and declares
  `disableDependentsState=true`; `show_language_switch_key` is Boolean, defaults
  to `true`, and uses `UncheckDisabledCheckBoxPreference`, so dependency disable
  visually unchecks it without overwriting its retained persisted value;
- the Settings-Activity form of `ajy.d()` has no IME Window token and therefore
  offers input-method switching only when this package has more than one enabled
  subtype or another enabled `com.google.*` IME has a non-auxiliary subtype.
  When available, Boolean `switch_to_other_imes` (default `true`) remains visible
  and depends on both the effective language-switch state and
  `show_english_keyboard`. When unavailable, that row is removed and the
  language-switch row additionally depends on `show_english_keyboard`;
- Compose derives visual checked/enabled state separately from all three stored
  Booleans. Disabled children retain storage, and Repository writes are rejected
  whenever the corresponding legacy dependency or visibility gate is false;
- `one_handed_mode` originally uses `AutoSyncedListPreference`; its implementation
  only refreshes the ListPreference on external writes and adds no second key or
  callback. The Compose selector therefore preserves the exact String values
  `0`, `1`, `2`, default `0`, original order and normal SharedPreferences
  notification path;
- contact import uses `AutoSyncedCheckBoxPreference`;
- fuzzy-Pinyin detail entries originally use
  `CheckBoxPreferenceWithContentDescription`; the Compose route preserves all
  twelve explicit accessibility descriptions on the Material 3 Switch nodes.

### Listener or side-effect parity required

The gesture mirror callback is migrated. Launcher visibility is also
implemented without duplicating the primary-DEX side effect: Compose writes the
exact Boolean key through the same SharedPreferences, so the process-wide
`AppBase` listener still invokes `LauncherIconVisibilityInitializer`, updates
only the legacy `LauncherActivity` component, and retains the existing
`BackupManager.dataChanged()` notification. Key absence remains explicit; its
fallback is `false` for system/updated-system apps and otherwise the original
`@bool/show_launcher_icon`. The testing-only Compose launcher is intentionally
independent. Dictionary/contact operations and remaining AutoSynced Preferences
still require their existing effects before migration.

## Remaining Input page inventory

- plain Boolean candidates pending per-key audit are now limited to related
  options not present on the principal visible Input page;
- migrated dependency groups now include gesture input and its preview/auto-
  commit children, Latin suggestions and next-word prediction, and fuzzy Pinyin
  with its twelve-option detail route;
- `pinyin_scheme`: implemented as the first official Material 3 single-choice
  dialog. It preserves String storage, absent default `quanpin`, original entry
  order (`quanpin`, Microsoft, Unispim, Pinyin PlusPlus, Intelligent ABC,
  Ziranma, flyPY), localized legacy labels, immediate single-selection commit,
  and dismiss-without-write behavior. Device acceptance confirms persistence,
  Full Pinyin and flyPY phrase input, unchanged glide input, cancel semantics,
  and alignment with the page's 24 dp content edge.

## Remaining Keyboard page inventory

- theme navigation is implemented as the original non-persistent navigation
  contract: the Compose row uses the legacy `setting_theme` title and starts the
  existing, non-exported same-package `ThemeSelectorActivity` with an explicit
  component Intent. It does not duplicate theme persistence, builder/editor,
  image selection/cropping, preview, or activity-result behavior. Functional
  device acceptance passes. The first routed build exposed an existing target-36
  geometry gap in the legacy no-ActionBar selector: its root began beneath the
  status bar. A dynamic system-bars Insets listener is now attached after the
  original `setContentView()`, preserving baseline padding and avoiding fixed
  dimensions, Insets consumption, or edge-to-edge opt-out. Portrait/landscape,
  top/bottom system bars, return navigation, and theme behavior pass device
  acceptance;
- vibration availability is implemented and accepted on Pixel hardware with a
  vibrator; the no-vibrator runtime branch remains in the later device matrix;
- emoji/language switch-key dependency group is implemented and device-
  accepted. The reversed emoji/language dependency and retained language value
  behave correctly. The first build hid `switch_to_other_imes` even though the
  Pixel had enabled targets including Gboard; this was traced to target-30+
  package visibility. The MD3 host declares only an `android.view.InputMethod`
  intent query (not `QUERY_ALL_PACKAGES`), after which the row is visible,
  persists changes, and its enabled/disabled value produces the expected actual
  globe-key behavior. With emoji, language, and English keyboard controls all
  off, the Chinese keyboard correctly has no internal globe key;
- physical-key symbol option was migrated in the first Boolean batch.

## Specialized pages and navigation

The confirmed modern hierarchy uses four home destinations: Input, Keyboard,
Dictionary and backup, and Other. Handwriting moves beneath Keyboard because it
is a keyboard input form and its two controls do not justify a top-level page;
this changes navigation only, not either Preference contract. Input divides into
general, Chinese, and English routes, with Fuzzy Pinyin under Chinese. Keyboard
divides into appearance/layout, keys/switching, feedback, and Handwriting. The
home screen contains navigation rows rather than live settings.

These are deliberately excluded from ordinary Boolean/List migration:

- theme selector/editor;
- dictionary health, contacts, shortcuts, clear operations;
- SAF backup location, interval, retention, immediate backup, and import;
- fuzzy-Pinyin detail page is implemented as a process/configuration-safe
  Compose route with app-bar and system Back navigation. Device acceptance
  confirms parent/child dependency, all defaults and retained child values,
  toolbar/system Back, configuration recreation, actual fuzzy candidates and
  restoration when disabled, plus Full Pinyin, flyPY and glide regressions;
- about, privacy, terms, and licenses.

Each modern navigation route must preserve the existing Activity/fragment
contract, result handling, SAF grants, threading, and side effects. No new data
format or replacement screen is implied.

## Formal routing gate

API 35+ routing remains disabled until the principal Input and Keyboard
settings, dependency groups, runtime visibility predicates, and specialized
navigation entry points are covered. API 17–34 continues to use the legacy
Preference implementation.
