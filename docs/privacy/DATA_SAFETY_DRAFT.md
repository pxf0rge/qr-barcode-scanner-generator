# Google Play Data Safety — Draft Answers

Fill Play Console **Data safety** using these answers. Re-verify against the shipped binary.

## Overview

- App collects data: **Yes** (via AdMob / advertising)
- Data encrypted in transit: **Yes** (HTTPS for ads/consent; app has no custom backend)
- Users can request deletion: **N/A for developer-held accounts** (no accounts). Ad data subject to Google policies / device settings.

## Data types

| Category | Collected | Shared | Ephemeral | Purpose |
| -------- | --------- | ------ | --------- | ------- |
| Device or other IDs (Advertising ID) | Yes (AdMob) | Yes (Google) | No | Advertising |
| App activity / ad interactions | Yes (AdMob) | Yes | No | Advertising |
| Approximate location | Possibly via ads (declare per AdMob guidance) | Yes if applicable | — | Advertising |
| Camera | Used for functionality; not collected/stored as photos by app | No | Yes (processed live) | App functionality |
| User-generated content (codes entered) | Processed locally; not sent to developer servers | No (unless user shares) | Yes | App functionality |

## Important notes

- Declare **Ads** as a data usage purpose.
- Declare that the app contains ads.
- Camera permission: explain “scan QR/barcodes only”.
- Do not mark “No data collected” while AdMob is integrated.

## Checklist

- [ ] Matches AdMob + UMP configuration
- [ ] Matches Privacy Policy text
- [ ] Matches in-app permission rationale
