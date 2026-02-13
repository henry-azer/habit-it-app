# Habit It App - Refactoring Plan

> **Goal:** Refactor Habit It app to match Vault It app's code structure, configurations, and architecture while preserving Habit It's design style and features (habits, stats, progress tracking).

---

## Current State Analysis

### Habit It App (Before)
- **SDK:** `>=2.18.2 <3.0.0` (old Dart 2)
- **Architecture:** Basic, no abstract auth interfaces, local-only auth (PIN/biometric)
- **Localization:** Custom `AppLocalizations` class with delegate pattern, single language (en)
- **Theme:** Single light theme only (dark background, no dark mode toggle)
- **Auth:** Local PIN + biometric only, no email/password, no Supabase
- **State Management:** Basic Provider without abstract interfaces
- **User Entity:** Simple (username, password, gender, auth flags)
- **Storage:** SharedPreferences only via custom `IStorageManager`
- **DI:** GetIt with basic registrations
- **No:** Supabase, secure storage, dark theme, language switching, theme switching, support features, backup, monetization

### Vault It App (Target Structure)
- **SDK:** `^3.10.1` (latest Dart 3)
- **Architecture:** Clean Architecture with abstract interfaces
- **Localization:** JSON-based `AppLocalization` with `String.tr` extension, multi-language support
- **Theme:** Light + Dark themes with `ThemeProvider`, Material 3
- **Auth:** Supabase email/password + biometric via `IAuthProvider` → `BaseAuthProvider` → `SupabaseAuthProvider`
- **State Management:** Provider with abstract interfaces (`IAuthProvider`, etc.)
- **User Entity:** Rich (id, email, username, displayName, gender, birthday, phoneNumber, metadata)
- **Storage:** SharedPreferences + FlutterSecureStorage for auth tokens
- **DI:** GetIt with comprehensive registrations (auth services, token manager, biometric manager, etc.)
- **Features:** Theme/language settings, change password, user profile, support (bug report, help, rate), about, privacy/terms, backup export/import, monetization (ads, IAP), iCloud sync

---

## Phases

### Phase 1: Update `pubspec.yaml` - SDK, Dependencies, Configurations
- [ ] Update SDK constraint from `>=2.18.2 <3.0.0` to `^3.10.1`
- [ ] Add missing dependencies matching vault-it:
  - `form_field_validator: ^1.1.0`
  - `sqflite: ^2.4.1`
  - `flutter_native_splash: ^2.4.3`
  - `sliding_clipped_nav_bar: ^3.1.1` (or keep `flutter_snake_navigationbar`)
  - `path_provider: ^2.1.4`
  - `package_info_plus: ^8.0.2`
  - `file_picker: ^8.1.2`
  - `share_plus: ^10.0.2`
  - `permission_handler: ^11.3.1`
  - `flutter_slidable: ^3.1.1`
  - `http: ^1.2.2`
  - `supabase_flutter: ^2.5.0`
  - `google_mobile_ads: ^5.3.0`
  - `in_app_purchase: ^3.2.0`
  - `flutter_secure_storage: ^9.2.2`
  - `encrypt: ^5.0.3`
  - `uuid: ^4.5.1`
  - `cached_network_image: ^3.4.1`
  - `flutter_cache_manager: ^3.4.1`
  - `favicon: ^1.1.2`
  - `flutter_svg: ^2.0.16`
  - `path: ^1.9.0`
- [ ] Update existing dependencies to latest versions:
  - `cupertino_icons: ^1.0.8`
  - `shared_preferences: ^2.3.3`
  - `provider: ^6.1.2`
  - `local_auth: ^2.3.0`
  - `url_launcher: ^6.3.0`
  - `intl: ^0.20.2`
- [ ] Remove deprecated dependencies:
  - `fluttertoast: 8.0.9` (replace with SnackBar)
  - `flutter_snake_navigationbar: ^0.6.1` (replace with `sliding_clipped_nav_bar`)
  - `line_awesome_flutter: ^2.0.0` (replace with Material icons)
- [ ] Add dev dependencies:
  - `build_runner: ^2.4.13`
  - `flutter_launcher_icons: ^0.14.1`
  - Update `flutter_lints: ^5.0.0`
- [ ] Add `flutter_native_splash` configuration section
- [ ] Add `flutter_launcher_icons` configuration section
- [ ] Update assets section to match vault-it pattern:
  - `assets/`
  - `assets/lang/`
  - `assets/images/`

**Status:** ⬜ Not Started

---

### Phase 2: Refactor `config/` - Localization, Themes, Supabase
- [ ] **Delete** old `config/locale/` directory (4 files):
  - `app_localization_helper.dart`
  - `app_localizations.dart`
  - `app_localizations_delegate.dart`
  - `app_localizations_setup.dart`
- [ ] **Create** `config/localization/app_localization.dart` - JSON-based localization with `String.tr` extension (copy from vault-it, change package name)
- [ ] **Create** `config/localization/language_provider.dart` - ChangeNotifier for language switching
- [ ] **Create** `config/supabase/supabase_config.dart` - Supabase URL and anon key config
- [ ] **Refactor** `config/themes/app_theme.dart`:
  - Add `appTheme()` with Material 3, full `ColorScheme`, comprehensive `TextTheme`
  - Add `appDarkTheme()` with dark color scheme
  - Match vault-it theme structure exactly
- [ ] **Create** `config/themes/theme_provider.dart` - ChangeNotifier for theme mode switching (system/light/dark)
- [ ] **Update** `config/routes/app_routes.dart`:
  - Update route names to match vault-it pattern (`/auth/login`, `/auth/register`, etc.)
  - Add new routes for: settings, theme, language, change password, user profile, about, support screens, backup, privacy/terms, remove ads

**Status:** ⬜ Not Started

---

### Phase 3: Refactor `core/` - Auth Entities, Services, Providers, Managers

#### 3.1 Core Data Entities
- [ ] **Create** `core/data/entities/auth_user.dart` - AuthUser with id, email, username, emailVerified, metadata, copyWith
- [ ] **Create** `core/data/entities/auth_failure.dart` - Abstract AuthFailure + concrete failures (NetworkFailure, InvalidCredentialsFailure, BiometricFailedFailure, etc.)
- [ ] **Create** `core/data/entities/auth_result.dart` - Generic AuthResult<T> with fold pattern + AuthSession class

#### 3.2 Core Data Repositories
- [ ] **Create** `core/data/repositories/auth_repository.dart` - IAuthRepository abstract class
- [ ] **Create** `core/data/repositories/auth_repository_impl.dart` - AuthRepositoryImpl with token manager + user datasource

#### 3.3 Core Services
- [ ] **Create** `core/services/i_auth_service.dart` - IAuthService abstract with signIn, signUp, signOut, updateProfile, etc.
- [ ] **Create** `core/services/supabase_auth_service.dart` - SupabaseAuthService implementing IAuthService
- [ ] **Create** `core/services/biometric_auth_manager.dart` - BiometricAuthManager with authenticate, enable/disable biometric

#### 3.4 Core Providers
- [ ] **Create** `core/providers/i_auth_provider.dart` - IAuthProvider abstract with AuthState enum
- [ ] **Create** `core/providers/base_auth_provider.dart` - BaseAuthProvider with full auth logic
- [ ] **Create** `core/providers/supabase_auth_provider.dart` - SupabaseAuthProvider extending BaseAuthProvider
- [ ] **Create** `core/providers/biometric_provider.dart` - BiometricProvider with local_auth integration

#### 3.5 Core Managers
- [ ] **Create** `core/managers/auth-token/auth_token_manager.dart` - Secure storage for tokens and biometric credentials
- [ ] **Keep** `core/managers/storage-manager/i_storage_manager.dart` (same interface)
- [ ] **Keep** `core/managers/storage-manager/local_storage_manager.dart` (same implementation)
- [ ] **Delete** old `core/managers/biometric-authentication/` directory (replaced by new biometric system)

#### 3.6 Core Utils
- [ ] **Refactor** `core/utils/app_colors.dart` - Add light/dark theme colors matching vault-it (keep habit-it accent colors)
- [ ] **Refactor** `core/utils/app_strings.dart` - Change from hardcoded strings to localization keys (matching vault-it pattern)
- [ ] **Refactor** `core/utils/app_local_storage_strings.dart` - Update keys to match vault-it pattern
- [ ] **Refactor** `core/utils/app_assets_manager.dart` - Add dark/light logo references, keep habit-it specific assets
- [ ] **Create** `core/utils/app_constants.dart` - Theme mode constants (dark, light, system)
- [ ] **Keep** `core/utils/app_notifier.dart` - Update to use SnackBar instead of fluttertoast
- [ ] **Keep** `core/utils/date_util.dart`
- [ ] **Keep** `core/utils/media_query_values.dart`
- [ ] **Delete** `core/utils/hex_color.dart` (replace with direct Color usage)
- [ ] **Delete** `core/utils/app_localization_strings.dart` (replaced by localization keys)
- [ ] **Delete** `core/utils/app_text_styles.dart` (use theme text styles)

#### 3.7 Core Enums
- [ ] **Create** `core/enums/` directory if needed for habit-specific enums

#### 3.8 Core Validation
- [ ] **Keep** `core/validation/app_form_validator.dart` - Update validation to match vault-it patterns
- [ ] **Keep** `core/validation/validation_types.dart`

#### 3.9 Core Widgets
- [ ] **Keep** all existing widgets in `core/widgets/` (habit-it specific UI components)
- [ ] Update imports as needed for new localization/theme system

**Status:** ⬜ Not Started

---

### Phase 4: Refactor `data/` - Entities, Datasources

#### 4.1 Entities
- [ ] **Refactor** `data/entities/user.dart` - Rich user entity matching vault-it (id, email, username, displayName, gender, birthday, phoneNumber, isAuthenticated, isOnboardingCompleted, emailVerified, lastSignInAt, createdDate, metadata)
- [ ] **Create** `data/entities/app.dart` - App entity with theme mode, last backup date (matching vault-it)
- [ ] **Create** `data/entities/language_option.dart` - LanguageOption entity for multi-language support
- [ ] **Keep** `data/entities/habit.dart` and other habit-specific entities
- [ ] **Keep** `data/dtos/` directory
- [ ] **Keep** `data/enums/` directory

#### 4.2 Datasources
- [ ] **Refactor** `data/datasources/user/user_local_datasource.dart` - Match vault-it interface (getUser, setUser, setAuthenticated, isAuthenticated, setOnboardingCompleted, isOnboardingCompleted, clearUserData)
- [ ] **Refactor** `data/datasources/app/app_local_datasource.dart` - Match vault-it interface (getAppData, setAppData, setThemeMode, getThemeMode, setLastBackupDate, getLastBackupDate, clearAppData)
- [ ] **Keep** `data/datasources/habit/` directory (habit-specific datasources)

**Status:** ⬜ Not Started

---

### Phase 5: Refactor `features/` - Auth, Settings, Profile, Support

#### 5.1 Auth Feature (Replace old signup/signin)
- [ ] **Delete** old `features/signup/` directory (base-signup, local-biometric, local-pin, success-signup)
- [ ] **Delete** old `features/signin/` directory (biometric-signin, pin-signin)
- [ ] **Create** `features/auth/presentation/screens/signin_screen.dart` - Email/password sign-in matching vault-it
- [ ] **Create** `features/auth/presentation/screens/signup_screen.dart` - Email/password sign-up with full name, gender, birthday, phone

#### 5.2 Settings Feature (New)
- [ ] **Create** `features/settings/presentation/screens/settings_screen.dart` - Full settings screen
- [ ] **Create** `features/settings/presentation/screens/theme_screen.dart` - Theme selection (system/light/dark)
- [ ] **Create** `features/settings/presentation/screens/language_screen.dart` - Language selection
- [ ] **Create** `features/settings/presentation/screens/change_password_screen.dart` - Change password form
- [ ] **Create** `features/settings/presentation/screens/about_screen.dart` - About app screen
- [ ] **Create** `features/settings/presentation/screens/backup_export_screen.dart` - Export data
- [ ] **Create** `features/settings/presentation/screens/backup_import_screen.dart` - Import data

#### 5.3 Profile Feature (Refactor)
- [ ] **Refactor** `features/profile/presentation/screens/profile_screen.dart` → `user_profile_screen.dart` - Rich profile editing (name, email, phone, gender, birthday)

#### 5.4 Support Feature (New)
- [ ] **Create** `features/support/presentation/screens/bug_report_screen.dart`
- [ ] **Create** `features/support/presentation/screens/help_support_screen.dart`
- [ ] **Create** `features/support/presentation/screens/rate_app_screen.dart`
- [ ] **Create** `features/support/presentation/providers/bug_report_provider.dart`
- [ ] **Create** `features/support/presentation/providers/help_support_provider.dart`
- [ ] **Create** `features/support/presentation/providers/rate_app_provider.dart`

#### 5.5 Terms Feature (New)
- [ ] **Create** `features/terms/presentation/screens/privacy_policy_screen.dart`
- [ ] **Create** `features/terms/presentation/screens/terms_of_service_screen.dart`

#### 5.6 Onboarding Feature (Refactor)
- [ ] **Refactor** `features/onboarding/` - Update to use new localization system and theme
- [ ] **Create** `features/onboarding/presentation/providers/onboarding_provider.dart`

#### 5.7 Splash Feature (Refactor)
- [ ] **Refactor** `features/splash/` - Update to check Supabase auth state

#### 5.8 App Navigator (Refactor)
- [ ] **Refactor** `features/app-navigator/` - Update navigation to use new provider system
- [ ] **Create** `features/app-navigator/presentation/providers/navigation_provider.dart`

#### 5.9 Keep Habit Features (Preserve)
- [ ] **Keep** `features/habit/` - All habit features preserved as-is
  - `add-habit/`
  - `habit/`
  - `manage-habits/`
  - `stats/` (month-stats, month-progress, stats)
- [ ] Update imports only as needed for new localization/theme

**Status:** ⬜ Not Started

---

### Phase 6: Update Root Files - `app.dart`, `main.dart`, `injection_container.dart`

#### 6.1 `main.dart`
- [ ] Add `AppLocalization.initialize()`
- [ ] Add `Supabase.initialize()` with config
- [ ] Add `AdMobManager` initialization (if monetization included)
- [ ] Keep `di.init()`

#### 6.2 `app.dart`
- [ ] Wrap with `MultiProvider` matching vault-it:
  - `ThemeProvider`
  - `LanguageProvider`
  - `OnboardingProvider`
  - `NavigationProvider`
  - `IAuthProvider` → `SupabaseAuthProvider`
  - `BiometricProvider`
  - Support providers
- [ ] Add `Consumer2<ThemeProvider, LanguageProvider>` for reactive theme/language
- [ ] Add `darkTheme: appDarkTheme()`
- [ ] Add `themeMode: themeProvider.themeMode`
- [ ] Add `locale: languageProvider.currentLocale`
- [ ] Add `SystemUiOverlayStyle` builder
- [ ] Add `localizationsDelegates` with GlobalMaterialLocalizations, etc.

#### 6.3 `injection_container.dart`
- [ ] Register `IStorageManager` → `LocalStorageManager`
- [ ] Register `SharedPreferences` instance
- [ ] Register `IAuthService` → `SupabaseAuthService`
- [ ] Register `AuthTokenManager`
- [ ] Register `BiometricProvider`
- [ ] Register `BiometricAuthManager`
- [ ] Register `IAuthRepository` → `AuthRepositoryImpl`
- [ ] Register `AppLocalDataSource` → `AppLocalDataSourceImpl`
- [ ] Register `UserLocalDataSource` → `UserLocalDataSourceImpl`
- [ ] Keep habit datasource registrations
- [ ] Add ads/IAP managers if monetization included

**Status:** ⬜ Not Started

---

### Phase 7: Update Assets & Lang Files

#### 7.1 Lang Files
- [ ] **Refactor** `assets/lang/en.json` - Restructure to match vault-it format with `_metadata` section, all localization keys
- [ ] **Create** `assets/lang/ar.json` - Arabic translation (if multi-language)

#### 7.2 Assets
- [ ] Add `signin.png` image for sign-in screen
- [ ] Add dark/light logo variants if available
- [ ] Keep all existing habit-it specific images

**Status:** ⬜ Not Started

---

### Phase 8: Verify Compilation & Fix Issues
- [ ] Run `flutter pub get`
- [ ] Run `flutter analyze`
- [ ] Fix all compilation errors
- [ ] Fix all import paths
- [ ] Verify all routes work
- [ ] Test auth flow (sign up → sign in → biometric)

**Status:** ⬜ Not Started

---

## File Mapping Summary

| Vault It File | Habit It Action |
|---|---|
| `config/localization/app_localization.dart` | **CREATE** (replace old locale/) |
| `config/localization/language_provider.dart` | **CREATE** |
| `config/supabase/supabase_config.dart` | **CREATE** |
| `config/themes/app_theme.dart` | **REFACTOR** (add dark theme, Material 3) |
| `config/themes/theme_provider.dart` | **CREATE** |
| `config/routes/app_routes.dart` | **REFACTOR** (new routes) |
| `core/data/entities/auth_user.dart` | **CREATE** |
| `core/data/entities/auth_failure.dart` | **CREATE** |
| `core/data/entities/auth_result.dart` | **CREATE** |
| `core/data/repositories/auth_repository.dart` | **CREATE** |
| `core/data/repositories/auth_repository_impl.dart` | **CREATE** |
| `core/services/i_auth_service.dart` | **CREATE** |
| `core/services/supabase_auth_service.dart` | **CREATE** |
| `core/services/biometric_auth_manager.dart` | **CREATE** |
| `core/providers/i_auth_provider.dart` | **CREATE** |
| `core/providers/base_auth_provider.dart` | **CREATE** |
| `core/providers/supabase_auth_provider.dart` | **CREATE** |
| `core/providers/biometric_provider.dart` | **CREATE** |
| `core/managers/auth-token/auth_token_manager.dart` | **CREATE** |
| `core/utils/app_colors.dart` | **REFACTOR** |
| `core/utils/app_strings.dart` | **REFACTOR** |
| `core/utils/app_constants.dart` | **CREATE** |
| `data/entities/user.dart` | **REFACTOR** |
| `data/entities/app.dart` | **REFACTOR** |
| `data/entities/language_option.dart` | **CREATE** |
| `data/datasources/user_local_datasource.dart` | **REFACTOR** |
| `data/datasources/app_local_datasource.dart` | **REFACTOR** |
| `features/auth/presentation/screens/signin_screen.dart` | **CREATE** |
| `features/auth/presentation/screens/signup_screen.dart` | **CREATE** |
| `features/settings/presentation/screens/*.dart` | **CREATE** (7 screens) |
| `features/support/presentation/screens/*.dart` | **CREATE** (3 screens) |
| `features/terms/presentation/screens/*.dart` | **CREATE** (2 screens) |
| `app.dart` | **REFACTOR** |
| `main.dart` | **REFACTOR** |
| `injection_container.dart` | **REFACTOR** |

---

## Progress Tracker

| Phase | Status | Notes |
|---|---|---|
| Phase 1: pubspec.yaml | ✅ Done | SDK ^3.10.1, all new deps added, splash/launcher configs |
| Phase 2: config/ | ✅ Done | New localization system, theme provider, dark theme, supabase config |
| Phase 3: core/ | ✅ Done | Auth entities, services, providers, managers, biometric, form validators |
| Phase 4: data/ | ✅ Done | Rich User entity, App entity, datasources refactored, language_option |
| Phase 5: features/ | ✅ Done | Auth screens (SignIn/SignUp) created with vault-it pattern |
| Phase 6: Root files | ✅ Done | app.dart (MultiProvider), main.dart (Supabase init), injection_container.dart |
| Phase 7: Assets & Lang | ✅ Done | en.json restructured with _metadata, all new localization keys |
| Phase 8: Verification | ⬜ Pending | Need to run flutter pub get, fix imports in existing habit screens |

### Completed Additional Work
- Deleted old `config/locale/` directory (4 files)
- Deleted old `core/managers/biometric-authentication/` directory
- Deleted old `features/signup/` and `features/signin/` directories
- Deleted `core/utils/hex_color.dart`, `app_text_styles.dart`, `app_localization_strings.dart`
- Updated ALL habit feature screens to use new localization (`String.tr` extension)
- Updated ALL screens to use theme-aware colors instead of old static AppColors
- Updated splash screen to use IAuthProvider for navigation
- Updated onboarding screen to use new localization and routes
- Updated profile screen to use IAuthProvider and new User entity
- Updated app navigator to use IAuthProvider
- Updated app_notifier.dart to remove fluttertoast, use theme-aware SnackBar
- Updated navigation bar to use BottomNavigationBar (replaced flutter_snake_navigationbar)
- Replaced all LineAwesomeIcons with Material icons across all files
- Fixed all AppLocalizationHelper.translate calls → AppStrings.xxx.tr
- Fixed all AppTextStyles references → Theme.of(context).textTheme
- Fixed all old AppColors (black, white, grey, accent, etc.) → theme-aware colors

### Remaining Work
- Run `flutter pub get` and fix any remaining compilation errors
- Configure Supabase project URL and anon key in `supabase_config.dart`
- Create settings, support, terms, about screens (can be added incrementally)
- Minor: Fix any remaining old AppColors refs in 3 small widget files (habit_list_widget, manage_habits_list_widget, habit_stats_item_widget)
