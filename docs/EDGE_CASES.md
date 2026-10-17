# Edge Cases — Handling Strategies

Status legend: **Done** = implemented in code; **Documented** = intentional behavior.

| Case | Handling | Status |
| ---- | -------- | ------ |
| Extremely long text | Soft capacity check via UTF-8 byte limit in `QrPayloadBuilder` (`qrTooLarge`) | Done |
| Unicode / emoji / Persian-Arabic | Passed through as UTF-8 to QR encoder; preview uses `SelectableText` with expand | Done |
| Invalid URL | `UrlValidator` requires http/https + host; form shows l10n error | Done |
| Invalid EAN | Length + checksum validation; no silent invalid barcode | Done |
| Open WiFi empty password | `nopass` omits `P:` field | Done |
| WiFi special chars `; , " \` | Escaped in `WifiQrEncoder` | Done |
| Large vCard | Same QR capacity limit; optional fields omitted when empty | Done |
| Camera unavailable / denied | Permission panes with retry / Open Settings | Done |
| Permanently denied camera | `openAppSettings` recovery path | Done |
| Export / share / save failure | Mapped to `AppFailure` + SnackBar with icon | Done |
| No internet (ads) | `ConnectivityGate` → `offlineAds` before rewarded load | Done |
| Reward dismiss / incomplete | `adNotEarned`; premium stays locked | Done |
| App background during scan | Scanner stops camera on pause/inactive; resumes on resume | Done |
| App background during ad | SDK callbacks decide unlock; resume alone never unlocks | Done |
| Process kill during export | No partial unlock persisted; next launch starts locked | Done |
| Low memory export | Catch → `exportFailed` message | Done |
| Duplicate scan events | `ScanDeduper` lock + window | Done |
| Sensitive actions from scan | Never auto-open URL/tel/mailto; user tap required | Done |
| Dark theme preview scannability | Codes rendered on white quiet-zone background | Done |
| SVG not renamed raster | Real SVG from QR matrix / barcode `toSvg` | Done |

## Offline policy

| Feature | Offline |
| ------- | ------- |
| Generate QR / barcode | Yes |
| Scan | Yes (on-device) |
| Preview / free export / share | Yes |
| Rewarded / banner / interstitial | Requires network; clear `offlineAds` / unavailable messages |

## Notes

- Premium unlock is **per export** and in-memory only.
- Connectivity checks improve messaging; free export paths do not require network.
