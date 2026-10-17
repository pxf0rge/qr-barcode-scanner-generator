# Release Build Notes

## Versions

- `pubspec.yaml`: `1.0.0+1` (name+code)
- `minSdk`: Flutter default (24)
- `compileSdk`: 37
- `targetSdk`: 36

## Dev run (sample ads)

```powershell
flutter run --dart-define=APP_ENV=dev
```

## Production AdMob (VectorQR)

| Slot | ID |
|------|-----|
| App ID | `ca-app-pub-1300636339318232~7128755322` |
| Banner_Main | `ca-app-pub-1300636339318232/5456349491` |
| Interstitial_Main | `ca-app-pub-1300636339318232/3777445473` |
| Rewarded_Main | `ca-app-pub-1300636339318232/3738661882` |

App ID is set in `AndroidManifest.xml`. Unit IDs resolve automatically when `APP_ENV=prod`.

## Production defines

```powershell
flutter build appbundle --release `
  --dart-define=APP_ENV=prod `
  --dart-define=PRIVACY_POLICY_URL=https://rentry.co/vectorqr-privacy-policy
```

Optional overrides: `ADMOB_APP_ID`, `AD_BANNER`, `AD_INTERSTITIAL`, `AD_REWARDED`.

## Signing (Phase 27)

1. Create upload keystore (client-owned) or use `android/keystore/upload-keystore.jks`.
2. Ensure `android/key.properties` exists (gitignored) — see `key.properties.example`.
3. `signingConfigs.release` is wired in `android/app/build.gradle.kts` when `key.properties` is present.
4. `flutter build appbundle --release --dart-define=APP_ENV=prod`

**Important:** change the default keystore password before Play production if this machine/repo is shared.

## Verify before upload

- [ ] Final `applicationId`
- [ ] Production AdMob App ID in AndroidManifest / defines
- [ ] No sample ad units in prod binary
- [ ] Privacy Policy URL opens
- [ ] `flutter analyze` + `flutter test` green
