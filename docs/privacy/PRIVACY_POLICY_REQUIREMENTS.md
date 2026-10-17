# Privacy Policy Requirements

Living requirements for the hosted Privacy Policy URL used in Play Console and in-app Settings.

## App identity

- App name: QR & Barcode (placeholder until client finalizes)
- Package: `com.smartapps.vectorqr`
- Platforms: Android
- No user accounts / no backend operated by the developer

## Data the app processes

| Data | Collected by app? | Stored by app? | Shared? | Purpose |
| ---- | ----------------- | -------------- | ------- | ------- |
| Camera frames | Processed on-device only for scanning | Not stored by app | No | Scan QR/barcodes |
| Device contacts (user-selected) | Read locally when user picks a contact | Not uploaded; only used to fill QR form | Only if user shares generated QR | Import contact into vCard QR |
| User-entered text / URLs / Wi‑Fi / contacts | Local only | Ephemeral (memory / exports user saves) | Only if user shares | Generate codes |
| Scanned content | Local only | Ephemeral | Only if user shares | Show results / actions |
| Exported images | Local / gallery if user saves | User device | Only if user shares | Export/share |
| Advertising ID / ad interaction data | Via Google Mobile Ads SDK | Per Google | Shared with Google / partners | Ads, measurement |
| Consent choices (UMP) | Via Google UMP | Per Google | Google | GDPR/EEA compliance |

## Disclosures the policy must include

1. Camera is used **only** to scan codes; frames are not uploaded by the app.
2. Contacts are accessed **only** when the user taps “Pick from contacts”; selected details stay on device unless the user exports/shares a generated code.
3. Wi‑Fi passwords and contact details entered by the user stay on device unless the user exports/shares them.
3. The app shows ads via Google AdMob and may use device advertising identifiers.
4. Users in applicable regions see a consent form (UMP) and can reopen privacy options from Settings.
5. How to contact the developer/client for privacy requests (email TBD by client).
6. Policy effective date and update process.

## Do not claim

- “We collect no data” (AdMob collects/processes data).
- “We never share data” without clarifying user-initiated share and ad SDK partners.

## Client actions before production

- [ ] Host final Privacy Policy URL
- [ ] Set `--dart-define=PRIVACY_POLICY_URL=...` / update `AppUrls.privacyPolicy`
- [ ] Provide support/privacy contact email
