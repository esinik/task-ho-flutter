import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/remote_config_service.dart';
import '../services/log_export_service.dart';

// Provider for checking if log export is enabled for user
final logExportEnabledProvider = FutureProvider.family<bool, String>((ref, userEmail) async {
  final remoteConfig = RemoteConfigService();
  // Ensure RC is ready before reading flags
  await remoteConfig.initialize();
  // Only allow when global flag is enabled AND user email is allowlisted
  final enabled = remoteConfig.isLoggingEnabled();
  if (!enabled) return false;
  return remoteConfig.isUserAllowedToExportLogs(userEmail);
});

// Provider for log statistics
final logStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final logExportService = ref.watch(logExportServiceProvider);
  return await logExportService.getLogStats();
});

// Provider for checking if database maintenance is enabled for user
final maintenanceEnabledProvider = FutureProvider.family<bool, String>((ref, userEmail) async {
  final remoteConfig = RemoteConfigService();
  // Ensure RC is ready before reading flags
  await remoteConfig.initialize();
  // Only allow when maintain_db flag is enabled AND user email is allowlisted
  final enabled = remoteConfig.isMaintenanceEnabled();
  if (!enabled) return false;
  return remoteConfig.isUserAllowedToExportLogs(userEmail);
});

// Provider for log export service
final logExportServiceProvider = Provider((ref) {
  return LogExportService();
});
