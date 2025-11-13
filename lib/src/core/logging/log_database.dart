import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'log_event.dart';

class LogDatabase {
  static final LogDatabase _instance = LogDatabase._internal();
  static Database? _database;

  factory LogDatabase() => _instance;

  LogDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'taskho_logs.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE logs (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // Create index for faster timestamp queries
    await db.execute('''
      CREATE INDEX idx_timestamp ON logs(timestamp DESC)
    ''');
  }

  Future<void> insertLog(LogEvent event) async {
    final db = await database;
    await db.insert(
      'logs',
      {
        'id': event.id,
        'type': event.type.name,
        'message': event.message,
        'timestamp': event.timestamp.toIso8601String(),
        'metadata': event.metadata?.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LogEvent>> getAllLogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'logs',
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) {
      return LogEvent(
        id: map['id'] as String,
        type: LogEventType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => LogEventType.info,
        ),
        message: map['message'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        metadata: map['metadata'] != null ? {'raw': map['metadata']} : null,
      );
    }).toList();
  }

  Future<List<LogEvent>> getLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'logs',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) {
      return LogEvent(
        id: map['id'] as String,
        type: LogEventType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => LogEventType.info,
        ),
        message: map['message'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        metadata: map['metadata'] != null ? {'raw': map['metadata']} : null,
      );
    }).toList();
  }

  Future<void> clearOldLogs(int daysToKeep) async {
    final db = await database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    await db.delete(
      'logs',
      where: 'timestamp < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
  }

  Future<void> clearAllLogs() async {
    final db = await database;
    await db.delete('logs');
  }

  Future<int> getLogCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM logs');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Runs WAL checkpoint and VACUUM to reclaim disk space.
  /// - Must not be called inside an open transaction.
  /// - Safe to call while the database is open.
  Future<void> vacuum() async {
    final db = await database;
    // If running in WAL mode, truncate the WAL file first (noop if not WAL)
    await db.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    // Rebuild the database file to reclaim free pages
    await db.execute('VACUUM');
  }

  /// Optional maintenance helper: delete old logs then vacuum.
  Future<void> maintain({int? daysToKeep}) async {
    if (daysToKeep != null) {
      await clearOldLogs(daysToKeep);
    }
    await vacuum();
  }
}
