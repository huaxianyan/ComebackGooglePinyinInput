# Unified Header Platform Foundation Audit

## Status

Historical foundation audit for `feat/header-platform`. The foundation described here was subsequently completed and runtime-accepted in isolated `diag52` and Compose-integrated `diag53` builds. It remains unmerged and unreleased. Final behavior, diagnostics `diag42`–`diag53`, password-height decisions and acceptance evidence are recorded in [`header-platform-runtime-acceptance.md`](header-platform-runtime-acceptance.md).

## Preserved baseline

- Formal `master`, `v2.0.2`, package, signature identity, and installed device state are unchanged.
- Existing Inline Autofill API 30 request/response protocol, bounded asynchronous inflation, stale-result rejection, Surface clipping bridge, and old-ART API isolation remain in source.
- Clipboard continues to use the real native Candidate path and retains sensitive payload/display separation.
- Candidate, phone, password/PIN/numeric/date-time Body, covering-IME, theme, settings, dictionary, and resource-ID contracts are not intentionally changed.

## Archived experiments

The complete pre-foundation dirty tree was archived locally under:

```text
work/header-platform-pre-foundation-archive/
```

It includes the tracked binary patch, untracked files, status/stat inventory, and SHA-256 manifest. Expanded overlay, free horizontal scrolling, manually synchronized separators, sampled theme colors, Provider-specific margins/translations, and carousel presentation experiments are not foundation code.

## Implemented foundation

### Module-facing contracts

```text
HeaderModule
HeaderPlatformContext
HeaderContribution
HeaderRendererPayload
HeaderPresentationKind
HeaderPlacement
HeaderHandle
```

Module-facing APIs expose opaque session/Header identities and publication operations, not Header sibling Views.

### Service-scoped control

```text
HeaderPlatformController
HeaderSessionController
HeaderArbiter
HeaderRenderPlan
HeaderRenderPlanListener
HeaderPlatformOwner
```

The controller owns compile-time module registration, session identity, Header identity, publication storage, native-Candidate priority, deterministic tie-breaking, withdrawal, lifecycle invalidation, theme/render generations, and immutable render plans.

Input-session identity and concrete Header-host identity are separate. A contribution is accepted only when both tokens match, preventing a late asynchronous result from an old editor or replaced Header from reappearing.

### Single host

`HeaderPlatformHostView` is placed exactly once in each candidate-capable phone/hardware/handwriting/universal Header layout. Module-specific Inline hosts were removed from the hidden Candidate-inner layouts.

The host binds directly to the service through `HeaderPlatformOwner`; it does not use a process-global weak host registry. It locates the nearest explicit native-holder interfaces within its own Header hierarchy and never exposes those Views to modules. A platform-owned `HeaderRendererRegistry` and renderer/content cleanup contracts prepare leading, center, and trailing content before committing a plan. Native Candidate ownership hides but retains an already prepared extension tree; idle/session invalidation releases it. Theme/render generation changes force native chrome recreation.

### Native holder seams

`FixedSizeCandidatesHolderView` now implements:

```text
HeaderChromeFactory
HeaderNativeCandidateSource
```

`createCandidateChromeSlot()` calls the original `Lavp.a()` native slot factory, then follows the original `Lavq` warm-up path to bind a layout-only `SoftKeyDef` carrying `Lavr.c` (`candidate_layout`). It does not construct or bind a `Candidate`, `ActionDef`, or submission payload. Because native `SoftKeyView.onInterceptTouchEvent()` always intercepts descendants, the factory product itself is never used as the remote parent: `HeaderVisualSlot` detaches the factory-inflated Candidate content hierarchy and transfers the exact factory-produced background Drawable into a neutral platform-owned `FrameLayout`. This preserves native chrome while allowing the Framework-owned `InlineContentView` to receive clicks. Runtime visual/touch acceptance is still required before this seam can be declared final.

Native Candidate priority now originates from actual holder count transitions through `HeaderNativeCandidateStateListener`. The old `InputBundle -> InlineAutofillClipHost` module-specific Candidate-state hook was removed. Listener registration immediately publishes current state, and append/clear paths publish subsequent transitions.

### IME lifecycle

`PinyinIME` implements `HeaderPlatformOwner` and lazily owns one initialized controller. It starts sessions from `onStartInput`, finishes them from input/window teardown, and destroys the platform from service destruction. This lifecycle is API-neutral and does not resolve API 30 Inline types on old ART.

### API 30 guard correction

The request/response branches now use the correct API 30 condition:

```text
if-ge SDK_INT, 30 -> supported path
otherwise         -> null/false fallback
```

The previous stage-B `if-lt` direction was a confirmed defect and is not retained.

## Static and build evidence

Completed on an isolated release-like audit package decoded from the original APK:

```text
package=com.google.android.inputmethod.pinyin.headerplatformaudit
versionCode=4520420
```

Passed:

- Header platform Java 7 host contract tests;
- generated Smali/API-neutral coupling checks;
- universal Header verifier;
- sensitive Clipboard host/decoded checks;
- Inline Autofill module/renderer protocol and old-ART isolation verifier;
- API 31, 33, 34, 35, and 36 invariants;
- apktool Smali/resource rebuild;
- all 6,633 legacy public resource IDs;
- isolated audit signing with v1/v2/v3 verification;
- post-signing `zipalign -P 16 -c 4` verification.

The resource-ID verifier was updated to accept modern `aapt2 dump resources` lines carrying `PUBLIC`/`STAGED` suffixes while retaining exact numeric-ID comparison.

Prepared but did not install:

```text
file=work/header-platform-module-build/aligned.apk
package=com.google.android.inputmethod.pinyin.headerplatformaudit
versionCode=4520421
versionName=2.0.2-header-platform-module
size=19,066,333 bytes
SHA-256=83d1a43617f08464115d539dfa695046f3bf5991de71bce287166cfd4582c0f5
signing=isolated audit certificate, v1/v2/v3
16 KiB ZIP alignment=true
debuggable=false
```

Synthetic Provider rebuilt offline and ready for the same isolated acceptance flow:

```text
file=work/inline-autofill-synthetic-provider/app/build/outputs/apk/debug/app-debug.apk
package=com.example.inlineautofillprovider
size=2,578,415 bytes
SHA-256=aa178792acbc38272ef04a71c941a075ba84a6b9950961b122f22e5d085de8cf
```

No phone installation or runtime test was attempted because the device was disconnected as requested.

## Inline Autofill module migration

The obsolete `InlineAutofillClipHost` process-global registry, sibling alpha manipulation, and module-owned z-order logic have been removed. The API 30 bridge now resolves the service-owned `InlineAutofillHeaderModule`, captures both session and Header tokens, and publishes an immutable `REMOTE_SURFACE` contribution only after bounded ordered inflation.

A generic `HeaderNativeActionPayload`/`HeaderNativeActionRenderer` path is also registered. Its module contract carries an action kind, description, enabled state, and View-free callback. Host tests publish a non-shipping `script-toggle-probe` contribution alongside center content without changing Autofill module code.

The platform `InlineAutofillRemoteRenderer` now:

- creates its center shell through the layout-only native Candidate chrome factory;
- creates previous/next rails through the same native factory and native theme arrow attrs;
- keeps remote Views pre-mounted and clips/disables non-current Surfaces;
- preserves Framework-owned remote clicks and never reads presentation text or Autofill values;
- keeps disabled actions at alpha `0.28` and removes them from accessibility;
- retains prepared remote content while native Candidates temporarily own the Header;
- releases clipping, listeners, Views, and accessibility state on idle/session/host teardown.

`scripts/verify_inline_autofill.py` now verifies the module/renderer path directly and rejects any return of `InlineAutofillClipHost`, API 30 types outside the narrow bridge, payload inspection, or direct clipping from API-neutral platform classes.

## Foundation follow-up result

The subsequent implementation completed the previously open foundation items:

1. Native visual-slot inflation, remote Surface mounting, stable previous/next rails, local-coordinate clipping, Framework click handling, themes, orientation and host replacement passed isolated runtime acceptance.
2. The official AndroidX Inline Style Bundle was restored. New requests use foreground from the real native Candidate rendering chain; Provider remote Views are never directly recolored.
3. Clipboard control-plane ownership moved into `ClipboardHeaderModule` while native Candidate data, selection, sensitive masking and full-text submission remained unchanged.
4. The generic native-action renderer is covered by a non-shipping host probe; no speculative product action was added.
5. Theme-response identity rejection was removed after `diag40`–`diag42` proved public theme color/cache keys cannot reliably identify a returned immutable Surface. This preserves valid Autofill at the cost of a bounded possible old-theme foreground.
6. API 36 isolated and full Compose-combination runtime passed. API 17–29 remains static/environment-limited, and TalkBack Inline support remains deliberately undeclared.
