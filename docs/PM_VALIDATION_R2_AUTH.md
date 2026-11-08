# PM Validation — Release 2 AUTH (Epic AUTH)

**Reviewer:** Product Owner (Habit It)
**Date:** 2026-06-07
**Slice:** TS-AUTH-001 .. TS-AUTH-008
**Inputs reviewed:** `docs/BUSINESS_STORIES.md` §4, `docs/QA_REPORT_R2_AUTH.md` (PASS), `docs/PO_DECISIONS.md` (G-001, G-003, G-004 binding), worktree `PROGRESS.md` (AUTH section, AQ-1..AQ-7), `docs/PM_VALIDATION_R1_FND.md` (the bar set for R1).
**QA verdict on the slice:** PASS. Crypto correct (PBKDF2-SHA256, 100k iters, 16-byte CSPRNG salt, 32-byte hash, constant-time XOR-accumulate compare). G-003 PasscodeUpgradeScreen verified by code read + zero grep matches for biometric chain on the upgrade path. Lockout persists across a fresh service instance against the same FSS map. GoRouter `refreshListenable` + `redirect:` closes FND C-3. No PIN/hash/salt logged. Quality gates: 0 errors / 3 pre-existing warnings / 134 infos / 70/70 tests passing.

---

## 1. Verdict

**SIGN-OFF-WITH-CONDITIONS.**

Epic AUTH lands clean. The crypto core is the right port, the G-003 contract is honoured to the letter (including the docstring discipline at `passcode_upgrade_screen.dart:15-19`), the lockout policy is correctly persisted and proven across process death, and the C-3 GoRouter deferral I flagged in R1 is now closed via `refreshListenable` on `AppLockService.lockedNotifier`. The user-facing AUTH surface is shippable to an internal-testing track.

The conditions are not regressions or product holes. They are: (a) the same trade-off I accepted in R1 C-1 (legacy SP/datasource retained as read-through) being re-acknowledged for AUTH-008, with the cleanup TODO now narrowed and explicitly re-owned by SET; (b) one small UX call on AQ-2 I'm overriding; (c) a router-coupling TODO QA flagged as informational that I want committed as a code comment before SET dispatches.

Release 3 (SET) can dispatch in parallel to these conditions; nothing on this list is a sequential gate on starting the SET hub + sub-screens.

---

## 2. Business-intent check per AUTH story

### AUTH-001 — 4-digit PBKDF2 PIN
**Intent satisfied.** PIN length is 4 (`kPinLength`), PBKDF2-SHA256 / 100k / 16-salt / 32-hash / `1$<salt>$<hash>` storage format match Vault-It exactly, FSS-only storage under `auth.pin_hash`, constant-time XOR-accumulate compare with no early-return timing leak. G-003 migration honoured: `AuthMigrator.isMigrationPending()` routes legacy users to `/signup/pin-migrate`, then on legacy-PIN verification routes to `PasscodeUpgradeScreen` (NOT generic setup), with the explicit "We've upgraded PIN security" copy and no biometric chain. 3 wrong legacy entries → Reset Data dialog. This is the highest-stakes UX moment in v1 and it's implemented correctly.

### AUTH-002 — `PasscodeKeypad`
**Intent satisfied.** 3×4 grid, biometric slot only when `onBiometric != null` (correctly hides when biometric unavailable per `IBiometricManager.isAvailable()`), haptics on digit/backspace/wrong-PIN per spec, dots indicator with animated transition, stateless widget with `enabled: false` suppression. Mirrors Vault-It line-for-line where it matters.

### AUTH-003 — Two-phase passcode setup
**Intent satisfied.** `create → confirm` state machine driven by ViewModel, mismatch shakes + snackbar + reset to phase 1, match calls `AppLockService.enable` + `setPINAuthentication(true)` then hands control to caller via `onComplete`. The caller-decides-next-step pattern is exactly what makes G-003 (no biometric chain on upgrade) implementable cleanly. Back-button resets create.

### AUTH-004 — Biometric opt-in
**Intent satisfied for the signup path.** Auto-skips when biometric unavailable via post-frame callback, `local_auth.authenticate(stickyAuth: true)`, success persists via `IUserRepository.setBiometricAuthentication(true)`, skip is no-op. AC#5 is correctly marked partial — SET-004 owns the in-settings toggle and the wiring hook is in place (`BiometricManagerImpl` + `IUserRepository.setBiometricAuthentication` DI-registered), so SET-004 can build the toggle without service-layer changes.

### AUTH-005 — App lock + lockout
**Intent satisfied. The R1 C-3 deferral is now closed.** `AppLockService` consolidates lock, `AppLockLifecycleObserver` records pause/resume, ≥30s in background triggers `lockedNotifier.value = true`, threshold sourced from `SecurityConstants.kBackgroundLockThreshold` (G-004 default) via the `Duration Function()` injection point so SET-004 can plumb the picker. Auto-biometric on resume + manual icon, lockout policy (5→30s, 10→5min) persisted to FSS as ISO-8601, survives process death (proven by the fresh-instance test against the same FSS map). GoRouter `refreshListenable` + `redirect:` rule force `/lock` and pop on unlock. The legacy `_deAuthOnBackground` retained for un-upgraded users — correct trade-off, see AQ-4.

### AUTH-006 — Forgot PIN / Reset
**Intent satisfied.** Explicit "permanently erases all habits, settings, and your PIN" copy on the dialog. `ResetService.resetAll()` clears Hive boxes + whitelisted FSS keys + `APP/*` SP keys + lockout state, routes to `/` for splash re-entry. Cancel returns to lock screen. No recovery seed surface anywhere — matches Vault-It's deliberate stance.

### AUTH-007 — Change PIN
**Intent satisfied.** Three-phase `current → create → confirm` flow at `/settings/security/change-pin`. Wrong current PIN goes through `AppLockService.verifyPasscode`, so it shares the same failed-attempts counter and lockout policy as the lock screen — no short-circuit, no separate counter (which would be a security hole). On success, hash replaced + failed-attempts + `lockoutUntil` reset in `changePasscode`. Clean.

### AUTH-008 — Multi-step signup
**Intent satisfied with one acknowledged trade-off (AQ-7).** Welcome → PasscodeSetup → BiometricOptIn → Profile sequence, each its own GoRouter route under `/signup/*`, back navigation allowed with intermediate state held in screens, username ≤ 16 chars enforced via `maxLength: 16`, gender via dropdown over Male/Female, final step routes to `/app/habits`. Email/phone/birthdate validators were never introduced (the legacy unused `passwordValidator` left in place is acceptable — deleting it is not in the AUTH critical path). The FND `TODO(post-AUTH/SET)` ownership is partially honoured — see AQ-7 below.

---

## 3. AQ-1..AQ-7 decisions

### AQ-1 — `SettingsModel.autoLockSeconds` injection point — **ACCEPT engineer's call**

Engineer's `Duration Function()` provider defaulting to `SecurityConstants.kBackgroundLockThreshold` (30s per G-004) is the right call. It is the minimum-coupling solution: SET-004 plumbs the picker value through the constructor without touching `AppLockService`'s contract, and the default keeps R2 self-contained. This is also the most testable shape — you can inject a fixed `Duration` in unit tests without needing a real `SettingsRepository`. The alternative (read directly from `SettingsRepository.autoLockSeconds$.value` inside the service) would couple two services that don't otherwise need to know about each other and would require AUTH to add a field to a model owned by SET. Don't do that. The injection point is exactly the seam SET should consume.

**Condition for SET-004:** when the picker lands, the `Duration Function()` provider must read from a single `BehaviorSubject` on `SettingsViewModel` and changes must propagate without restart (consistent with `themeModeNotifier` / `languageNotifier` patterns from FND-004 / SET-006).

### AQ-2 — PasscodeUpgradeScreen success UX (snackbar + route to `/app/habits`) — **OVERRIDE**

I'm pushing back here. The engineer's choice (route to `/app/habits` + `"PIN updated"` snackbar) is restrained and consistent with how the rest of the app handles successful operations — but the migration moment is *exceptional*. A user who just walked through:

1. Splash redirect they didn't ask for
2. "Enter your current 5-digit PIN" screen
3. "We've upgraded PIN security" explainer
4. Two-phase create → confirm flow

…now lands on `/app/habits` with a snackbar that auto-dismisses in 4 seconds. If they tabbed away or the snackbar overlapped a `SnackBar` queue, they get no closing acknowledgement of what just happened to their credentials. That's a confidence problem on the one moment in v1 where confidence matters most (per G-003 rationale: "the very next thing a confused user does is tap 'Forgot PIN?'").

**Decision:** Add a one-screen confirmation step before routing to `/app/habits`. Single-button "PIN updated successfully" screen with explicit copy ("Your new 4-digit PIN is set. Use it the next time you open the app.") and a "Continue" CTA. No snackbar. The screen is shown once, on success, only on the migration path (not on first-time signup or change-PIN). This is intentionally heavier than a snackbar because it's a one-time event in the user's lifetime with the app.

**Acceptance criteria amendment (AUTH-001 AC#5 / G-003):**
> AC#5 (further amendment, layered on top of G-003): On successful new 4-digit PIN setup via the migration path, `PasscodeUpgradeScreen.onComplete` routes to a new confirmation screen `features/auth/screens/passcode_upgrade_success_screen.dart` (not directly to `/app/habits`). The success screen shows a checkmark illustration, the copy "Your new 4-digit PIN is set. Use it the next time you open the app.", and a single "Continue" CTA that routes to `/app/habits`. There is no biometric prompt, no snackbar, and no "Forgot PIN?" link on this screen. This confirmation screen is reached only via the migration path; first-time signup (AUTH-008) and change-PIN (AUTH-007) continue to use their existing success paths.

**Effort:** S (one stateless screen + one route entry + one routing change in `PasscodeUpgradeScreen.onComplete`). Should be a same-day patch on top of the AUTH slice before SET-004 starts editing adjacent code. Engineer is free to do this as a follow-up commit on the AUTH branch.

### AQ-3 — Forgot-PIN during active lockout — **ACCEPT engineer's call**

Allowing the Forgot-PIN dialog to open during a lockout countdown is the correct UX. The lockout is a defence against *retry brute-force*, not a defence against *reset*. A user who is locked out for 5 minutes and remembers they don't actually know their PIN should not have to wait out the countdown before being shown the reset path — that's a hostile UX with no security upside (the reset wipes everything anyway; there's nothing to brute-force at that point). Clearing `auth.lockout_until` as part of `ResetService.resetAll()` is also correct — a fresh-install state should have no lockout carry-over. The FSS sweep already covers this. No amendment.

### AQ-4 — Legacy `/signin/*` routes redirected to `/lock` — **ACCEPT engineer's call**

This is the same shape as the FND C-1 trade-off I accepted in R1: legacy code paths retained as a read-through for users who haven't been migrated, with the migration cleanup deferred to the epic that owns the surface (SET in this case). Redirecting to `/lock` rather than rendering the legacy widget is the right pragmatic call — once a user has been migrated (their `pin_hash` exists in FSS), there is no reason to ever route them through legacy signin, and the redirect closes the back-button hole where a legacy user could deep-link to `/signin/pin` after upgrade.

**Condition for SET sprint:** the legacy `/signin/*` route registrations + the corresponding screen widgets must be deleted during SET (specifically as part of SET-004 or as a SET-cleanup ticket). I'm not willing to carry unreachable-but-registered routes into Release 4. The cleanup is owned by the SET sprint per AQ-7.

### AQ-5 — `CustomDropdown` not in codebase, `DropdownButtonFormField` used instead — **ACCEPT engineer's call**

The TS reference to `CustomDropdown` was speculative (the widget doesn't exist in habit-it; the reference was inherited from a Vault-It pattern). For gender selection with two options (Male / Female), a Material `DropdownButtonFormField` is fully sufficient — no search field needed (Vault-It's `CustomDropdown` had search for vault-category selection, which has dozens of options), no custom theming hook needed beyond what Material gives via the existing theme tokens. UX-003 is the canonical home for any future `CustomDropdown` widget, and it'll get one when there's a real use case (likely the habit category picker in SCH-003 / UX-002). Building one now for a two-option dropdown is over-engineering. No amendment.

**Note for UX-003:** when a real `CustomDropdown` ships, the AUTH-008 profile screen's gender picker can be migrated to it for visual consistency, but that's a polish pass, not a blocker.

### AQ-6 — Legacy `SplashScreen._navigateNext` patched in place — **ACCEPT engineer's call**

Patching `_navigateNext` to consult `AuthMigrator.isMigrationPending()` + `AppLockService.isSecurityEnabled()` before falling through to the legacy decision tree is the minimum-risk surface change. A wholesale rewrite of `SplashScreen` is out of scope for an AUTH slice — it would touch every routing decision the app makes at boot, including ones owned by SET (settings hydration), SCH (schedule re-evaluation), and ENG (notification re-scheduling). UX is unchanged for non-migration users. The legacy decision tree continues to handle the unregistered / not-yet-signed-up / has-onboarded cases.

**Condition for SET sprint:** SET-001 (Settings hub) is the natural moment to revisit the splash routing logic — if the splash is going to read `SettingsRepository.defaultLanding` (for ENG-007's "Default landing" picker), it should also be the moment we replace `_navigateNext` with a proper `SplashViewModel.decideRoute()` call that consolidates migration + auth + settings checks. Track as a SET follow-up, not blocking.

### AQ-7 — `UserLocalDataSourceImpl` DI registration retained — **ACCEPT with explicit re-ownership**

This is the most important AQ and the one where I want to be clear about the precedent. The engineer is asking the same question I answered in R1 C-1 for the habit datasource: "the spec says delete it, but deleting it crashes the legacy screens, and we're going to rewrite those screens in a later sprint anyway — accept the carry-through or insist on a cleanup story now?"

In R1 I accepted the carry-through with a hard cleanup gate at Release 4. I'm going to be consistent and apply the same pattern here, but I'm also going to formalise what "consistent" means so we don't accumulate carry-throughs indefinitely.

**Decision:** Accept the engineer's pragmatic call. The legacy `UserLocalDataSourceImpl` registration stays in DI for AUTH; the `auth_boot_cleanup.dart` one-shot + `ResetService.resetAll()` sweep is sufficient to ensure the canonical user lives in Hive post-AUTH-008 and the legacy datasource only ever reads defaults from here on. The migrator TODO narrowing to `TODO(post-SET/SCH/ENG)` is correct.

**Re-ownership (not a new escalation, a formalisation):** The cleanup of the four remaining `*LocalDataSourceImpl` registrations (User, Habit, HabitStats, App) is now formally owned by the **SET sprint**, specifically as part of SET-001 / SET-003 (which rewrites the screens consuming `UserLocalDataSourceImpl` — Profile and Settings hub). The migrator's `TODO(post-SET/SCH/ENG)` is decomposed into:
- User datasource removal → SET-003 (Edit Profile sub-screen) ownership.
- Habit + HabitStats datasource removal → SCH/ENG epic ownership (whichever rewrites `HabitScreen` first).
- App datasource removal → SET-001 ownership.

**Acceptance criteria amendment (Release 4 ship gate, carried over from R1):**
> No `*LocalDataSourceImpl` legacy registration may exist in `lib/core/di/injection.dart` at the time Release 4 ("polish") is dispatched to a Play Store public track. SET, SCH, and ENG sprints each own the removal of the registrations whose legacy screens they replace. The migrator's `TODO(post-SET/SCH/ENG)` is the single tracking marker; it must be deleted (not narrowed further) before R4 PR is opened.

**Escalation answer:** I am **not** escalating to a follow-on slice. The R1 precedent applies and the trade-off is bounded by the SET sprint, which is the next thing to ship. If the SET sprint surfaces a reason it cannot delete the User datasource (e.g., a legacy widget I'm not aware of), I'll revisit. Until then, the SET sprint owns the cleanup as part of its normal scope.

---

## 4. Open conditions for Release 3 (SET) start

These do not block SET dispatch — they are work items SET should pick up as part of its scope or fix in-flight. SET can start immediately.

- **AQ-2 follow-up:** Implement `passcode_upgrade_success_screen.dart` as a follow-up commit on the AUTH branch before SET begins editing adjacent routing code. Single screen, single route, single line change in `PasscodeUpgradeScreen.onComplete`. Same-day patch.
- **AQ-1 wiring:** SET-004 must wire the `Duration Function()` provider on `AppLockService` to read from `SettingsViewModel.autoLockSeconds$` once the picker exists. Document this in the SET-004 acceptance criteria.
- **AQ-4 cleanup:** Delete the legacy `/signin/*` route registrations and the corresponding screen widget files during SET (as part of SET-004 or a SET-cleanup ticket). The redirect-to-`/lock` shim is interim, not permanent.
- **AQ-6 splash consolidation:** SET-001 should fold the migration + auth + settings checks into a proper `SplashViewModel.decideRoute()` call, replacing the patched `_navigateNext`. Tracking, not blocking.
- **AQ-7 DI cleanup:** SET-003 owns the removal of the `UserLocalDataSourceImpl` registration as part of the Edit Profile rewrite. SET-001 owns the `AppLocalDataSourceImpl` removal as part of the Settings hub. Both must be done before Release 4 PR per the R1 precedent.
- **Informational TODO from QA V5:** Add a code comment near the `app_router.dart` redirect (line ~48) noting that the gate is `lockedNotifier`-driven only and any new app entry-point (e.g., notification deep-links from ENG-006) must call `lockNow()` if `isSecurityEnabled()` is true. This is the only QA-flagged informational item; it's a five-line comment, not a refactor.
- **Cross-product visual check for G-001 default accent on AUTH surfaces:** The lock screen, signup welcome screen, and passcode upgrade screen all consume accent for primary CTAs — do a one-pass visual sanity check on a real device that `#00A36C` reads as a primary action color on these surfaces (not as a "success" affordance). If it reads as success, that's a flag for SET-005 (Appearance) to consider tweaking the swatch contrast, not a blocker for AUTH.
- **G-002 migration-log spot check:** During the real-device upgrade smoke test (carried over from R1 §4 item 4), confirm the migration log surfaces `coercedEmptyRepeatDays` count correctly when AUTH-001 migration runs alongside FND-002 migration. They share boot-time ordering.

---

## 5. Release-2 ship criteria I'm declaring met

Things I'd be willing to attach my name to for a Play Store internal-testing track build that includes both R1 Foundation and R2 AUTH (NOT public release — public release waits for SET / SCH / ENG / AI / DAT minimum + G-007 legal copy):

- **PIN credentials are properly hashed.** Plain-text 5-digit PIN is migrated to PBKDF2-SHA256 / 100k / 16-salt / 32-hash under FSS, with a verified-correct constant-time compare. No PIN/hash/salt anywhere in logs.
- **The G-003 contract is honoured.** Legacy users go through `PasscodeUpgradeScreen` (not generic setup), with explicit upgrade copy, and never get a biometric prompt during the migration moment. Zero grep matches for biometric chain on the upgrade path. (AQ-2 success-screen amendment will land as a follow-up.)
- **Lockout policy is real, not advisory.** 5 attempts → 30s, 10 attempts → 5min, persisted to FSS as ISO-8601, survives process death (proven against a fresh service instance + same FSS map).
- **App lock is enforced at the router level.** GoRouter `refreshListenable` on `lockedNotifier` + `redirect:` rule force `/lock` when locked and bounce back to `/app/habits` when unlocked. The R1 C-3 deferral is closed.
- **Forgot-PIN is honest and complete.** Explicit "permanently erases" copy, `ResetService.resetAll()` clears Hive + FSS + SP + lockout state, no recovery seed. Available during lockout (correct).
- **Multi-step signup works end-to-end.** Welcome → Passcode → Biometric → Profile, each its own route, back-nav intact, profile persists username ≤16 chars + gender, final step routes to `/app/habits`.
- **Change PIN is consistent with lockout.** Wrong current PIN counts toward the same lockout counter; no separate counter. On success, hash replaced + counter + lockoutUntil reset together.
- **Behavioral parity preserved.** Legacy `HabitScreen` is functionally unchanged (QA V7). Un-upgraded legacy users still work via retained `_deAuthOnBackground` + legacy datasource registrations.
- **Quality gates green.** 0 analyze errors, 0 new warnings (3 pre-existing), 70/70 tests passing including the fresh-instance lockout persistence test.

I am NOT yet declaring met:
- **The AQ-2 success screen.** Engineer's snackbar approach is interim until the success-screen amendment lands. Should be a same-day follow-up commit; until then, the migration UX is acceptable-but-not-ideal.
- **Single-source-of-truth storage.** Legacy `*LocalDataSourceImpl` registrations (User, Habit, HabitStats, App) still exist in DI. Carry-through accepted under the R1 precedent; cleanup owned by SET / SCH / ENG; hard gate at R4 dispatch.
- **Public Play Store readiness.** Per the R1 standard, public release requires SET + SCH + ENG + AI + DAT minimum plus G-007 legal copy. AUTH unblocks internal testing only.

These are acknowledged deferrals, not silent gaps.

---

## 6. Release 3 (SET) dispatch authorization

**SET can start immediately.** None of the conditions in §4 are sequential gates on starting the SET hub + sub-screens. The AQ-2 success-screen patch is independent of SET work and can land as a follow-up commit on the AUTH branch in parallel. The DI cleanup is part of SET's own scope, not a precondition for it.

The architect should kick off SET-001 (hub) + SET-002 (ViewModel + Repository) + SET-003 (Edit Profile) + SET-004 (Security) as the Release-3 critical path. SET-005 (Appearance), SET-007 (Notifications), SET-008 (AI Coach) can be parallel work or follow-up depending on team capacity. SET-006 (Language) is P1 and can defer.
