/// Environment and AdMob configuration.
///
/// Production AdMob units are used by default (including debug).
/// Opt into Google sample units with `--dart-define=USE_SAMPLE_ADS=true`.
class AppEnvironment {
  static const name = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static bool get isDev => name != 'prod';

  /// Google sample ads only when explicitly requested.
  static bool get useSampleAds => const bool.fromEnvironment(
        'USE_SAMPLE_ADS',
        defaultValue: false,
      );
}

class AdUnits {
  // Google sample IDs (optional via USE_SAMPLE_ADS=true).
  static const _sampleAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const _sampleBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const _sampleInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const _sampleRewarded = 'ca-app-pub-3940256099942544/5224354917';

  // VectorQR production AdMob (Play) — default for debug and release.
  static const _prodAppId = 'ca-app-pub-1300636339318232~7128755322';
  static const _prodBanner = 'ca-app-pub-1300636339318232/5456349491';
  static const _prodInterstitial = 'ca-app-pub-1300636339318232/3777445473';
  static const _prodRewarded = 'ca-app-pub-1300636339318232/3738661882';

  static String get applicationId {
    const override = String.fromEnvironment('ADMOB_APP_ID');
    if (override.isNotEmpty) return override;
    return AppEnvironment.useSampleAds ? _sampleAppId : _prodAppId;
  }

  static String get banner {
    const override = String.fromEnvironment('AD_BANNER');
    if (override.isNotEmpty) return override;
    return AppEnvironment.useSampleAds ? _sampleBanner : _prodBanner;
  }

  static String get interstitial {
    const override = String.fromEnvironment('AD_INTERSTITIAL');
    if (override.isNotEmpty) return override;
    return AppEnvironment.useSampleAds ? _sampleInterstitial : _prodInterstitial;
  }

  static String get rewarded {
    const override = String.fromEnvironment('AD_REWARDED');
    if (override.isNotEmpty) return override;
    return AppEnvironment.useSampleAds ? _sampleRewarded : _prodRewarded;
  }
}

class AdPolicy {
  /// Minimum time between interstitial impressions.
  static const interstitialCooldown = Duration(seconds: 60);

  /// Show an interstitial only after this many relevant actions (free exports, etc.).
  static const interstitialEveryNActions = 4;

  /// High-quality transparent PNG edge length (client V1: 1000×1000).
  static const defaultExportSize = 1000;
}

class AppUrls {
  /// Public Privacy Policy (Play Console + in-app). Override with --dart-define=PRIVACY_POLICY_URL=...
  static const privacyPolicy = String.fromEnvironment(
    'PRIVACY_POLICY_URL',
    defaultValue: 'https://rentry.co/vectorqr-privacy-policy',
  );

  /// Public Terms of Service. Override with --dart-define=TERMS_URL=...
  static const termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://rentry.co/vectorqr-terms',
  );
}
