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

## Plain-looking entries that are not yet safe to migrate

### Dynamic availability

`AbstractSettingsActivity.initializePreferenceItems()` conditionally removes
legacy rows based on runtime capability checks:

- `enable_popup_on_keypress`;
- `enable_voice_input`;
- `enable_vibrate_on_keypress` and `vibration_duration`;
- `one_handed_mode`.

The existing vibration controls predate this inventory and therefore still
need capability-visibility parity before formal routing. Popup, voice, and
one-handed controls must not be added until the corresponding `ais` predicates
are reconstructed without hidden assumptions.

### Dependencies or custom state machines

- `enable_incremental_gesture_input` and `enable_gesture_auto_commit` depend on
  `enable_gesture_input`;
- `next_word_prediction` depends on `latin_show_suggestion`;
- fuzzy-Pinyin detail depends on `fuzzy_pinyin`;
- `switch_to_other_imes` depends on `show_language_switch_key`;
- `show_emoji_switch_key` declares `disableDependentsState=true`;
- `show_language_switch_key` uses `UncheckDisabledCheckBoxPreference`;
- `one_handed_mode` uses `AutoSyncedListPreference`;
- contact import uses `AutoSyncedCheckBoxPreference`;
- fuzzy-Pinyin detail entries use
  `CheckBoxPreferenceWithContentDescription` and must preserve those explicit
  accessibility descriptions.

### Listener or side-effect parity required

`SettingsActivity` mirrors changes to `enable_gesture_input` into the separate
persistent gesture key. That setting is not a plain Boolean write. Launcher
visibility, dictionary/contact operations, and any AutoSynced Preference also
require their existing component or synchronization effects before migration.

## Remaining Input page inventory

- plain Boolean candidates pending per-key audit: Latin correction,
  capitalization, and related options;
- dependency groups: gesture input and its preview/auto-commit children; Latin
  suggestions and next-word prediction; fuzzy Pinyin and its detail page;
- `pinyin_scheme`: ListPreference with exact entry ordering and String values.

## Remaining Keyboard page inventory

- theme navigation (specialized Activity);
- `one_handed_mode` (AutoSyncedListPreference plus capability gate);
- popup and voice controls (capability gates);
- emoji/language switch-key dependency group;
- physical-key symbol option (migrated in the first Boolean batch).

## Specialized pages and navigation

These are deliberately excluded from ordinary Boolean/List migration:

- theme selector/editor;
- dictionary health, contacts, shortcuts, clear operations;
- SAF backup location, interval, retention, immediate backup, and import;
- fuzzy-Pinyin detail page;
- about, privacy, terms, and licenses.

Each modern navigation route must preserve the existing Activity/fragment
contract, result handling, SAF grants, threading, and side effects. No new data
format or replacement screen is implied.

## Formal routing gate

API 35+ routing remains disabled until the principal Input and Keyboard
settings, dependency groups, runtime visibility predicates, and specialized
navigation entry points are covered. API 17–34 continues to use the legacy
Preference implementation.
