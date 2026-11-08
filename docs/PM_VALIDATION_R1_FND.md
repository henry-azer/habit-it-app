# PM Validation — Release 1 Foundation (Epic FND)

**Reviewer:** Product Owner (Habit It)
**Date:** 2026-06-05
**Slice:** TS-FND-001 .. TS-FND-006
**Inputs reviewed:** `docs/BUSINESS_STORIES.md` §3, `docs/QA_REPORT_R1_FND.md` (original + Re-QA appendix), `docs/PO_DECISIONS.md`, worktree `PROGRESS.md`.
**QA verdict on the slice:** PASS (post C-1/C-2 fix). Quality gates: 0 errors / 3 pre-existing warnings / 131 pre-existing infos / 18 tests passing.

---

## 1. Verdict

**SIGN-OFF-WITH-CONDITIONS.**

The architectural rails are landed and behaviorally safe. The slice satisfies the *business intent* of Epic FND: every subsequent epic now has a unified spine to build on, and the migration is non-destructive for existing users. The conditions I'm attaching are not regressions or product holes — they are process hygiene (git commit) and one real-device proof point that a PM cannot delegate to QA. Release 2 (AUTH) can dispatch in parallel to those conditions; only the production-channel release of an APK that includes this code is gated.

---

## 2. Business-intent check per FND story

### FND-001 — Bootstrap layered architecture
**Intent satisfied.** The new `core/` `data/` `features/` `widgets/` tree exists, Hive is initialised before `runApp`, DI bootstraps through `getIt.allReady()`, and the StatefulShellRoute with three bottom-nav branches replaces the snake nav. The legacy screens still work end-to-end on upgrade because the C-1 fix retained legacy SP keys — which means AC#5 ("existing screens still work") is now genuinely met, not just claimed. The product can keep shipping while the rest of the rewrite catches up.

### FND-002 — Hive-backed repositories + SP migrator
**Intent satisfied, with one product-level call I'm formalising below.** All eight repositories exist behind `I*Repository` interfaces. The migrator runs once, persists `migratedV1=true` before clearing anything (idempotency-safe even on partial failure), and PO decision G-002 is honoured: empty `repeatDays` are coerced to `HabitSchedule.none()` and counted in the migration report. The test fixture exercises this. The duplicated-storage trade-off (SP retained alongside Hive) is acceptable to me for this slice — see §3 C-1.

### FND-003 — Freezed + json_serializable conversion
**Intent satisfied.** 13 entities are Freezed, enums use `@JsonEnum(valueField: 'wireName')`, and the critical migration-safety invariant — `HabitState.IN_PROGRESS` appended at the end, ordinal stability preserved, legacy `.index`-encoded payloads still load via `fromLegacyIndex` — is implemented and unit-tested. This is the line where NFR-7 either holds or doesn't, and QA verified it holds.

### FND-004 — Theme tokens
**Intent satisfied with the PO override honoured.** Token system exists (`AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`, `ThemeFactory`) and **G-001 is verified**: default accent is `#00A36C` (green), confirmed by `lib/core/theme/app_colors.dart:14` and a unit test in `theme_factory_test.dart`. The hand-review checklist (no analyzer plugin) is acceptable per spec for v1. SET-005 will need a visual contrast review when accent goes live on streak chips and heatmap tiles, but that's an SET-epic concern, not this slice.

### FND-005 — GoRouter replacement
**Intent satisfied for the Foundation surface, with one acknowledged gap.** `AppRoutes` is a class of `path`/`name` constants, the three shell branches are wired, typed `extra` replaces `arguments` casts, the error route renders the original "No Route Found" copy, and a back-compat alias class preserves every legacy path string. **Gap:** `app_route_guards.dart` is a placeholder; `GoRouter` has no `redirect:` parameter. Deep-link to `/app/habits` would currently bypass any auth gate. Engineer's call: deferred to AUTH-005. See §3 C-3 for my position.

### FND-006 — ViewModel migration
**Intent partially satisfied — contracts in place, behavior deferred.** All 14 ViewModels exist with `BehaviorSubject` streams + `dispose()` + repository-only dependencies. Splash and Onboarding are reference end-to-end implementations and unit-tested. The other 12 are skeleton classes marked `TODO(FND-006-followup)`. The live legacy screens are NOT rewired to consume the new VMs — they continue to read SP via the un-rewired `*LocalDataSourceImpl` registrations. This is exactly what the engineer flagged as Q1. See §3 TS-FND-006 for my position.

---

## 3. Open decisions I'm now making

### Decision: TS-FND-006 partial port (Q1) — **ACCEPT**
The skeleton-VM approach is contract-correct, the reference implementations prove the pattern works end-to-end with tests, and AUTH/SET/ENG are about to wholesale-rewrite every one of those parent screens anyway. Filling in behavior now would be throwing engineering hours at code with a ~6-week shelf life. I'm not requiring further work on the 12 skeletons in this slice. **Condition (for the AUTH/SET/ENG sprints, not this one):** the team must replace each skeleton with a real VM as part of the epic that rewrites its parent screen — no skeleton may survive past the epic that owns its surface. This is a tracking commitment, not a Release-1 blocker.

### Decision: C-3 GoRouter redirects deferred to AUTH-005 — **ACCEPT**
The argument that "auth bypass is theoretical because there is no AUTH yet" holds for *this APK*. Every legacy screen still works because legacy SplashScreen + `AppShell._checkAuthOnStart()` make the routing decisions in the interim. **However:** the moment AUTH-005 lands, the redirect rules from BUSINESS_STORIES §4 / TECHNICAL_STORIES are non-negotiable — `/app/habits` from a deep link MUST hit the redirect chain (unregistered → signup, locked → /lock). I'm flagging this as the hard product gate for AUTH-005 acceptance, not as a Release-1 blocker. Until AUTH ships, there is no functional auth to bypass.

### Decision: C-1 Option 1 (keep legacy SP keys alive, Hive as new-truth + SP as legacy-read-through) — **ACCEPT**
This is the right call for a one-release window. Option 2 (rewire `*LocalDataSourceImpl` to delegate to Hive) is structurally cleaner but it's a refactor that touches the storage substrate of every legacy screen, which is exactly the surface AUTH/SET/ENG are about to delete. Spending the engineering cost to make legacy datasources Hive-backed three sprints before deleting them is wasted work. The duplicated-storage trade-off is **bounded**: it lasts exactly as long as the legacy `*LocalDataSourceImpl` registrations live in DI, and the `TODO(post-AUTH/SET)` marker in the migrator docstring is the cleanup contract. **Condition:** the cleanup TODO must be honoured before Release 4 ("polish") ships — I'm not willing to carry duplicated storage into a public Play Store release. If by Release 4 the legacy datasources are still alive, I'm escalating it to the architect.

### Decision: Commit hygiene — uncommitted slice — **REQUIRE CHANGE BEFORE NEXT DISPATCH**
This one I'm pulling up from "process nit" to a sign-off condition. The entire R1 Foundation slice is `Untracked` in the worktree. Without an R0 baseline commit, `git diff master..HEAD` is empty, future review of the C-1 fix (or any subsequent fix) has nothing to diff against, and `git blame` will eventually attribute the whole foundation to a single squash commit. That's a regression in our ability to audit changes — and we'll need that audit trail when AUTH lands and starts modifying these files. **Required action:** commit the slice to the worktree branch *before* dispatching any subsequent agent (whether that's a fix, AUTH-001, or anything else). The commit message should explicitly enumerate which TS-FND stories are included and reference the QA Re-QA PASS verdict. The C-1 fix can be a follow-up commit on top — I don't need it amended into the foundation commit. This is non-negotiable as a precondition for AUTH dispatch.

---

## 4. What to do before Release 2 (AUTH epic) starts

1. **Commit the R1 Foundation slice to version control.** Single commit (or logical multi-commit) covering TS-FND-001..006; C-1 fix as a follow-up commit referencing the QA report.
2. **Real-device upgrade-path smoke test.** Install the current production APK on a Pixel-class Android device (Pixel 6a per NFR-4 reference hardware). Create 2 habits across 2 months, mark some DONE / NOT_DONE / SUSPENDED, set username + biometric. Upgrade APK to this build. Confirm: Splash routes to Habits tab (NOT onboarding), all habits visible with correct state, username intact, biometric flag intact. This is the definitive proof that C-1 is fixed in the wild, not just in unit tests.
3. **G-001 fresh-install visual check.** Clean install on the same device, complete onboarding/signup, confirm accent renders as green (`#00A36C`) on whatever surfaces currently consume it (today: theme-derived elements only; full surface coverage lands with ENG-002 streak chip + ENG-004 heatmap).
4. **G-002 field-data check.** After the upgrade smoke test, inspect the migration log output for `coercedEmptyRepeatDays`. If non-zero on a real device, that's a real-world G-002 hit — note it in the team's launch-week journal so we can monitor whether it shows up in user-reported issues.
5. **Confirm cleanup TODO ownership.** Before AUTH-001 dispatch, the architect should assign the `TODO(post-AUTH/SET): drop legacy SP keys when legacy *LocalDataSource* impls are removed` cleanup to a specific story in the AUTH or SET backlog. I don't want it floating as an unowned tech-debt marker.
6. **Re-run quality gates on a clean (committed) checkout.** Once item 1 is done, run `flutter analyze` + `flutter test` from a fresh clone (not the worktree). Confirm: 0 errors, no *new* warnings beyond the 3 pre-existing, 18/18 tests passing. This catches any worktree-only state that QA's verification might have missed.

---

## 5. Release-1 ship criteria I'm declaring met

These are the things I'd be willing to attach my name to for a Play Store internal-testing track build (NOT public release — public release waits for AUTH/SET/SCH/ENG/AI/DAT minimum):

- The app launches, navigates, and exits cleanly on both fresh-install and upgrade paths.
- Existing users do NOT lose data on upgrade. Their habits, completion history, username, and PIN flag survive the SP→Hive migration. (Proven by C-1 fix + retention unit test; pending real-device confirmation per §4 item 2.)
- The new architecture (DI, GoRouter, Hive, Freezed, theme tokens, ViewModel contracts) is in place and consumed by the bootstrap path. Every subsequent epic has a unified spine to build on.
- The G-001 default accent (`#00A36C` green) and G-002 empty-`repeatDays` coercion are honoured.
- Behavior-equivalence for the legacy screens (splash → onboarding → signup → signin → habit list → add habit → manage habits → stats → profile). The user-facing app is functionally indistinguishable from the previous release except for cosmetic theming differences from the new ThemeFactory.
- Quality gates green: 0 analyze errors, 18/18 tests passing, build_runner clean.
- Migration is one-shot and idempotent. The `migratedV1` flag flips once and the migrator becomes a no-op thereafter.

I am NOT yet declaring met:
- Deep-link auth gating (deferred to AUTH-005 — re-validate there).
- Full ViewModel adoption by live screens (12 of 14 still legacy — re-validate per epic).
- Single-source-of-truth storage (SP + Hive coexist — re-validate at the cleanup TODO).

These are acknowledged deferrals, not silent gaps.
