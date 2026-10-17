import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:qr_barcode_app/features/settings/presentation/theme_preference.dart';

enum SearchEngine { google, bing, duckDuckGo }

extension SearchEngineX on SearchEngine {
  String get label => switch (this) {
        SearchEngine.google => 'Google',
        SearchEngine.bing => 'Bing',
        SearchEngine.duckDuckGo => 'DuckDuckGo',
      };

  String searchUrl(String query) {
    final q = Uri.encodeQueryComponent(query);
    return switch (this) {
      SearchEngine.google => 'https://www.google.com/search?q=$q',
      SearchEngine.bing => 'https://www.bing.com/search?q=$q',
      SearchEngine.duckDuckGo => 'https://duckduckgo.com/?q=$q',
    };
  }
}

class AppSettingsState {
  const AppSettingsState({
    this.beep = true,
    this.vibrate = true,
    this.notification = true,
    this.searchEngine = SearchEngine.google,
  });

  final bool beep;
  final bool vibrate;
  final bool notification;
  final SearchEngine searchEngine;

  AppSettingsState copyWith({
    bool? beep,
    bool? vibrate,
    bool? notification,
    SearchEngine? searchEngine,
  }) {
    return AppSettingsState(
      beep: beep ?? this.beep,
      vibrate: vibrate ?? this.vibrate,
      notification: notification ?? this.notification,
      searchEngine: searchEngine ?? this.searchEngine,
    );
  }
}

final appSettingsProvider =
    NotifierProvider<AppSettingsNotifier, AppSettingsState>(
  AppSettingsNotifier.new,
);

class AppSettingsNotifier extends Notifier<AppSettingsState> {
  static const _beepKey = 'settings_beep';
  static const _vibrateKey = 'settings_vibrate';
  static const _notificationKey = 'settings_notification';
  static const _searchKey = 'settings_search_engine';

  @override
  AppSettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final search = switch (prefs.getString(_searchKey)) {
      'bing' => SearchEngine.bing,
      'duckDuckGo' => SearchEngine.duckDuckGo,
      _ => SearchEngine.google,
    };
    return AppSettingsState(
      beep: prefs.getBool(_beepKey) ?? true,
      vibrate: prefs.getBool(_vibrateKey) ?? true,
      notification: prefs.getBool(_notificationKey) ?? true,
      searchEngine: search,
    );
  }

  Future<void> setBeep(bool value) async {
    state = state.copyWith(beep: value);
    await ref.read(sharedPreferencesProvider).setBool(_beepKey, value);
  }

  Future<void> setVibrate(bool value) async {
    state = state.copyWith(vibrate: value);
    await ref.read(sharedPreferencesProvider).setBool(_vibrateKey, value);
  }

  Future<void> setNotification(bool value) async {
    state = state.copyWith(notification: value);
    await ref
        .read(sharedPreferencesProvider)
        .setBool(_notificationKey, value);
  }

  Future<void> setSearchEngine(SearchEngine value) async {
    state = state.copyWith(searchEngine: value);
    await ref
        .read(sharedPreferencesProvider)
        .setString(_searchKey, value.name);
  }
}
