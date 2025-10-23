import 'package:flutter_riverpod/flutter_riverpod.dart';
// Change this to your backend base URL
final baseUrlProvider = Provider<String>((ref) => const String.fromEnvironment(
      'TASKHO_BASE_URL',
      defaultValue: 'http://localhost:4000/api',
    ));
