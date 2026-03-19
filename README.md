# Gridly

A clean, mobile-first habit tracking app built with Flutter.

## 📱 Mobile-Only Scope

This project supports **Android and iOS only**.

- Web is **not supported**.
- Desktop platforms are **not supported**.
- CI is configured for mobile checks only.
- Isar is used as a native mobile database (no web target in release flow).

## ✨ Features

- Create, edit, and delete habits
- Mark daily completion with one tap
- Visual consistency heatmap
- Persistent light/dark theme toggle
- Offline-first local storage with Isar

## 📸 Screenshots

Add screenshots in `docs/screenshots/` and reference them here:

- Home screen
- Habit creation dialog
- Dark mode
- Heatmap progress

## 🛠 Tech Stack

- Flutter (Dart)
- Provider (state management)
- Isar (local database)
- Shared Preferences (lightweight settings)

## 📂 Folder Structure

```text
lib/
  app/
    app.dart
  core/
    theme/
  features/
    habits/
      models/
      presentation/
        pages/
        widgets/
  services/
    habit_database.dart
  main.dart

test/
  widget_test.dart
```

## ⚙️ Installation

### Prerequisites

- Flutter SDK installed (`flutter --version`)
- Android Studio and/or Xcode

### Setup

```bash
flutter pub get
```

### Run

```bash
flutter run
```

### Quality Checks

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

## 🔐 Android Release Signing

1. Copy template:

```bash
cp android/key.properties.example android/key.properties
```

2. Fill real values in `android/key.properties`.
3. Keep your `.jks`/keystore file outside source control.

`android/key.properties` and keystore files are ignored by `.gitignore`.

## 🤝 Contribution Guide

1. Branch from `develop`.
2. Use conventional commits (`feat:`, `fix:`, `chore:`).
3. Ensure analyze/test/build checks pass.
4. Open PR with checklist completion.

## 🔁 CI/CD

GitHub Actions runs:

- `flutter pub get`
- formatting verification
- `flutter analyze`
- `flutter test`
- Android APK debug build

Workflow file: `.github/workflows/flutter-ci.yml`

## 📄 License

MIT License. See `LICENSE`.
