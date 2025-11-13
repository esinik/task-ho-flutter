// Log event types
enum LogEventType {
  screenView,
  apiRequest,
  apiResponse,
  apiError,
  login,
  logout,
  buttonClick,
  dataCreate,
  dataUpdate,
  dataDelete,
  error,
  warning,
  info,
}

// Log event model
class LogEvent {
  final String id;
  final LogEventType type;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  LogEvent({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory LogEvent.fromJson(Map<String, dynamic> json) {
    return LogEvent(
      id: json['id'] as String,
      type: LogEventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LogEventType.info,
      ),
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}
