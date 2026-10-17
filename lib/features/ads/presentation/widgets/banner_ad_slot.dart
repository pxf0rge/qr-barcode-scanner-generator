import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:qr_barcode_app/core/config/app_config.dart';
import 'package:qr_barcode_app/data/ads/ads_initializer.dart';

/// Bottom banner. Uses anchored adaptive size; hides itself until loaded.
class BannerAdSlot extends StatefulWidget {
  const BannerAdSlot({super.key});

  @override
  State<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends State<BannerAdSlot> {
  BannerAd? _banner;
  bool _loaded = false;
  bool _started = false;
  int _attempts = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _load();
  }

  Future<void> _load() async {
    await AdsInitializer.instance.ensureInitialized();
    if (!AdsInitializer.instance.isInitialized || !mounted) return;

    await AdLoadMutex.run(() async {
      if (!mounted || _loaded) return;
      _attempts++;

      final width = MediaQuery.sizeOf(context).width.truncate();
      final adaptive = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(width);
      final size = adaptive ?? AdSize.banner;

      if (kDebugMode) {
        debugPrint(
          'Banner load attempt=$_attempts unit=${AdUnits.banner} '
          'size=${size.width}x${size.height}',
        );
      }

      final ad = BannerAd(
        adUnitId: AdUnits.banner,
        size: size,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (loaded) {
            if (!mounted) {
              loaded.dispose();
              return;
            }
            setState(() {
              _banner?.dispose();
              _banner = loaded as BannerAd;
              _loaded = true;
            });
          },
          onAdFailedToLoad: (failed, error) {
            debugPrint(
              'Banner failed: code=${error.code} domain=${error.domain} '
              '${error.message}',
            );
            failed.dispose();
            if (!mounted) return;
            setState(() {
              _banner = null;
              _loaded = false;
            });
            if (_attempts < 4) {
              Future<void>.delayed(
                Duration(milliseconds: 800 * _attempts),
                () {
                  if (mounted && !_loaded) _load();
                },
              );
            }
          },
        ),
      );
      await ad.load();
    });
  }

  @override
  void dispose() {
    _banner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (!_loaded || banner == null) {
      // Reserve nothing until loaded so empty slot does not push UI.
      return const SizedBox.shrink();
    }
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        width: double.infinity,
        height: banner.size.height.toDouble(),
        child: Center(
          child: SizedBox(
            width: banner.size.width.toDouble(),
            height: banner.size.height.toDouble(),
            child: AdWidget(ad: banner),
          ),
        ),
      ),
    );
  }
}
