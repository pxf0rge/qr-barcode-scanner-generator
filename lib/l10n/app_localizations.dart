import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'VectorQR — QR & Barcodes'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generate, scan, export and share codes'**
  String get appSubtitle;

  /// No description provided for @welcomeBrand.
  ///
  /// In en, this message translates to:
  /// **'VectorQR'**
  String get welcomeBrand;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeStart;

  /// No description provided for @welcomeAgreePrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing you agree to our'**
  String get welcomeAgreePrefix;

  /// No description provided for @welcomePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get welcomePrivacyPolicy;

  /// No description provided for @welcomeTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get welcomeTerms;

  /// No description provided for @navScanner.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get navScanner;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get navCreate;

  /// No description provided for @navSetting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSetting;

  /// No description provided for @createSectionSocial.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get createSectionSocial;

  /// No description provided for @historyFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get historyFilterAll;

  /// No description provided for @actionCreateQr.
  ///
  /// In en, this message translates to:
  /// **'Create QR Code'**
  String get actionCreateQr;

  /// No description provided for @actionCreateBarcode.
  ///
  /// In en, this message translates to:
  /// **'Create Barcode'**
  String get actionCreateBarcode;

  /// No description provided for @actionScan.
  ///
  /// In en, this message translates to:
  /// **'Scan Code'**
  String get actionScan;

  /// No description provided for @actionHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get actionHistory;

  /// No description provided for @actionClearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get actionClearHistory;

  /// No description provided for @actionSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get actionSettings;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No history yet. Generate or scan a code to see it here.'**
  String get historyEmpty;

  /// No description provided for @historyEmptyShort.
  ///
  /// In en, this message translates to:
  /// **'No Records Yet'**
  String get historyEmptyShort;

  /// No description provided for @historyGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get historyGenerated;

  /// No description provided for @historyScanned.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get historyScanned;

  /// No description provided for @historyCleared.
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// No description provided for @actionGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get actionGenerate;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get actionCall;

  /// No description provided for @actionEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get actionEmail;

  /// No description provided for @actionScanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get actionScanAgain;

  /// No description provided for @actionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get actionOpenSettings;

  /// No description provided for @actionSaveGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get actionSaveGallery;

  /// No description provided for @actionShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get actionShowMore;

  /// No description provided for @actionShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get actionShowLess;

  /// No description provided for @actionWatchAd.
  ///
  /// In en, this message translates to:
  /// **'Watch ad to unlock'**
  String get actionWatchAd;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonSuccessCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get commonSuccessCopied;

  /// No description provided for @commonSuccessSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to gallery'**
  String get commonSuccessSaved;

  /// No description provided for @commonSuccessShared.
  ///
  /// In en, this message translates to:
  /// **'Ready to share'**
  String get commonSuccessShared;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'VectorQR'**
  String get homeTitle;

  /// No description provided for @createClipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get createClipboard;

  /// No description provided for @createClipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty.'**
  String get createClipboardEmpty;

  /// No description provided for @createTypeLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get createTypeLink;

  /// No description provided for @createTypeBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get createTypeBarcode;

  /// No description provided for @createTypeContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get createTypeContact;

  /// No description provided for @createTypeTelephone.
  ///
  /// In en, this message translates to:
  /// **'Telephone'**
  String get createTypeTelephone;

  /// No description provided for @createTypeEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get createTypeEmail;

  /// No description provided for @createTypeCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get createTypeCalendar;

  /// No description provided for @createTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get createTypeText;

  /// No description provided for @createTypeWifi.
  ///
  /// In en, this message translates to:
  /// **'WiFi'**
  String get createTypeWifi;

  /// No description provided for @createTypeMyCard.
  ///
  /// In en, this message translates to:
  /// **'My Card'**
  String get createTypeMyCard;

  /// No description provided for @createTypeYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get createTypeYoutube;

  /// No description provided for @createTypeX.
  ///
  /// In en, this message translates to:
  /// **'X'**
  String get createTypeX;

  /// No description provided for @createTypeFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get createTypeFacebook;

  /// No description provided for @createTypeSpotify.
  ///
  /// In en, this message translates to:
  /// **'Spotify'**
  String get createTypeSpotify;

  /// No description provided for @createTypeTiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get createTypeTiktok;

  /// No description provided for @createTypeLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get createTypeLinkedin;

  /// No description provided for @qrTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'QR Code type'**
  String get qrTypeTitle;

  /// No description provided for @qrTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get qrTypeText;

  /// No description provided for @qrTypeTextDesc.
  ///
  /// In en, this message translates to:
  /// **'Encode any text'**
  String get qrTypeTextDesc;

  /// No description provided for @qrTypeUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get qrTypeUrl;

  /// No description provided for @qrTypeUrlDesc.
  ///
  /// In en, this message translates to:
  /// **'Website or link'**
  String get qrTypeUrlDesc;

  /// No description provided for @qrTypeWifi.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi'**
  String get qrTypeWifi;

  /// No description provided for @qrTypeWifiDesc.
  ///
  /// In en, this message translates to:
  /// **'Network credentials'**
  String get qrTypeWifiDesc;

  /// No description provided for @qrTypeContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get qrTypeContact;

  /// No description provided for @qrTypeContactDesc.
  ///
  /// In en, this message translates to:
  /// **'vCard contact card'**
  String get qrTypeContactDesc;

  /// No description provided for @qrTypeWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get qrTypeWhatsapp;

  /// No description provided for @qrTypeWhatsappDesc.
  ///
  /// In en, this message translates to:
  /// **'Chat link from phone number'**
  String get qrTypeWhatsappDesc;

  /// No description provided for @qrTypeYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get qrTypeYoutube;

  /// No description provided for @qrTypeYoutubeDesc.
  ///
  /// In en, this message translates to:
  /// **'Video or channel link'**
  String get qrTypeYoutubeDesc;

  /// No description provided for @qrTypeFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get qrTypeFacebook;

  /// No description provided for @qrTypeFacebookDesc.
  ///
  /// In en, this message translates to:
  /// **'Profile or page link'**
  String get qrTypeFacebookDesc;

  /// No description provided for @qrTypeInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get qrTypeInstagram;

  /// No description provided for @qrTypeInstagramDesc.
  ///
  /// In en, this message translates to:
  /// **'Profile link'**
  String get qrTypeInstagramDesc;

  /// No description provided for @fieldWhatsappPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get fieldWhatsappPhone;

  /// No description provided for @fieldWhatsappCountry.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get fieldWhatsappCountry;

  /// No description provided for @fieldWhatsappMessage.
  ///
  /// In en, this message translates to:
  /// **'Message (optional)'**
  String get fieldWhatsappMessage;

  /// No description provided for @fieldYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube URL or video ID'**
  String get fieldYoutube;

  /// No description provided for @fieldFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook username or URL'**
  String get fieldFacebook;

  /// No description provided for @fieldInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram username'**
  String get fieldInstagram;

  /// No description provided for @fieldX.
  ///
  /// In en, this message translates to:
  /// **'X username or URL'**
  String get fieldX;

  /// No description provided for @fieldSpotify.
  ///
  /// In en, this message translates to:
  /// **'Spotify URL or search'**
  String get fieldSpotify;

  /// No description provided for @fieldTiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok username or URL'**
  String get fieldTiktok;

  /// No description provided for @fieldLinkedin.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn username or URL'**
  String get fieldLinkedin;

  /// No description provided for @hintWhatsappPhone.
  ///
  /// In en, this message translates to:
  /// **'5551234567'**
  String get hintWhatsappPhone;

  /// No description provided for @hintYoutube.
  ///
  /// In en, this message translates to:
  /// **'https://youtu.be/… or video ID'**
  String get hintYoutube;

  /// No description provided for @hintFacebook.
  ///
  /// In en, this message translates to:
  /// **'username or https://facebook.com/…'**
  String get hintFacebook;

  /// No description provided for @hintInstagram.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get hintInstagram;

  /// No description provided for @hintX.
  ///
  /// In en, this message translates to:
  /// **'@username or https://x.com/…'**
  String get hintX;

  /// No description provided for @hintSpotify.
  ///
  /// In en, this message translates to:
  /// **'https://open.spotify.com/…'**
  String get hintSpotify;

  /// No description provided for @hintTiktok.
  ///
  /// In en, this message translates to:
  /// **'@username or https://tiktok.com/…'**
  String get hintTiktok;

  /// No description provided for @hintLinkedin.
  ///
  /// In en, this message translates to:
  /// **'username or https://linkedin.com/in/…'**
  String get hintLinkedin;

  /// No description provided for @errorInvalidSocialInput.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid value for this QR type.'**
  String get errorInvalidSocialInput;

  /// No description provided for @qrCustomizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize QR'**
  String get qrCustomizeTitle;

  /// No description provided for @qrCustomizeColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get qrCustomizeColor;

  /// No description provided for @qrCustomizeShape.
  ///
  /// In en, this message translates to:
  /// **'Module shape'**
  String get qrCustomizeShape;

  /// No description provided for @qrShapeSquare.
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get qrShapeSquare;

  /// No description provided for @qrShapeCircle.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get qrShapeCircle;

  /// No description provided for @barcodeTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Barcode type'**
  String get barcodeTypeTitle;

  /// No description provided for @barcodeTypeCode128.
  ///
  /// In en, this message translates to:
  /// **'Code 128'**
  String get barcodeTypeCode128;

  /// No description provided for @barcodeTypeCode128Desc.
  ///
  /// In en, this message translates to:
  /// **'Letters, numbers and symbols'**
  String get barcodeTypeCode128Desc;

  /// No description provided for @barcodeTypeEan8.
  ///
  /// In en, this message translates to:
  /// **'EAN-8'**
  String get barcodeTypeEan8;

  /// No description provided for @barcodeTypeEan8Desc.
  ///
  /// In en, this message translates to:
  /// **'7 or 8 digit product code'**
  String get barcodeTypeEan8Desc;

  /// No description provided for @barcodeTypeEan13.
  ///
  /// In en, this message translates to:
  /// **'EAN-13'**
  String get barcodeTypeEan13;

  /// No description provided for @barcodeTypeEan13Desc.
  ///
  /// In en, this message translates to:
  /// **'12 or 13 digit product code'**
  String get barcodeTypeEan13Desc;

  /// No description provided for @fieldText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get fieldText;

  /// No description provided for @fieldUrl.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get fieldUrl;

  /// No description provided for @fieldSsid.
  ///
  /// In en, this message translates to:
  /// **'Network name (SSID)'**
  String get fieldSsid;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get fieldSecurity;

  /// No description provided for @fieldHiddenNetwork.
  ///
  /// In en, this message translates to:
  /// **'Hidden network'**
  String get fieldHiddenNetwork;

  /// No description provided for @fieldFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get fieldFirstName;

  /// No description provided for @fieldLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get fieldLastName;

  /// No description provided for @fieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get fieldPhone;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get fieldEmailSubject;

  /// No description provided for @fieldEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Body (optional)'**
  String get fieldEmailBody;

  /// No description provided for @fieldEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Event title'**
  String get fieldEventTitle;

  /// No description provided for @fieldEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location (optional)'**
  String get fieldEventLocation;

  /// No description provided for @fieldEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get fieldEventDescription;

  /// No description provided for @fieldEventStart.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get fieldEventStart;

  /// No description provided for @fieldEventPick.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick'**
  String get fieldEventPick;

  /// No description provided for @fieldOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get fieldOrganization;

  /// No description provided for @fieldAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get fieldAddress;

  /// No description provided for @fieldWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get fieldWebsite;

  /// No description provided for @fieldBarcodeData.
  ///
  /// In en, this message translates to:
  /// **'Barcode data'**
  String get fieldBarcodeData;

  /// No description provided for @hintUrl.
  ///
  /// In en, this message translates to:
  /// **'https://example.com'**
  String get hintUrl;

  /// No description provided for @securityWpa.
  ///
  /// In en, this message translates to:
  /// **'WPA / WPA2'**
  String get securityWpa;

  /// No description provided for @securityWep.
  ///
  /// In en, this message translates to:
  /// **'WEP'**
  String get securityWep;

  /// No description provided for @securityNone.
  ///
  /// In en, this message translates to:
  /// **'None (open)'**
  String get securityNone;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get previewTitle;

  /// No description provided for @previewType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get previewType;

  /// No description provided for @previewContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get previewContent;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export format'**
  String get exportTitle;

  /// No description provided for @exportJpeg.
  ///
  /// In en, this message translates to:
  /// **'JPEG'**
  String get exportJpeg;

  /// No description provided for @exportPng.
  ///
  /// In en, this message translates to:
  /// **'PNG (with background)'**
  String get exportPng;

  /// No description provided for @exportPngTransparent.
  ///
  /// In en, this message translates to:
  /// **'PNG transparent (1000×1000)'**
  String get exportPngTransparent;

  /// No description provided for @exportSvg.
  ///
  /// In en, this message translates to:
  /// **'Editable Vector SVG'**
  String get exportSvg;

  /// No description provided for @exportFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get exportFree;

  /// No description provided for @exportPremium.
  ///
  /// In en, this message translates to:
  /// **'Watch ad'**
  String get exportPremium;

  /// No description provided for @exportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get exportComingSoon;

  /// No description provided for @exportComingSoonHint.
  ///
  /// In en, this message translates to:
  /// **'Available in a future update.'**
  String get exportComingSoonHint;

  /// No description provided for @exportLoadingAd.
  ///
  /// In en, this message translates to:
  /// **'Loading ad…'**
  String get exportLoadingAd;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get exporting;

  /// No description provided for @exportSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Save to Downloads'**
  String get exportSaveFile;

  /// No description provided for @exportSaveDownloadsHint.
  ///
  /// In en, this message translates to:
  /// **'Keeps transparent background'**
  String get exportSaveDownloadsHint;

  /// No description provided for @exportSavedFile.
  ///
  /// In en, this message translates to:
  /// **'Saved to Downloads.'**
  String get exportSavedFile;

  /// No description provided for @exportSavedTransparentPng.
  ///
  /// In en, this message translates to:
  /// **'Transparent PNG (1000×1000) saved to Downloads.'**
  String get exportSavedTransparentPng;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scannerTitle;

  /// No description provided for @scannerHint.
  ///
  /// In en, this message translates to:
  /// **'Align the code inside the frame'**
  String get scannerHint;

  /// No description provided for @scannerHintShort.
  ///
  /// In en, this message translates to:
  /// **'Point at a code'**
  String get scannerHintShort;

  /// No description provided for @scannerNoCodeInImage.
  ///
  /// In en, this message translates to:
  /// **'No QR or barcode found in this image.'**
  String get scannerNoCodeInImage;

  /// No description provided for @scannerPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera permission needed'**
  String get scannerPermissionTitle;

  /// No description provided for @scannerPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Camera access is used only to scan QR codes and barcodes. Nothing is uploaded.'**
  String get scannerPermissionBody;

  /// No description provided for @cameraAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow camera access'**
  String get cameraAccessTitle;

  /// No description provided for @cameraAccessBody.
  ///
  /// In en, this message translates to:
  /// **'VectorQR uses the camera only to scan QR codes and barcodes on your device. Nothing is uploaded.'**
  String get cameraAccessBody;

  /// No description provided for @cameraAccessScan.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission for scanning'**
  String get cameraAccessScan;

  /// No description provided for @cameraAccessFlash.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission for flash light'**
  String get cameraAccessFlash;

  /// No description provided for @cameraAccessGrant.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get cameraAccessGrant;

  /// No description provided for @startupPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get startupPermissionsTitle;

  /// No description provided for @startupPermissionsBody.
  ///
  /// In en, this message translates to:
  /// **'This app needs camera access to scan codes, and contacts access so you can import a contact into a QR code. Nothing is uploaded.'**
  String get startupPermissionsBody;

  /// No description provided for @scannerPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission was denied.'**
  String get scannerPermissionDenied;

  /// No description provided for @scannerPermissionPermanent.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is permanently denied. Open Settings to enable it.'**
  String get scannerPermissionPermanent;

  /// No description provided for @scannerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Camera is unavailable on this device.'**
  String get scannerUnavailable;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan result'**
  String get resultTitle;

  /// No description provided for @resultWifiTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi‑Fi network'**
  String get resultWifiTitle;

  /// No description provided for @resultContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get resultContactTitle;

  /// No description provided for @resultCreateQr.
  ///
  /// In en, this message translates to:
  /// **'Create QR from result'**
  String get resultCreateQr;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTitleShort.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitleShort;

  /// No description provided for @settingsCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get settingsCollection;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get settingsGeneral;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsHelp;

  /// No description provided for @settingsBeep.
  ///
  /// In en, this message translates to:
  /// **'Scan sound'**
  String get settingsBeep;

  /// No description provided for @settingsBeepHint.
  ///
  /// In en, this message translates to:
  /// **'Play a click when a code is found'**
  String get settingsBeepHint;

  /// No description provided for @settingsVibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get settingsVibrate;

  /// No description provided for @settingsNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get settingsNotification;

  /// No description provided for @settingsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get settingsSearch;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get settingsRate;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyOptions.
  ///
  /// In en, this message translates to:
  /// **'Privacy options'**
  String get settingsPrivacyOptions;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @errorEmptyInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value.'**
  String get errorEmptyInput;

  /// No description provided for @errorInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid http:// or https:// URL.'**
  String get errorInvalidUrl;

  /// No description provided for @errorWifiSsidRequired.
  ///
  /// In en, this message translates to:
  /// **'Network name is required.'**
  String get errorWifiSsidRequired;

  /// No description provided for @errorContactNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least a first or last name.'**
  String get errorContactNameRequired;

  /// No description provided for @errorEanInvalidLength.
  ///
  /// In en, this message translates to:
  /// **'Enter the correct number of digits.'**
  String get errorEanInvalidLength;

  /// No description provided for @errorEanInvalidChecksum.
  ///
  /// In en, this message translates to:
  /// **'Invalid check digit.'**
  String get errorEanInvalidChecksum;

  /// No description provided for @errorEanNonNumeric.
  ///
  /// In en, this message translates to:
  /// **'EAN codes must contain only digits.'**
  String get errorEanNonNumeric;

  /// No description provided for @errorCode128Empty.
  ///
  /// In en, this message translates to:
  /// **'Enter barcode data.'**
  String get errorCode128Empty;

  /// No description provided for @errorCode128IllegalChar.
  ///
  /// In en, this message translates to:
  /// **'This character is not supported by Code 128.'**
  String get errorCode128IllegalChar;

  /// No description provided for @errorExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get errorExportFailed;

  /// No description provided for @errorShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Sharing failed. Please try again.'**
  String get errorShareFailed;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save to gallery.'**
  String get errorSaveFailed;

  /// No description provided for @errorAdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Ad could not load. Check your connection and try again.'**
  String get errorAdUnavailable;

  /// No description provided for @errorAdNotEarned.
  ///
  /// In en, this message translates to:
  /// **'Watch the full ad to unlock this export.'**
  String get errorAdNotEarned;

  /// No description provided for @errorOfflineAds.
  ///
  /// In en, this message translates to:
  /// **'Ads need an internet connection.'**
  String get errorOfflineAds;

  /// No description provided for @errorCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan.'**
  String get errorCameraDenied;

  /// No description provided for @errorContactsDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is required to import a contact.'**
  String get errorContactsDenied;

  /// No description provided for @errorContactPickCancelled.
  ///
  /// In en, this message translates to:
  /// **'No contact selected.'**
  String get errorContactPickCancelled;

  /// No description provided for @errorContactPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not import the contact. Try again.'**
  String get errorContactPickFailed;

  /// No description provided for @actionPickContact.
  ///
  /// In en, this message translates to:
  /// **'Pick from contacts'**
  String get actionPickContact;

  /// No description provided for @contactImportedHint.
  ///
  /// In en, this message translates to:
  /// **'Fields filled from your contact. Edit if needed, then generate.'**
  String get contactImportedHint;

  /// No description provided for @errorUnsupportedFormat.
  ///
  /// In en, this message translates to:
  /// **'This format is not supported.'**
  String get errorUnsupportedFormat;

  /// No description provided for @errorQrTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Content is too large for a QR code.'**
  String get errorQrTooLarge;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @labelRequiresAd.
  ///
  /// In en, this message translates to:
  /// **'Requires ad'**
  String get labelRequiresAd;

  /// No description provided for @actionTorch.
  ///
  /// In en, this message translates to:
  /// **'Torch'**
  String get actionTorch;

  /// No description provided for @labelYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get labelYes;

  /// No description provided for @labelNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get labelNo;

  /// No description provided for @labelUnknownFormat.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get labelUnknownFormat;

  /// No description provided for @semanticsQrPreview.
  ///
  /// In en, this message translates to:
  /// **'QR code preview'**
  String get semanticsQrPreview;

  /// No description provided for @semanticsBarcodePreview.
  ///
  /// In en, this message translates to:
  /// **'Barcode preview'**
  String get semanticsBarcodePreview;

  /// No description provided for @semanticsHomeAction.
  ///
  /// In en, this message translates to:
  /// **'Open {title}'**
  String semanticsHomeAction(String title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
