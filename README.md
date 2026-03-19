# Gridly

Gridly is a production-ready habit tracker built with Flutter for mobile platforms.

## Mobile-Only Support

This project is Android mobile only.
Web is not supported.

- No web build pipeline is included.
- Isar is used as a native mobile database.

## Features

- Create, edit, and delete habits
- Daily completion tracking
- Heatmap-style progress visualization
- Light and dark theme support
- Offline-first local persistence

## Screenshots

Add screenshots under `docs/screenshots/` and reference them here.

- Home screen
- Add/edit habit dialog
- Theme toggle state
- Progress heatmap

## Tech Stack

- Flutter (Dart)
- Provider
- Isar
- Shared Preferences

## Project Structure

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
```

## Setup

1. Install Flutter SDK.
2. Run `flutter pub get`.
3. Run `flutter run`.

## Quality Commands

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Android Release Signing

1. Copy `android/key.properties.example` to `android/key.properties`.
2. Fill in real keystore credentials.
3. Place your keystore at `android/app/upload-keystore.jks`.
4. Keep keystore and `key.properties` out of source control.

Expected structure:

```text
android/
  key.properties
  app/
    upload-keystore.jks
```

Local release validation:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## CI/CD

Workflow file: `.github/workflows/build-apk.yml`

Pipeline steps:

- Checkout
- Setup Java 17
- Setup Flutter
- Dependency install
- Analyze and test
- Build Android release APK
- Upload release APK artifact

## Contribution

1. Branch from `develop`.
2. Use conventional commits.
3. Run quality commands before PR.

## License

MIT License. See `LICENSE`.
