# Play Console publish checklist

## Deliverables ready in repo

- Source: entire Flutter project
- Preview APK: `dist/QRCode-Generator-client-preview.apk`
- Release AAB: `dist/vectorqr-release.aab` (after build)
- Libraries list: `docs/LIBRARIES.md`
- Build notes: `docs/RELEASE_BUILD.md`

## Client must provide

1. Play Console access (or upload AAB yourself)
2. Production AdMob App ID + Rewarded (and optional Banner/Interstitial) unit IDs
3. Privacy Policy URL (live)
4. Upload keystore ownership (or accept the project `android/keystore/` upload key and keep `key.properties` private)

## Build release AAB

```powershell
flutter build appbundle --release --dart-define=APP_ENV=prod `
  --dart-define=PRIVACY_POLICY_URL=https://rentry.co/vectorqr-privacy-policy
```

Production AdMob App ID is in `AndroidManifest.xml`  
(`ca-app-pub-1300636339318232~7128755322`). Banner / interstitial / rewarded units activate with `APP_ENV=prod`.

## Signing

If `android/key.properties` exists, release builds use the upload keystore.
Otherwise release falls back to the debug keystore (not for Play production).

## Cannot be done without client account

Uploading to **their** Play Console and “Publish to my console account” requires the client’s Google Play login / API access. Ship the signed AAB + this checklist; they (or you with their invite) complete the console upload.
