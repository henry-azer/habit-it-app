# QA Report — Release 2 (AUTH)

**Date:** 2026-06-07
**Scope:** AUTH-001..008 only (5 commits on top of FND `8378ca3`: `4ab5746`, `f3f7d2d`, `b8714fb`, `474d81e`, `b68cdd0`)
**Worktree:** `.claude/worktrees/agent-aa02e1c46de05f3e2`

## Executive summary

Release 2 AUTH passes the high-risk verification battery cleanly. Quality gates match the engineer's claimed numbers exactly (0 errors / 3 pre-existing warnings / 134 infos, 70/70 tests passing). The crypto core (`PasscodeServiceImpl`) is a faithful port of the vault-it implementation: PBKDF2-HMAC-SHA256 with 100k iterations, 16-byte CSPRNG salt, 32-byte hash, the exact `1$<salt>$<hash>` storage format, and a correct XOR-accumulate constant-time compare with no early-return timing leak. The PO G-003 PIN-upgrade flow is implemented as a dedicated screen that bypasses the biometric opt-in chain and goes straight to `/app/habits` with a snackbar — verified by both reading the code and grepping the upgrade path for any `BiometricOptInScreen` reference (zero matches). The TS-AUTH-005 lockout policy (5 → 30 s, 10 → 5 min) persists to secure storage and has an explicit "fresh service instance" test that proves it survives process death. The GoRouter redirect closes FND C-3 via `refreshListenable` on `lockedNotifier`, with cold-start gating handled by the splash calling `lockNow()` before navigating. No PIN/hash/salt is logged anywhere in the auth surface. The legacy habit screen retains behavioral parity. **No bugs of any severity were found inside the V1-V7 scope.**

## Quality gates

**V1 — Quality gates: PASS.** Engineer claims match observed.

- `flutter pub get` — clean (57 transitive packages have newer versions blocked by constraints; not a regression).
- `flutter analyze` — **0 errors / 3 warnings / 134 infos** (137 total). Matches the engineer's claim exactly. The 3 warnings are pre-existing legacy code (not introduced by AUTH commits): `OTPTextField.clearText` non-final field in `lib/core/widgets/otp/otp_text_field_widget.dart:9`, and two `invalid_use_of_visible_for_testing_member` / `invalid_use_of_protected_member` for `ScrollPosition.activity` in `lib/features/habit/habit/presentation/widgets/app-bar/calendar_app_bar_widget.dart:156`.
- `flutter test` — **70/70 passing** in ~10 s. Matches engineer's claim.

## High-risk verification

### V2 — Crypto correctness (TS-AUTH-001 AC#2, AC#4): PASS

`lib/core/services/auth/passcode_service_impl.dart` is a clean port of the vault-it implementation.

- **PBKDF2-HMAC-SHA256** with parameters sourced from `SecurityConstants` (single source of truth): `kPbkdf2Iterations = 100000`, `kSaltBytes = 16`, `kHashBytes = 32`. See `lib/core/constants/security_constants.dart:6-9`. Derivator at `passcode_service_impl.dart:112-116` uses `PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))` — the `64` is the SHA-256 block size in bytes, correct for HMAC.
- **Salt is generated with `Random.secure()`** (`passcode_service_impl.dart:40, 49-51`) — CSPRNG, not the weak default `Random()`. Good.
- **Format string** at `passcode_service_impl.dart:54` is `'$_kFormatVersion\$${base64Encode(salt)}\$${base64Encode(hash)}'`, which materializes to exactly `1$<base64-salt>$<base64-hash>`. No trailing whitespace, no missing separator.
- **Constant-time compare** at `passcode_service_impl.dart:119-126`: length-equality guard, then `diff |= a[i] ^ b[i]` over the full array with a final `diff == 0` check. **No early-return on byte mismatch.** This is the correct XOR-accumulate pattern; not vulnerable to a timing oracle.
- Note: the early-return on `a.length != b.length` (line 120) is acceptable since lengths here are fixed (32 bytes from PBKDF2 on both sides) and don't leak passcode content.

### V3 — G-003 PasscodeUpgradeScreen routing (TS-AUTH-001 AC#5, TS-AUTH-008): PASS

- After legacy 5-digit PIN verifies, `lib/features/auth/screens/pin_migrate_prompt_screen.dart:64-68` routes to `AppRoutes.passcodeUpgradePath` — **the dedicated upgrade screen**, not `PasscodeSetupScreen` directly.
- `PasscodeUpgradeScreen` (`lib/features/auth/screens/passcode_upgrade_screen.dart:20`) wraps `PasscodeSetupScreen` internally as a child widget (line 57) with custom copy ("We've upgraded PIN security", line 42) and a custom `onComplete` callback at lines 60-70. On successful new PIN setup it calls `AuthMigrator.finalize()`, shows a `SnackBar('PIN updated.')`, and `context.go(AppRoutes.habitsPath)` — straight to `/app/habits`.
- Grepped `passcode_upgrade_screen.dart` and `pin_migrate_prompt_screen.dart` for `BiometricOptInScreen|biometricOptIn|biometric_opt_in` — **zero matches**. No biometric opt-in chain leaks into the migration path.
- Per-class docstring at `passcode_upgrade_screen.dart:15-19` explicitly captures the PO contract ("does NOT chain into the biometric opt-in afterward"). Good documentation discipline.

### V4 — Lockout persistence (TS-AUTH-005): PASS

- **Constants:** `lib/core/services/auth/app_lock_service.dart:41-44` pulls from `SecurityConstants`: 5 attempts → 30 s, 10 attempts → 5 min. The lockout-end timestamp is written via `_passcode.setLockoutUntil(until)` (lines 127, 132), which under the hood writes to `flutter_secure_storage` (`passcode_service_impl.dart:103-109`) as ISO-8601 — survives process death.
- **5-attempt test** (`test/core/services/auth/app_lock_service_test.dart:75-86`): 5 wrong attempts produce `UnlockLockedOut` with `remaining.inSeconds` between 25 and 30.
- **10-attempt test** (`app_lock_service_test.dart:88-103`): attempts bumped to 9, then 10th wrong attempt produces `UnlockLockedOut` with `remaining.inMinutes` between 4 and 5.
- **App-kill persistence test** (`app_lock_service_test.dart:129-156`): after triggering lockout on the first service pair, the test does `lock.dispose()`, then instantiates `freshPasscode = PasscodeServiceImpl(storage: storage)` and `freshLock = AppLockService(...)` against the **same `FakeSecureStorage` map**. Asserts `freshLock.getActiveLockout()` is not null and `inSeconds > 0`, and `freshPasscode.getFailedAttempts() == 5`. This is exactly the "fresh instance" assertion the spec requires.

### V5 — GoRouter redirect closes C-3 (TS-AUTH-005): PASS

- `lib/core/router/app_router.dart:43-59`: `buildAppRouter` wires `refreshListenable: lock.lockedNotifier` (line 47) and a `redirect:` callback (line 48) that sends any non-`/lock` route to `AppRoutes.lockPath` when the notifier is true (line 51), and bounces back to `/app/habits` when unlocked (line 55).
- **Cold-start gating** is handled at `lib/features/splash/presentation/screens/splash_screen.dart:102-110`: when `AppLockService.isSecurityEnabled()` is true the splash calls `lock.lockNow()` then `context.go(lockPath)`. The router redirect then prevents any subsequent attempt to reach `/app/habits` until `unlockNow()` is called.
- **Resume-after-background gating**: `AppLockService.evaluateResume` (`app_lock_service.dart:87-99`) flips the gate when the elapsed background time crosses the threshold, triggering the same redirect.
- The redirect uses `state.matchedLocation != AppRoutes.lockPath` (line 51) to avoid a redirect loop — correct.

**Minor observation (informational, not a bug):** the router redirect is purely a `lockedNotifier`-driven gate; it does not separately check `isSecurityEnabled()`. This means the splash MUST call `lockNow()` before navigating, or the gate is bypassable by deep-linking to `/app/habits` before splash has run. The splash code does call `lockNow()` so the current behavior is correct, but it's a coupling worth noting: any new entry-point added later must also call `lockNow()` if security is enabled.

### V6 — PIN never logged: PASS

`grep -rn "debugPrint\|print(\|developer.log" lib/core/services/auth/ lib/features/auth/` returns **zero matches** across the entire AUTH-001..008 surface — no `pin`, `passcode`, `hash`, or `salt` is ever exposed through any logging primitive. Best-case outcome.

### V7 — Behavioral parity, legacy habit screen: PASS

`lib/features/habit/habit/presentation/screens/habit_screen.dart` (232 lines) is functionally unchanged: still uses the original `HabitLocalDataSource` via `GetIt.instance` (line 50), same per-month init + previous-month migration dialog (lines 53-73), same reorder / toggle / suspend / load flow, same `CalendarAppBar` + `FloatingSpeedDial` UI. The only AUTH-adjacent change is that `_navigateToAddHabit` / `_navigateToManageHabits` now use GoRouter's `context.push` (lines 91, 98) — required because the router was migrated, but the navigation semantics are equivalent. Compiles cleanly (file appears in the passing analyze + test run). No behavioral parity break.






## Bugs found

**None within the V1-V7 scope.**

The only items worth noting are informational, not bugs:

- **Informational (not a bug):** `app_router.dart:48-59` redirect is purely `lockedNotifier`-driven; it does not independently check `isSecurityEnabled()`. This works correctly today because splash calls `lockNow()` before any navigation, but any new app entry-point added later (e.g., notification taps that deep-link past splash) must also call `lockNow()` if security is enabled, or the gate is bypassable. Worth a TODO comment near the redirect; not blocking.
- **Informational (not a bug):** the 3 `flutter analyze` warnings (OTPTextField non-final field; two ScrollPosition.activity protected-member uses) are pre-existing legacy code unaffected by AUTH commits.

## Verdict

**PASS — PM may proceed with Release 2 AUTH.**

All seven high-risk verifications pass cleanly. No Critical, Major, Minor, or Nit bugs found within the AUTH-001..008 scope. Out-of-scope items (AQ-1..AQ-7 open questions, SET/SCH/ENG/AI/DAT/UX slices) are explicitly not assessed by this review and remain for the PM / architect.
