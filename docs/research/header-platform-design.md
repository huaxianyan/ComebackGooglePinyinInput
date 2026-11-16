# Unified Header Platform Design

## Status

Implemented and runtime-accepted on the isolated `diag52` Header package and the complete Compose-integrated `diag53` package. This document remains the normative architecture contract; detailed build and runtime evidence is recorded in [`header-platform-runtime-acceptance.md`](header-platform-runtime-acceptance.md). The work is not merged or released.

## Goal

Turn the universal Google Pinyin Header from a shared piece of layout into a lifecycle-safe module platform. Clipboard, Inline Autofill, and future actions such as a Simplified/Traditional Chinese toggle must use the same registration, arbitration, layout, theme, accessibility, and cleanup contracts without being forced into the same data model.

## Non-goals

- Do not expose a third-party dynamic plugin ABI yet.
- Do not convert every contribution into a Google Pinyin `Candidate`.
- Do not let modules manipulate Header siblings, alpha, visibility, or z-order directly.
- Do not approximate native chrome with sampled colors, copied near-match drawables, device-specific offsets, or Provider-specific tuning.
- Do not let a module read another module's private content or payload.

## Platform topology

```text
SoftKeyboardView Header
├─ native Prime/idle surface
├─ native Candidate surface
└─ HeaderPlatformHost
   ├─ HeaderModuleRegistry
   ├─ HeaderArbiter
   ├─ HeaderChromeFactory
   ├─ HeaderRendererRegistry
   └─ HeaderSessionController
```

There is one `HeaderPlatformHost` per universal Header. Modules never search for or mutate sibling Views. The host owns all rendering transitions and restores the native Header when no contribution is active.

## Core contracts

### HeaderModule

A project-internal, compile-time registered module.

```text
id
priority
onAttach(platformContext)
onStartInput(editorContext, sessionToken)
onHeaderAvailable(headerHandle)
onNativeCandidateStateChanged(state)
onThemeChanged(themeToken)
onFinishInput(sessionToken)
onDetach()
```

A module may publish or withdraw immutable contributions. Lifecycle calls must be idempotent. Late asynchronous results must include the originating session token and be rejected by the platform after invalidation.

### HeaderContribution

A content-free platform envelope around renderer-specific data.

```text
moduleId
stableId
sessionToken
priority
presentationKind
placementPolicy
coexistencePolicy
accessibilityPolicy
rendererPayload
```

The platform envelope must not contain sensitive plaintext unless the selected renderer contract explicitly requires short-lived process-local payload handling. Inline Autofill contributions contain remote framework objects, not extracted presentation text or Autofill values.

### Presentation kinds

The platform unifies module integration, not data semantics.

#### NATIVE_CANDIDATE

For content whose real semantic action is native text submission, such as Clipboard paste.

- Uses the existing native Candidate holder and Candidate callbacks.
- Preserves Candidate theme, paging, accessibility, and touch behavior.
- Sensitive display text remains separate from short-lived submission payload.
- Must not be used for Inline Autofill or arbitrary action buttons.

#### REMOTE_SURFACE

For Android Inline Autofill.

- Hosts framework-provided `InlineContentView` objects.
- Never reads presentation text, `AutofillValue`, or Provider payload.
- Never calls `commitText()` for Autofill.
- Owns explicit Surface clipping, pre-attachment, stale rejection, and cleanup.
- Uses native chrome slots without creating fake Candidate data.

#### NATIVE_ACTION

For future project-owned actions such as Simplified/Traditional Chinese switching or another keyboard command.

- Uses native key/action chrome from `HeaderChromeFactory`.
- Has an explicit project-owned callback and accessibility description.
- Does not create Candidate data solely to obtain visuals.
- Must declare whether it is persistent, contextual, or mutually exclusive with center content.

Additional presentation kinds require an explicit platform contract and tests; modules may not introduce one-off View ownership.

## Native chrome factory

`FixedSizeCandidatesHolderView` already separates native slot creation from Candidate binding internally:

```text
Lavp.a()                  -> create native themed SoftKeyView
Lavp.a(index, Candidate)  -> bind Candidate model and action
```

The platform will expose the first stage through an API-neutral project interface. The returned visual slot is created by the original native factory but is not inserted into Candidate submission, learning, deletion, deduplication, or paging state.

Planned minimal factory responsibilities:

```text
createCandidateChromeSlot()
createCandidateSeparator()
createHeaderActionChrome(actionVisualKind)
refreshChrome(slot, themeToken)
releaseChrome(slot)
```

The factory must return independently owned slots and must not lend a View still owned by a native holder. It must preserve current theme state without reflection, hidden resource lookup, copied pixel colors, or fake Candidate objects.

## Arbitration

The `HeaderArbiter` is the only component allowed to decide visibility and composition.

Initial priority policy:

```text
active native composition/candidates (including a dismissible Clipboard Candidate)
> contextual remote Inline Autofill
> optional native actions
> Prime/idle Header
```

Priority alone is insufficient. Contributions also declare coexistence and placement:

```text
EXCLUSIVE_CONTENT
CENTER_CONTENT
LEADING_ACTION
TRAILING_ACTION
PERSISTENT_ACTION
```

A real Clipboard Candidate temporarily takes native ownership over Inline Autofill. Closing or consuming that Candidate withdraws native ownership and lets the still-valid Inline contribution return; this policy uses no TOTP/content heuristic. For example, a future Simplified/Traditional toggle may be a trailing action when the active center renderer permits it, but must disappear rather than compress password keys or violate a remote presentation's minimum geometry.

The arbiter must produce one immutable render plan. Renderers apply that plan atomically; modules do not hide each other.

## Session and lifecycle ownership

A service-scoped `HeaderSessionController` owns monotonically increasing session tokens. It invalidates or rebinds contributions on:

- new editor/input session;
- new input view or Header identity;
- `onFinishInput`;
- service destruction;
- Header detach;
- keyboard replacement;
- theme/configuration rebuild when renderer state cannot be retained safely.

`onFinishInputView()` and IME Window hiding are not, by themselves, editor-session completion. They may detach or hide the current renderer/host, but must not invalidate content that still belongs to the active editor and can be safely rebound. Final editor invalidation occurs on the true `onFinishInput()` boundary or a newer editor session.

Asynchronous modules publish only through the controller. A result is accepted only if module identity, session token, Header identity, and renderer generation all still match.

## Theme ownership

- Renderers request chrome from `HeaderChromeFactory`; modules never resolve native theme attrs themselves.
- Theme changes issue a new `themeToken` and either rebind or replace platform-owned chrome.
- Remote Provider content remains Provider-owned. Style Bundles are advisory and must degrade safely.
- Custom image themes, light/dark/fixed slots, phone/tablet variants, and navigation visual geometry remain supported by the existing keyboard theme pipeline.

## Accessibility

- The platform exposes only the active render plan.
- Inactive pre-attached remote Surfaces are clipped, disabled, and hidden from accessibility.
- Native actions provide explicit project-owned descriptions and enabled/disabled semantics.
- Sensitive Clipboard plaintext never enters display or accessibility text.
- Inline Autofill accessibility remains Provider/framework-owned; touch-exploration support is not declared until separately accepted.

## Old-ART and API boundary

The platform core, module interfaces, arbiter, native chrome factory, and Candidate/action renderers remain API-neutral in primary DEX.

API 30 classes remain confined to the Inline Autofill bridge/controller. API 17–29 startup must not resolve `InlineSuggestion`, `InlineSuggestionsRequest`, `InlineContentView`, or `InlinePresentationSpec`.

## Implemented migration

1. Archived and removed the expanded, scrolling, sampled-theme, and margin-offset experiments from product implementation.
2. Preserved the verified API 30 request/response bridge, bounded inflation, stale rejection, Provider order, clipping, and payload isolation.
3. Introduced the platform interfaces, registry, session controller, arbiter, and immutable render plan.
4. Added the native chrome factory seam to `FixedSizeCandidatesHolderView` while keeping Candidate binding/submission semantics separate.
5. Migrated Clipboard control-plane publication and priority signaling to `ClipboardHeaderModule` while retaining the true Candidate renderer.
6. Migrated Inline Autofill to `InlineAutofillHeaderModule` and a remote-surface renderer using native visual slots.
7. Removed dispersed module-specific sibling hiding and static visibility hooks.
8. Added a non-shipping native-action probe to host tests, proving future actions can register without changing Clipboard or Autofill modules.
9. Completed the available static, rebuild, resource-ID, theme, lifecycle, Pixel API 36 and Compose-integration gates. API 17–29 runtime remains environment-limited; TalkBack Inline acceptance remains separate.

## Required gates

- Every universal keyboard Header exposes exactly one platform host.
- Modules cannot receive raw sibling Views or mutate Header ownership directly.
- Every contribution has a module ID, stable ID, session token, renderer kind, priority, and coexistence policy.
- Fake Candidate use for remote or action modules is statically prohibited.
- Inline Autofill payload extraction and `commitText()` remain statically prohibited.
- Native Candidate, Clipboard, and phone accessibility behavior remain unchanged when no extension contribution is active.
- API 17–29 primary DEX remains free of API 30 Inline types.
- All 6,633 legacy resource IDs remain stable.
- Full rebuild from the original APK remains reproducible.

## Acceptance boundary

The platform guarantees native Header chrome, geometry, module composition, lifecycle, and ownership. It cannot read or re-render Provider-owned remote presentation text. Any visual behavior inside the remote Surface remains controlled by the Autofill Provider and Android framework.
