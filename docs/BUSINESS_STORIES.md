# Habit It — Business Stories & Detailed Requirements

**Document version:** 1.0 · **Date:** 2026-06-02 · **Status:** Ready for engineering

This document specifies every story needed to take Habit It from its current state (see [`APP_OVERVIEW.md`](APP_OVERVIEW.md)) to the target product described by the product owner. It covers:

- A foundational architectural migration to the **Padlock stack** (RxDart + GetIt + GoRouter + Hive + Freezed + clean layers).
- An auth rewrite mirroring **Vault-It** (4-digit PBKDF2 PIN, custom keypad, layered biometric, lockout policy).
- A **Padlock-style Settings** module with all sub-screens (Appearance, Notifications, Security, Language, AI, Data, About, Help, Bug Report, Rate, Privacy, Terms).
- A **flexible scheduling** engine for habits (day-of-week, day-of-month "always on day 1", monthly, one-time, no-schedule) with **optional** reminder times.
- A **Groq AI integration** modelled on Readline (`llama-3.3-70b-versatile` over the OpenAI-compatible endpoint, secure-storage key, settings gate, system+user prompts) — driven by a "How do you feel today?" textbox / Q&A intake.
- All P0/P1 features the product owner identified: local reminders, streaks + heatmap, habit detail, encrypted PIN + recovery, JSON export/import, today agenda + cross-month calendar, quantitative habits, categories/icons/colors, notes per check-in, theming.

Every story has an ID, a user-story line, priority (**P0** = ship next; **P1** = differentiator; **P2** = stretch), rough effort (**S/M/L**), numbered acceptance criteria, technical notes that name files / packages / classes, and explicit dependencies on other stories. The **Traceability Matrix** at the end proves every requirement maps to at least one story.

---

## 0. Reference Apps & Adopted Decisions

| Decision | Source | Why |
|---|---|---|
| State: **RxDart `BehaviorSubject` + ViewModel** | Padlock `padlock_app/lib/features/**/viewmodels/` | Single workspace convention; readline + vault-it also use it |
| DI: **GetIt 9.2.1** lazy singletons in `core/di/injection.dart` | Padlock | Unified naming + drop-in replacement for current 7.2.0 |
| Routing: **GoRouter 17.2.0** with flat routes + StatefulShellRoute | Padlock `core/router/app_router.dart` | Replaces `onGenerateRoute`; settings sub-screens become top-level routes |
| Storage: **Hive 2.2.3 + hive_flutter** per-feature boxes (`settings`, `habits`, `app`, `secure_meta`) | Padlock | Replaces today's `SharedPreferences`-everywhere |
| Secure: **flutter_secure_storage 9.2.2** for PIN hash + Groq API key | Vault-It + Readline | Matches workspace convention |
| Models: **Freezed 3.1.0 + json_serializable 6.x + json_annotation 4.9.0** | Padlock | Replaces hand-rolled `toJson/fromJson` |
| Theme: **`AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`** tokens + `ValueNotifier<String> themeModeNotifier` | Padlock `core/theme/` | Replaces today's hard-coded dark palette |
| Localization: **Custom JSON + `.tr` extension** | Existing habit-it (keep) + readline pattern | Reuse existing keys; add `ar.json` |
| Notifications: **`flutter_local_notifications` ^18.x + `timezone` ^0.10.x** | New for habit-it | PM P0.1 |
| Crypto: **`pointycastle` ^3.9.1 + `crypto` ^3.0.6** | Vault-It | PBKDF2 PIN hashing |
| Biometric: **`local_auth` ^2.3.0** | Vault-It + current | Upgrade from current 2.1.7 |
| AI HTTP: **`http` ^1.3.0** (raw, no SDK) | Readline | OpenAI-compatible POST to Groq |
| Icons: **`font_awesome_flutter` ^11.0.0** | Padlock | Replaces `line_awesome_flutter` 2.0.0 (unmaintained) |
| Fonts: **`google_fonts` ^8.0.2** | Padlock | Allow swapping Roboto for SF Pro / Inter without re-bundling |
| Misc: **`package_info_plus` ^10.0.0**, **`share_plus` ^13.0.0**, **`uuid` ^4.5.1**, **`path_provider` ^2.1.5** | Padlock | Replace `numbers_util.dart` random-id |
| Dart SDK: **^3.8.0** | Padlock | Bumps from current `>=2.18.2 <3.0.0` |

---

## 1. Glossary

| Term | Meaning |
|---|---|
| **Habit** | The existing user-tracked behavior. The PO sometimes calls these "tasks"; we keep the word **habit** in code and UI for consistency. |
| **Schedule** | A rule that decides which calendar days a habit applies to. Schedule kinds: `daily`, `weekly(repeatDays)`, `monthly(daysOfMonth)`, `oneTime(date)`, `none`. |
| **Reminder** | Optional local notification at a `TimeOfDay` on a habit's scheduled days. |
| **Day state** | Existing `HabitState`: `CREATED / DONE / NOT_DONE / SUSPENDED`. Extended in this work: `IN_PROGRESS` (quantitative). |
| **Magic / Coach** | The Groq-backed habit-suggestion feature (mirrors Readline's "Magic Content"). |
| **Vault** | Vault-It's term for the encrypted store. In habit-it, the PIN protects access but does not encrypt data at rest (out of scope for v1). |

---

## 2. Non-Functional Requirements

| NFR | Requirement |
|---|---|
| **NFR-1 — Offline-first** | All P0/P1 features MUST work without network. Only the AI feature (Groq) requires network and MUST degrade gracefully. |
| **NFR-2 — Single-user** | The app remains single-user. No accounts, no multi-tenant data, no server-side identity in any v1/v2 story. |
| **NFR-3 — Privacy** | Anything sent to Groq MUST be limited to text the user explicitly typed in the Magic intake. No habit history, no PIN, no PII automatically attached. |
| **NFR-4 — Performance** | Cold start to home ≤ 1.5 s on a Pixel 6a. Habit list re-renders ≤ 60 fps for ≤ 100 habits. |
| **NFR-5 — Accessibility** | All tap targets ≥ 44×44. Semantic labels on icon-only buttons. Respect system text scaling (no fixed `fontSize` without `MediaQuery.textScaler`). |
| **NFR-6 — i18n** | All user-visible strings via `'key'.tr` (no hard-coded literals in screens). `en.json` + `ar.json` shipped at v1; RTL layout supported via `Directionality`. |
| **NFR-7 — Migration safety** | Existing users on SharedPreferences-only storage MUST be migrated to Hive without data loss. Old `HabitState.index` order MUST be preserved during enum extension. |
| **NFR-8 — Telemetry-free** | No analytics SDK in v1. No crash reporting until a privacy policy lists it. |
| **NFR-9 — Bundle size** | APK release ≤ 30 MB after the Hive + GoRouter + Freezed migration. |

---

## 3. Epic FND — Foundation & Architectural Migration

Adopt the Padlock stack so every subsequent epic can be built on a consistent base. This epic produces no user-visible feature on its own; it is a refactor + library swap with strict regression coverage.

### FND-001 — Bootstrap the Padlock-style layered architecture
**As a developer**, I want the app organized into `core/`, `data/`, `features/`, `widgets/` with a Hive-backed repository layer, so that every new feature follows one convention.

- **Priority:** P0 · **Effort:** L · **Depends on:** —

**Acceptance criteria**
1. New top-level folders exist: `lib/core/{config,constants,di,extensions,localization,managers,router,services,theme,utils}`, `lib/data/{datasources,entities,enums,models,repositories}`, `lib/features/<feature>/{screens,viewmodels,widgets,models}`, `lib/widgets/` for cross-feature shared UI.
2. Dart SDK bumped to `^3.8.0`. `pubspec.yaml` updated per §0 (RxDart, GetIt 9.2.1, GoRouter 17.2.0, Hive 2.2.3, hive_flutter, Freezed 3.1.0, json_annotation 4.9.0, build_runner, json_serializable, google_fonts 8.0.2, flutter_animate 4.5.2, font_awesome_flutter 11.0.0, http 1.3.0, crypto 3.0.6, pointycastle 3.9.1, flutter_secure_storage 9.2.2, local_auth 2.3.0, path_provider 2.1.5, package_info_plus 10.0.0, share_plus 13.0.0, uuid 4.5.1, flutter_local_notifications, timezone, permission_handler, fluttertoast). Removed: `flutter_snake_navigationbar`, `line_awesome_flutter`, `provider`.
3. `core/di/injection.dart` registers every service as `getIt.registerLazySingleton<I>(() => Impl(...))`. Bootstraps from `main.dart` via `await GetIt.instance.allReady()`.
4. `core/router/app_router.dart` exports a single `GoRouter` with a `StatefulShellRoute.indexedStack` for the three bottom-nav tabs (Habits, Stats, Profile) and flat routes for every other screen.
5. Existing screens still work after migration: splash, onboarding, signup, signin, habit list, add habit, manage habits, stats, profile. (Behavioral regression test required.)

**Technical notes**
- Mirror `padlock_app/lib/core/di/injection.dart` registration order.
- Use `package:hive_flutter/hive_flutter.dart` and `Hive.initFlutter()` in `main.dart` before `runApp`.
- All Freezed unions use `@freezed` + `with _$Foo`; run `dart run build_runner build --delete-conflicting-outputs` in CI.

---

### FND-002 — Replace `SharedPreferences` with Hive-backed repositories
**As a developer**, I want all persistent data behind a `XxxRepository` interface backed by a `HiveXxxSource`, so storage is swappable and testable.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-001

**Acceptance criteria**
1. Hive boxes: `app` (App entity), `user` (User), `habits` (Map<MonthKey, List<HabitDto>>), `settings` (SettingsModel), `notifications_meta` (per-habit notification ids), `magic_meta` (Groq feature flags + rate-limit log).
2. Repositories: `AppRepository`, `UserRepository`, `HabitRepository`, `HabitStatsRepository`, `SettingsRepository`, `NotificationRepository`, `MagicRepository`. Each is abstract with a `*Impl` and registered in DI.
3. A one-shot **migration service** (`SharedPrefsToHiveMigrator`) runs on first launch after upgrade: detects legacy keys `APP/APP`, `APP/USER`, `APP/HABIT/MONTH/<…>`, `APP/HABIT/MONTH/INIT<…>`, `APP/HABIT/INIT/<…>`; reads each, writes to Hive, then clears the legacy keys. Migration status persisted in Hive as `migrated_v1: true` so it never runs twice.
4. All existing entity behaviors preserved: `Habit.daysStates`, `HabitState.index` ordinal mapping, repeat-day strings.
5. Unit tests cover migration with fixture SharedPreferences data captured from a real install.

**Technical notes**
- Hive does not need adapters when storing primitives + `Map<String, dynamic>` (Freezed `toJson()` output).
- Use `Hive.openBox<Map>(boxName)` and serialize Freezed models via their `toJson()`.

---

### FND-003 — Convert all entities to Freezed + `json_serializable`
**As a developer**, I want immutable Freezed models with generated JSON, so I stop hand-writing `toJson/fromJson` and gain `copyWith` for free.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-001

**Acceptance criteria**
1. `App`, `User`, `Habit`, `HabitProgress`, `HabitStats`, `SettingsModel`, `HabitSchedule`, `HabitReminder`, `HabitNote`, `HabitCategory` are Freezed.
2. Enums (`HabitState`, `Day`, `Gender`) annotated with `@JsonEnum(valueField: 'wireName')` so wire format is decoupled from Dart ordinal. Wire format documented in [`APP_OVERVIEW.md`](APP_OVERVIEW.md) §5.3.
3. `HabitState` extended with `IN_PROGRESS` — the new value appended at the end so existing `.index`-encoded payloads continue to load. Migration step (FND-002) re-serialises legacy `.index` values to the new `wireName` field.
4. Generated files committed (`*.freezed.dart`, `*.g.dart`); CI runs `build_runner build --delete-conflicting-outputs` and fails on drift.

---

### FND-004 — Adopt theme tokens (`AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`)
**As a developer**, I want padlock-style theme tokens so screens stop hard-coding hex strings and pixel values.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-001

**Acceptance criteria**
1. `core/theme/app_colors.dart` exposes both **dark** (current palette) and **light** variants of every token currently in [`app_colors.dart`](../lib/core/utils/app_colors.dart). New: `AppColors.surface`, `surfaceContainer`, `onSurface`, `primaryContainer` for settings tiles.
2. `core/theme/app_spacing.dart`: `xxs=4, xs=8, sm=12, md=16, lg=20, xl=24, xxl=32, xxxl=40` (mirror Padlock).
3. `core/theme/app_typography.dart`: `displayLarge`, `titleLarge`, `titleMedium`, `bodyLarge`, `bodyMedium`, `bodySmall`, `labelLarge`, `labelSmall`. Per-screen styles in current `app_text_styles.dart` map to these.
4. `core/theme/app_radius.dart`: `smBorder=8, mdBorder=12, lgBorder=16, pillBorder=999`.
5. `core/theme/theme_factory.dart`: `ThemeData light()` + `ThemeData dark()` consumed by `MaterialApp.theme` and `darkTheme`, driven by `themeModeNotifier` (`ValueNotifier<ThemeMode>`) so settings can switch without restart.
6. Lint rule (custom analyzer plugin or hand-review checklist) banning raw `Color(0x…)`, `HexColor('#…')`, `EdgeInsets.all(<literal>)` in `features/`. Tokens only.

---

### FND-005 — Replace named routes with GoRouter
**As a developer**, I want GoRouter so deep-linking, sub-screens, and the settings flat-route pattern just work.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-001

**Acceptance criteria**
1. `AppRoutes` becomes a class of `static const String path` + `static const String name` pairs.
2. `StatefulShellRoute.indexedStack` for `/app` with three branches: `/app/habits`, `/app/stats`, `/app/profile`. The custom `SnakeNavigationBar` is removed; a `BottomNavigationBar` with `font_awesome_flutter` icons replaces it.
3. All current routes from §9 of `APP_OVERVIEW.md` re-exposed at the same paths so memory of paths in screenshots/docs is preserved.
4. Typed extras (`extra: SomeModel`) replace `routeSettings.arguments as T`.
5. Error route (`errorBuilder`) renders the "No Route Found" Scaffold currently in `AppRoutes.undefinedRoute()`.

---

### FND-006 — Replace `setState` data flow with ViewModels
**As a developer**, I want every screen backed by a `ViewModel` exposing `BehaviorSubject<T>` streams that the screen consumes via `StreamBuilder`, so state is unit-testable.

- **Priority:** P0 · **Effort:** L · **Depends on:** FND-001, FND-002

**Acceptance criteria**
1. ViewModels for every existing screen: `SplashViewModel`, `OnboardingViewModel`, `SignupViewModel`, `PasscodeSetupViewModel`, `PasscodeSigninViewModel`, `BiometricSigninViewModel`, `HabitListViewModel`, `AddHabitViewModel`, `ManageHabitsViewModel`, `HabitStatsViewModel`, `MonthStatsViewModel`, `MonthProgressViewModel`, `ProfileViewModel`.
2. ViewModels expose `dispose()` and screens call it from `dispose()`.
3. ViewModels depend on repositories, not data sources. Data sources stay private to the data layer.
4. No `Future` work happens in `initState` — screens call `vm.load()` and bind to streams.
5. Existing behavior preserved (regression test pass).

---

## 4. Epic AUTH — Vault-It-style authentication

Replace today's 5-digit plain PIN with a 4-digit PBKDF2-hashed PIN, custom keypad, layered biometric, and lockout policy. Add a multi-step signup mirroring Vault-It's `passcode_setup_screen` two-phase pattern.

### AUTH-001 — Migrate PIN length to 4 digits and hash with PBKDF2-SHA256
**As a user**, I want my PIN stored encrypted so even with device access nobody can read it from my phone's storage.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-001, FND-002

**Acceptance criteria**
1. PIN length is **exactly 4 digits** (currently 5). Documented in `core/constants/security_constants.dart` as `kPinLength = 4`.
2. PIN hashing: PBKDF2-SHA256, **100,000 iterations**, **16-byte random salt**, **32-byte derived key**, encoded `"1$<base64-salt>$<base64-hash>"` (matches Vault-It `passcode_service.dart:31-49`).
3. Hash + salt stored in `flutter_secure_storage` under key `auth.pin_hash`. Never in Hive, never in SharedPreferences.
4. Constant-time comparison on verify (port Vault-It's `_constantTimeEquals`).
5. Legacy plain-text PIN migration: on first run post-upgrade, `AuthMigrator` reads the legacy `User.password` (5-digit), prompts user once on splash to "Secure your PIN — enter your current PIN to upgrade", hashes & stores it, clears `User.password`. If user enters wrong PIN three times, they are taken to **Reset App Data** flow (with explicit warning).

**Technical notes**
- New service `IPasscodeService` / `PasscodeServiceImpl` in `core/services/auth/`, registered in DI.
- Library: `pointycastle ^3.9.1` (`PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))`).

---

### AUTH-002 — Custom `PasscodeKeypad` widget
**As a user**, I want a clean numeric keypad instead of an OTP text field, because tapping numbers feels right for a PIN.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-004

**Acceptance criteria**
1. `widgets/passcode_keypad.dart` renders a **3×4 grid**: digits 1–9, biometric/empty slot at bottom-left, 0 at bottom-center, backspace at bottom-right (matches Vault-It `passcode_keypad.dart`).
2. Biometric slot is shown only when `IBiometricAuthenticationManager.isBiometricAuthenticationAvailable()` returns true *and* the user has opted in.
3. Tactile feedback: `HapticFeedback.lightImpact()` on each digit tap, `HapticFeedback.mediumImpact()` on backspace, `HapticFeedback.heavyImpact()` on wrong PIN.
4. Pin entry "dots" widget (4 circles above keypad) reflects filled count.
5. Widget exposes `onDigit(int)`, `onBackspace()`, `onBiometric()` callbacks. No state inside the widget itself.

---

### AUTH-003 — Two-phase Passcode Setup (create → confirm)
**As a new user**, I want to set a PIN with a "confirm" step so I don't lock myself out with a typo.

- **Priority:** P0 · **Effort:** S · **Depends on:** AUTH-001, AUTH-002

**Acceptance criteria**
1. Single screen `features/auth/passcode_setup_screen.dart` with state machine `PasscodeSetupStep.create → confirm` (mirrors Vault-It).
2. Phase 1 ("Create your PIN"): user enters 4 digits; transition to confirm on 4th tap.
3. Phase 2 ("Confirm your PIN"): user re-enters; mismatch shakes the dots (use `flutter_animate`), shows snackbar "PIN doesn't match", returns to phase 1 with empty buffer.
4. Match → `PasscodeService.set(pin)` → mark `user.isPINAuthenticated = true`, `user.isAuthenticated = true` → route to Biometric opt-in (AUTH-004) if available, else to Signup-Success.
5. "Back" gesture in confirm phase resets to phase 1.

---

### AUTH-004 — Biometric opt-in (layered on PIN)
**As a user**, I want biometric as an *additional* fast-path on top of my PIN, so my PIN remains the master credential.

- **Priority:** P0 · **Effort:** S · **Depends on:** AUTH-001

**Acceptance criteria**
1. Opt-in screen `features/auth/biometric_opt_in_screen.dart` shown after AUTH-003 only when biometric is available.
2. "Enable biometric" CTA invokes `local_auth` with `stickyAuth: true`; success persists `user.isBiometricAuthenticated = true`.
3. "Skip" CTA proceeds without enabling.
4. Biometric never replaces PIN: even with biometric on, the user can fall back to PIN (digit keypad always present on the lock screen).
5. Disabling biometric in Settings (SET-004) flips the flag but keeps the PIN intact.

---

### AUTH-005 — App Lock with auto-biometric & lockout policy
**As a user**, I want the app to lock when I background it and re-unlock smoothly with biometric, falling back to PIN.

- **Priority:** P0 · **Effort:** M · **Depends on:** AUTH-001, AUTH-002, AUTH-004

**Acceptance criteria**
1. `core/services/auth/app_lock_service.dart` consolidates lock logic (today's `AppNavigatorScreen.didChangeAppLifecycleState` moves here).
2. Background → foreground after **≥ 30 s** in background triggers lock screen (`features/auth/lock_screen.dart`). Under 30 s, no relock.
3. On foreground, if biometric enabled, auto-attempt `local_auth.authenticate(stickyAuth: false)` once; on success, dismiss lock.
4. **Lockout policy** (mirrors Vault-It):
   - 5 wrong PIN attempts → 30-second lockout. Countdown displayed.
   - 10 wrong PIN attempts → 5-minute lockout.
   - Lockout end timestamp persisted to `flutter_secure_storage` so it survives app kill.
5. Lock screen shows: PIN dots, keypad, "Forgot PIN?" link (routes to AUTH-006 Reset flow).

---

### AUTH-006 — "Forgot PIN" → Reset All Data
**As a user**, I want a one-way escape from a lost PIN that explicitly tells me my data will be wiped.

- **Priority:** P0 · **Effort:** S · **Depends on:** AUTH-005, DAT-003

**Acceptance criteria**
1. "Forgot PIN?" on lock screen opens a dialog: "There is no PIN recovery. You can reset the app, which will permanently delete all habits and settings. Continue?"
2. Confirm → call `ResetService.resetAll()` → clears all Hive boxes, secure storage, and SharedPreferences (back-compat) → routes to Splash → Onboarding.
3. Cancel returns to the lock screen.
4. **No recovery seed** is offered (matches Vault-It's deliberate stance).

---

### AUTH-007 — Change PIN
**As a user**, I want to change my PIN without resetting.

- **Priority:** P1 · **Effort:** S · **Depends on:** AUTH-001..003

**Acceptance criteria**
1. Route `/settings/security/change-pin`; reached from Settings → Security (SET-004).
2. Flow: "Enter current PIN" → "Create new PIN" → "Confirm new PIN".
3. Wrong current PIN counts toward AUTH-005 lockout.
4. On success, hash is replaced; lockout counter reset.

---

### AUTH-008 — Multi-step Signup (Vault-It style)
**As a new user**, I want signup to feel staged: welcome → PIN → biometric → profile, so each step is unambiguous.

- **Priority:** P0 · **Effort:** M · **Depends on:** AUTH-003, AUTH-004

**Acceptance criteria**
1. Replaces current signup hub (`SignupScreen`) with a sequence: **Welcome → Passcode Setup (AUTH-003) → Biometric Opt-in (AUTH-004) → Profile (username + gender)**.
2. Each step is its own route under `/signup/<step>`. Back navigation allowed within steps.
3. Email/phone/birthdate validators in `app_form_validator.dart` are deleted (dead code — see `APP_OVERVIEW.md` §11.4).
4. Profile step persists `username` (≤ 16 chars) + `gender` (Male / Female via `CustomDropdown` until UX-003 replaces it).
5. Final step transitions to `/app/habits` via `pushReplacement`. Splash flow rerouted accordingly.

---

## 5. Epic SET — Padlock-style Settings & sub-screens

Replace today's tri-mode Profile screen with a dedicated Settings hub that **routes via GoRouter to flat sub-screens** (mirrors Padlock — sub-screens are top-level features, not nested children). The "Profile" tab becomes the Settings hub.

### SET-001 — Settings hub screen
**As a user**, I want one Settings screen listing every category of configuration, so I can find anything in two taps.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-004, FND-005

**Acceptance criteria**
1. Route `/app/settings` replaces `/app/profile`. Tab #3 in the shell renamed "Settings", icon `FontAwesomeIcons.gear`.
2. Screen structure (top-to-bottom): **Header** (avatar by gender from `male.png` / `female.png`, username, "Edit profile" chevron tile linking to SET-003) — **Section: Preferences** (Appearance, Notifications, Language, AI Coach) — **Section: Security** (PIN & Biometric) — **Section: Data** (Export, Import, Reset) — **Section: Habit defaults** (default schedule, default reminder time) — **Section: Help & feedback** (Help & Support, Bug Report, Rate App) — **Section: About** (About, Privacy, Terms) — **Footer** version string from `package_info_plus`.
3. Each row is a `SettingsRowChevron` (icon + title + optional subtitle + trailing chevron) or `SettingsRowToggle` (for booleans). Sections wrapped in `SettingsSectionCard`.
4. No business logic in the screen — all bindings to `SettingsViewModel` via `BehaviorSubject` streams.

**Technical notes**
- Mirror Padlock `features/settings/widgets/{settings_section_card,settings_row_chevron,settings_row_toggle,settings_picker_option}.dart` line-for-line where appropriate.

---

### SET-002 — `SettingsViewModel` + `SettingsRepository`
**As a developer**, I want one ViewModel + one Repository that arbitrates every setting, so the hub and every sub-screen share state.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-002, FND-006

**Acceptance criteria**
1. `SettingsViewModel` exposes streams: `themeMode$` (system/light/dark), `accentColor$`, `language$`, `notificationsEnabled$`, `dailySummaryTime$`, `defaultHabitSchedule$`, `defaultReminderTime$`, `biometricEnabled$`, `aiEnabled$`, `aiHasKey$`, `version$`.
2. `SettingsRepository` interface + Hive-backed impl persist a single `SettingsModel` (Freezed) under key `app_settings` in box `settings`.
3. Mutations are serialised via a `Future` queue so concurrent saves can't lose updates (mirror Padlock `SettingsRepositoryImpl._update`).
4. Theme + language changes broadcast through `themeModeNotifier` / `languageNotifier` so `MaterialApp` rebuilds without restart.

---

### SET-003 — Edit Profile sub-screen
**As a user**, I want to edit my username and gender without leaving Settings.

- **Priority:** P0 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/profile`. Form with `TextFieldWidget` (username, ≤ 16 chars) + `CustomDropdown` (gender). Save → `UserRepository.update()`.
2. Reuses `signupName` validator (≤ 16, ≥ 2 chars).
3. Header avatar refreshes after save.
4. Cancel returns to Settings without persisting.

---

### SET-004 — Security sub-screen
**As a user**, I want to manage PIN, biometric, and lockout policy from one place.

- **Priority:** P0 · **Effort:** M · **Depends on:** AUTH-007, AUTH-005

**Acceptance criteria**
1. Route `/settings/security`. Rows:
   - **Change PIN** → chevron → AUTH-007 flow.
   - **Biometric unlock** → toggle. On enable, triggers `local_auth` verification first; on disable, just flips flag.
   - **Auto-lock after** → picker (Immediate / 30s / 1m / 5m / Never). Wires to AUTH-005's 30-second default.
   - **Lockout policy** (read-only summary: "5 attempts → 30s, 10 attempts → 5m").
2. Toggling biometric requires successful biometric prompt before persisting on=true (prevents a stale "on" if hardware changed).

---

### SET-005 — Appearance sub-screen
**As a user**, I want to choose light, dark, or system theme and pick an accent color.

- **Priority:** P1 · **Effort:** M · **Depends on:** SET-001, FND-004

**Acceptance criteria**
1. Route `/settings/appearance`. Three radio rows (`SettingsPickerOption`) for **Theme**: System / Light / Dark.
2. Five-swatch row for **Accent color**: defaults (#1C2D32 current accent, #FF725E coral, #00A36C green, #0072B1 blue, #900C3F deep red).
3. Live preview pane at the top showing a sample habit row in the chosen theme + accent.
4. Persisted via `SettingsRepository.setThemeMode()` / `setAccent()`; reflected immediately via `themeModeNotifier`.
5. README's "Dark mode" claim becomes accurate after this story ships.

---

### SET-006 — Language sub-screen (English + Arabic stub wiring)
**As a user**, I want to switch the app language.

- **Priority:** P1 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/language`. Radio rows for **English** (`en`) and **العربية** (`ar`).
2. Selecting Arabic loads `assets/lang/ar.json` (initially a 1:1 copy of `en.json` until translation lands — file MUST exist so the picker doesn't error).
3. `MaterialApp.locale` updates through `languageNotifier` (`ValueNotifier<Locale>`).
4. Layout flips to RTL when Arabic is selected (`Directionality.of(context)` derived from locale).
5. `AppStrings.arabicCode` / `englishCode` constants kept; the dead `Locale('en')` hard-code in `app.dart` removed.

---

### SET-007 — Notifications sub-screen
**As a user**, I want a single place to govern reminders.

- **Priority:** P0 · **Effort:** M · **Depends on:** ENG-006

**Acceptance criteria**
1. Route `/settings/notifications`. Rows:
   - **Enable habit reminders** toggle — master switch. When OFF, all per-habit reminders are suspended (not deleted; restored on re-enable).
   - **Daily summary** toggle — enables a single agenda push at the user-picked time.
   - **Daily summary time** picker (Material `TimePicker`).
   - **Notification permissions** status row with "Open system settings" CTA when denied (uses `permission_handler`).
2. Toggling the master switch immediately calls `NotificationService.applyMasterSwitch(bool)` which (un)schedules existing reminders.
3. First entry into this screen on Android 13+ proactively requests `POST_NOTIFICATIONS`.

---

### SET-008 — AI Coach sub-screen (Groq settings)
**As a user**, I want to enable the AI coach and paste my Groq API key, like in Readline.

- **Priority:** P0 · **Effort:** M · **Depends on:** AI-001, AI-002

**Acceptance criteria**
1. Route `/settings/ai`. Rows:
   - **Enable AI coach** toggle (`magicEnabled`). Default OFF.
   - **Groq API key** — masked text field (`obscureText: true`), "Paste from clipboard" affordance.
   - **Validate & save** button → calls `GroqCredentialValidator.validate(key)` (probes `/models`, 8s timeout). On success: shows green check, persists to `flutter_secure_storage` under `magic.groq_api_key`. On failure: shows red error with reason (network / unauthorized / timeout).
   - **Model** picker (default `llama-3.3-70b-versatile`; advanced users can pick `llama-3.1-8b-instant`).
   - **Where does my data go?** info row → modal with the system prompt verbatim + a sentence about what is and isn't sent (NFR-3).
2. Toggle OFF disables AI without deleting the key.
3. Key field is the only place the key is editable; never logged, never copied to non-secure storage.

---

### SET-009 — Data sub-screen
**As a user**, I want to export, import, or reset my data without hunting.

- **Priority:** P0 · **Effort:** S · **Depends on:** DAT-001, DAT-002, DAT-003

**Acceptance criteria**
1. Route `/settings/data`. Rows:
   - **Export backup** → DAT-001 flow.
   - **Import backup** → DAT-002 flow with explicit "this will overwrite" confirmation dialog.
   - **Reset app data** → AUTH-006 flow (after confirmation).
2. Last-export timestamp displayed under the export row (e.g. "Last exported 2 days ago").

---

### SET-010 — Habit defaults sub-screen
**As a user**, I want the Add-Habit screen to default to my preferred schedule/time so I don't pick them every time.

- **Priority:** P1 · **Effort:** S · **Depends on:** SCH-001, SCH-002

**Acceptance criteria**
1. Route `/settings/habit-defaults`. Rows:
   - **Default schedule** picker (Daily / Weekly: Mon–Fri / Weekly: Mon–Sun / Monthly: day 1 / None).
   - **Default reminder time** picker (Off / 8:00 / 12:00 / 18:00 / custom).
2. New habits created without an explicit schedule inherit these defaults.

---

### SET-011 — About sub-screen
**As a user**, I want to see app info + creator socials in one consistent screen.

- **Priority:** P0 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/about`. Content: Logo, app name, version (from `package_info_plus`), tagline ("HABIT IT"), creator name + photo (`henry.jpg`).
2. Social rows: LinkedIn, GitHub, WhatsApp, Facebook, Mail — using `IconTextButton` + `font_awesome_flutter` icons. Tapping opens via `url_launcher` (replacing today's `launch` with `launchUrl`).
3. The current `AboutUsWidget` inside `ProfileScreen` is deleted.

---

### SET-012 — Help & Support sub-screen
**As a user**, I want a structured FAQ + contact path.

- **Priority:** P1 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/help`. Top section: collapsible FAQ list (5–10 questions: "How do streaks work?", "What's the AI coach?", "How do I export?", "What if I forget my PIN?", etc.). Q&A pairs sourced from `assets/lang/en.json` keys `faq.q1` / `faq.a1` … `faq.q10` / `faq.a10`.
2. Bottom section: "Contact us" button → `mailto:henryazer@outlook.com?subject=Habit%20It%20Support` via `url_launcher`.
3. Mirrors Padlock `features/support/screens/help_support_screen.dart`.

---

### SET-013 — Bug Report sub-screen
**As a user**, I want to send a bug report without leaving the app.

- **Priority:** P1 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/bug-report`. Form fields: **Title** (≤ 80 chars), **Description** (multi-line), **Steps to reproduce** (multi-line), **Include device info** toggle (default ON — appends OS / model / app version from `package_info_plus`).
2. Submit composes a `mailto:` URL with body pre-filled, opens default mail client. (No backend — keep within NFR-1.)
3. Confirmation snackbar on success.

---

### SET-014 — Rate App sub-screen
**As a user**, I want a quick path to rate the app.

- **Priority:** P1 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Route `/settings/rate`. Single illustration + "Rate on Play Store" CTA opening `market://details?id=<packageName>` (fallback to https Play Store URL).
2. If app is sideloaded (no Play Store), CTA hidden, replaced with "Star us on GitHub" linking to creator's GitHub.

---

### SET-015 — Privacy Policy & Terms of Service sub-screens
**As a user**, I want to read the legal docs in-app.

- **Priority:** P1 · **Effort:** S · **Depends on:** SET-001

**Acceptance criteria**
1. Routes `/settings/privacy` and `/settings/terms`. Render Markdown from `assets/legal/privacy_en.md` + `privacy_ar.md` (same for terms) via `flutter_markdown` (or a hand-rolled minimal renderer if size matters).
2. Locale-aware: loads `_<lang>.md`; falls back to `_en.md` if missing.
3. Legal text drafted to reflect: offline-only data, optional Groq calls, no analytics, contact email.

---

## 6. Epic SCH — Flexible scheduling & optional timing

Today's `Habit` only repeats on **weekdays** (`repeatDays: List<String>`). The PO requires **calendar-day** ("always on day 1 of the month"), **monthly without specific day**, **one-time tasks**, **none**, and **optional reminder time**. This epic introduces a sealed `HabitSchedule` union.

### SCH-001 — Sealed `HabitSchedule` union
**As a user**, I want to choose how a habit recurs: daily, on specific weekdays, on specific calendar days of the month, monthly without a date, one-time, or never.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-003

**Acceptance criteria**
1. New Freezed union:
   ```dart
   @freezed
   sealed class HabitSchedule with _$HabitSchedule {
     const factory HabitSchedule.daily()                       = DailySchedule;
     const factory HabitSchedule.weekly(List<String> weekdays) = WeeklySchedule;     // existing behavior
     const factory HabitSchedule.monthlyDays(List<int> days)   = MonthlyDaysSchedule;// e.g. [1] = "day 1 every month"
     const factory HabitSchedule.monthlyAny()                  = MonthlyAnySchedule; // any day in the month
     const factory HabitSchedule.oneTime(DateTime date)        = OneTimeSchedule;
     const factory HabitSchedule.none()                        = NoneSchedule;       // ad-hoc habit, no recurrence
   }
   ```
2. `Habit` model adds `HabitSchedule schedule`. Legacy field `repeatDays` becomes a getter that returns `weekly.weekdays` or `[]` for backward serialisation; on migration (FND-002) every existing habit is coerced to `HabitSchedule.weekly(repeatDays)`.
3. `HabitState` engine (`HabitLocalDataSource.updateDayHabits`, `getHabitsByDay`) is rewritten against `HabitSchedule.shouldShowOn(DateTime day)`:
   - `daily` → always
   - `weekly(days)` → `days.contains(weekdayName(day))`
   - `monthlyDays(days)` → `days.contains(day.day)`
   - `monthlyAny` → `day.isInSameMonth(habit.createdDate)` once per month (first time only)
   - `oneTime(d)` → `isSameDate(d, day)`
   - `none` → only on the day the user explicitly opens it (no auto-roll-forward)
4. `_createDaysStates` initialiser rewritten symmetrically: for `monthlyDays([1])`, only day 1 of every month is pre-populated as `NOT_DONE` (the other days remain `CREATED` and are filtered out by `getHabitsByDay`).
5. Migration (FND-002) preserves enum order — `HabitState` not changed by this story.

---

### SCH-002 — Optional reminder time per habit
**As a user**, I want to optionally schedule a habit at a specific time (e.g. "drink water at 8am"), but I shouldn't be forced to set one.

- **Priority:** P0 · **Effort:** S · **Depends on:** SCH-001, ENG-006

**Acceptance criteria**
1. `Habit` adds `HabitReminder? reminder` (nullable Freezed model: `TimeOfDay timeOfDay`, `bool enabled`).
2. When `reminder == null` → no notification scheduled for the habit.
3. When `reminder != null && reminder.enabled && settings.notificationsEnabled` → `NotificationService.scheduleForHabit(habit)` is called on save, on app boot, and on date roll-over.
4. UI: Add Habit + Manage Habit screens show "Reminder time" row with **Off / Set time** toggle. "Set time" opens `TimePicker`.
5. Default per-habit reminder time inherits from SET-010.

---

### SCH-003 — Add Habit screen rebuild
**As a user**, I want the Add-Habit screen to let me choose any schedule kind, with the UI adapting per choice.

- **Priority:** P0 · **Effort:** M · **Depends on:** SCH-001, SCH-002, UX-002

**Acceptance criteria**
1. Sections: **Name** (text field) → **Category** (chips, UX-002) → **Schedule** (segmented control: Daily / Weekly / Monthly / One-time / None) → context-sensitive picker per choice → **Reminder** (optional time) → **Quantitative target** (optional, UX-001) → **Notes** (optional multi-line) → **Save**.
2. Weekly picker = today's `SelectWeekDays` (Mon–Sun chips).
3. Monthly picker = a numeric grid (1–31) with multi-select; "Last day of month" sentinel = `0`. Tapping "Day 1" only is one tap.
4. One-time picker = `DatePicker`.
5. Validation:
   - Name ≥ 2, ≤ 30 chars (today's 20-char cap raised to 30).
   - Weekly schedule MUST have ≥ 1 day selected (snackbar otherwise).
   - Monthly schedule MUST have ≥ 1 day selected.
   - One-time date MUST be today or future.
6. Save creates the habit and pops with `true` so the parent reloads.

---

### SCH-004 — Cross-month calendar navigation
**As a user**, I want to swipe left/right on the calendar bar to review past months, not be stuck on the current month.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-006

**Acceptance criteria**
1. `CalendarAppBar` replaced by a horizontally pageable calendar showing 7 days at a time, with month label in the header. Swipe left → previous week; swipe right → next week (bounded by `app.initDate` and today + 30 days).
2. Selecting a day in the past loads its historical states (read-only — no toggling past days).
3. Selecting a day ≤ today is editable.
4. Selecting a day > today is reserved for one-time scheduled habits (read-only preview).
5. Long-press on month label opens the existing `showMonthPicker` (today's Stats picker) to jump months.

---

## 7. Epic ENG — Engagement: streaks, heatmap, today, notes, notifications

### ENG-001 — Streak computation service
**As a user**, I want to see how many days in a row I've kept a habit, because that's why I check in.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-002

**Acceptance criteria**
1. `HabitStatsRepository.streakOf(habitId)` returns `(currentStreak, longestStreak)` computed from the union of all months' `daysStates`.
2. A day counts toward a streak if state is `DONE`. `SUSPENDED` and weekday-mismatched days are **skipped** (don't break the streak). `NOT_DONE` breaks it.
3. Computation memoised per habit per session.

---

### ENG-002 — Streak chip on habit row
**As a user**, I want to see streak info next to each habit on the home list.

- **Priority:** P0 · **Effort:** S · **Depends on:** ENG-001

**Acceptance criteria**
1. `HabitItemWidget` adds a small chip showing `🔥 <currentStreak>` if `currentStreak ≥ 2` (suppressed for 0/1 to reduce noise).
2. Tap on chip opens habit detail (ENG-003).
3. Visual: pill-shaped `AppColors.surfaceContainer` background, accent-coloured icon.

---

### ENG-003 — Habit detail screen
**As a user**, I want to tap a habit and see its full story: streak, heatmap, completion rate, schedule, notes.

- **Priority:** P0 · **Effort:** L · **Depends on:** ENG-001, ENG-004

**Acceptance criteria**
1. Route `/app/habits/:habitId`. Sections:
   - **Header**: habit name + category color + edit pencil → Manage flow.
   - **Streak block**: current streak (big), longest streak, completion rate %, days tracked.
   - **Heatmap**: 12-month GitHub-style grid (ENG-004).
   - **Schedule**: human-readable summary ("Every Mon, Wed, Fri" / "Day 1 of each month" / "Once on 2026-06-15").
   - **Reminder**: time + toggle.
   - **Notes**: list of `HabitNote`s grouped by date (ENG-005).
   - **Actions**: Suspend today · Delete (red).
2. Pull-to-refresh recomputes streaks/heatmap.

---

### ENG-004 — Year-view heatmap widget
**As a user**, I want a visual at-a-glance year overview.

- **Priority:** P0 · **Effort:** M · **Depends on:** ENG-003

**Acceptance criteria**
1. `widgets/year_heatmap.dart` renders a 52-week × 7-day grid (current month at the right edge).
2. Cell colour scale: `surface` (no data) → `accent×0.25` (CREATED/scheduled but no event) → `accent×0.5` (NOT_DONE) → `green` (DONE) → `red` (SUSPENDED).
3. Tap a cell → bottom sheet shows that date's state + any note.
4. Horizontally scrollable.

---

### ENG-005 — Notes per check-in
**As a user**, I want to attach an optional note to a check-in ("skipped because sick").

- **Priority:** P1 · **Effort:** S · **Depends on:** FND-003

**Acceptance criteria**
1. Long-pressing the state pill on `HabitItemWidget` opens a text input bottom sheet.
2. `HabitNote(habitId, date, text)` persisted in a new Hive box `notes`. One note per (habit, date).
3. Notes shown on Habit Detail (ENG-003) grouped by month.
4. Notes excluded from streak math; purely descriptive.

---

### ENG-006 — Local notifications service
**As a user**, I want to be reminded of habits at the times I choose, even if the app is closed.

- **Priority:** P0 · **Effort:** L · **Depends on:** FND-001

**Acceptance criteria**
1. `core/services/notifications/notification_service.dart` wraps `flutter_local_notifications ^18.x` + `timezone ^0.10.x`.
2. On app boot, the service re-schedules all habits whose `reminder.enabled == true` (covers device reboots — Android wipes scheduled notifications on reboot).
3. Notification id = stable hash of habit id (`uuid.v5(namespace, habitId)` truncated to int32) so re-scheduling overwrites.
4. Notification payload includes `habitId` + scheduled date; tapping deep-links to `/app/habits/:habitId`.
5. Notification action button "✓ Done" marks the habit `DONE` for that day without opening the app (Android only — iOS gracefully no-ops).
6. Daily summary notification (SET-007) shows "You have N habits today" at user-picked time.
7. Permission flow: Android 13+ requests `POST_NOTIFICATIONS` on first entry to Settings → Notifications. Denial state surfaced as a non-blocking warning on Habits screen.

---

### ENG-007 — "Today" agenda landing
**As a user**, when I open the app, I want to see today's habits with this-week's progress dots, not a date-locked single day.

- **Priority:** P1 · **Effort:** M · **Depends on:** SCH-004

**Acceptance criteria**
1. Tab #1 root becomes a "Today" agenda by default (configurable in Settings: SET-010 adds "Default landing" picker).
2. Each habit row shows 7 small dots representing Mon–Sun of the current week, colour-coded by state. Tap a dot to jump to that day.
3. "Show full calendar" expander reveals the existing SCH-004 weekly calendar.

---

## 8. Epic AI — Groq integration ("How do you feel today?")

Mirrors Readline's Magic Content pattern: `flutter_secure_storage` API key, OpenAI-compatible POST to `https://api.groq.com/openai/v1`, model `llama-3.3-70b-versatile`, defensive JSON parsing, accept-or-discard UI.

### AI-001 — Groq HTTP service
**As a developer**, I want a clean Groq client behind a typed contract.

- **Priority:** P0 · **Effort:** M · **Depends on:** FND-001

**Acceptance criteria**
1. `IHabitSuggestionService` abstract; `GroqHabitSuggestionService` implementation in `core/services/ai/`.
2. POST to `https://api.groq.com/openai/v1/chat/completions` via `http: ^1.3.0`. Headers: `Authorization: Bearer <key>`, `Content-Type: application/json`. Timeouts: 8s validation, 60s generate.
3. Request body: `model`, `temperature: 0.7`, `seed: <random>`, `messages: [system, user]`, `response_format: {type: "json_object"}` (forces JSON output).
4. `GroqCredentialValidator` probes `GET /models` (8s timeout); returns typed `ValidationResult.ok / unauthorized / network / timeout`.
5. Returns sealed `SuggestionResult.success(List<HabitSuggestion>) / error(SuggestionError)` where `SuggestionError` enum is `network / timeout / unauthorized / empty / parse / server / quotaExceeded`.

---

### AI-002 — Settings-aware wrapper + feature flag
**As a developer**, I want a single entry point that respects the AI Coach toggle and missing key.

- **Priority:** P0 · **Effort:** S · **Depends on:** AI-001, SET-008

**Acceptance criteria**
1. `SettingsAwareHabitSuggestionService(getIt<SettingsRepository>(), getIt<IHabitSuggestionService>())` checks `magicEnabled` + key presence; short-circuits with `SuggestionError.unauthorized` if either fails.
2. DI registers the wrapper as the `IHabitSuggestionService` consumers see.
3. Mirror Readline's `SettingsAwareContentGenerationService`.

---

### AI-003 — Prompt builder
**As a developer**, I want a single prompt builder file owning all prompt logic.

- **Priority:** P0 · **Effort:** M · **Depends on:** AI-001

**Acceptance criteria**
1. `core/services/ai/habit_suggestion_prompt_builder.dart` exposes `buildSystemPrompt()` + `buildUserPrompt(MagicIntake intake)`.
2. **System prompt (verbatim)**:
   ```
   You are a thoughtful habit coach. The user describes how they feel and what they want to improve. You suggest small, concrete, daily-achievable habits.

   Strict rules:
   - Each habit name is ≤ 30 characters, imperative voice ("Drink one glass of water"), no emojis.
   - Each habit has a schedule: daily | weekly | monthly. Choose what fits the suggestion best.
   - For weekly, list weekdays from this set: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.
   - For monthly, list days of month from 1..28 (avoid 29–31 to be safe across months).
   - Reminder time is optional (HH:mm) when a time clearly helps; otherwise omit.
   - Never suggest medical, financial, or legal advice. If the user is in distress, include exactly one habit named "Talk to someone you trust today" and limit total suggestions to 2.
   - Return between 1 and 5 suggestions.
   - Respond ONLY with a JSON object matching the schema; no prose, no markdown fences.

   Schema:
   {
     "suggestions": [
       {
         "name": "string (≤30 chars)",
         "reason": "string (≤120 chars, one sentence explaining why)",
         "schedule": { "kind": "daily" } | { "kind": "weekly", "weekdays": ["Monday", ...] } | { "kind": "monthly", "days": [1, 15] },
         "reminder": "HH:mm" | null,
         "category": "Health" | "Mind" | "Productivity" | "Relationships" | "Learning" | "Other"
       }
     ]
   }
   ```
3. **User prompt template**:
   ```
   Feeling: {feeling}

   Answers:
   - What do you want more of in your life? {answer1}
   - What's one small thing you could start tomorrow? {answer2}
   - When in the day are you most consistent? {answer3}

   Suggest {n} habits.
   ```
   `n` defaults to 3, configurable to 1–5.
4. Empty answers are omitted from the prompt (no "Answer: " lines for blanks).
5. Topic / `feeling` is trimmed and length-limited to 500 chars before sending.

---

### AI-004 — JSON response parser
**As a developer**, I want defensive JSON parsing that survives model misbehaviour.

- **Priority:** P0 · **Effort:** M · **Depends on:** AI-001

**Acceptance criteria**
1. `parseSuggestions(String raw)` returns `List<HabitSuggestion>` or throws `SuggestionParseException`.
2. Strategy (mirrors Readline parser):
   - Strip markdown code fences (`` ```json … ``` ``).
   - Unwrap OpenAI-style envelopes (`{"choices":[{"message":{"content":"…"}}]}`).
   - Parse outer JSON object; pick `suggestions` array.
   - For each item: coerce `schedule` into `HabitSchedule` union; coerce `reminder` into `TimeOfDay?` (regex `HH:mm`); validate name length; trim; drop invalid items but keep valid ones.
   - If fewer than 1 valid suggestion survives, raise parse error.
3. Refusal detection: if outer `content` matches `/I (cannot|can't|won't) (help|provide)/i`, return `SuggestionError.empty` (no parse).

---

### AI-005 — Magic Coach screen ("How are you feeling?")
**As a user**, I want a calm screen where I describe how I feel and the app suggests habits.

- **Priority:** P0 · **Effort:** L · **Depends on:** AI-001..004, SET-008

**Acceptance criteria**
1. Entry points:
   - Habits screen empty state: "Need ideas? Try the AI Coach" CTA.
   - FAB speed-dial: third option **AI Coach** (icon `FontAwesomeIcons.wandMagicSparkles`).
   - Settings → AI Coach has a "Try it" button when key validated.
2. Route `/coach/intake`. Form:
   - **Multi-line "How do you feel right now?"** — 500-char limit, counter visible.
   - **Q1**: "What do you want more of in your life?" (single line, ≤ 120 chars).
   - **Q2**: "What's one small thing you could start tomorrow?" (single line, ≤ 120 chars).
   - **Q3**: "When in the day are you most consistent?" (chips: Morning / Afternoon / Evening / Night / Anytime).
   - **Suggestion count** slider (1–5; default 3).
3. "Suggest habits" button: disabled while a request is in flight; label swaps to "Thinking…" (mirrors Readline's pattern; no spinner).
4. On success, navigate to AI-006 results screen.
5. On error, snackbar with human-readable message per `SuggestionError`.
6. Rate-limit guardrail: 1 request per 30 seconds + max 30 requests/day (counter persisted in `magic_meta` Hive box). Over limit → friendly "You've used today's quota" message.

---

### AI-006 — Suggestion review screen
**As a user**, I want to review, edit, accept, or dismiss each suggestion before it becomes a real habit.

- **Priority:** P0 · **Effort:** M · **Depends on:** AI-005, SCH-001

**Acceptance criteria**
1. Route `/coach/suggestions`. Each `HabitSuggestion` rendered as an expandable card:
   - Header: habit name + category tag + reason (one line).
   - Body (expanded): schedule summary, reminder time, "Edit" button (opens prefilled Add-Habit screen), "Add" button (persists as `Habit` directly), "Dismiss" button.
2. Top-right "Add all" button persists every non-dismissed suggestion in order.
3. After Add/Edit, the card collapses to a confirmation row "Added ✓".
4. Suggestions are not persisted to Hive until accepted (matches Readline's pattern).
5. "Try again" CTA at bottom re-fires the previous intake with a new random seed.

---

### AI-007 — Privacy disclosure + telemetry-free guarantee
**As a user**, I want to know exactly what's sent to Groq before I use the feature.

- **Priority:** P0 · **Effort:** S · **Depends on:** AI-005

**Acceptance criteria**
1. First time the Magic Coach is opened, a one-time modal shows: the system prompt, the answer fields, "Nothing else is sent — not your existing habits, not your name, not your PIN", and a "Don't show again" checkbox.
2. The modal can be re-read from Settings → AI Coach → "Where does my data go?" (SET-008).
3. The Groq response is not logged or persisted anywhere except in the in-memory result list until the user accepts a suggestion.

---

## 9. Epic DAT — Data: export, import, reset, schema versioning

### DAT-001 — JSON export
**As a user**, I want a one-tap backup file I can save to Drive / Files.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-002, SET-009

**Acceptance criteria**
1. `BackupService.export()` returns a `Map<String, dynamic>` of all repositories' state plus `schemaVersion: 1`, `exportedAt: ISO8601`, `appVersion`.
2. The JSON is written to a temp file and shared via `share_plus` (`Share.shareXFiles([XFile(path)])`).
3. PIN hash is **NOT** included (it's tied to the device's secure storage). Restoring on a fresh install requires a new PIN.
4. File name: `habit_it_backup_<YYYY-MM-DD>.json`.

---

### DAT-002 — JSON import (with overwrite confirmation)
**As a user**, I want to restore from a backup file.

- **Priority:** P0 · **Effort:** M · **Depends on:** DAT-001

**Acceptance criteria**
1. Settings → Data → Import opens a `file_picker` to choose a `.json` file.
2. App validates `schemaVersion`; supports `1`. Future versions handled via a migrator.
3. Confirmation dialog: "This will overwrite your current habits and settings. Continue?" with explicit Yes/Cancel.
4. On confirm: every Hive box overwritten transactionally; on any error, the previous state is restored (BackupService takes a snapshot before mutating).
5. Success snackbar; app navigates back to Habits.

---

### DAT-003 — Reset service
**As a user**, I want a single, unambiguous reset that wipes everything.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-002

**Acceptance criteria**
1. `ResetService.resetAll()` clears all Hive boxes by name (whitelisted: `app`, `user`, `habits`, `settings`, `notes`, `notifications_meta`, `magic_meta`), clears `flutter_secure_storage` (`auth.*`, `magic.*`), and clears any leftover SharedPreferences (for safety).
2. Replaces today's `AppLocalDataSource.reset()` which calls `clearAll()` indiscriminately on SharedPreferences (see `APP_OVERVIEW.md` §13 caveat — now narrowed to whitelisted keys).
3. Used by SET-009 and AUTH-006.

---

## 10. Epic UX — Quantitative habits, categories, theming polish

### UX-001 — Quantitative habits with targets
**As a user**, I want to track "drink 8 glasses of water" with progress, not just done/not-done.

- **Priority:** P1 · **Effort:** L · **Depends on:** SCH-001, FND-003

**Acceptance criteria**
1. `Habit` adds nullable `target: HabitTarget?` (Freezed: `int value`, `String unit` e.g. "glasses", "minutes", "pages").
2. When `target != null`, the per-day state becomes a counter: `Map<int, int> progress` in addition to `daysStates`. State derived: `progress >= target → DONE`, `0 < progress < target → IN_PROGRESS` (new enum value), `progress == 0 → NOT_DONE / CREATED` per existing rules.
3. `HabitItemWidget` pill shows `<progress>/<target>` instead of check/cross when target is set; tap increments by 1; long-press opens "Set value" dialog.
4. Stats: `total_done` counts days where `progress >= target`. Existing month-stats table gains an optional "Avg" column.

---

### UX-002 — Habit categories with icon + accent
**As a user**, I want to tag habits with a category, color, and icon for visual grouping.

- **Priority:** P1 · **Effort:** M · **Depends on:** FND-003

**Acceptance criteria**
1. Seed categories shipped: Health, Mind, Productivity, Relationships, Learning, Other (matches AI-003 schema).
2. Each category has a `FontAwesomeIcons` glyph and an accent color (default mapping bundled).
3. `Habit` adds nullable `categoryId: String?`. Add Habit + Manage Habit screens include a category picker (horizontal chip list).
4. Habit row shows a small icon + accent dot on the left.
5. Today/Manage screens get a category filter chip row above the list.

---

### UX-003 — Replace `flutter_snake_navigationbar` + `line_awesome_flutter`
**As a developer**, I want maintained icon/nav packages.

- **Priority:** P0 · **Effort:** S · **Depends on:** FND-005

**Acceptance criteria**
1. Bottom nav uses Material `NavigationBar` with `FontAwesomeIcons` glyphs.
2. All `LineAwesomeIcons.*` references swapped to `FontAwesomeIcons.*` equivalents (mapping table tracked in PR description).
3. Snake animation removed; navigation has standard Material highlight.

---

## 11. Out-of-scope (documented for posterity)

| Story | Why deferred |
|---|---|
| OOS-001 — E2E-encrypted Supabase sync | Requires ongoing infra + cost; flagged P2 by PM. Documented in a separate spec when prioritised. |
| OOS-002 — On-device AI weekly review (Gemini Nano / TFLite) | Hardware-dependent; do once core engagement loop ships. |
| OOS-003 — Android home-screen widget | High-value but solo-developer effort; queue after AI ships. |
| OOS-004 — Quick Settings tile + Wear OS | Same reasoning. |
| OOS-005 — Social feed / leaderboards | Explicitly rejected by PM thesis (anti-feature). |
| OOS-006 — Gamification (XP/coins/avatars) | Anti-feature. |
| OOS-007 — In-app subscription paywall | Not in v1; revisit once sync ships. |

---

## 12. Requirement Traceability Matrix

This proves every requirement from the product-owner request maps to at least one story.

| Requirement | Stories |
|---|---|
| PM **P0.1** — Local reminders | ENG-006, SCH-002, SET-007 |
| PM **P0.2** — Streaks + heatmap | ENG-001, ENG-002, ENG-004 |
| PM **P0.3** — Habit detail screen | ENG-003 |
| PM **P0.4** — Encrypted PIN + recovery | AUTH-001, AUTH-006 |
| PM **P0.5** — JSON export / import | DAT-001, DAT-002, SET-009 |
| PM **P0.6** — Today agenda + cross-month calendar | ENG-007, SCH-004 |
| PM **P1.1** — Quantitative habits | UX-001 |
| PM **P1.2** — Categories + color + icon | UX-002 |
| PM **P1.4** — Notes per check-in | ENG-005 |
| PM **P1.5** — Light/dark theme + accent | SET-005, FND-004 |
| PM **P1.3** — Home-screen widget | OOS-003 (deferred) |
| PM **P2.1** — Cloud sync | OOS-001 (deferred) |
| PM **P2.2** — On-device AI review | OOS-002 (deferred) |
| **Refactor settings like padlock + sub-screens** | SET-001, SET-002, SET-003, SET-004, SET-005, SET-006, SET-007, SET-008, SET-009, SET-010, SET-011, SET-012, SET-013, SET-014, SET-015 |
| **Tasks on specific days ("always day 1 of month")** | SCH-001 (`MonthlyDaysSchedule`), SCH-003 (monthly picker) |
| **Optional timing — day / week / month / etc.** | SCH-001 (all six schedule kinds), SCH-002 (optional reminder time) |
| **Groq integration like Readline ("how I feel")** | AI-001, AI-002, AI-003 (system prompt + Q&A template), AI-004, AI-005 (intake screen), AI-006 (review), AI-007 (privacy) |
| **Suggest related todos based on questions / textbox** | AI-005 (multi-question + textbox), AI-006 (accept/edit/dismiss) |
| **Clean code structure like padlock** | FND-001 (folders + DI), FND-002 (repositories), FND-003 (Freezed), FND-004 (theme tokens), FND-005 (GoRouter), FND-006 (ViewModels) |
| **Use same technologies as padlock, latest versions** | §0 stack table; FND-001 acceptance criterion 2 enumerates versions |
| **PIN + signup like vault-it** | AUTH-001 (PBKDF2 4-digit), AUTH-002 (custom keypad), AUTH-003 (two-phase create→confirm), AUTH-004 (biometric layered), AUTH-005 (lockout), AUTH-008 (multi-step signup) |
| **Review carefully + cover every requirement** | This document end-to-end; this matrix is the proof. |

---

## 13. Recommended Release Sequence

The PM's "ship in next release" picks were **encrypted PIN → reminders → streaks**. Stretched into a realistic four-release plan that respects the architectural dependency on FND-*:

### Release 1 — Foundation + Auth hardening (4–6 weeks)
- FND-001, FND-002, FND-003, FND-004, FND-005, FND-006
- AUTH-001, AUTH-002, AUTH-003, AUTH-004, AUTH-005, AUTH-006, AUTH-008
- SET-001, SET-002, SET-003, SET-004, SET-011, SET-009, DAT-001, DAT-002, DAT-003
- UX-003

*Outcome:* a credible, Play-Store-ready Habit It with hashed PINs, multi-step signup, padlock-style settings, and proper export/import.

### Release 2 — Engagement loop (3–4 weeks)
- SCH-001, SCH-002, SCH-003, SCH-004
- ENG-001, ENG-002, ENG-003, ENG-004
- ENG-006, SET-007
- SET-005, SET-006, SET-010

*Outcome:* habits become flexible, reminders work, streaks make checking in rewarding, cross-month calendar lands, real light/dark + Arabic.

### Release 3 — AI Coach + Notes (2–3 weeks)
- AI-001, AI-002, AI-003, AI-004, AI-005, AI-006, AI-007
- SET-008
- ENG-005
- ENG-007

*Outcome:* the "How do you feel?" Groq coach ships, notes ship, Today agenda becomes the default landing.

### Release 4 — Quantitative + categories + polish (2–3 weeks)
- UX-001, UX-002
- AUTH-007
- SET-012, SET-013, SET-014, SET-015

*Outcome:* habits can be counters, categories give visual grouping, support / legal / bug-report sub-screens complete the settings build-out.

### Beyond v1
- OOS-001 Sync, OOS-003 widget, OOS-002 on-device AI review — sequenced per future business case.

---

*End of document. Total stories: 6 (FND) + 8 (AUTH) + 15 (SET) + 4 (SCH) + 7 (ENG) + 7 (AI) + 3 (DAT) + 3 (UX) + 7 (OOS) = **60 stories**. Reviewed against the product-owner brief on 2026-06-02; every explicit requirement is mapped in §12.*
