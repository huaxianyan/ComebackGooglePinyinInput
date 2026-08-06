# Material 3 first-run and settings redesign

## Scope and baseline

This branch starts from the formal Android 16 / target SDK 36 `v2.0.0`
baseline. Native 16 KiB work remains parked on
`fix/native-16kb-page-size`; predictive Back and Android 17 remain separate.

The redesign covers the complete user-visible setup/settings surface:

- the single-page first-run flow;
- the settings header screen and every preference fragment;
- switches, check boxes, list choices, sliders, categories and summaries;
- preference dialogs and dictionary import/export/backup surfaces;
- theme selector, theme builder and theme editor shells;
- action bars/top bars, system bars, empty/loading/error states and day/night;
- narrow phones, landscape and framework `PreferenceActivity` multi-pane mode.

It does not redesign the keyboard, candidates, handwriting canvas or native
engine. It must not change preference keys, stored value types, dictionary I/O,
SAF grants, theme package formats, first-run completion state or navigation
semantics.

## Gboard reference findings

The current Gboard sample keeps setup state separate from presentation and
re-checks activation state when focus returns. Google Pinyin follows that state
model but presents both required actions on one page: enable the IME, then
select it. This removes pager navigation without merging the two independent
system states or bypassing either system-owned screen.

Gboard settings use AndroidX `Preference` plus custom presentation classes.
Relevant visual/structural behavior includes:

- a preference-screen hierarchy rather than bespoke state storage;
- icon-bearing header rows grouped into sections;
- rounded/clipped selected header surfaces on API 31+;
- title and summary colors taken from theme tokens;
- switch/list/slider widgets that retain ordinary Preference persistence;
- a single settings surface model shared by rows, dialogs and top bars.

Google Pinyin 4.5.2 uses framework `android.preference.PreferenceActivity` and
`PreferenceFragment`. Replacing that framework wholesale would unnecessarily
risk every custom preference and listener. This redesign therefore applies an
MD3 presentation layer while preserving the existing Preference objects,
fragment classes, XML keys and callbacks. It must not copy Gboard's obfuscated
code or resources.

## Visual model

The modern surface uses a coherent day/night token set:

- `primary`, `onPrimary`, `primaryContainer`, `onPrimaryContainer`;
- `surface`, `surfaceContainer`, `surfaceContainerHigh`;
- `onSurface`, `onSurfaceVariant`, `outline`, `outlineVariant`;
- explicit error colors;
- 20–28 dp rounded containers, 40–48 dp controls and at least 48 dp touch
  targets;
- headline/body/label typography based on platform sans-serif families.

The first-run and settings tokens must describe the same product. Static tokens
are used initially because the APK has no Material Components dynamic-color
runtime. Dynamic color may be added only through public APIs and with a stable
fallback; it is not a prerequisite for a valid MD3 layout.

## Functional invariants

### First run

1. One page contains the Enable and Select input method actions.
2. Select remains disabled until Enable is complete.
3. Both states are rechecked after returning from system UI and displayed
   independently on their respective cards.
4. Finish remains disabled until both states are complete; there are no
   Previous, Next, page indicator, swipe gesture, or separate Done page.
5. Back before completion exits only through the accepted exit path.
6. Finish atomically writes the installation-local completion marker, opens
   `SettingsActivity`, and calls ordinary `finish()`.
7. No permission overview or anonymous metrics page returns.
8. Newly installed audit packages are not launched or mutated before manual
   first-run testing.

### Settings

1. Existing `Preference` keys, defaults, dependencies and value types remain
   byte-for-byte compatible.
2. Existing custom preference subclasses remain responsible for persistence
   and dialogs.
3. Dictionary health stays asynchronous and content-safe.
4. SAF provider/backup I/O stays off the UI thread.
5. Theme selection/cropping does not rewrite an existing cropped image unless
   the user explicitly reselects and crops.
6. No deprecated cloud/account settings return.
7. All rows and controls retain accessibility labels, enabled state and a
   minimum 48 dp interaction target.

## Delivery stages

1. **Theme foundation (implemented):** shared day/night tokens, modern system
   bars, action bars, dialogs and first-run shell.
2. **Preference rows (in progress):** categories, ordinary rows, switch/check
   widgets, list rows, disabled state, section spacing and main header rows.
   The API 35+ header screen keeps the original five routes and adds distinct,
   tint-aware icons through `res/xml-v35/settings.xml`; older Android versions
   retain the original header resource and behavior. Gboard's decoded header
   resources use theme-attribute tinting and outline geometry rather than a
   fixed accent fill. Accordingly, these icons use the neutral semantic
   `onSurfaceVariant` token in both day and night modes and 1.8 dp rounded
   outlines; blue `primary` remains reserved for active controls and emphasis.
   Framework and behavior-compatible custom `CheckBoxPreference` rows use a
   trailing switch with an explicit 52×32 dp rounded track and 20 dp handle;
   recoloring the platform's legacy switch alone is not considered an MD3
   implementation. The switch itself is non-clickable and non-focusable so the
   existing Preference row remains the single interaction and persistence
   owner. On API 20+, the legacy application rewrites every XML
   `CheckBoxPreference` into an `android.preference.SwitchPreference` or one of
   its custom subclasses in `gc.a(PreferenceGroup)`. Therefore MD3 decoration
   must target both widget families and use their distinct binding IDs:
   `@android:id/checkbox` and `@android:id/switch_widget`. Missing the converted
   family leaves the platform's legacy switch visible and also explains the
   remaining custom-row alignment differences. Framework, auto-synced list and
   custom `DialogPreference` rows share the modern row layout without changing
   their dialog handlers. This keeps ordinary, converted switch, slider,
   volume, vibration and long-press rows on the same 24 dp leading alignment.
3. **Custom controls:** seek bars, vibration/volume/long-press choices and all
   custom dialogs.
4. **Dictionary/backup:** health, directory, immediate backup and import lists.
5. **Theme tools:** selector, builder, crop and editor shells without changing
   image data semantics.
6. **Accessibility/responsive audit:** font scaling, TalkBack order, contrast,
   landscape, multi-pane and both navigation modes.
7. **Release-like acceptance:** isolated non-debug package, clean first run,
   upgrade/data hashes, crash/DropBox/VerifyError and complete functional
   regression.

## Audit package

Visual and behavior iterations use an isolated release-like application ID,
for example:

```text
com.google.android.inputmethod.pinyin.md3audit
```

It must not replace or mutate the formal package. Debug builds remain diagnostic
only and are not acceptance artifacts.
