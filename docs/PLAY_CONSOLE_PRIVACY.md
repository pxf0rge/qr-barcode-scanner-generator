# Play Console — Privacy & Data safety (VectorQR)

## Public URLs (use these)

| Document | URL |
| --- | --- |
| **Privacy Policy** | https://rentry.co/vectorqr-privacy-policy |
| **Terms of Service** | https://rentry.co/vectorqr-terms |

Paste the **Privacy Policy** URL into:

1. **Play Console → App content → Privacy policy**
2. AdMob app settings (if asked for a privacy policy link)

Source HTML (for GitHub Pages / your own domain later): `docs/privacy-policy/index.html`

Privacy page edit code (rentry): `aZNHCyx6` — keep private; use only if you need to update the hosted text.  
Terms page edit code (rentry): `EP7qUvuC` — keep private.

## Wired in the app

`AppUrls.privacyPolicy` → `https://rentry.co/vectorqr-privacy-policy`  
`AppUrls.termsOfService` → `https://rentry.co/vectorqr-terms`

Override at build time if you move hosting:

```bash
flutter build appbundle --dart-define=PRIVACY_POLICY_URL=https://your.domain/privacy --dart-define=TERMS_URL=https://your.domain/terms
```

## Policy coverage (Play-friendly)

- Camera: on-device scanning only; not uploaded to developer servers
- Photos/Storage: gallery scan + save/share (user-initiated); not uploaded by us
- Optional Contacts: vCard import on-device only
- Google AdMob: Banner, Interstitial, Rewarded + Google policy links
- Developer collects **no personal data on developer servers** (no accounts / no backend)
- Honest AdMob third-party disclosure (required for review)

## Data safety form (suggested)

| Question | Suggested |
| --- | --- |
| Does your app collect/share user data? | **Yes** (AdMob / advertising ID) |
| Personal info collected by *you*? | **No** |
| Photos/videos collected by *you*? | **No** (on-device access only; not sent to your servers) |
| Device or other IDs? | **Advertising ID** via Google AdMob |
| Data encrypted in transit? | **Yes** |
| Users can request deletion? | No developer-held account data; uninstall clears local app data |
| App contains ads? | **Yes** (Banner, Interstitial, Rewarded) |

## Contact email in the policy

`privacy.smartapps.vectorqr@gmail.com`  
Replace with your real inbox before production if needed, then update the rentry page.
