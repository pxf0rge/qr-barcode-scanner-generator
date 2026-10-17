# VectorQR — open-source libraries

All dependencies below are used in a commercial Android app context.
None require paid licenses, developer personal API keys, or recurring fees
to generate/scan/export QR or barcodes.

## Flutter / Dart (pubspec.yaml)

| Package | Purpose | License (typical) |
|---------|---------|-------------------|
| flutter / flutter_localizations | UI framework | BSD-3 |
| cupertino_icons | Icons | MIT |
| flutter_riverpod | State management | MIT |
| go_router | Navigation | BSD-3 |
| qr | QR encoding | BSD-3 |
| qr_flutter | QR widget rendering | BSD-3 |
| barcode | Barcode encoding + SVG | Apache-2.0 |
| barcode_widget | Barcode widgets | Apache-2.0 |
| mobile_scanner | Camera QR/barcode scanning (ML Kit) | BSD-3 / Apache-2.0 (transitive) |
| google_mobile_ads | AdMob (incl. rewarded) | Apache-2.0 |
| share_plus | Android share sheet | BSD-3 |
| path_provider | Temp file paths | BSD-3 |
| permission_handler | Camera / contacts permissions | MIT |
| url_launcher | Open links / tel / mailto | BSD-3 |
| shared_preferences | Local preferences + history | BSD-3 |
| package_info_plus | App version in Settings | BSD-3 |
| gal | Save images to gallery | MIT |
| xml | SVG XML helpers | MIT |
| image | Image encode (JPEG/PNG) | MIT / Apache-2.0 |
| equatable | Value equality | MIT |
| intl | Localization formatting | BSD-3 |
| uuid | IDs | MIT |
| connectivity_plus | Offline ads messaging | BSD-3 |
| flutter_contacts | Import contact → vCard QR | MIT |

## Android / platform notes

- Camera scanning uses `mobile_scanner` (Google ML Kit on Android).
- Ads use Google Mobile Ads SDK via `google_mobile_ads` + UMP consent.
- Package id: `com.smartapps.vectorqr`

## Not used

- No paid QR/barcode SDKs
- No social network APIs (WhatsApp/YouTube/Facebook/Instagram are URL presets only)
- No developer-owned backend credentials required to build the project

See in-app **Settings → Licenses** for the full Flutter license tree.
