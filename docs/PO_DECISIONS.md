# PO Decisions — Architect Gap Review

**Date:** 2026-06-02
**Reviewer:** Product Owner (Habit It)
**Source:** 12 gaps flagged by software architect during translation of `BUSINESS_STORIES.md` to technical stories.

---

## Summary

Accepted 8 of 12 architect defaults. Overrode 3 (G-001, G-003, G-008) and escalated 1 (G-007 — legal copy needs a human, not an engineer or PM). The most important decision: **G-003 — after legacy 5-digit PIN verification, do NOT silently downgrade or surface a fresh "Set up your PIN" flow. Instead, show a one-screen "We've upgraded PIN security — choose a new 4-digit PIN" screen that explicitly explains why and uses the AUTH-003 two-phase widget.** Migration is the riskiest moment in the v1 release because it touches the user's only credential — a confused user here loses all their data via Reset (AUTH-006), so the messaging matters as much as the flow.

I pushed back on the defaults where I felt the architect optimized for engineering convenience (G-001 picking the current accent because it's the current accent, G-008 default-routing tap to a generic agenda, G-007 letting engineering draft legal copy). I accepted where the default is genuinely the right product call, not just the safe one (G-005, G-009, G-010, G-012).

---

## G-001 — Default accent color (SET-005)

**Verdict:** Override.

**Decision:** Default accent on first launch is `#00A36C` (green), not `#1C2D32`.

**Rationale:** `#1C2D32` is a near-black dark slate. It works as a background-surface color (which is what it is today in `AppColors.accent` — the codebase is using it because the app is currently a single-theme dark UI without a real accent system). Once SET-005 ships, accent becomes a *foreground* color used on streak chips, primary buttons, heatmap intensity, and the AI Coach magic icon. A near-black accent on a dark background is invisible; on a light background it's drab. Green (`#00A36C`) is the universal "habit completed / streak alive" signal, aligns with the heatmap's `DONE = green` (ENG-004 AC#2), and gives the user a positive first impression in onboarding. Picking the legacy color "because it's current" is a regression masquerading as continuity.

**Acceptance criteria amendment (SET-005 AC#2):**
> AC#2 (amended): Five-swatch row for **Accent color**: `#00A36C` (green, **default**), `#1C2D32` (slate), `#FF725E` (coral), `#0072B1` (blue), `#900C3F` (deep red). On first launch and after Reset (AUTH-006), `SettingsRepository.accentColor` initializes to `#00A36C`. Existing installs (migrated via FND-002) retain whatever accent was previously persisted; if none, they receive `#00A36C` on first read.

**Downstream impact:**
- **ENG-002** (streak chip): visual review — confirm `#00A36C` on `AppColors.surfaceContainer` has WCAG AA contrast in both themes.
- **ENG-004** (heatmap): cell color scale uses `accent×0.25 / accent×0.5` — confirm green-on-green tiers are still distinguishable.
- **AI-005** (Magic Coach): `wandMagicSparkles` icon tint inherits accent — sanity-check it doesn't look like a "success" affordance when it's actually a CTA.

---

## G-002 — Migrating habits with empty `repeatDays` (FND-002 / SCH-001)

**Verdict:** Accept default.

**Rationale:** `weekly([])` is by definition a habit that never recurs, which is exactly the semantic meaning of `HabitSchedule.none()`. Coercing to `none()` preserves the habit row (the user's data) without inventing a fictional schedule the user never picked. Logging the coercion is the right hygiene step so we can spot a systemic data-corruption pattern in early field reports rather than discovering it from a user complaint six months later.

**Downstream impact:** None — this is a defensive migration branch only.

---

## G-003 — Legacy 5-digit PIN vs new 4-digit PIN (AUTH-001)

**Verdict:** Override (with a refinement, not a reversal).

**Decision:** Keep the architect's flow direction (post-verification → push user to set a new 4-digit PIN), but **do not** drop them into the generic `PasscodeSetupScreen`. Use a dedicated `PasscodeUpgradeScreen` that:
1. Shows a one-sentence explanation: "We've upgraded PIN security. Your old 5-digit PIN has been verified — please choose a new 4-digit PIN."
2. Reuses the AUTH-003 two-phase create → confirm state machine internally.
3. On successful set, surfaces a single-button success state ("PIN updated") rather than continuing into the AUTH-004 biometric opt-in (the user has been re-prompted enough — biometric opt-in can be discovered later via Settings → Security).

**Rationale:** This is the riskiest UX moment in the v1 release. A user opens the app expecting it to work, gets prompted for their old PIN (good), enters it (good), and then is dropped into a screen that looks identical to first-time onboarding ("Create your PIN"). That ambiguity is dangerous because the very next thing a confused user does is tap "Forgot PIN?" — which under AUTH-006 wipes all their data with no recovery. The architect's default is functionally correct but UX-naive. Downgrading to a 4-digit prefix of the old PIN is a non-starter (silent security degradation, plus collisions when users had repeating digits like `12121`).

**Acceptance criteria amendment (AUTH-001 AC#5):**
> AC#5 (amended): Legacy plain-text PIN migration: on first run post-upgrade, `AuthMigrator` reads the legacy `User.password` (5-digit), prompts user once on splash with copy "Secure your PIN — enter your current 5-digit PIN to upgrade". On correct entry, route to a new screen `features/auth/passcode_upgrade_screen.dart` with copy "We've upgraded PIN security. Please choose a new 4-digit PIN." This screen reuses the AUTH-003 two-phase widget but does NOT chain into AUTH-004 biometric opt-in afterward — it ends on a "PIN updated" confirmation that routes directly to the Habits tab. Biometric remains available via Settings → Security. If user enters wrong 5-digit PIN three times during migration, they go to **Reset App Data** flow with the explicit warning copy from AUTH-006.

**Downstream impact:**
- **AUTH-003** — confirm the two-phase widget is parameterizable (title + subtitle copy injected) so it can be reused without forking. If not, file a small follow-up.
- **AUTH-004** — biometric opt-in must be reachable as a one-tap setting from `/settings/security` (it already is per SET-004 AC#1 row "Biometric unlock"). No new work, but verify discoverability copy is clear.
- **AUTH-006** — no change to behavior, but worth a QA pass that the "Forgot PIN?" link is *not* present on the `PasscodeUpgradeScreen` (only on the lock screen and the legacy-PIN entry screen). A user mid-upgrade should not have a "wipe everything" escape hatch on the new-PIN-creation step.

---

## G-004 — Auto-lock-after default (SET-004 / AUTH-005)

**Verdict:** Accept default.

**Rationale:** 30 seconds matches AUTH-005 AC#2 (the existing lock-screen trigger threshold) and is what Vault-It ships — there's a deliberate reference-app precedent here. Going lower ("Immediate") creates friction for users who swipe to the home screen to check a notification and come back; going higher ("5m") weakens the security posture for what is fundamentally a privacy app. 30s is the boring correct answer.

**Downstream impact:** None — this is just locking in the existing AUTH-005 threshold as the default picker value.

---

## G-005 — "Where does my data go?" localisation (SET-008 / AI-007)

**Verdict:** Accept default.

**Rationale:** The whole point of the modal is to show the user, verbatim, what is sent to a third-party server. Translating the system prompt would mean either (a) showing translated text but actually sending English to Groq — which is a lie of disclosure, or (b) sending the translated prompt to Groq — which degrades AI quality and changes the contract for non-English users. Surrounding explanatory copy ("This is the instruction we send to Groq…") should be translated; the system prompt itself stays English-source. This is the same pattern reputable apps use for showing raw API requests in privacy modals.

**Acceptance criteria amendment (SET-008 AC#1 – clarification, not override):**
> AC#1 (clarification): The "Where does my data go?" modal renders the system prompt verbatim in English (not translated), wrapped by localised explanatory copy via `AppLocalization.tr()` keys `ai.privacy.intro`, `ai.privacy.outro`. The system prompt is rendered in a monospace text style to visually distinguish it as a literal payload.

**Downstream impact:**
- **AI-007** — same modal is reused on first-time Magic Coach open; ensure the same English-verbatim treatment applies there.

---

## G-006 — FAQ Q&A content (SET-012)

**Verdict:** Accept default.

**Rationale:** Engineering knows the app feature set better than I do at this level of detail (which exact error states, edge cases, and "wait, what does this button do" moments come up in dogfooding). FAQ content is genuinely a "draft from product knowledge, polish for tone" artifact, not a strategic decision. PM review at QA is the right gate.

**Downstream impact:** None — but flag a PM checkpoint at QA: review the 10 FAQ entries for voice/tone alignment, accuracy, and that they don't accidentally promise features still in backlog (especially around AI Coach behavior and data export semantics).

---

## G-007 — Privacy / Terms legal copy (SET-015)

**Verdict:** Escalate.

**Rationale:** This is the one item I won't sign off on with a "PM reviews at QA" rubber stamp. Privacy policies and terms of service are legal instruments with downstream liability — Play Store rejection risk, GDPR/UK-DPA disclosure obligations, AI-feature data-processing language (especially for the Groq disclosure under SET-008/AI-007), and California CCPA-style "Do Not Sell" language even though we don't sell. An engineer drafting v1 and a PM reviewing is the wrong control surface. The correct path is: engineer drafts a *technical fact sheet* of what data is collected/sent/stored, a legal reviewer (or a vetted template like Iubenda / Termly customised for an offline-first AI-optional app) writes the actual policy, PM reviews for accuracy of factual claims.

**Acceptance criteria amendment (SET-015 AC#3):**
> AC#3 (amended): Legal text drafted from a vetted source (template-derived or counsel-reviewed) to reflect: offline-only data storage, optional opt-in Groq API calls (with explicit list of fields sent), no analytics or telemetry, no third-party SDKs except `flutter_local_notifications` / `local_auth` / `share_plus` / `package_info_plus` / `url_launcher` / `permission_handler`, contact email. Engineer produces a *data inventory* (one-page fact sheet) listing every Hive box, every secure storage key, every outbound network call, and every permission requested; this fact sheet is the input to legal review, not the output.

**Downstream impact:**
- **Release sequencing** — if legal review is not yet sourced, this story should slip out of Release 4 ("Quantitative + categories + polish") and into a separate pre-Play-Store-submission gate. App can ship to internal testing without the in-app legal screens populated, but cannot ship to public Play Store without them.
- **AI-007** — privacy modal copy is a subset of this concern; verify the modal's claims about "nothing else is sent" survive the legal-review pass and remain factually true.

---

## G-008 — Daily summary content (ENG-006)

**Verdict:** Override.

**Decision:** Tap on the daily summary notification deep-links to the **Today agenda** view (ENG-007), not to `/app/habits` with today selected.

**Rationale:** The architect's default is the legacy calendar-based Habits view with today's date pre-selected. But ENG-007 introduces a dedicated "Today" agenda landing that is *literally* the screen a user wants to see when they tap a notification that says "You have N habits today." The two are not the same — `/app/habits` with today selected still shows the calendar bar, the week strip, all the schedule chrome; the Today agenda is a clean list of today's items. Deep-linking to the older screen because it's already wired up is engineering convenience at the cost of UX coherence.

If ENG-007 ships in a later release than ENG-006 (the dependency graph allows it — ENG-006 is in Release 2 per §13, ENG-007 is also Release 2 but only P1), the deep-link target falls back to `/app/habits` until ENG-007 lands. After ENG-007, the target updates.

**Acceptance criteria amendment (ENG-006 AC#6):**
> AC#6 (amended): Daily summary notification (SET-007) shows "You have N habits today" at user-picked time. Tapping the notification deep-links to the Today agenda (`/app/today` per ENG-007) when that route is available; falls back to `/app/habits` with today pre-selected when ENG-007 has not yet shipped. The deep-link target is resolved at tap-time, not at schedule-time, so users who upgrade past ENG-007 automatically get the new target without re-scheduling notifications.

**Downstream impact:**
- **ENG-007** — currently P1. Recommend re-checking whether it should be P0 given that it's now part of the canonical notification-tap path. If it stays P1, the fallback behavior above must be unit-tested.
- **FND-005** (GoRouter) — `/app/today` route must be registered alongside `/app/habits` so the deep-link can resolve via name lookup.

---

## G-009 — `MonthlyAnySchedule` semantics (SCH-001)

**Verdict:** Accept default.

**Rationale:** "Once per month, any day" is fundamentally a *count* constraint, not a *date* constraint. Penalising the user for picking the wrong day would turn a flexible schedule into a hidden game of "guess the right slot." If a user marks DONE on the 5th, realises they actually did it on the 7th, and wants to move the mark — that's a correction, not a fresh completion. The default correctly models user intent. The only edge case worth a unit test: streak math (ENG-001) when the marked day shifts within a month — confirm the streak counts a single completion per month regardless of which day it lands on.

**Acceptance criteria amendment (SCH-001 AC#3 – clarification):**
> AC#3 (clarification for `monthlyAny`): The "once per month" constraint is enforced as a count, not a slot. A user can unmark a previously-DONE day within the month and mark a different day in the same month; this counts as a single completion for that month. Streak math (ENG-001) treats the month as completed if any day in the month has state DONE, regardless of which day. Attempting to mark a second day as DONE in the same month while another day is already DONE shows an inline hint: "This habit is monthly — already done this month."

**Downstream impact:**
- **ENG-001** (streak service): must group `monthlyAny` habits by `(year, month)` rather than by day when computing currentStreak/longestStreak. Add a unit test fixture.
- **ENG-004** (heatmap): for `monthlyAny` habits, a "DONE" tile on day 7 represents completion for the month — confirm the visual doesn't imply only that single day was the target.

---

## G-010 — Notification action button vs lock state (ENG-006 / AUTH-005)

**Verdict:** Accept default.

**Rationale:** The "Done" action is a database write performed by the notification handler in the background process — there is no UI, no data shown to the user, no opportunity for shoulder-surfing. The user has already proven possession of the device by interacting with the notification shade (which on both Android and iOS respects system-level lock-screen privacy settings via the OS, not the app). Requiring the user to unlock the app just to confirm "yes I did the thing" introduces friction that defeats the purpose of the action button. The lock posture protects the *UI surface* of the app (which contains visible habit names, notes, streaks) — it does not need to protect the action of writing a single state transition for a habit whose name the user just saw on the notification anyway.

**Acceptance criteria amendment (ENG-006 AC#5 – clarification):**
> AC#5 (clarification): The "✓ Done" notification action invokes `HabitRepository.markDone(habitId, date)` in the background isolate without unlocking the app. The app's lock state is unaffected; the next time the user opens the app, they still face the lock screen per AUTH-005. The action is a write-only operation and never displays habit data, notes, or streak info in any UI surface beyond the system notification itself (which is governed by OS-level lock-screen privacy settings, not the app).

**Downstream impact:**
- **AUTH-005** — confirm the lock-screen state machine does not treat a background DB write as "user activity" that would reset the 30-second background timer.
- **Security review pass** — note this behavior explicitly in the threat model: "An attacker with the device unlocked at the OS level (e.g. someone who already has the phone passcode) can mark habits done via notification actions without entering the app PIN. This is acceptable; the app PIN protects UI confidentiality, not write integrity."

---

## G-011 — Suggestion seed for "Try again" (AI-006)

**Verdict:** Accept default.

**Rationale:** Persisting intake across navigation would mean either (a) reviving the previous intake on next Magic Coach open — which surprises the user, or (b) storing it in Hive and synchronising lifecycle — which is engineering cost for a feature whose entire premise is "describe how you feel *right now*." Feelings are session-local by design. In-memory is correct and matches Readline's reference pattern (AI-002 explicitly mirrors `SettingsAwareContentGenerationService` from Readline).

**Downstream impact:** None.

---

## G-012 — Locale switch immediate vs prompt (SET-006)

**Verdict:** Accept default.

**Rationale:** Gradual update via `languageNotifier` is the architecturally correct answer in a ViewModel-driven app — by FND-006, ViewModels expose streams and screens consume via `StreamBuilder`, which means localised strings are read at build time, not held as state. A "rebuild from root" hammer would discard in-flight ViewModel state (e.g. a half-filled Add Habit form, an open Magic Coach intake) which is a worse UX than a 200ms visual lag while a screen re-renders. The single guardrail: confirm no ViewModel stores a localised string in its `BehaviorSubject` — strings must be derived in the screen via `'key'.tr`, not pushed by the ViewModel. This is already implied by the Flutter Unified Standards spec but is worth an explicit lint check.

**Acceptance criteria amendment (SET-006 AC#3 – clarification):**
> AC#3 (clarification): `MaterialApp.locale` updates through `languageNotifier` (`ValueNotifier<Locale>`). ViewModels MUST NOT emit localised strings via their streams; all `.tr` lookups happen at widget build time. A code-review checklist item (or lint rule) is added under the Flutter Unified Standards to enforce: "no `'key'.tr` call inside a `BehaviorSubject` value or ViewModel state class."

**Downstream impact:**
- **FND-006** — add the "ViewModels do not hold localised strings" rule to the ViewModel review checklist.
- **All future ViewModels** — confirm during code review of SCH-003 (Add Habit), AI-005 (Magic Coach intake), and any error-message-producing ViewModel.

---

## Tally

| Verdict | Count | Gaps |
|---|---|---|
| Accept default | 8 | G-002, G-004, G-005, G-006, G-009, G-010, G-011, G-012 |
| Override | 3 | G-001, G-003, G-008 |
| Escalate | 1 | G-007 |

**Engineer is unblocked on 11 of 12 gaps.** G-007 (legal copy) is the only blocker for public Play Store submission and should be tracked as a separate sourcing task outside the engineering backlog. All other overrides include literal acceptance-criteria amendments above.
