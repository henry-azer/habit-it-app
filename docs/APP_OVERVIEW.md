# Habit It — App Reference

A complete reference for the Habit It Flutter app: identity, design system, widget library, features, technical patterns, and end-to-end flows. Sourced from the codebase as of `master`.

---

## 1. Identity

| Field | Value |
|------|-------|
| App name | **Habit It** (`AppStrings.appName`) |
| Tagline / splash title | `HABIT IT` |
| Creator | Henry Azer ([@henry-azer](https://github.com/henry-azer)) |
| Pitch | An offline-first mobile companion to build healthier routines — create daily/weekly habits, check them off, see streaks, secured by local PIN or biometric. |
| Distribution | Android APK via Google Drive ([link in `README.md`](../README.md)) |
| Package name | `habit_it` |
| Version | `1.0.0+1` (`pubspec.yaml`) |
| Dart SDK | `>=2.18.2 <3.0.0` |
| Locale | `en` only (hard-coded in `app.dart`; `ar` placeholder exists in `AppStrings` but is not wired up) |
| Code lives in | [`lib/`](../lib/) |
| Social handles (creator) | LinkedIn, GitHub, Facebook, WhatsApp, Outlook email — surfaced on the **About Us** screen |

---

## 2. Design System

### 2.1 Color Palette

Defined in [`lib/core/utils/app_colors.dart`](../lib/core/utils/app_colors.dart). Built on a custom `HexColor` helper ([`hex_color.dart`](../lib/core/utils/hex_color.dart)) that parses `#RRGGBB` or `#AARRGGBB` strings.

The product is **monochrome-first** — pure black background, white surface accents, deep teal panels, and a coral pop only for the (unused) `secondaryAccent` token.

| Token | Hex | Where used |
|-------|-----|-----------|
| `primary` | `#000000` | App background, primary brand |
| `secondary` | `#FFFFFF` | Buttons, surfaces, borders |
| `accent` | `#1C2D32` | Card backgrounds (habit rows, header curves, speed-dial open state) |
| `secondaryAccent` | `#FF725E` | Defined but not currently consumed |
| `background` | `#000000` | `scaffoldBackgroundColor` |
| `fontPrimary` | `#FFFFFF` | Text on dark surfaces |
| `fontSecondary` | `#000000` | Text on light surfaces (button labels) |
| `button` | `#FFFFFF` | Default button fill |
| `border` / `borderSecondary` | `#FFFFFF` / `#000000` | Outlines |
| `snackbar` | `#FFFFFF` | Toast / snackbar background |
| `error` | `#900C3F` | Form-field error border + error text |
| `grey` | `#808080` | Hints, disabled icons, neutral state |
| `red` | `#F44336` | Failed / not-done habit indicator, logout |
| `green` | `#00A36C` | Done habit indicator, active save action |
| `black` / `white` | `#000000` / `#FFFFFF` | Pure swatches |
| `facebook` | `#3B5998` | Facebook brand chip |
| `github` | `#000000` | GitHub brand chip |
| `linkedin` | `#0072B1` | LinkedIn brand chip |
| `whatsapp` | `#075E54` | WhatsApp brand chip |
| `outlook` | `#127CD6` | Mail brand chip |

A 10-stop `MaterialColor primarySwatch` is built around `accent` (`#1C2D32`), spanning `#E4E8EA` (50) → `#050608` (900), used as the `ThemeData.primarySwatch`.

### 2.2 Typography

Family: **Roboto** (bundled in [`assets/fonts/roboto/`](../assets/fonts/roboto/), declared in `pubspec.yaml`). All ten weight/style variants are shipped (Thin, Light, Regular, Medium, Bold + italics).

Reference token: `AppFonts.roboto` ([`app_assets_manager.dart`](../lib/core/utils/app_assets_manager.dart)).

Type scale lives in [`lib/core/utils/app_text_styles.dart`](../lib/core/utils/app_text_styles.dart) — there is **no** generic h1/h2/body scale; every style is named per screen / element. Sizes roughly cluster as:

| Bucket | px | Examples |
|--------|-----|----------|
| Display | 52 (w900) | `splashText` |
| Hero | 30–32 (w400) | `onboardingSubtitle`, `signupSubtitle` |
| Title | 24–28 (w300–w400) | `headerTitle`, `headerTitle2`, `profileTitle` |
| Section | 20–22 (w300–w400) | `appbarTitle` (with `1.4` letter-spacing), `signupWith`, `signupPIN` |
| Body | 16–18 (w300–w400) | `signupBodyDescription`, `habitNameText`, `signinDescription` |
| Caption / meta | 14–15 (w300–w400) | `statsDescription`, `alertDialogActionButton` |

The `appbarTitle` style is the only one with explicit `letterSpacing` (1.4). All styles inherit `fontFamily: AppFonts.roboto`.

### 2.3 Theme

[`lib/config/themes/app_theme.dart`](../lib/config/themes/app_theme.dart) — a single light-`Brightness` theme on a pure-black background:

```dart
ThemeData(
  backgroundColor: AppColors.background,    // #000000
  primaryColor: AppColors.background,
  hintColor: AppColors.white,
  brightness: Brightness.light,
  primarySwatch: AppColors.primarySwatch,
  scaffoldBackgroundColor: AppColors.background,
  unselectedWidgetColor: AppColors.white,
);
```

> README claims a "Dark Mode option" — in the current code the app is dark-by-default and there is no light/dark switcher. Treat the README line as aspirational.

### 2.4 Imagery & Iconography

- **Image assets** are listed in [`AppImageAssets`](../lib/core/utils/app_assets_manager.dart) under `assets/images/`. Notable: `logo.png` (splash), `onboarding_1..3.png`, `signup.png`, `signup_success.png`, `pin.png`, `biometric.png`, `male.png` / `female.png` (profile avatars), `henry.jpg` (creator avatar in About Us), `add_habit.png`, `empty_habits.png`, `remove.png`, `stats_1.png`, `stats_2.png`.
- **Icons** come from two sources:
  - `Icons.*` (Material) — used for habit-state markers (`check`, `close`, `remove`, `delete_outline`), form-field icons.
  - `LineAwesomeIcons.*` (`line_awesome_flutter` package) — used for navigation (`clipboard_list`, `pie_chart`, `user`), profile menu (`user_edit`, `info`, `alternate_sign_out`), habit screen speed-dial (`pushed`, `tools`, `list`), header back arrow (`angle_left`), edit/save in manage screen (`save`, `link`, `unlink`), social chips (`linkedin_in`, `github`, `facebook_f`, `what_s_app`).
- The **app icon** is regenerated from `ios/Runner/Assets.xcassets/AppIcon.appiconset/` (the only file currently modified vs. HEAD).

### 2.5 Spacing & Layout

- No central spacing token. Spacing is inline: `SizedBox(height: 10/15/20/30)` for static gaps, and `MediaQuery.of(context).size.height * 0.02..0.15` (or `context.height * X` via the `MediaQueryValues` extension) for proportional gaps.
- The `MediaQueryValues` extension on `BuildContext` ([`media_query_values.dart`](../lib/core/utils/media_query_values.dart)) is the canonical sizing helper:
  ```dart
  context.height       // MediaQuery.size.height
  context.width        // MediaQuery.size.width
  context.toPadding    // viewPadding.top
  context.bottom       // viewInsets.bottom
  ```
- Header curves: `HeaderWidget` uses `borderRadius: bottom-left 60 + bottom-right 60` over `AppColors.accent` for the curved-panel look that anchors most secondary screens.
- Most forms use `padding: EdgeInsets.symmetric(horizontal: 40)` around their column body.

---

## 3. Widget Library (`lib/core/widgets/`)

All reusable UI primitives. Used across features.

### 3.1 App Bars

| Widget | File | Use |
|--------|------|-----|
| `CupertinoAppBar` | [`appbar/cupertino_app_bar_widget.dart`](../lib/core/widgets/appbar/cupertino_app_bar_widget.dart) | A `CupertinoNavigationBar` thinly wrapped to implement `ObstructingPreferredSizeWidget` (height 50, no border). Used on splash → signup → signin flows. |
| `HeaderWidget` | [`appbar/header_widget.dart`](../lib/core/widgets/appbar/header_widget.dart) | The curved-bottom panel header. Optional `LineAwesomeIcons.angle_left` back button at left, centered title. Configurable `height` (default 125), `paddingLeft` factor (default `0.08 * width`). Used on Add-Habit / Manage-Habits / Stats / Month-Stats / Month-Progress. |
| `CalendarAppBar` | `habit/.../widgets/app-bar/calendar_app_bar_widget.dart` | Horizontal scrollable day picker used as `Scaffold.appBar` on the home Habit screen. Configured with `firstDate`, `lastDate`, `selectedDate`, `onDateChanged`, plus theme colors. |

### 3.2 Buttons

| Widget | File | Notes |
|--------|------|-------|
| `ButtonWidget` | [`buttons/button_widget.dart`](../lib/core/widgets/buttons/button_widget.dart) | Generic `ElevatedButton` wrapper with explicit `width`, `height`, `backgroundColor`, `borderColor`, `borderWidth`, `borderRadius`, child. Used for primary CTAs ("Submit", "Let's Goooooo", "Back"). |
| `IconTextButton` | [`buttons/icon_text_button_widget.dart`](../lib/core/widgets/buttons/icon_text_button_widget.dart) | `ElevatedButton` with a `Row(spaceBetween)` of `Text` + `Icon`. Used for biometric/PIN CTAs and social chips on About Us. |

### 3.3 Forms

| Widget | File |
|--------|------|
| `TextFieldWidget` | [`forms/text_field_widget.dart`](../lib/core/widgets/forms/text_field_widget.dart) — generic text field, takes `validateType` (string key from `ValidationTypes`), styles for hint/error/border, `onChange`/`onSave` callbacks. |
| `OTPTextField` | [`otp/otp_text_field_widget.dart`](../lib/core/widgets/otp/otp_text_field_widget.dart) — 5-cell PIN entry; emits the joined PIN through `onSubmit` when the last field is filled. Used on Signup PIN and Signin PIN. Field height 60, box-style cells. |
| `CustomDropdown` | [`dropdown/custom_dropdown.dart`](../lib/core/widgets/dropdown/custom_dropdown.dart) + overlay/items list/search field/animated section/overlay builder | Custom dropdown with overlay positioning & optional search. Used for gender selection on Signup Success and Update Profile. |

### 3.4 Day / Month Pickers

| Widget | File |
|--------|------|
| `SelectWeekDays` | [`day-picker/widgets/select_day.dart`](../lib/core/widgets/day-picker/widgets/select_day.dart) (data model `DayInWeek` in [`day-picker/model/day_in_week.dart`](../lib/core/widgets/day-picker/model/day_in_week.dart)) — multi-select chips for "Mon..Sun"; `onSelect` returns a `List<String>` of day names. Used on Add Habit + Manage Habit edit-mode. Constructed via `DayInWeek.getWeekDays()` (fresh) or `DayInWeek.getWeekDaysBySelectedDays(...)` (preselected). |
| `month_picker` | [`month-picker/month_picker.dart`](../lib/core/widgets/month-picker/month_picker.dart) — `showMonthPicker(context, firstDate, lastDate)` returns a `DateTime?`. Bounded by the app's `initDate` and `lastDate`. Used on the Stats hub to pick the month for the stats table / progress grid. |

### 3.5 Floating Speed Dial

| Widget | File |
|--------|------|
| `FloatingSpeedDial` + `FloatingSpeedDialChild` | [`floating-action-button/floating_speed_dial.dart`](../lib/core/widgets/floating-action-button/floating_speed_dial.dart), [`floating-action-button/floating_speed_dial_child.dart`](../lib/core/widgets/floating-action-button/floating_speed_dial_child.dart) | Expanding FAB on the home screen — children: `Add Habit` (`LineAwesomeIcons.pushed`) and `Manage Habits` (`LineAwesomeIcons.tools`). Configurable open/closed foreground & background colors. |

### 3.6 Titles & Misc

| Widget | File |
|--------|------|
| `TitleDividerWidget` | [`title/title_divider_widget.dart`](../lib/core/widgets/title/title_divider_widget.dart) | Section divider with a centered label: `Expanded(Divider) — Text — Expanded(Divider)`. Used everywhere as section break (e.g. "Habits", "Create New Habit", "Month Stats", `2024-3-15` style date label). |

### 3.7 Feedback (Dialogs / Snackbar / Toast)

[`lib/core/utils/app_notifier.dart`](../lib/core/utils/app_notifier.dart) — single static facade for transient UI:

- `showErrorDialog({context, message})` — Cupertino-style alert with an "Ok" button.
- `showAlertDialog({context, message, onClickYes})` — Yes/Cancel confirmation.
- `showDeleteActionDialog({context, message, descriptionMessage, onClickYes})` — Yes/Cancel with embedded `remove.png` illustration.
- `showMoveHabitsActionDialog({context, message, descriptionMessage, onClickYes, onClickNo})` — Yes/Cancel-with-callback (both sides act), illustration `add_habit.png`.
- `showToast({message, color?, gravity?})` — Fluttertoast wrapper (long duration, bottom by default).
- `showSnackBar({context, message})` — Floating Material `SnackBar` with `snackbar` color and 0.9 opacity.

---

## 4. Features

Each feature lives under `lib/features/<feature>/presentation/{screens,widgets}/`. No `domain/` layer; screens call data sources directly via `GetIt.instance<T>()`.

### 4.1 Splash (`features/splash/`)

- Logo + `HABIT IT` wordmark on pure black.
- Hydrates `App` and `User` from local storage, then routes after 1 s (if registered) or 5 s (first launch):
  - `!app.init` → **Onboarding**
  - `!user.isRegistered` → **Signup**
  - `user.isBiometricAuthenticated` → **Signin Biometric**, else **Signin PIN**.
- Stamps `app.lastDate = today` before going to signin (used by stats to bound the month picker).

### 4.2 Onboarding (`features/onboarding/`)

Three full-screen pages built atop a custom slider (`OnBoardingSlider`) with subordinate widgets `OnboardingItem`, `Background*`, `PageOffsetProvider`. Pages:

1. **Build Better Habits** — `onboarding_1.png`
2. **Optimize Your Time** — `onboarding_2.png`
3. **Track Your Habits** — `onboarding_3.png`

Finish CTA: **"Let's Start"**. On finish: sets `app.init = true` and `pushReplacement → Routes.appSignup`.

### 4.3 Signup hub (`features/signup/base-signup/`)

- Defensive: if `app.init == false` → bounces back to Onboarding.
- Probes `IBiometricAuthenticationManager.isBiometricAuthenticationAvailable()` and conditionally renders a **Biometric** button (fingerprint icon).
- Always renders a **PIN** button (`Icons.pin`).
- Routes to `appSignupBiometric` or `appSignupPIN`.

### 4.4 Signup — PIN (`features/signup/local-pin/`)

- `OTPTextField` with 5 cells.
- On `onSubmit(pin)` → `UserLocalDataSource.setUserPINAuthentication(pin)`:
  - Sets `user.password = pin`, `isAuthenticated = true`, `isPINAuthenticated = true`.
- On success → `pushNamedAndRemoveUntil → Routes.appSignupSuccess`.
- On failure → `AppNotifier.showErrorDialog` with `signup_pin_failed` (note: the localization key falls back to `signup_biometric_failed` due to a typo in [`AppLocalizationKeys.signupPINFailed`](../lib/core/utils/app_localization_strings.dart#L58)).

### 4.5 Signup — Biometric (`features/signup/local-biometric/`)

- Immediately calls `requestBiometricAuthentication()` on mount (`stickyAuth: true`).
- On success → `setUserBiometricAuthentication(true)` (`isAuthenticated = true`, `isBiometricAuthenticated = true`) → `pushNamedAndRemoveUntil → Routes.appSignupSuccess`.
- On failure → `showErrorDialog` and a `IconTextButton` to retry.

### 4.6 Signup Success — Profile capture (`features/signup/success-signup/`)

- Welcomes the user (`signup_success.png` hero), then asks for **Username** (max 16 chars, validated via `ValidationTypes.signupName`) and **Gender** (Male / Female via `CustomDropdown`).
- On submit:
  - Empty username → `showErrorDialog(signup_name_error)`.
  - Empty gender → `showErrorDialog(signup_gender_error)`.
  - `setUsernameAndGender(...)` → `isRegistered = true`.
  - Stamps `app.initDate = today` (the lower bound for stats).
  - `pushReplacementNamed → Routes.app` (enters the main navigator).

### 4.7 Signin — PIN (`features/signin/pin-signin/`)

- Bounces to splash if not registered.
- `OTPTextField` 5-cell PIN entry; compares with `user.password`.
- Success → `setUserAuthentication(true)` → `pushReplacement → Routes.app`.
- Failure → `showSnackBar(signin_pin_invalid)`.

### 4.8 Signin — Biometric (`features/signin/biometric-signin/`)

- Bounces to splash if not registered.
- Calls `verifyBiometricAuthentication()` immediately on mount (`stickyAuth: false`).
- Success → `setUserAuthentication(true)` → `pushReplacement → Routes.app`.
- Manual retry CTA also calls the same handler.

### 4.9 App Navigator (`features/app-navigator/`)

- Three-tab shell using `SnakeNavigationBar` (`flutter_snake_navigationbar` package, `SnakeBarBehaviour.floating`, `SnakeShape.rectangle`):
  1. **Habits** — `LineAwesomeIcons.clipboard_list`
  2. **Stats** — `LineAwesomeIcons.pie_chart`
  3. **Profile** — `LineAwesomeIcons.user`
- Backed by a `PageController` (`PageView` with `AlwaysScrollableScrollPhysics`); tapping a tab animates the page (300 ms, `easeInOut`).
- **Security on background:** observes `WidgetsBindingObserver` — when `AppLifecycleState.paused` or `detached` fires, flips `user.isAuthenticated = false`. Coming back to the app from background therefore re-routes through PIN/Biometric (checked in `initState`).

### 4.10 Habits (home tab) (`features/habit/habit/`)

[`habit_screen.dart`](../lib/features/habit/habit/presentation/screens/habit_screen.dart). The heart of the app.

- `CalendarAppBar` lets the user pick any day within the current month, bounded by `[first-of-month, today]`. Today is highlighted via `events: [_todayDate]`.
- On mount:
  1. `_initMonthHabits()` — checks `isMonthHabitsInit(currentMonth)`. If **not** initialized **and** the previous month has habits, shows the **Move Habits** dialog ("Keep Your Last Month Habits"). Yes copies last-month habits forward via `moveMonthHabits(...,true)`, No just marks the month initialized.
  2. `_loadHabits()` — runs `updateDayHabits(...)` to advance "CREATED → NOT_DONE" for any past day that matches the repeat schedule, then calls `getHabitsByDay(...)`.
- Empty state: `empty_habits.png` + "No habits added for this day. / Try to add some."
- Habit row: `HabitItemWidget`
  - Drag handle (the home list is a `ReorderableListView` via `HabitListWidget`).
  - Tap the **state pill** to toggle Done (`green check`) / Not-Done (`red close`). Default empty state shows a grey horizontal line; suspended day shows a red horizontal line.
  - Tap the **trash icon** to suspend that day for that habit.
- Floating speed-dial: **Add Habit** + **Manage Habits**.

### 4.11 Add Habit (`features/habit/add-habit/`)

- `HeaderWidget(title: "HABIT", backButton: true)`.
- `TextFieldWidget` for habit name (max 20 chars, validated as `signupName`).
- `SelectWeekDays` chip row for the repeat schedule.
- Submit → `addHabit(name, repeatDays, currentMonth)` → pops with `true` so the parent home reloads.
- Empty name → `showSnackBar(habit_name_required)`.

### 4.12 Manage Habits (`features/habit/manage-habits/`)

- Lists every habit registered for the current month (regardless of repeat schedule).
- Each `ManageHabitWidget` is a row with:
  - Drag handle (`ReorderableListView`).
  - Double-tap the habit name → enter edit mode (text field + `SelectWeekDays` preselected with current repeat days).
  - Edit mode: save (`LineAwesomeIcons.save`, green) updates name + repeat-day list; cancel reverts.
  - Out of edit mode: tap the link/unlink icon to suspend/unsuspend the habit for the selected day; trash icon → delete dialog (`showDeleteActionDialog`).
- Header label: `${currentMonth}-${selectedDay}` (e.g. `2026-6-2`).

### 4.13 Stats — Hub (`features/habit/stats/stats/`)

- Two big tappable cards:
  - **Month Stats** → `stats_1.png` → month picker → `Routes.appHabitMonthStats(date)`
  - **Month Progress** → `stats_2.png` → month picker → `Routes.appHabitMonthProgress(date)`
- Month picker is bounded by `[app.initDate, app.lastDate]`.
- Sets `SystemChrome.setPreferredOrientations([portrait + landscape])` to allow rotation downstream.

### 4.14 Month Stats (`features/habit/stats/month-stats/`)

- Reads `HabitStats[]` for the month via `getHabitsStatsByMonth(...)`.
- Renders a `DataTable` (4 cols): **Habit name | Total Done (green) | Total Not (red) | Total**.
- Header: `DateFormat.yMMMM().format(date)` (e.g. "June 2026").
- Total row above the table prints `Total Habits N`.

### 4.15 Month Progress (`features/habit/stats/month-progress/`)

- Forces **landscape** in `initState` (`landscapeLeft + landscapeRight`), restores portrait on `dispose`.
- Reads `HabitProgress[]` (which includes the full `daysStates` map) for the month.
- Renders a `DataTable` with **one column per day** of the month, plus a leading **Habit** label column and a trailing **Total** column (`totalDone/total`).
- Cell glyphs:
  - `DONE` → `Icons.check` in green
  - `NOT_DONE` → `Icons.close` in red
  - `SUSPENDED` → `Icons.remove` in red
  - `CREATED` / unset → `Icons.remove` in grey

### 4.16 Profile (`features/profile/`)

`ProfileScreen` is a tri-mode page: **menu**, **update-profile form**, **about-us**. Switching is local `setState` (no routes).

- **Header** (`ProfileHeaderWidget`):
  - Avatar = `male.png` or `female.png` based on `user.gender`, or `henry.jpg` when in About Us.
  - Title = username, or "Update Profile", or "Henry Azer" (in About Us).
- **Menu** (default):
  - **Update User Profile** (`LineAwesomeIcons.user_edit`) — switch to update mode.
  - **Reset App Data** (`Icons.lock_reset_outlined`) — `showDeleteActionDialog` → `AppLocalDataSource.reset()` → `pushReplacement → Routes.initial`. **This calls `IStorageManager.clearAll()` — wipes ALL `SharedPreferences` keys, not just app keys.**
  - **About Us** (`LineAwesomeIcons.info`) — switch to about mode.
  - **Logout** (`LineAwesomeIcons.alternate_sign_out`, red label, no end-arrow) — routes to biometric or PIN signin depending on `user.isBiometricAuthenticated`. Logout does **not** flip `isAuthenticated = false` directly; the `AppNavigator`'s lifecycle hook handles re-locking on background.
- **Update Profile** (`UpdateProfileWidget`): same form fields as Signup Success (username + gender), saved via `setUsernameAndGender(...)`.
- **About Us** (`AboutUsWidget`): rows of `IconTextButton` social chips:
  - LinkedIn → `https://www.linkedin.com/in/henry-azer`
  - GitHub → `https://github.com/henry-azer`
  - WhatsApp → `https://wa.me/201207885279`
  - Facebook → `https://www.facebook.com/henry.azer0`
  - Mail → `mailto:henryazer@outlook.com`
  - Each launched via `url_launcher`'s `launch(...)`.
  - Bottom "Back" `ButtonWidget`.

---

## 5. Data Model

### 5.1 Entities (`lib/data/entities/`)

| Entity | Fields | Notes |
|--------|--------|-------|
| `App` | `init: bool`, `initDate: String`, `lastDate: String` | Tracks first-run state and the date bounds used by the month picker on Stats. |
| `User` | `id, username, gender, password, isRegistered, isAuthenticated, isPINAuthenticated, isBiometricAuthenticated` | Single-user app; `password` stores the 5-digit PIN **in plaintext** inside `SharedPreferences`. |
| `Habit` | `id, name, createdDate, repeatDays: List<String>, daysStates: Map<int, HabitState>` | The day-index is `DateTime.day` (1..31). Serialized as `{ "<day>": <enum.index> }`. |

All entities are plain Dart classes with **hand-written `toJson()` / `fromJson()`** — no `json_serializable` codegen.

### 5.2 DTOs (`lib/data/dtos/`)

| DTO | Fields |
|-----|--------|
| `HabitStats` | `id, name, total, totalDone` — drives the Month Stats table. |
| `HabitProgress` | `id, name, total, totalDone, daysStates` — drives the Month Progress grid. |

### 5.3 Enums (`lib/data/enums/`)

| Enum | Values |
|------|--------|
| `Day` | `Monday..Sunday` with `.value` extension returning the English name. |
| `Gender` | `male, female` + `genders = ['Male', 'Female']` list for the dropdown. |
| `HabitState` | `CREATED, DONE, NOT_DONE, SUSPENDED` — serialized by `.index`. |

> **Enum order is load-bearing.** `HabitState.values[storedIndex]` reads stored data. Reordering this enum will corrupt every saved habit. Same caution applies to `Day` and `Gender`.

---

## 6. Storage

### 6.1 Backing store

`SharedPreferences` — each value is `jsonEncode(...)`'d to a `String` and decoded back on read. The wrapper is [`LocalStorageManager`](../lib/core/managers/storage-manager/local_storage_manager.dart) implementing [`IStorageManager`](../lib/core/managers/storage-manager/i_storage_manager.dart):

```dart
abstract class IStorageManager {
  Future<T?> getValue<T>(String key);
  Future setValue(String key, dynamic value);
  void removeValue(String key);
  void clearAll();
}
```

### 6.2 Keys ([`app_local_storage_strings.dart`](../lib/core/utils/app_local_storage_strings.dart))

| Key | Purpose | Value shape |
|-----|---------|------------|
| `APP/APP` | App-level state | `App.toJson()` |
| `APP/USER` | Single-user record | `User.toJson()` |
| `APP/HABIT/MONTH/<YYYY>-<M>` | Habit list per month | `List<Habit.toJson()>` |
| `APP/HABIT/MONTH/INIT<YYYY>-<M>` | Has the month been initialized (and possibly carried-forward)? | `bool` |
| `APP/HABIT/INIT/<YYYY>-<M>-<D>` | Has the day been processed by `updateDayHabits`? | `bool` |

**Note:** the month-init key is `habitMonthInit` (`"APP/HABIT/MONTH/INIT"`) concatenated with `<YYYY>-<M>`, so the resulting full key has no hyphen between `INIT` and the date — e.g. `APP/HABIT/MONTH/INIT2026-6`. The day-init key has a trailing slash — e.g. `APP/HABIT/INIT/2026-6-2`.

### 6.3 Reset

`AppLocalDataSource.reset()` calls `IStorageManager.clearAll()` — purges **all** SharedPreferences entries, not just app-namespaced ones.

---

## 7. Habit Engine — Behavioral Rules

The logic in [`habit_local_datasource.dart`](../lib/data/datasources/habit/habit_local_datasource.dart) encodes the product's day-by-day semantics. Key rules:

### 7.1 Initial day states (`_createDaysStates` inside `addHabit`)

When a habit is added on day `N` of a month with `K` total trackable days (`countDaysOfMonth`):

- Day `K` (last trackable day, i.e. today) is `NOT_DONE` **only if** today's weekday matches the habit's repeat schedule; otherwise it's `CREATED`.
- Days `1..K-1` are `CREATED` (unset).
- Future days of the month are **not pre-populated** — they get a state lazily via `updateDayHabits` on the day the user opens the app.

### 7.2 `updateDayHabits(day, month)` — lazy daily roll-forward

Runs from `HabitScreen._loadHabits` on every load. For the given day:

- If `APP/HABIT/INIT/<date>` is already `true`, return (idempotent).
- For each habit in the month:
  - If the habit's `repeatDays` contains `getDayOfWeekName(day)`:
    - If `day.day` isn't in `daysStates` yet → mark `NOT_DONE`.
    - Otherwise → mark `CREATED`. *(Note: this branch effectively re-sets pre-existing entries to `CREATED`. The dominant case in practice is the first branch, since past states never re-enter this codepath thanks to the per-day init flag.)*
- Persist and set the per-day init flag to `true`.

### 7.3 `getHabitsByDay(date, month)` — what the home screen shows

A habit shows up for `date` if any of:

- `daysStates[date.day] == DONE`, **or**
- `daysStates[date.day] == NOT_DONE`, **or**
- `repeatDays.contains(weekday)` **AND** `daysStates[date.day] == CREATED`.

`SUSPENDED` entries are excluded from the daily list.

### 7.4 `toggleHabitStatus(habit, day, month)`

Pure toggle: `DONE ↔ NOT_DONE`. Called when the user taps the green-check pill in `HabitItemWidget`.

### 7.5 `suspendHabit(habit, day, month)` / `unsuspendHabit(...)`

- Suspend: if the day matches the repeat schedule → set `SUSPENDED`; otherwise → set `CREATED` (effectively re-hiding it). This is the trash-icon action in `HabitItemWidget` and the link/unlink in `ManageHabitWidget`.
- Unsuspend: always sets to `NOT_DONE`.

### 7.6 `moveMonthHabits(lastMonth, currentMonth, value)`

When the user lands on a new month with no habits, the **"Keep Your Last Month Habits"** dialog calls this with either `true` (carry forward) or `false` (start clean). On `true` it iterates last month's habits and re-adds them via `addHabit(name, repeatDays, currentMonth)`, which means the new month gets fresh `daysStates` initialized via the rules in §7.1 — it does **not** copy historic Done/Not-Done state.

### 7.7 Reorder

Drag-and-drop persists via `reorderHabit(habit1, habit2, month)` — removes by `oldIndex`, inserts at `newIndex` *in storage order* (not per-day order). Used in both the home `HabitListWidget` and `ManageHabitsListWidget`.

### 7.8 Stats math (`habit_stats_local_datasource.dart`)

For a given month:

- `total` = count of `daysStates.values` where state is `DONE` or `NOT_DONE` (i.e. days the habit actually ran). `CREATED` and `SUSPENDED` are excluded.
- `totalDone` = count of `DONE`.

---

## 8. Authentication

### 8.1 PIN

Stored as plaintext in `User.password` (5-digit). Authentication is a string compare in `signin_pin_screen.dart`:
```dart
if (pin == _authenticatedPIN) { ... }
```
No hashing, no salting. The PIN OTP field is a 5-cell `OTPTextField`.

### 8.2 Biometric

[`BiometricAuthenticationManager`](../lib/core/managers/biometric-authentication/biometric_auth_manager.dart) wraps `LocalAuthentication` (`local_auth` package):

- `requestBiometricAuthentication()` — `stickyAuth: true` (used on Signup).
- `verifyBiometricAuthentication()` — `stickyAuth: false` (used on Signin).
- `isBiometricAuthenticationAvailable()` — `canCheckBiometrics && isDeviceSupported`.
- `enableBiometricAuthentication()` — delegate to `userLocalDataSource.setUserBiometricAuthentication(true)`.

All four are typed against `IBiometricAuthenticationManager`.

### 8.3 Session lifecycle

- Login screens set `user.isAuthenticated = true`.
- `AppNavigatorScreen.didChangeAppLifecycleState`:
  - On `paused` or `detached` → `user.isAuthenticated = false` (persisted).
- On the next foreground, `AppNavigatorScreen.initState → _checkIfUserAuthenticated` re-checks `user.isAuthenticated`; if `false`, routes to PIN or Biometric signin.
- The single-user model means there's no "logout" in the destructive sense; **Profile → Logout** just navigates to the appropriate signin screen.

---

## 9. Routing

Named routes via `Navigator.pushNamed(...)` / `pushReplacementNamed(...)`. All keys are constants on [`Routes`](../lib/config/routes/app_routes.dart#L21), all dispatch in [`AppRoutes.onGenerateRoute`](../lib/config/routes/app_routes.dart#L46).

| Route key | String | Args | Screen |
|-----------|--------|------|--------|
| `initial` | `/` | — | `SplashScreen` |
| `appOnboarding` | `/app/onboarding` | — | `OnboardingScreen` |
| `appSignup` | `/app/signup` | — | `SignupScreen` |
| `appSignupBiometric` | `/app/signup/biometric` | — | `SignupBiometricScreen` |
| `appSignupPIN` | `/app/signup/pin` | — | `SignupPINScreen` |
| `appSignupSuccess` | `/app/signup/success` | — | `SignupSuccessScreen` |
| `appSigninBiometric` | `/app/signin/biometric` | — | `SigninBiometricScreen` |
| `appSigninPIN` | `/app/signin/pin` | — | `SigninPINScreen` |
| `app` | `/app` | — | `AppNavigatorScreen` |
| `appHabit` | `/app/habit` | — | `HabitScreen` (also tab #1 inside `AppNavigatorScreen`) |
| `appHabitAdd` | `/app/habit/add` | — | `AddHabitScreen` (pops `bool` = "should reload") |
| `appHabitManage` | `/app/habit/manage` | `int selectedDay` | `ManageHabitsScreen` |
| `appHabitStats` | `/app/habit/stats` | — | `HabitStatsScreen` (also tab #2) |
| `appHabitMonthStats` | `/app/habit/stats/month-stats` | `DateTime date` | `HabitMonthStatsScreen` |
| `appHabitMonthProgress` | `/app/habit/stats/month-progress` | `DateTime date` | `HabitMonthProgressScreen` |
| `appProfile` | `/app/profile` | — | `ProfileScreen` (also tab #3) |
| `default` | — | — | "No Route Found" Scaffold (from `AppStrings.noRouteFound`) |

Argument passing convention: typed `routeSettings.arguments as T` cast inside `onGenerateRoute`.

---

## 10. Localization

Custom JSON-driven layer ([`config/locale/`](../lib/config/locale/)) — **not** `flutter_intl`, ARB, or generated.

- Translations live in [`assets/lang/en.json`](../assets/lang/en.json).
- Keys are duplicated as Dart constants in [`AppLocalizationKeys`](../lib/core/utils/app_localization_strings.dart).
- Public API: `AppLocalizationHelper.translate(context, AppLocalizationKeys.X)` (returns the English string).
- `app.dart` sets `locale: const Locale('en')` and registers `AppLocalizationsSetup.localizationsDelegates` plus Flutter's built-in delegates (Material / Cupertino / Widgets).
- `AppStrings` defines `arabicCode = 'ar'` and `englishCode = 'en'` — only English is wired up; Arabic support is stubbed but not implemented (no `ar.json`).

**Adding a new key** requires editing both:
1. `assets/lang/en.json` — the key/value.
2. `lib/core/utils/app_localization_strings.dart` — a Dart constant pointing at that key.

The `en.json` also contains the social-media metadata (LinkedIn / GitHub / Facebook / WhatsApp / Mail URLs) consumed by `AboutUsWidget`.

---

## 11. Technical Patterns

### 11.1 Dependency Injection — GetIt

[`lib/injection_container.dart`](../lib/injection_container.dart) registers everything as `LazySingleton`:

```dart
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<AppLocalDataSource>(() => AppLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<UserLocalDataSource>(() => UserLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitLocalDataSource>(() => HabitLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton<HabitStatsLocalDataSource>(() => HabitStatsLocalDataSourceImpl(storageManager: sl()));
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
  sl.registerLazySingleton<IStorageManager>(() => LocalStorageManager());
  sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());
  sl.registerLazySingleton<IBiometricAuthenticationManager>(() =>
    BiometricAuthenticationManager(localAuthentication: sl(), userLocalDataSource: sl()));
}
```

`main.dart` awaits `di.init()` before `runApp`. Screens fetch from `GetIt.instance<Type>()` inside `initState`.

### 11.2 No domain layer / no repository layer

The presentation layer (screens) calls data sources directly. There is no `domain/`, no `*Repository`, no `Result<T>`, no `Either`. Errors are surfaced via `try/catch` in screens calling `AppNotifier.showErrorDialog` / `showSnackBar`.

### 11.3 State management — plain `setState`

There is no Riverpod, no Provider (despite `provider` being declared in `pubspec.yaml`), no BLoC. Every screen is a `StatefulWidget` that:

1. Stores a data-source reference (`late HabitLocalDataSource _x;`).
2. Initializes it from `GetIt.instance<T>()` inside `_initServices()` from `initState`.
3. Loads data into a local list/var.
4. Calls `setState` after mutations.

Async work is fire-and-forget from `initState`. The data sources are the source of truth.

### 11.4 Form validation

[`AppFormValidator.validate(value, type)`](../lib/core/validation/app_form_validator.dart) is a static switch over [`ValidationTypes`](../lib/core/validation/validation_types.dart) constants. Returns either an `i18n key` (e.g. `"required"`, `"invalid_email"`, `"at_least_3_chars"`) or `""` for valid input. Consumers display the returned key as the error label.

Active rule sets: `signupName` (max 16), `signinEmail`, `signinPassword` (≥8), and the rest are declared but unused (email, phone, birth date — vestigial scaffolding).

### 11.5 Conventions

- **File naming:** `kebab-case/` directories, `snake_case.dart` files; `*_screen.dart`, `*_widget.dart`, `*_manager.dart`, `*_datasource.dart`.
- **Interfaces:** managers are `I` prefix (`IStorageManager`, `IBiometricAuthenticationManager`). Data sources keep the abstract name (`HabitLocalDataSource`) and use an `Impl` suffix on the implementation.
- **Privacy:** screen state members start with `_`, helpers also `_`.
- **Async lifecycle:** screens never `await` in `initState`; helpers are `async` but called synchronously.

### 11.6 Lints

[`analysis_options.yaml`](../analysis_options.yaml) → `package:flutter_lints/flutter.yaml` only. No custom rules.

---

## 12. End-to-End Flows

### 12.1 First-launch onboarding flow

```
Splash (1s)
  └─ !app.init
       └─ pushReplacement → Onboarding
            └─ swipe / "Let's Start"
                 └─ app.init = true
                 └─ pushReplacement → Signup hub
```

### 12.2 Signup (biometric branch)

```
Signup hub
  └─ tap Biometric
       └─ Signup Biometric (auto-prompts)
            └─ success
                 ├─ user.isAuthenticated = true
                 ├─ user.isBiometricAuthenticated = true
                 └─ pushNamedAndRemoveUntil → Signup Success
                      └─ enter username + gender → Submit
                           ├─ user.username/gender set, user.isRegistered = true
                           ├─ app.initDate = today
                           └─ pushReplacement → AppNavigator (Habits tab)
```

### 12.3 Signup (PIN branch)

```
Signup hub
  └─ tap PIN
       └─ Signup PIN (5-cell OTP)
            └─ onSubmit(pin)
                 ├─ user.password = pin
                 ├─ user.isPINAuthenticated = true
                 ├─ user.isAuthenticated = true
                 └─ pushNamedAndRemoveUntil → Signup Success → AppNavigator
```

### 12.4 Returning user signin

```
Splash (5s if registered)
  ├─ app.lastDate = today
  └─ user.isBiometricAuthenticated
       ├─ true  → Signin Biometric (auto-verify)
       └─ false → Signin PIN
            └─ on success: user.isAuthenticated = true → AppNavigator
```

### 12.5 Daily home interaction

```
HabitScreen.initState
  ├─ _initMonthHabits → maybe showMoveHabitsActionDialog
  │     ├─ Yes → moveMonthHabits(prev, curr, true) → seed habits with fresh states
  │     └─ No  → moveMonthHabits(prev, curr, false) (just mark month initialized)
  └─ _loadHabits
       ├─ updateDayHabits(selectedDate, currentMonth)   // lazy day roll-forward
       └─ getHabitsByDay(selectedDate, currentMonth)
            └─ render HabitListWidget OR empty state

User interactions:
  • tap green/red pill → toggleHabitStatus(habit, selectedDay)
  • tap trash         → suspendHabit(habit, selectedDay)
  • drag-and-drop      → reorderHabit(h1, h2)
  • CalendarAppBar tap → _onDateChanged → reload
  • FAB → Add Habit  → AddHabitScreen.submit → addHabit(...) → pop(true) → reload
  • FAB → Manage Habits → ManageHabitsScreen (passes selectedDay)
```

### 12.6 Backgrounding security

```
AppNavigator on paused/detached
  └─ user.isAuthenticated = false (persisted)

Next foreground (Splash bypassed; AppNavigator.initState)
  └─ _checkIfUserAuthenticated
       └─ !isAuthenticated → push Signin (Biometric or PIN)
```

### 12.7 Stats flow

```
Stats hub
  ├─ Month Stats card
  │    └─ showMonthPicker(initDate..lastDate)
  │         └─ push HabitMonthStatsScreen(date)
  │              └─ getHabitsStatsByMonth(date) → DataTable
  └─ Month Progress card
       └─ showMonthPicker(initDate..lastDate)
            └─ push HabitMonthProgressScreen(date)
                 ├─ force landscape
                 └─ getHabitsProgressByMonth(date) → wide DataTable
                                                    (1 column per day)
```

### 12.8 Reset / re-onboard

```
Profile → Reset App Data
  └─ showDeleteActionDialog → Yes
       └─ AppLocalDataSource.reset() = clearAll() on SharedPreferences
            └─ pushReplacement → Routes.initial (Splash)
                 └─ app.init = false → Onboarding (fresh flow)
```

---

## 13. Known Quirks & Pitfalls

A working register of things that could surprise future contributors. None of these are bugs that block the app from running; all are real behaviors worth knowing.

- **PIN is plaintext.** `user.password` is stored unhashed in SharedPreferences. The threat model is "physical access to an unlocked device," so this is consistent with the app's local-only design — but don't treat it as a secret.
- **`Reset App Data` wipes everything.** `clearAll()` clears every `SharedPreferences` key — including any other plugin keys an app might add later.
- **Enum order is load-bearing.** `HabitState`, `Day`, and `Gender` are serialized by `.index`; reordering will corrupt historical data.
- **Provider is declared but unused.** `pubspec.yaml` lists `provider: ^6.0.5` but the app doesn't import it. Removing it would be safe; leaving it doesn't hurt.
- **`AppStrings.arabicCode` is dead-letter.** No `ar.json`, no LTR/RTL handling.
- **`signupPINFailed` localization key.** Points to `'signup_biometric_failed'` ([line 58](../lib/core/utils/app_localization_strings.dart#L58)) — a copy-paste leftover. Both PIN and Biometric failure dialogs show the biometric copy.
- **README "Dark Mode" claim.** The app is dark-only; there's no toggle.
- **Stats hub orientation.** Sets `[portraitUp, portraitDown, landscapeLeft, landscapeRight]` on entry but doesn't restore on exit, so other screens may unexpectedly become rotatable until the app is killed.
- **`updateDayHabits` "else CREATED" branch.** Past days that already have a state get re-marked `CREATED` when their day-init flag is missing. The per-day init flag (`APP/HABIT/INIT/<date>`) gates this so it doesn't reset Done/Not-Done — but the branch is reachable for any day whose init flag was wiped (e.g. after an OS-level clear of app data on Android).
- **`addHabit` on a habit whose repeat-day matches today** marks today `NOT_DONE` (not `CREATED`). The "ready to be done today" state is therefore `NOT_DONE`, not a neutral state, which is why the home screen filter in `getHabitsByDay` accepts both `DONE` and `NOT_DONE`.

---

*Last updated: 2026-06-02. This document is hand-maintained against the codebase on `master`; treat the source files cited above as the source of truth if anything below feels stale.*
