# Play Store release checklist (VectorQR)

## Done in app code
- Real AdMob IDs (default; no `USE_SAMPLE_ADS`)
- Banner shown on main tabs (above bottom navigation)
- Anchored adaptive banner size
- `maxAdContentRating = G` before Mobile Ads init

## You must do in AdMob Console (client)
1. Open [AdMob](https://apps.admob.com) → Blocking controls
2. Set **Ad content rating** filter to **G** (General audiences) if available at account/app level
3. Block sensitive categories (Dating, Mature, Gambling, etc.) for this app
4. Confirm `app-ads.txt` is verified for `http://vectorqr.xo.je/app-ads.txt`

## Build commands (signed)
```bash
flutter clean
flutter pub get
flutter build appbundle --release
flutter build apk --release
```

Outputs:
- `build/app/outputs/bundle/release/app-release.aab`
- `build/app/outputs/flutter-apk/app-release.apk`

## Store listing URLs
- Privacy: prefer `http://vectorqr.xo.je/privacy-policy.html` (or rentry)
- Terms: `http://vectorqr.xo.je/terms.html`
- Developer website (for app-ads.txt): `http://vectorqr.xo.je`
