# UX / Accessibility Checklist

## Completed

- [x] IconButtons have localized `tooltip` (Settings, Torch)
- [x] Home primary actions have `Semantics` labels + min height 48
- [x] QR/Barcode preview wrapped in `Semantics` image labels
- [x] Premium export tiles show lock icon + `labelRequiresAd` text (not color-only)
- [x] Form fields use `InputDecoration.labelText`
- [x] Error SnackBars include icon + text
- [x] Scanner hint uses dark scrim + text shadow for contrast on camera
- [x] Theme uses Material 3 seed with light/dark schemes
- [x] Wi‑Fi hidden field shows Yes/No (localized), not raw true/false

## Widget coverage

- Home smoke + textScaler 1.5 overflow check (`test/features/a11y_text_scale_test.dart`)

## Manual (TalkBack)

- [ ] Focus order: Home → QR → Generate → Preview actions
- [ ] Scanner torch announced
- [ ] Export sheet lock items announced as requiring ad

## Notes

Large text (1.5x) relies on `ListView` / scrollable forms; keep new screens scrollable.
