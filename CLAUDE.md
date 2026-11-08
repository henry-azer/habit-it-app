# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Habit It — a standalone offline-first Flutter habit tracker. Local authentication (PIN + biometric), monthly habit lists, daily check-ins, and stats. No backend; all data lives in `SharedPreferences`.

This project predates the workspace-level `docs/superpowers/specs/2026-04-02-flutter-unified-standards-design.md`. **Do not retrofit those standards** (Riverpod, Freezed, sealed `Result<T>`, `IAuthService`, etc.) onto this codebase unless explicitly asked — the patterns here are intentionally simpler.

## Build & Run

```bash
flutter pub get
flutter run                                 # debug, attached device/emulator
flutter analyze                             # uses package:flutter_lints/flutter.yaml
flutter test                                # all tests
flutter test test/widget_test.dart          # single test file
flutter build apk --release
flutter build appbundle --release
```

The Dart SDK constraint in `pubspec.yaml` is `>=2.18.2 <3.0.0` — Flutter 3.x with that bound. No code generation step (no Freezed / json_serializable / build_runner).

The release APK is distributed via Google Drive — URL lives in `README.md` and was last bumped in commit `805dec5`.

## Architecture

Layered clean-architecture-lite, all local:

```
lib/
  main.dart              # boots WidgetsFlutterBinding, awaits di.init(), runs HabitItApp
  app.dart               # MaterialApp: theme, routes, locale setup
  injection_container.dart  # GetIt registrations (sl = GetIt.instance)
  config/                # routes, themes, locale
  core/
    managers/            # storage-manager, biometric-authentication (abstract I*Manager + impl)
    utils/               # AppStrings, AppColors, AppTextStyles, DateUtil, app_localization_strings, etc.
    validation/
    widgets/             # shared widgets: appbar, buttons, day-picker, month-picker, otp, forms…
  data/
    datasources/{app,habit,user}/   # *_local_datasource.dart — abstract + Impl, talk to IStorageManager
    entities/            # plain Dart classes with hand-written toJson/fromJson (Habit, User, app)
    dtos/                # habit_progress, habit_stats
    enums/               # day, gender, habit_state
  features/
    splash/   onboarding/   signup/{base-signup,local-pin,local-biometric,success-signup}/
    signin/{pin-signin,biometric-signin}/
    habit/{habit,add-habit,manage-habits,stats/{stats,month-stats,month-progress}}/
    profile/  app-navigator/
```

Each feature ends in `presentation/{screens,widgets}/`. There is **no `domain/` layer** and **no repository abstraction** above data sources — screens pull data sources directly from GetIt (`GetIt.instance<HabitLocalDataSource>()`) and call them. State is managed with plain `StatefulWidget` + `setState`. `provider` is in `pubspec.yaml` but the codebase doesn't use it for app state.

### Data flow

`Screen → HabitLocalDataSource (impl) → IStorageManager (LocalStorageManager wraps SharedPreferences) → JSON-encoded entity in prefs`

Habits are stored per-month, keyed by `AppLocalStorageKeys.habitMonth + monthString` (see `date_util.dart` for the month-string format). When the current month has no data and the previous month does, `HabitScreen._initMonthHabits()` prompts the user to carry habits forward via `moveMonthHabits`.

### Routing

Named routes only — no GoRouter. All route names are constants on `Routes` and dispatched in `AppRoutes.onGenerateRoute` (`lib/config/routes/app_routes.dart`). Some routes expect typed `routeSettings.arguments` (e.g. `appHabitManage` → `int`, `appHabitMonthStats`/`appHabitMonthProgress` → `DateTime`) — when adding a route that takes args, follow this same `arguments as T` cast pattern and document the expected type at the call site.

### Localization

Custom JSON-driven, not `flutter_intl` / ARB. Strings live in `assets/lang/en.json`. Access with:

```dart
AppLocalizationHelper.translate(context, AppLocalizationKeys.someKey)
```

Add new keys to **both** `assets/lang/en.json` and `lib/core/utils/app_localization_strings.dart`.

### Theming

Single `appTheme()` in `lib/config/themes/app_theme.dart`. Colors come from `core/utils/app_colors.dart`, text styles from `app_text_styles.dart`. `Roboto` is bundled in `assets/fonts/roboto/` and declared in `pubspec.yaml`.

### Dependency injection

All wiring lives in `lib/injection_container.dart`. Pattern:

1. Define an abstract interface (e.g. `HabitLocalDataSource`, `IStorageManager`, `IBiometricAuthenticationManager`).
2. Implement it (`HabitLocalDataSourceImpl`).
3. `sl.registerLazySingleton<Interface>(() => Impl(dep: sl()));` in `init()`.

When adding a new data source / manager, follow this exact shape and register it in `init()`.

## Conventions

- **File naming:** `kebab-case/` directories, `snake_case.dart` files, `*_local_datasource.dart`, `*_screen.dart`, `*_widget.dart`, `*_manager.dart`.
- **Interfaces:** managers use the `I`-prefix (`IStorageManager`), data sources don't (`HabitLocalDataSource` is itself the abstract type, paired with `*Impl`).
- **Entities** are mutable classes with `late` fields and explicit `toJson`/`fromJson` — keep that style when extending; do not introduce Freezed here.
- **Enum persistence:** `HabitState` is serialized by `.index` and rehydrated via `HabitState.values[value]` — preserve enum *order* when editing or you will corrupt stored data.
- **Lints:** `flutter_lints` defaults only; no extra rules customized in `analysis_options.yaml`.
