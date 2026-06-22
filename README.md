# feed_bucket

`feed_bucket` is a Flutter / FlutterFlow project.

## Portable Restore Notes

This project was cleaned on 2026-06-17 to remove machine-specific build
artifacts and absolute-path files that were carried over from another Windows
environment. The removed items are expected to be regenerated locally after the
Flutter SDK is available.

Cleaned categories:

- `.dart_tool/`
- `build/`
- `android/.gradle/`
- `android/.kotlin/`
- `.flutter-plugins-dependencies`
- `android/local.properties`
- `ios/Flutter/Generated.xcconfig`
- `ios/Flutter/flutter_export_environment.sh`
- `ios/Flutter/ephemeral/`
- `macos/Flutter/ephemeral/`

## First-Time Setup On A New Windows PC

1. Install Flutter stable and add `flutter\bin` to `PATH`.
2. Install Android Studio or an Android SDK + JDK.
3. In the project root, run:

   ```powershell
   flutter doctor
   flutter pub get
   flutter test
   flutter run -d chrome
   ```

4. If you need Android builds, run `flutter run` or `flutter build apk` after
   the Android SDK is configured so Flutter can regenerate
   `android/local.properties`.

## Dependency Notes

The first `flutter pub get` requires network access because this project uses
packages from `pub.dev` and two Git dependencies: `dropdown_button2`,
`webviewx_plus`.

The local plugin `local_plugins/file_picker` is already included in this
repository.
