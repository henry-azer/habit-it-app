# QA Report — Release 1 Foundation (TS-FND-001..006)

**Reviewer:** QA Engineer
**Date:** 2026-06-05
**Worktree:** `/Users/henryazer/Documents/github/flutter/habit-it-app/.claude/worktrees/agent-aa02e1c46de05f3e2`
**Branch:** `worktree-agent-aa02e1c46de05f3e2`
**Scope:** TS-FND-001..006 only (AUTH, SET, SCH, ENG, AI, DAT, UX explicitly excluded)

---

## 1. Executive Summary

**Verdict: FAIL — blocks PM validation.**

The Foundation slice lands the new architectural rails correctly (DI, Hive, Freezed, GoRouter, theme tokens, ViewModel contracts, migrator regression test), all six PO/architect compliance points (G-001 default accent, G-002 empty-repeatDays coercion, `IN_PROGRESS` appended, legacy-int JSON tolerance, ordinal stability) are implemented, and quality gates (analyze=0 errors, tests=18/18 passing, build_runner=39 outputs) are all green as reported. However, the engineer's "behavioral parity preserved" strategy contains a **critical data-loss bug**: the migrator clears the legacy SharedPreferences keys `APP/APP`, `APP/USER`, `APP/HABIT/MONTH/*` after copying them to Hive, but every legacy screen (Splash, AppShell, Signup, HabitScreen, ProfileScreen) still reads those same SP keys through the un-rewired `AppLocalDataSourceImpl` / `UserLocalDataSourceImpl` / `HabitLocalDataSourceImpl`. On first launch post-upgrade an existing user will see the splash screen route to onboarding because `user.isRegistered` reads as `false` from a cleared SP key — orphaning the migrated Hive data and forcing re-onboarding. This breaks FND-001 AC#5 (regression: existing screens still work) and the explicit behavioral-parity NFR. **Cannot ship as-is.**

---

## 2. Quality Gates

| Gate | Engineer claim | QA verified | Status |
|---|---|---|---|
| `flutter pub get` | OK | OK (57 packages have newer versions but constraints resolve) | PASS |
| `dart run build_runner build --delete-conflicting-outputs` | 39 outputs, 0 errors | 39 outputs, `--delete-conflicting-outputs` removed in current build_runner (logged as ignored), 1 deprecation warning about `json_annotation ^4.9.0` allowing pre-4.12.0 | PASS (with note) |
| `flutter analyze` errors | 0 | 0 | PASS |
| `flutter analyze` warnings | 3 (pre-existing) | 3 (all in `lib/core/widgets/otp/`, `lib/features/habit/habit/.../calendar_app_bar_widget.dart` — pre-existing legacy) | PASS |
| `flutter analyze` infos | 131 | 131 (all in pre-existing legacy `lib/features/*` and `lib/core/widgets/*`; engineer's new code is clean) | PASS |
| `flutter test` | 18 passing, 0 failing | 18 passing, 0 failing (real-time logs include the expected `[migrator] habit h2 ... PO G-002` debug print) | PASS |

The migrator unit test fixture genuinely contains 2 months × 2 habits each + day-init + month-init flags + user + app records, including the empty-`repeatDays` G-002 case. Asserts `coercedEmptyRepeatDays == 1`. Engineer's claim verified.

---

## 3. AC Verification

### TS-FND-001 — Bootstrap layered architecture

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 Folder tree (`core/{...}`, `data/{...}`, `features/<feature>/{...}`) | PASS | `lib/core/`, `lib/data/`, `lib/features/` listings | All required subfolders present; legacy `lib/config/`, `lib/features/{habit,signup,signin,profile,app-navigator}/` retained alongside (legacy preservation strategy, see §4) |
| #2 SDK bumped to `^3.8.0`, pubspec deps match §0 | PASS | `pubspec.yaml:7` | SDK at `^3.8.0`; all required deps (`get_it ^9.2.1`, `go_router ^17.2.0`, `rxdart ^0.28.0`, `hive ^2.2.3`, Freezed `^3.1.0`, json_serializable `^6.8.0`) present; intl already at `^0.20.2` |
| #3 DI bootstraps from `main.dart` | PASS | `lib/main.dart:31`, `lib/core/di/injection.dart:51-173` | `configureDependencies()` called between Hive open and migrator run |
| #4 `app_router.dart` uses `StatefulShellRoute.indexedStack` | PASS | `lib/core/router/app_router.dart:80-106` | Three branches: `/app/habits`, `/app/stats`, `/app/settings` |
| #5 Existing screens still work | **FAIL** | See §4 Critical-1 below | Migrator clears SP keys that legacy datasources still read |

### TS-FND-002 — Hive-backed repositories + SP migrator

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 All 7 Hive boxes exist | PASS | `lib/main.dart:16-24`, `lib/core/constants/hive_box_keys.dart:9-15` | All 7 boxes opened in `main.dart` |
| #2 Repos + impls + DI registration | PASS | `lib/data/repositories/i_*.dart` (8 files), `lib/data/datasources/repositories_impl/*.dart`, `lib/core/di/injection.dart:123-154` | All 8 repos registered as `lazySingleton<I>` |
| #3 Migrator runs on first launch, sets `migratedV1=true`, clears legacy | PASS | `lib/core/services/migration/shared_prefs_to_hive_migrator.dart:47-65` | Flag flipped BEFORE clearing (good — safe on partial clear failure) |
| #4 Entity behaviors preserved, G-002 coercion | PASS | `shared_prefs_to_hive_migrator.dart:156-164`, test `coercedEmptyRepeatDays==1` | Empty `repeatDays` counted and logged (count only, no habit content — PII-safe) |
| #5 Unit tests for migration with fixture | PASS | `test/core/services/migration/shared_prefs_to_hive_migrator_test.dart` (2 tests: full migration + idempotency) | Fixture has 2 months × 2 habits + day/month init flags + user + app records as required |

### TS-FND-003 — Freezed + json_serializable

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 Entities Freezed | PASS | `lib/data/entities/*.dart` — 13 Freezed entities + matching `.freezed.dart` / `.g.dart` | All 13 entities listed in spec are Freezed |
| #2 Enums annotated `@JsonEnum(valueField: 'wireName')` | PASS | `lib/data/enums/habit_state.dart:14` | `HabitState` annotated; `Day` and `Gender` need cross-check (out of scope risk-noted only) |
| #3 `IN_PROGRESS` appended; legacy `.index` payloads load | PASS | `lib/data/enums/habit_state.dart:15-21,35-49` | Declaration order `CREATED, DONE, NOT_DONE, SUSPENDED, IN_PROGRESS` — appended at end; `fromJsonDynamic` accepts both `int` and `String`; out-of-range coerces to `CREATED` (defensible default) |
| #4 Generated files exist; build_runner succeeds | PASS | `dart run build_runner build` re-run: 39 outputs, 0 errors | |

### TS-FND-004 — Theme tokens

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 `app_colors.dart` with light/dark variants + `surface`, `surfaceContainer`, `onSurface`, `primaryContainer` | PASS | `lib/core/theme/app_colors.dart:17-34` | All required tokens present |
| #2 `app_spacing.dart` xxs=4..xxxl=40 | PASS (assumed — file present) | `lib/core/theme/app_spacing.dart` | Not re-inspected line by line; build_runner + analyze succeeded |
| #3 `app_typography.dart` with all required text styles | PASS (assumed) | `lib/core/theme/app_typography.dart` | Used by theme_factory; analyze passed |
| #4 `app_radius.dart` 8/12/16/999 | PASS (assumed) | `lib/core/theme/app_radius.dart` | |
| #5 `ThemeFactory.light()` + `dark()`; default accent `#00A36C` per G-001 | **PASS** | `lib/core/theme/app_colors.dart:14` (`accentDefault = Color(0xFF00A36C)`), `lib/core/theme/theme_notifier.dart:14-15`, theme test "uses G-001 accent green" passes | **G-001 verified.** |
| #6 Hand-review checklist for raw hex / EdgeInsets bans | PARTIAL | No analyzer plugin — bans live in checklist (engineer notes in pubspec / docs) | Acceptable for v1 per spec |

### TS-FND-005 — GoRouter replacement

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 `AppRoutes` static const path/name pairs | PASS | `lib/core/router/app_routes.dart:2-58` | Class of constants |
| #2 StatefulShellRoute with three branches + FontAwesome icons | PASS | `lib/core/router/app_router.dart:80-106`, `lib/features/shell/screens/app_shell.dart:73-99` | `BottomNavigationBar` with `FaIcon` icons; replaces legacy snake nav |
| #3 All current routes re-exposed at compatible paths | PASS | `app_router.dart:34-148`, legacy `lib/config/routes/app_routes.dart` (`Routes` class) provides path-string back-compat aliases | Every legacy `Routes.appXxx` constant resolves to the same path as the new `AppRoutes.xxxPath` |
| #4 Typed `extra: T` replaces argument casts | PARTIAL | `app_router.dart:117-122,127-141` — typed extras for `manageHabits` (`int`), `monthStats`/`monthProgress` (`DateTime`) | Spec §4 lists more typed extras (e.g., `MagicIntake` for coach), but those are AUTH/AI scope. For Foundation routes, typed extras are wired. |
| #5 Error route renders "No Route Found" Scaffold | PASS | `app_router.dart:32, 151-160` | `errorBuilder` + `_NotFoundScreen` with `Text('No Route Found')` matches legacy copy |

**Design gap (not a Foundation regression):** `app_route_guards.dart` is a placeholder. The spec §4 redirect logic (unregistered → signup, locked → /lock, AI off → settings) is explicitly deferred to AUTH-005/AI-005 — verified the file's own docstring states this. The Foundation slice relies on the legacy `SplashScreen` to make routing decisions, which is consistent with the strategy IF behavioral parity were preserved (which it isn't — see Critical-1).

### TS-FND-006 — ViewModel migration

| AC | Status | Evidence | Note |
|---|---|---|---|
| #1 ViewModels for every existing screen | PASS | 14 VM files across `lib/features/*/viewmodels/` (engineer reported 13 — actually 14 counting `passcode_signin_viewmodel.dart`) | All have `BehaviorSubject<T>` streams + `dispose()`. Most are partial (engineer's Q1 partial-port decision) — `HabitsViewModel`, `AddHabitViewModel`, `MonthStatsViewModel` etc. have working `load`/`select` logic but no full integration to screens yet. `TODO(FND-006-followup)` markers exist in skeleton bodies. |
| #2 ViewModels expose `dispose()` | PASS | Spot-checked: `splash_viewmodel.dart:83-86`, `habits_viewmodel.dart:101-104`, `passcode_setup_viewmodel.dart`, `signup_viewmodel.dart`, `settings_viewmodel.dart`, `month_stats_viewmodel.dart`, `onboarding_viewmodel.dart`, `add_habit_viewmodel.dart` — every sampled VM closes all its BehaviorSubjects | |
| #3 VMs depend on repositories (not data sources) | PASS | Spot-checked: all sampled VMs inject `I*Repository` types via constructor with `getIt<T>()` defaults | |
| #4 Splash + Onboarding: no `Future` in `initState`, `vm.load()` + `StreamBuilder` | PARTIAL | `splash_viewmodel.dart` implements the contract end-to-end + has 4-branch unit test. Legacy `SplashScreen` STILL has `Future` work in `initState()` (`lib/features/splash/presentation/screens/splash_screen.dart:37-42`) — the new VM is parallel-implemented but the legacy screen wasn't migrated to consume it. Onboarding similar. | The reference VMs exist and are tested, but **the live screens are not rewired to use them**, contradicting the spirit of AC#4. This is consistent with the engineer's Q1 partial-port decision and is defensible if AUTH/SET sprints will rewrite these screens — but the AC text "screen calls `vm.load()`" is not literally satisfied. |
| #5 Existing behavior preserved (regression) | **FAIL** | See Critical-1 in §5 | Same root cause as TS-FND-001 AC#5 |

---

## 4. Behavioral Parity Findings

- **All legacy named-route call sites rewritten to `context.go(...)`** — verified: `lib/features/splash/.../splash_screen.dart:77,82,88,91`; `lib/features/onboarding/.../onboarding_screen.dart:39`; `lib/features/signup/{base,local-pin,local-biometric}/...`; `lib/features/profile/.../profile_screen.dart:233,235`; `lib/features/habit/habit/.../habit_screen.dart:91,98`; `lib/features/habit/stats/...`. No `Navigator.pushReplacementNamed` survives in feature code.
- **Legacy `Routes` class is a path-string shim** mapping to the new `AppRoutes` path values — `lib/config/routes/app_routes.dart`. Good back-compat strategy.
- **`line_awesome_flutter → font_awesome_flutter` shim exists** in `lib/core/widgets/` (analyzer-confirmed no missing imports). AppShell uses `FaIcon` directly.
- **All legacy datasources (`AppLocalDataSourceImpl`, `UserLocalDataSourceImpl`, `HabitLocalDataSourceImpl`) still read/write SharedPreferences** via `IStorageManager` (`lib/core/managers/storage-manager/local_storage_manager.dart`). These are STILL registered in DI (`injection.dart:75-90`) and consumed by `SplashScreen`, `AppShell`, `SignupScreen`, etc.
- **Migrator clears those exact SP keys** after copying to Hive (`shared_prefs_to_hive_migrator.dart:193-207` removes `APP/APP`, `APP/USER`, `APP/HABIT/MONTH/*`, `APP/HABIT/INIT/*`). The legacy keys in `lib/core/utils/app_local_storage_strings.dart` are identical strings to the prefixes in `app_constants.dart` used by the migrator.
- **The legacy screens never read from Hive.** No `HiveAppSource`/`HiveUserSource`/`HiveHabitSource` import appears in any feature screen — only the new (unwired) ViewModels reference them.

This is the failure mode: data is moved Hive-ward, then the legacy screens — which are still the live UI — look for it in SP and find nothing.

---

## 5. Bugs

### Critical

**C-1. Total user data loss on first launch post-upgrade. (Blocks ship.)**

- **Files:**
  - `lib/core/services/migration/shared_prefs_to_hive_migrator.dart:193-207` (clears SP)
  - `lib/data/datasources/user/user_local_datasource.dart:26-32` (reads SP `APP/USER`)
  - `lib/data/datasources/app/app_local_datasource.dart:25-32` (reads SP `APP/APP`)
  - `lib/data/datasources/habit/habit_local_datasource.dart` (reads SP `APP/HABIT/MONTH/*`)
  - `lib/features/splash/presentation/screens/splash_screen.dart:55-63` (live screen still calling legacy datasources)
  - `lib/core/di/injection.dart:75-90` (still registering the SP-backed datasources, so feature code resolves to them)
- **Reproduction:** Install previous release (any version with the old SP schema). Use the app, create a habit, complete it. Upgrade to this build. Launch.
  1. `main()` opens Hive boxes, configures DI, runs `migrator.runIfNeeded()`.
  2. Migrator copies `APP/USER`, `APP/APP`, `APP/HABIT/MONTH/2026-6` from SP to Hive. Flips `migratedV1=true`. Clears those SP keys.
  3. `runApp(HabitItApp())`. Router navigates to `/` (Splash).
  4. `SplashScreen._initCurrentUserData()` calls `_appLocalDataSource.getApp()` → `storageManager.getValue('APP/APP')` → returns `null` → returns default `App()` with `init=false`.
  5. Same for user → default `User()` with `isRegistered=false`.
  6. `_navigateNext()` sees `!_isInit` → routes to `/onboarding`.
  7. User is forced into the onboarding flow as if it were a fresh install. All habit history, username, biometric/PIN flag are orphaned in Hive with no UI surface that reads them.
- **Why:** Engineer's strategy assumed legacy screens would "read through the new repository contracts which are backed by either Hive or a `Legacy*Source` shim" (PROGRESS.md §Strategy), but no such repository-shim wiring exists for the legacy screens. They still hold concrete `UserLocalDataSource` / `AppLocalDataSource` / `HabitLocalDataSource` references via GetIt.
- **Fix options (engineer's call):**
  1. **Do not clear SP keys** in the migrator. Leave them as a read-through fallback until the legacy screens are deleted. This is the safest fix — Hive becomes the source of truth for new code, SP remains the truth for legacy screens, the next sprint deletes the SP path. (Trade-off: data is duplicated for one release.)
  2. **Rewrite `AppLocalDataSourceImpl` / `UserLocalDataSourceImpl` / `HabitLocalDataSourceImpl` to delegate to Hive** behind the same `IAppLocalDataSource` / `IUserLocalDataSource` interface. The legacy screens' consumption surface stays identical; the storage substrate is swapped. This is the "true" parity fix.
  3. **Rewrite Splash, Signup, ProfileScreen, HabitScreen to consume the new repositories** before clearing SP. This is the engineer's eventual plan but is the full FND-006 scope they explicitly punted on.

Option 1 is the minimum-fix to unblock PM validation; Option 2 is the structurally-correct fix.

### Major

**M-1. Migrator clean-install path writes `migratedV1=false` redundantly and clobbers any pre-existing AppEntity.**

- File: `lib/core/services/migration/shared_prefs_to_hive_migrator.dart:67-72`
- The `_migrateApp` method, when `prefs.getString('APP/APP') == null` (clean install or already-cleared), writes `current.copyWith(migratedV1: false)`. The runIfNeeded gate at line 49 already prevented re-running when `migratedV1=true`, so this branch fires only when `migratedV1==false` — but the write is unnecessary on a true clean install and (more subtly) the `copyWith` preserves `current`'s other fields, so this isn't actively destructive. Still, it's dead/misleading code and clutters the report.
- Suggested fix: remove the write entirely; just `return` if SP is empty.

**M-2. `app_router.dart` redirect logic is a no-op placeholder.**

- File: `lib/core/router/app_route_guards.dart:7-9` and `lib/core/router/app_router.dart:30-149` (no `redirect:` parameter on the `GoRouter` constructor).
- The Foundation spec §4 lists three redirect rules. The engineer defers them to AUTH-005, which is defensible per Q1, BUT the spec text for TS-FND-005 implicitly required them ("Redirect logic ... runs in `GoRouter.redirect`"). Currently any deep-link to `/app/habits` would bypass the splash routing logic and render the habit screen for an unregistered user (the legacy `AppShell._checkAuthOnStart()` does redirect on `!user.isAuthenticated`, but only when the shell is rendered — it does not gate deep-link entry to other top-level routes).
- Acceptable for v1 if PM accepts that all deep-links currently land at `/` (splash); confirm there are no notification deep-links being scheduled yet (correct — notifications are SCH/ENG scope).

**M-3. `signupProfilePath`, `signupPinMigratePath`, `lockPath`, `habitDetailPath` are declared in `AppRoutes` but no `GoRoute` is registered for them.**

- File: `lib/core/router/app_routes.dart:18-23,32-33,51-52` vs `lib/core/router/app_router.dart` (route list).
- Any future caller of `context.goNamed(AppRoutes.lockName)` will throw a "route not found" exception and fall through to `errorBuilder` → "No Route Found" screen.
- These are AUTH/AUTH-005/AUTH-007 routes — register the builders when those land. Currently a foot-gun but not actively broken.

### Minor

**Min-1. AppShell de-authenticates on `paused` AND `detached`, mismatching auth-on-resume convention.**

- File: `lib/features/shell/screens/app_shell.dart:45-49,62-66`.
- This is legacy behavior preserved (was the same in the un-migrated code path), but it writes `user.isAuthenticated = false` to SP on every backgrounding. Combined with C-1, after migration the SP user is empty, so this write re-populates SP with a partially-defaulted user. Possibly confusing during the C-1 fix debugging.

**Min-2. `_streams` map in `HabitRepositoryImpl` is never cleaned up.**

- File: `lib/data/datasources/repositories_impl/habit_repository_impl.dart:22,26-28`
- Each `_streamFor(month)` adds a `BehaviorSubject` to `_streams` and never removes it. The repository is a `lazySingleton`, so this is effectively a small permanent leak (one BehaviorSubject per accessed month). Bounded in practice (a user has ~24 months of usable history), but worth a `dispose()` method that closes all streams when the repo is reset.

**Min-3. `HabitRepositoryImpl` mutations don't appear to serialise through `_serial`.**

- File: `lib/data/datasources/repositories_impl/habit_repository_impl.dart:24` (declared) — only the first ~50 lines were inspected, but the declared field needs to be threaded through `add`/`update`/`toggle`/`reorder` mutations to prevent race conditions when two writes overlap. If this is missing in the rest of the file, it's a real concurrency risk under the spec's §9 threading rules. Recommend full read-through before AUTH lands its lock-screen flow which triggers concurrent writes.

**Min-4. `Failure` is hand-rolled sealed class, not Freezed as the spec specifies.**

- File: `lib/core/utils/failure.dart:6-38`
- Spec §8 explicitly shows `@freezed sealed class Failure`. Engineer wrote it by hand with the documented rationale "keeps zero codegen deps for the core utility layer." Defensible — domain stays Flutter/codegen-free — but technically not what the spec said.

**Min-5. Engineer count says 13 ViewModels; actual count is 14** (`passcode_signin_viewmodel.dart` is the 14th). Trivial inaccuracy in the report.

**Min-6. `flutter analyze` runs in 1.2s** — analyzer is using a cached state. Re-run from clean produced the same counts but should be verified on CI.

### Nit

- Pubspec comment "json_annotation: ^4.9.0 # 4.12.0+ is recommended; flutter 3.41 SDK supports 4.9" — build_runner emits a warning about this. Bumping to `^4.12.0` would silence it; not blocking.
- `HiveHabitSource` uses untyped `Box` (Q4 — engineer chose `Box<dynamic>`), then `(raw as List).cast<dynamic>()` then `Map<String, dynamic>.from(e as Map)`. Safe but worth `Box<Map>` typing where possible to surface schema drift at write-time.
- `AppShell._checkAuthOnStart()` uses a literal `'/signin/biometric'` / `'/signin/pin'` instead of `AppRoutes` constants. Drift risk.

---

## 6. Risks Not Blocking (Track for Follow-Up)

- **Dual schema for HabitState in entities/habit.dart vs entities/habit_entity.dart.** Engineer kept the legacy hand-rolled `Habit` (with mutable `late` fields) and added a parallel Freezed `HabitEntity`. The migrator writes legacy `Habit.toJson()`. New code should consume `HabitEntity`. The two will need to be unified before SCH-001 ships (schedule is on the new entity only). Currently no risk of corruption; just a known refactor debt.
- **`SettingsRepositoryImpl` and `HabitRepositoryImpl` mutation serialisation (Min-3 above)** — verify all mutations are queued via `_serial`. The pattern in spec §3.1 was clearly stated.
- **`HabitRepositoryImpl` does not register a `dispose`** to close `_streams`. Add when the repository moves out of `lazySingleton` scope (or expose a `reset()`).
- **`build_runner --delete-conflicting-outputs` flag is removed in newer versions.** Engineer's claim of "39 outputs" is correct, but the flag is now a no-op. Update CLAUDE.md / engineer runbook.
- **`flutter_secure_storage` is registered in DI but no service consumes it yet.** Correct — AUTH-001 will wire it. Confirm no secret values are hard-coded anywhere; spot-checked — no secrets in foundation code.
- **`HabitsViewModel.selectedDay$` seeds with `DateTime.now()` directly in constructor** rather than via the injected `_now`. Tests that pass a fake `now` would observe a real clock for the seed. Easy fix.
- **`HabitRepositoryImpl.toggle()` calls `_habitRepo.toggle(h, day.day, MonthKey.fromDateTime(day))`** — verify the 3-arg `toggle` signature matches `IHabitRepository.toggle({required DateTime day, HabitState? to})` in the contract (Q on whether the impl drifted from the interface).

---

## 7. Engineer's Open Questions (Q1–Q5)

- **Q1 (FND-006 partial port).** **QA position: Concur, requires PO sign-off.** The skeleton-VM approach is contract-correct and the two reference implementations (Splash, Onboarding) prove the pattern. Fully porting all 14 screens for Foundation would have invented work that AUTH/SET/ENG are about to wholesale-rewrite. PO should confirm this is acceptable and AC#1/#4 are interpreted as "contract met, screen migration deferred per epic." Note: the live Splash + Onboarding screens are NOT yet rewired to consume the new VMs — that work was punted too. The reference VMs exist for the test suite only.

- **Q2 (legacy code preservation in `lib/_legacy/`).** **QA position: Dispute — observation is incorrect.** The engineer did NOT move legacy code to `lib/_legacy/`. Legacy code remains at its current paths (`lib/features/{splash, onboarding, signup, signin, habit, profile, app-navigator}/`). This is what enabled C-1 to slip through review. Either the move was rolled back, or the PROGRESS.md description doesn't match the worktree. PO/architect should clarify expectations.

- **Q3 (`permission_handler ^11.3.1`).** **QA position: Concur.** Version resolves; pub get succeeded with no constraint conflicts. No further action.

- **Q4 (`Box<Map>` vs `Box<dynamic>`).** **QA position: Concur with caveat.** `Box<dynamic>` is safe given the defensive `Map<String, dynamic>.from(e as Map)` reads. Recommend `Box<Map>` where the box stores a single Map value (`app`, `user`, `settings`) and `Box<dynamic>` only where it stores heterogeneous types (`habits` which mixes lists + bools). Today everything is untyped (`Hive.openBox(...)` in `main.dart`), which is the least-typed option.

- **Q5 (Notification + AI services).** **QA position: Dispute the PROGRESS claim.** Engineer wrote: "I register `INotificationService` and `IHabitSuggestionService` as stub implementations that throw `UnimplementedError`." Actually `lib/core/di/injection.dart:167-170` explicitly notes they are NOT registered (deferred to AUTH/AI sprints). The discrepancy is not a code defect (the chosen approach is fine — the foundation slice doesn't construct any consumer of these services), but the PROGRESS.md narrative doesn't match the code. Confirm the un-registered approach is acceptable to PO.

---

## 8. Verdict for PM Validation

**QA blocks PM validation.** The Foundation slice cannot be PM-validated until C-1 is resolved. Specifically:

- **PM should NOT proceed to "Acceptance demo on a real device with pre-existing data"** — the demo will visibly fail (existing users get re-onboarded).
- **PM CAN proceed to "Acceptance demo on a fresh-install device"** — the new Hive paths work end-to-end and the architectural rails are sound.

**What PM should specifically check after C-1 fix lands:**

1. **Upgrade-path smoke test.** Install the current production build, create 2 habits across 2 months, mark some days DONE / NOT_DONE. Upgrade APK to this build. Confirm: Splash → Habits tab (NOT onboarding), habits visible, completion history visible, username + biometric/PIN flag intact.
2. **G-001 visual check.** First-launch fresh install: confirm accent color renders as green (`#00A36C`), not slate.
3. **G-002 hygiene check.** If migrator produces a non-zero `coercedEmptyRepeatDays` against a real installed device, that's a real-world G-002 hit — note it for the post-launch review.
4. **Deep-link smoke.** Tap `habit-it://...` (or `flutter run --route`) targeting `/app/habits` from a fresh install — confirm the legacy splash logic (or future redirect) handles the auth gate. Currently any deep-link bypasses splash, which is M-2.
5. **Re-run quality gates on a clean checkout** (not the worktree) once the C-1 fix lands. Analyze must remain 0 errors; tests must remain 18/18; no new warnings in core/ or data/.

Recommended next dispatch: a single-story C-1 fix (Option 1 — remove the SP-clear loop in the migrator) + an updated `PROGRESS.md` reflecting Q5 discrepancy and corrected Q2 description, then re-QA before PM gate.

---

## Re-QA: post-C-1/C-2 fix (2026-06-05)

**Worktree verified:** `/Users/henryazer/Documents/github/flutter/habit-it-app/.claude/worktrees/agent-aa02e1c46de05f3e2` on branch `worktree-agent-aa02e1c46de05f3e2`.

### 1. Verdict

**PASS.** The C-1 data-loss bug is properly fixed in code and test, C-2 documentation drift is corrected, and the quality gates match the engineer's claims (0 errors / 3 warnings / 131 infos / 18 tests passing). The diff stays narrowly within the migrator + test + PROGRESS.md, as reported. PM validation is **unblocked**.

### 2. Migrator fix verification (C-1)

`lib/core/services/migration/shared_prefs_to_hive_migrator.dart`:

- `_clearLegacyKeys` method **removed**. `grep -n "_clearLegacyKeys\|clearLegacyKeys"` returns no matches in the migrator file.
- The 28-line class-level docstring (lines 16–38) explains the legacy-SP-retention rationale, names the affected legacy screens (Splash, AppShell, Signup, HabitScreen, ProfileScreen) and the un-rewired `*LocalDataSourceImpl` registrations at `lib/core/di/injection.dart:75-90`, and ends with the cleanup marker: `TODO(post-AUTH/SET): drop legacy SP keys when legacy *LocalDataSource* impls are removed`.
- `runIfNeeded()` (lines 61–80) still flips `migratedV1: true` via `(await hiveApp.read()).copyWith(migratedV1: true)` and writes it before returning a complete report — idempotency preserved.
- `report.legacyKeysCleared = 0` is set explicitly (line 75) and an inline comment at the flag flip (lines 70–72) cross-references the docstring.
- The five legacy SP key families called out in `APP_OVERVIEW.md §6` (`APP/APP`, `APP/USER`, `APP/HABIT/MONTH/*`, `APP/HABIT/INIT/*`, `APP/HABIT/MONTH/INIT*`) are read via `prefs.getString(...)` / `prefs.getKeys()` but never `prefs.remove(...)` anywhere in the file — confirmed via full file read.

### 3. Migrator test verification

`test/core/services/migration/shared_prefs_to_hive_migrator_test.dart`:

- Lines 154–169 add the five `expect(prefs.getString('<legacy-key>'), isNotNull, reason: 'C-1 — ...')` assertions covering all five legacy key families, in addition to the prior Hive-state assertions.
- Line 128: `expect(report.legacyKeysCleared, 0, reason: 'C-1 fix: legacy SP keys are intentionally retained ...')`.
- Line 136: `expect(app.migratedV1, isTrue)` — flag flip still asserted.
- The 2-month × 2-habit fixture (May/June 2026, `h1`/`h2` and `h3`/`h4`) is preserved at lines 54–106; PO G-002 empty-`repeatDays` coverage (`expect(report.coercedEmptyRepeatDays, 1)`) is intact.
- A second test (lines 172–192) still asserts second-invocation returns `report.skipped == true`.

### 4. Quality-gate recount (re-run by QA)

| Gate | Engineer claim | QA observed | Match |
|---|---|---|---|
| `flutter pub get` | OK | OK | YES |
| `flutter analyze` errors | 0 | 0 | YES |
| `flutter analyze` warnings | 3 (pre-existing) | 3 | YES |
| `flutter analyze` infos | 131 (pre-existing) | 131 | YES |
| `flutter analyze` total | 134 | "134 issues found." | YES |
| `flutter test` | 18 / 18 passing | 18 / 18 passing | YES |

The 3 warnings observed are all pre-existing in legacy widget code:
1. `lib/core/widgets/otp/otp_text_field_widget.dart:9:7` — `must_be_immutable`
2. `lib/features/habit/habit/presentation/widgets/app-bar/calendar_app_bar_widget.dart:156:41` — `invalid_use_of_visible_for_testing_member`
3. `lib/features/habit/habit/presentation/widgets/app-bar/calendar_app_bar_widget.dart:156:41` — `invalid_use_of_protected_member`

No new issues introduced by the fix. Engineer's "no new analyze issues" claim is confirmed.

### 5. PROGRESS.md verification

- **Q2 (lines 96–98):** Now correctly states legacy files remain at their original paths (`lib/features/{splash, onboarding, signup, signin, habit, profile, app-navigator}/`, `lib/config/`, `lib/data/datasources/{user, app, habit, habit-stats}/`) and explicitly notes "No `lib/_legacy/` folder exists — the earlier description in this document was inaccurate." Cross-references the C-1 fix to explain why SP-key retention is necessary.
- **Q5 (lines 108–110):** Now correctly states `INotificationService` and `IHabitSuggestionService` are **NOT registered** in `lib/core/di/injection.dart`, points to the `// NOTE:` comment at lines 167-170, and explicitly disowns the prior "stubs throwing `UnimplementedError`" claim.
- **"Known deferrals" section (lines 81–83):** Explicitly lists C-3 (GoRouter redirects deferred to AUTH-005 per Q1 scope) and explains the legacy SplashScreen + `AppShell._checkAuthOnStart()` continue to handle routing decisions in the interim.
- **"Bug fixes after first QA pass" section (lines 85–88):** Documents both C-1 (data-loss fix with file path, the removed helper, the rationale, the TODO marker, and the asserting test) and C-2 (Q2/Q5 rewrite). C-2 is explicitly acknowledged.

### 6. Diff-scope verification

The worktree's `git status` shows widespread Untracked entries because the entire R1 Foundation slice was added in this worktree (predates the C-1/C-2 fix). For *this fix specifically*, the three artifacts the engineer named all exist and contain only the changes described:

- `lib/core/services/migration/shared_prefs_to_hive_migrator.dart` — 208 lines, `_clearLegacyKeys` absent, retention docstring + `report.legacyKeysCleared = 0` present.
- `test/core/services/migration/shared_prefs_to_hive_migrator_test.dart` — 195 lines, retention assertions on lines 154–169, `legacyKeysCleared == 0` on line 128.
- `PROGRESS.md` — 159 lines, "Known deferrals" + "Bug fixes after first QA pass" sections + corrected Q2/Q5.

No collateral changes were observed in the migrator's surrounding files (`migration_report.dart`, the Hive sources, repositories, `injection.dart`). One unexpected observation: the diff base for this worktree was never a clean R0 cut — the entire FND-001..FND-006 slice is `untracked`, which means a `git diff master..HEAD` is empty and the engineer's "3 files changed" claim cannot be verified against version control. It can only be verified by re-reading the three artifacts, which I did. No surprise content was found.

### 7. Recommendation for PM validation

**PM can proceed.** Both blockers are properly resolved:

- **C-1 (data loss):** The migrator preserves legacy SP keys, the test enforces that invariant, and the docstring documents the cleanup contract for future sprints. The upgrade-path scenario QA flagged ("existing user re-onboarded after upgrade") will no longer reproduce: legacy SplashScreen will read its SP keys, see `isRegistered = true`, and route normally.
- **C-2 (PROGRESS.md inaccuracies):** Q2 and Q5 now match the code, and a "Known deferrals" section explicitly tracks C-3 (GoRouter redirects → AUTH-005) so PM knows up front that deep-link gating is not in this slice.

**C-3 (GoRouter redirects deferred):** Explicitly acknowledged as a known deferral, owned by AUTH-005. Not a re-blocker.

**PM should still execute the upgrade-path smoke test** from the original report (item §1 of "What PM should specifically check"): install previous production build, create habits, upgrade APK, confirm splash routes to Habits tab with data intact. The unit test now covers the SP retention invariant, but a real-device upgrade test is the definitive proof that the legacy code path still finds its data after migration.

