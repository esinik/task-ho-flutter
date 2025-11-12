import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'l10n/app_localizations.dart';
import 'src/app_router.dart';
import 'src/core/providers/auth_provider.dart';
import 'src/core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    Phoenix(
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const TaskHoApp(),
      ),
    ),
  );
}

class TaskHoApp extends ConsumerWidget {
  const TaskHoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);

    log('🏗️ TaskHoApp rebuilding with locale: ${locale.languageCode}');

    return MaterialApp.router(
      key: ValueKey(locale.languageCode), // Force rebuild when locale changes
      debugShowCheckedModeBanner: false,
      title: 'TaskHo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Turkish
        Locale('sq'), // Albanian
        Locale('sr'), // Serbian
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        // Force use of the selected locale
        return locale;
      },
      routerConfig: router,
    );
  }
}
