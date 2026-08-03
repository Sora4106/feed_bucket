# Feed Bucket Monitor PWA

This repository intentionally contains only the deployable web PWA for Feed Bucket Monitor. Flutter/Dart source files, native Android/iOS projects, build tooling, and release packages are retained only in the local development project and must not be added here.

## Public site

`https://sora4106.github.io/feed_bucket/`

## Repository layout

- `site/` — the compiled Flutter web application served by GitHub Pages.
- `.github/workflows/deploy-pages.yml` — deploys the contents of `site/` when `main` is updated.

## Publishing an updated web release

The private Flutter project's `pubspec.yaml` is the single source of truth for
the release number. Increment its build number for every public PWA release;
for example, `1.0.6+7` becomes `1.0.6+8`.

Build the private local Flutter project for the GitHub Pages subpath, then replace the contents of `site/` with its `build/web/` output and commit only the resulting static files.

```powershell
Set-Location ..\feed_bucket
flutter build web --release --base-href "/feed_bucket/"
```

After copying the build output, run the private project's synchronization tool:

```powershell
Set-Location ..\feed_bucket
powershell -NoProfile -ExecutionPolicy Bypass -File .\tooling\sync_pwa_release.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File .\tooling\sync_pwa_release.ps1 -Check
```

It writes `site/release.json` and `site/version.json` from the canonical
`pubspec.yaml` value. The deployment workflow validates those files and uses
the exact same value for the PWA cache, so it will fail rather than publish a
mismatched version.

Do not copy `lib/`, `android/`, `ios/`, `assets/` from the Flutter project root, APK/AAB/IPA files, or any other source/release materials into this repository.
