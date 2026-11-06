# Zikir Tracker

An offline-first Flutter app for recording Zikir sessions manually and reviewing progress.

## Features
- Create, edit, and delete Zikir goals.
- Optional daily target and required overall target.
- Record a completed count manually (no in-app counter).
- Save the exact date and time for each session; backdated entries are supported.
- Edit and delete session records.
- Dashboard with today's total and overall goal progress.
- History and weekly/monthly analytics.
- SQLite storage on the device.

## Run
This source bundle contains the Dart app and package configuration. Generate the Android/iOS platform folders with Flutter first:

1. Install Flutter and the Android toolchain.
2. Run `flutter create zikir_tracker`.
3. Copy the `lib/` folder and `pubspec.yaml` from this bundle into the generated `zikir_tracker/` folder, replacing the generated files.
4. From the project folder, run `flutter pub get`.
5. Run `flutter run` or build an APK with `flutter build apk --release`.

## Data persistence
Records are stored in the app's private SQLite database. They remain after closing or restarting the app. Uninstalling the app or clearing its storage can remove the database, so add a backup/export feature before relying on it as your only copy.

## Folder structure
```text
lib/
  main.dart
  data/database_helper.dart
  models/zikir.dart
  models/zikir_log.dart
  providers/zikir_provider.dart
  screens/main_shell.dart
  screens/home_screen.dart
  screens/zikir_screen.dart
  screens/history_screen.dart
  screens/analytics_screen.dart
  screens/zikir_form_screen.dart
  screens/log_form_screen.dart
  theme/app_theme.dart
  widgets/empty_state.dart
  widgets/section_title.dart
```
