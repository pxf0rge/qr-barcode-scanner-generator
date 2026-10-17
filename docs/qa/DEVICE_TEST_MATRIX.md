# Device Test Matrix (Phase 24)

Use a **debug or internal-testing** build with **sample AdMob IDs**.

Build: _____________   Device: _____________   Date: _____________   Tester: _____________

## Generator

| # | Case | Pass | Notes |
| - | ---- | ---- | ----- |
| G1 | Text QR → Preview scannable | ☐ | |
| G2 | URL valid / invalid | ☐ | |
| G3 | Wi‑Fi WPA with special chars | ☐ | |
| G4 | Wi‑Fi open (nopass) | ☐ | |
| G5 | Contact vCard | ☐ | |
| G5b | WhatsApp / YouTube / Facebook / Instagram QR | ☐ | |
| G6 | Code128 | ☐ | |
| G7 | EAN-8 / EAN-13 valid + bad checksum | ☐ | |
| H1 | History lists generated + scanned items | ☐ | |

## Scanner

| # | Case | Pass | Notes |
| - | ---- | ---- | ----- |
| S1 | First grant permission | ☐ | |
| S2 | Deny → retry | ☐ | |
| S3 | Don’t ask again → Open Settings | ☐ | |
| S4 | Scan QR once (no duplicate nav) | ☐ | |
| S5 | Scan Again works | ☐ | |
| S6 | Background during scan → resume | ☐ | |

## Export / Share / Ads

| # | Case | Pass | Notes |
| - | ---- | ---- | ----- |
| E1 | Free JPEG / PNG opaque | ☐ | |
| E2 | Transparent PNG after reward | ☐ | |
| E3 | SVG after reward (valid file) | ☐ | |
| E4 | Dismiss rewarded → still locked | ☐ | |
| E5 | Airplane mode free export OK | ☐ | |
| E6 | Airplane mode premium → offline/unavailable message | ☐ | |
| E7 | Banner on Home | ☐ | |
| E8 | Interstitial cooldown respected | ☐ | |

## Sign-off

P0 open bugs: _____  
Result: ☐ Go  ☐ No-Go
