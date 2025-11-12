import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('tr')) {
    _loadLocale();
  }

  static const _localeKey = 'app_locale';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      state = Locale(localeCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    log('🌍 Locale changing to: ${locale.languageCode}');
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    log('✅ Locale changed and saved: ${locale.languageCode}');
  }
}

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
