import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import 'log_event.dart';
import 'log_database.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  final LogDatabase _database = LogDatabase();
  final _uuid = const Uuid();

  factory AppLogger() => _instance;

  AppLogger._internal();

  // Log screen navigation
  Future<void> logScreenView(String screenName, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.screenView,
      message: 'Screen viewed: $screenName',
      metadata: metadata,
    );
  }

  // Log API requests
  Future<void> logApiRequest(
    String method,
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    await _log(
      type: LogEventType.apiRequest,
      message: '$method $url',
      metadata: {
        'method': method,
        'url': url,
        'data': data,
        'headers': headers,
      },
    );
  }

  // Log API responses
  Future<void> logApiResponse(
    String method,
    String url,
    int statusCode, {
    dynamic data,
  }) async {
    await _log(
      type: LogEventType.apiResponse,
      message: '$method $url - Status: $statusCode',
      metadata: {
        'method': method,
        'url': url,
        'statusCode': statusCode,
        'data': data,
      },
    );
  }

  // Log API errors
  Future<void> logApiError(
    String method,
    String url,
    String error, {
    Map<String, dynamic>? metadata,
  }) async {
    await _log(
      type: LogEventType.apiError,
      message: '$method $url - Error: $error',
      metadata: {
        'method': method,
        'url': url,
        'error': error,
        ...?metadata,
      },
    );
  }

  // Log user login (without password)
  Future<void> logLogin(String username, {bool success = true}) async {
    await _log(
      type: LogEventType.login,
      message: success ? 'User logged in: $username' : 'Login failed for: $username',
      metadata: {
        'username': username,
        'success': success,
      },
    );
  }

  // Log user logout
  Future<void> logLogout(String username) async {
    await _log(
      type: LogEventType.logout,
      message: 'User logged out: $username',
      metadata: {'username': username},
    );
  }

  // Log button clicks
  Future<void> logButtonClick(String buttonName, String screen, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.buttonClick,
      message: 'Button clicked: $buttonName on $screen',
      metadata: {
        'button': buttonName,
        'screen': screen,
        ...?metadata,
      },
    );
  }

  // Log data operations
  Future<void> logDataCreate(String entityType, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.dataCreate,
      message: 'Created: $entityType',
      metadata: {'entityType': entityType, ...?metadata},
    );
  }

  Future<void> logDataUpdate(String entityType, String entityId, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.dataUpdate,
      message: 'Updated: $entityType ($entityId)',
      metadata: {
        'entityType': entityType,
        'entityId': entityId,
        ...?metadata,
      },
    );
  }

  Future<void> logDataDelete(String entityType, String entityId, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.dataDelete,
      message: 'Deleted: $entityType ($entityId)',
      metadata: {
        'entityType': entityType,
        'entityId': entityId,
        ...?metadata,
      },
    );
  }

  // Log errors
  Future<void> logError(String message, {Map<String, dynamic>? metadata, StackTrace? stackTrace}) async {
    await _log(
      type: LogEventType.error,
      message: message,
      metadata: {
        ...?metadata,
        if (stackTrace != null) 'stackTrace': stackTrace.toString(),
      },
    );
  }

  // Log warnings
  Future<void> logWarning(String message, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.warning,
      message: message,
      metadata: metadata,
    );
  }

  // Log info
  Future<void> logInfo(String message, {Map<String, dynamic>? metadata}) async {
    await _log(
      type: LogEventType.info,
      message: message,
      metadata: metadata,
    );
  }

  // Get all logs
  Future<List<LogEvent>> getAllLogs() async {
    return await _database.getAllLogs();
  }

  // Get logs by date range
  Future<List<LogEvent>> getLogsByDateRange(DateTime startDate, DateTime endDate) async {
    return await _database.getLogsByDateRange(startDate, endDate);
  }

  // Clear old logs
  Future<void> clearOldLogs(int daysToKeep) async {
    await _database.clearOldLogs(daysToKeep);
  }

  // Clear all logs
  Future<void> clearAllLogs() async {
    await _database.clearAllLogs();
  }

  // Get log count
  Future<int> getLogCount() async {
    return await _database.getLogCount();
  }

  // Private method to log events
  Future<void> _log({
    required LogEventType type,
    required String message,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final event = LogEvent(
        id: _uuid.v4(),
        type: type,
        message: message,
        timestamp: DateTime.now(),
        metadata: metadata,
      );

      // Save to database
      await _database.insertLog(event);

      // Also log to console in debug mode
      developer.log(
        message,
        name: 'AppLogger',
        time: event.timestamp,
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to log event: $e',
        name: 'AppLogger',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
