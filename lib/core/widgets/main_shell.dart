import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qr_barcode_app/features/ads/presentation/widgets/banner_ad_slot.dart';
import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';
import 'package:qr_barcode_app/l10n/app_localizations.dart';

const welcomeCompletedKey = 'welcome_completed_v1';

final welcomeCompletedProvider = Provider<bool>((ref) {
  return ref.watch(sharedPreferencesProvider).getBool(welcomeCompletedKey) ??
      false;
});

class WelcomeGate {
  static Future<void> complete(SharedPreferences prefs) async {
    await prefs.setBool(welcomeCompletedKey, true);
  }
}

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BannerAdSlot(),
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onTap,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.qr_code_scanner_outlined),
                selectedIcon: const Icon(Icons.qr_code_scanner_rounded),
                label: l10n.navScanner,
              ),
              NavigationDestination(
                icon: const Icon(Icons.schedule_outlined),
                selectedIcon: const Icon(Icons.schedule_rounded),
                label: l10n.navHistory,
              ),
              NavigationDestination(
                icon: const Icon(Icons.add_box_outlined),
                selectedIcon: const Icon(Icons.add_box_rounded),
                label: l10n.navCreate,
              ),
              NavigationDestination(
                icon: const Icon(Icons.tune_outlined),
                selectedIcon: const Icon(Icons.tune_rounded),
                label: l10n.navSetting,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
