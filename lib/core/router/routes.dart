abstract final class AppRoutes {
  static const welcome = '/welcome';
  static const scanner = '/scanner';
  static const history = '/history';
  static const create = '/create';
  static const settings = '/settings';

  /// Legacy alias used by older deep links / tests.
  static const home = create;

  static const qr = '/qr';
  static const qrText = '/qr/text';
  static const qrUrl = '/qr/url';
  static const qrWifi = '/qr/wifi';
  static const qrContact = '/qr/contact';
  static const qrPhone = '/qr/phone';
  static const qrEmail = '/qr/email';
  static const qrCalendar = '/qr/calendar';
  static const qrMyCard = '/qr/my-card';
  static const qrWhatsapp = '/qr/whatsapp';
  static const qrYoutube = '/qr/youtube';
  static const qrFacebook = '/qr/facebook';
  static const qrInstagram = '/qr/instagram';
  static const barcode = '/barcode';
  static const barcodeCode128 = '/barcode/code128';
  static const barcodeEan8 = '/barcode/ean8';
  static const barcodeEan13 = '/barcode/ean13';
  static const preview = '/preview';
  static const result = '/result';
}
