import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../providers/env.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final base = ref.watch(baseUrlProvider);
  return ApiClient(base);
});
