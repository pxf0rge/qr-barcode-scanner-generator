// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'VectorQR — QR & Barcodes';

  @override
  String get appSubtitle => 'Generate, scan, export and share codes';

  @override
  String get welcomeBrand => 'VectorQR';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get welcomeAgreePrefix => 'By continuing you agree to our';

  @override
  String get welcomePrivacyPolicy => 'Privacy Policy';

  @override
  String get welcomeTerms => 'Terms of Service';

  @override
  String get navScanner => 'Scan';

  @override
  String get navHistory => 'History';

  @override
  String get navCreate => 'Create';

  @override
  String get navSetting => 'Settings';

  @override
  String get createSectionSocial => 'Social';

  @override
  String get historyFilterAll => 'All';

  @override
  String get actionCreateQr => 'Create QR Code';

  @override
  String get actionCreateBarcode => 'Create Barcode';

  @override
  String get actionScan => 'Scan Code';

  @override
  String get actionHistory => 'History';

  @override
  String get actionClearHistory => 'Clear history';

  @override
  String get actionSettings => 'Settings';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionOpen => 'Open';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty =>
      'No history yet. Generate or scan a code to see it here.';

  @override
  String get historyEmptyShort => 'No Records Yet';

  @override
  String get historyGenerated => 'Generated';

  @override
  String get historyScanned => 'Scanned';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get actionGenerate => 'Generate';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionExport => 'Export';

  @override
  String get actionShare => 'Share';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionEdit => 'Edit';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionCall => 'Call';

  @override
  String get actionEmail => 'Send email';

  @override
  String get actionScanAgain => 'Scan again';

  @override
  String get actionOpenSettings => 'Open Settings';

  @override
  String get actionSaveGallery => 'Save to gallery';

  @override
  String get actionShowMore => 'Show more';

  @override
  String get actionShowLess => 'Show less';

  @override
  String get actionWatchAd => 'Watch ad to unlock';

  @override
  String get commonError => 'Something went wrong';

  @override
  String get commonSuccessCopied => 'Copied to clipboard';

  @override
  String get commonSuccessSaved => 'Saved to gallery';

  @override
  String get commonSuccessShared => 'Ready to share';

  @override
  String get homeTitle => 'VectorQR';

  @override
  String get createClipboard => 'Clipboard';

  @override
  String get createClipboardEmpty => 'Clipboard is empty.';

  @override
  String get createTypeLink => 'Link';

  @override
  String get createTypeBarcode => 'Barcode';

  @override
  String get createTypeContact => 'Contact';

  @override
  String get createTypeTelephone => 'Telephone';

  @override
  String get createTypeEmail => 'E-mail';

  @override
  String get createTypeCalendar => 'Calendar';

  @override
  String get createTypeText => 'Text';

  @override
  String get createTypeWifi => 'WiFi';

  @override
  String get createTypeMyCard => 'My Card';

  @override
  String get createTypeYoutube => 'YouTube';

  @override
  String get createTypeX => 'X';

  @override
  String get createTypeFacebook => 'Facebook';

  @override
  String get createTypeSpotify => 'Spotify';

  @override
  String get createTypeTiktok => 'TikTok';

  @override
  String get createTypeLinkedin => 'LinkedIn';

  @override
  String get qrTypeTitle => 'QR Code type';

  @override
  String get qrTypeText => 'Text';

  @override
  String get qrTypeTextDesc => 'Encode any text';

  @override
  String get qrTypeUrl => 'URL';

  @override
  String get qrTypeUrlDesc => 'Website or link';

  @override
  String get qrTypeWifi => 'Wi‑Fi';

  @override
  String get qrTypeWifiDesc => 'Network credentials';

  @override
  String get qrTypeContact => 'Contact';

  @override
  String get qrTypeContactDesc => 'vCard contact card';

  @override
  String get qrTypeWhatsapp => 'WhatsApp';

  @override
  String get qrTypeWhatsappDesc => 'Chat link from phone number';

  @override
  String get qrTypeYoutube => 'YouTube';

  @override
  String get qrTypeYoutubeDesc => 'Video or channel link';

  @override
  String get qrTypeFacebook => 'Facebook';

  @override
  String get qrTypeFacebookDesc => 'Profile or page link';

  @override
  String get qrTypeInstagram => 'Instagram';

  @override
  String get qrTypeInstagramDesc => 'Profile link';

  @override
  String get fieldWhatsappPhone => 'Phone number';

  @override
  String get fieldWhatsappCountry => 'Country code';

  @override
  String get fieldWhatsappMessage => 'Message (optional)';

  @override
  String get fieldYoutube => 'YouTube URL or video ID';

  @override
  String get fieldFacebook => 'Facebook username or URL';

  @override
  String get fieldInstagram => 'Instagram username';

  @override
  String get fieldX => 'X username or URL';

  @override
  String get fieldSpotify => 'Spotify URL or search';

  @override
  String get fieldTiktok => 'TikTok username or URL';

  @override
  String get fieldLinkedin => 'LinkedIn username or URL';

  @override
  String get hintWhatsappPhone => '5551234567';

  @override
  String get hintYoutube => 'https://youtu.be/… or video ID';

  @override
  String get hintFacebook => 'username or https://facebook.com/…';

  @override
  String get hintInstagram => 'username';

  @override
  String get hintX => '@username or https://x.com/…';

  @override
  String get hintSpotify => 'https://open.spotify.com/…';

  @override
  String get hintTiktok => '@username or https://tiktok.com/…';

  @override
  String get hintLinkedin => 'username or https://linkedin.com/in/…';

  @override
  String get errorInvalidSocialInput => 'Enter a valid value for this QR type.';

  @override
  String get qrCustomizeTitle => 'Customize QR';

  @override
  String get qrCustomizeColor => 'Color';

  @override
  String get qrCustomizeShape => 'Module shape';

  @override
  String get qrShapeSquare => 'Square';

  @override
  String get qrShapeCircle => 'Rounded';

  @override
  String get barcodeTypeTitle => 'Barcode type';

  @override
  String get barcodeTypeCode128 => 'Code 128';

  @override
  String get barcodeTypeCode128Desc => 'Letters, numbers and symbols';

  @override
  String get barcodeTypeEan8 => 'EAN-8';

  @override
  String get barcodeTypeEan8Desc => '7 or 8 digit product code';

  @override
  String get barcodeTypeEan13 => 'EAN-13';

  @override
  String get barcodeTypeEan13Desc => '12 or 13 digit product code';

  @override
  String get fieldText => 'Text';

  @override
  String get fieldUrl => 'URL';

  @override
  String get fieldSsid => 'Network name (SSID)';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldSecurity => 'Security';

  @override
  String get fieldHiddenNetwork => 'Hidden network';

  @override
  String get fieldFirstName => 'First name';

  @override
  String get fieldLastName => 'Last name';

  @override
  String get fieldPhone => 'Phone';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldEmailSubject => 'Subject (optional)';

  @override
  String get fieldEmailBody => 'Body (optional)';

  @override
  String get fieldEventTitle => 'Event title';

  @override
  String get fieldEventLocation => 'Location (optional)';

  @override
  String get fieldEventDescription => 'Description (optional)';

  @override
  String get fieldEventStart => 'Start time';

  @override
  String get fieldEventPick => 'Tap to pick';

  @override
  String get fieldOrganization => 'Organization';

  @override
  String get fieldAddress => 'Address';

  @override
  String get fieldWebsite => 'Website';

  @override
  String get fieldBarcodeData => 'Barcode data';

  @override
  String get hintUrl => 'https://example.com';

  @override
  String get securityWpa => 'WPA / WPA2';

  @override
  String get securityWep => 'WEP';

  @override
  String get securityNone => 'None (open)';

  @override
  String get previewTitle => 'Preview';

  @override
  String get previewType => 'Type';

  @override
  String get previewContent => 'Content';

  @override
  String get exportTitle => 'Export format';

  @override
  String get exportJpeg => 'JPEG';

  @override
  String get exportPng => 'PNG (with background)';

  @override
  String get exportPngTransparent => 'PNG transparent (1000×1000)';

  @override
  String get exportSvg => 'Editable Vector SVG';

  @override
  String get exportFree => 'Free';

  @override
  String get exportPremium => 'Watch ad';

  @override
  String get exportComingSoon => 'Coming Soon';

  @override
  String get exportComingSoonHint => 'Available in a future update.';

  @override
  String get exportLoadingAd => 'Loading ad…';

  @override
  String get exporting => 'Exporting…';

  @override
  String get exportSaveFile => 'Save to Downloads';

  @override
  String get exportSaveDownloadsHint => 'Keeps transparent background';

  @override
  String get exportSavedFile => 'Saved to Downloads.';

  @override
  String get exportSavedTransparentPng =>
      'Transparent PNG (1000×1000) saved to Downloads.';

  @override
  String get scannerTitle => 'Scanner';

  @override
  String get scannerHint => 'Align the code inside the frame';

  @override
  String get scannerHintShort => 'Point at a code';

  @override
  String get scannerNoCodeInImage => 'No QR or barcode found in this image.';

  @override
  String get scannerPermissionTitle => 'Camera permission needed';

  @override
  String get scannerPermissionBody =>
      'Camera access is used only to scan QR codes and barcodes. Nothing is uploaded.';

  @override
  String get cameraAccessTitle => 'Allow camera access';

  @override
  String get cameraAccessBody =>
      'VectorQR uses the camera only to scan QR codes and barcodes on your device. Nothing is uploaded.';

  @override
  String get cameraAccessScan => 'Camera Permission for scanning';

  @override
  String get cameraAccessFlash => 'Camera Permission for flash light';

  @override
  String get cameraAccessGrant => 'Allow';

  @override
  String get startupPermissionsTitle => 'Allow access';

  @override
  String get startupPermissionsBody =>
      'This app needs camera access to scan codes, and contacts access so you can import a contact into a QR code. Nothing is uploaded.';

  @override
  String get scannerPermissionDenied => 'Camera permission was denied.';

  @override
  String get scannerPermissionPermanent =>
      'Camera permission is permanently denied. Open Settings to enable it.';

  @override
  String get scannerUnavailable => 'Camera is unavailable on this device.';

  @override
  String get resultTitle => 'Scan result';

  @override
  String get resultWifiTitle => 'Wi‑Fi network';

  @override
  String get resultContactTitle => 'Contact';

  @override
  String get resultCreateQr => 'Create QR from result';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTitleShort => 'Settings';

  @override
  String get settingsCollection => 'Collection';

  @override
  String get settingsGeneral => 'Scanning';

  @override
  String get settingsHelp => 'Support';

  @override
  String get settingsBeep => 'Scan sound';

  @override
  String get settingsBeepHint => 'Play a click when a code is found';

  @override
  String get settingsVibrate => 'Vibrate';

  @override
  String get settingsNotification => 'Notification';

  @override
  String get settingsSearch => 'Search';

  @override
  String get settingsFeedback => 'Feedback';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsRate => 'Rate';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyOptions => 'Privacy options';

  @override
  String get settingsLicenses => 'Licenses';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsAbout => 'About';

  @override
  String get errorEmptyInput => 'Please enter a value.';

  @override
  String get errorInvalidUrl => 'Enter a valid http:// or https:// URL.';

  @override
  String get errorWifiSsidRequired => 'Network name is required.';

  @override
  String get errorContactNameRequired => 'Enter at least a first or last name.';

  @override
  String get errorEanInvalidLength => 'Enter the correct number of digits.';

  @override
  String get errorEanInvalidChecksum => 'Invalid check digit.';

  @override
  String get errorEanNonNumeric => 'EAN codes must contain only digits.';

  @override
  String get errorCode128Empty => 'Enter barcode data.';

  @override
  String get errorCode128IllegalChar =>
      'This character is not supported by Code 128.';

  @override
  String get errorExportFailed => 'Export failed. Please try again.';

  @override
  String get errorShareFailed => 'Sharing failed. Please try again.';

  @override
  String get errorSaveFailed => 'Could not save to gallery.';

  @override
  String get errorAdUnavailable =>
      'Ad could not load. Check your connection and try again.';

  @override
  String get errorAdNotEarned => 'Watch the full ad to unlock this export.';

  @override
  String get errorOfflineAds => 'Ads need an internet connection.';

  @override
  String get errorCameraDenied => 'Camera permission is required to scan.';

  @override
  String get errorContactsDenied =>
      'Contacts permission is required to import a contact.';

  @override
  String get errorContactPickCancelled => 'No contact selected.';

  @override
  String get errorContactPickFailed =>
      'Could not import the contact. Try again.';

  @override
  String get actionPickContact => 'Pick from contacts';

  @override
  String get contactImportedHint =>
      'Fields filled from your contact. Edit if needed, then generate.';

  @override
  String get errorUnsupportedFormat => 'This format is not supported.';

  @override
  String get errorQrTooLarge => 'Content is too large for a QR code.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get labelRequiresAd => 'Requires ad';

  @override
  String get actionTorch => 'Torch';

  @override
  String get labelYes => 'Yes';

  @override
  String get labelNo => 'No';

  @override
  String get labelUnknownFormat => 'Unknown';

  @override
  String get semanticsQrPreview => 'QR code preview';

  @override
  String get semanticsBarcodePreview => 'Barcode preview';

  @override
  String semanticsHomeAction(String title) {
    return 'Open $title';
  }
}
