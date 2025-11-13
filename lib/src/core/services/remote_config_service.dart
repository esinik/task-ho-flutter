import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  late final FirebaseRemoteConfig _remoteConfig;
  bool _initialized = false;

  factory RemoteConfigService() => _instance;

  RemoteConfigService._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Ensure Firebase is initialized; ignore errors if not configured
      try {
        await Firebase.initializeApp();
      } catch (_) {}

      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig.setConfigSettings(_defaultSettings());

      await _remoteConfig.fetchAndActivate();
      _initialized = true;
      _logSnapshot('initialized');
    } catch (e, stackTrace) {
      developer.log(
        'Failed to initialize Remote Config: $e',
        name: 'RemoteConfigService',
        error: e,
        stackTrace: stackTrace,
      );
      _initialized = false;
    }
  }

  bool isLoggingEnabled() {
    if (!_initialized) return false;
    return _remoteConfig.getBool('enable_logging');
  }

  bool isUserAllowedToExportLogs(String userEmail) {
    if (!_initialized) return false;

    final allowedUsers = _remoteConfig.getString('allowed_log_users');
    if (allowedUsers.isEmpty) return false;

    // Split by comma and trim whitespace
    final userList = allowedUsers.split(',').map((e) => e.trim().toLowerCase()).toList();

    return userList.contains(userEmail.toLowerCase());
  }

  int getLogRetentionDays() {
    if (!_initialized) return 60; // Default fallback
    return _remoteConfig.getInt('log_retention_days');
  }

  bool isMaintenanceEnabled() {
    if (!_initialized) return false;
    return _remoteConfig.getBool('maintain_db');
  }

  Future<void> refresh({bool force = false}) async {
    if (!_initialized) return;

    try {
      if (force) {
        // Temporarily remove caching to force a network fetch
        await _remoteConfig.setConfigSettings(
          RemoteConfigSettings(
            fetchTimeout: const Duration(seconds: 10),
            minimumFetchInterval: Duration.zero,
          ),
        );
      } else {
        await _remoteConfig.setConfigSettings(_defaultSettings());
      }

      final activated = await _remoteConfig.fetchAndActivate();
      _logSnapshot('refreshed (force=$force, activated=$activated)');
    } catch (e) {
      developer.log('Failed to refresh Remote Config: $e', name: 'RemoteConfigService');
    } finally {
      // Restore defaults for subsequent fetches
      await _remoteConfig.setConfigSettings(_defaultSettings());
    }
  }

  RemoteConfigSettings _defaultSettings() => RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(minutes: 30),
      );

  void _logSnapshot(String phase) {
    try {
      final status = _remoteConfig.lastFetchStatus;
      final lastFetch = _remoteConfig.lastFetchTime;
      final enableLogging = _remoteConfig.getBool('enable_logging');
      final allowedUsers = _remoteConfig.getString('allowed_log_users');
      final retentionDays = _remoteConfig.getInt('log_retention_days');
      final maintainDb = _remoteConfig.getBool('maintain_db');

      developer.log(
        'RemoteConfig $phase\n'
        '  Status: $status\n'
        '  Last Fetch: $lastFetch\n'
        '  enable_logging: $enableLogging\n'
        '  allowed_log_users: "$allowedUsers"\n'
        '  log_retention_days: $retentionDays\n'
        '  maintain_db: $maintainDb',
        name: 'RemoteConfigService',
      );

      // Additional debug: check if values are from defaults or fetched
      developer.log(
        'Value sources:\n'
        '  enable_logging: ${_remoteConfig.getValue('enable_logging').source}\n'
        '  maintain_db: ${_remoteConfig.getValue('maintain_db').source}',
        name: 'RemoteConfigService',
      );
    } catch (e) {
      developer.log('Failed to log snapshot: $e', name: 'RemoteConfigService');
    }
  }
}
