import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
// import 'package:path/path.dart' as path; // Removed unused import
import '../logging/app_logger.dart';
import '../logging/log_event.dart';

class LogExportService {
  static final LogExportService _instance = LogExportService._internal();
  final AppLogger _logger = AppLogger();

  factory LogExportService() => _instance;

  LogExportService._internal();

  /// Exports logs, automatically chunking into multiple parts and zipping when size is large.
  ///
  /// - Chunks are ~`maxPartSizeMB` each (text), bundled as a single `.zip`.
  /// - If small enough, still produces a `.zip` with one part for consistency.
  Future<String?> exportLogs({
    DateTime? startDate,
    DateTime? endDate,
    int maxPartSizeMB = 10,
  }) async {
    try {
      // Get logs from database
      final List<LogEvent> logs;
      if (startDate != null && endDate != null) {
        logs = await _logger.getLogsByDateRange(startDate, endDate);
      } else {
        logs = await _logger.getAllLogs();
      }

      if (logs.isEmpty) {
        return null;
      }

      // Ask user where to save (zip bundle)
      final String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Device Logs (ZIP bundle)',
        fileName: '${_generateFileName(baseNameOnly: true)}.zip',
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (outputPath == null) {
        // User cancelled
        return null;
      }

      // Build a zip archive with chunked parts
      final zipBytes = _buildZipWithChunks(
        logs: logs,
        startDate: startDate,
        endDate: endDate,
        maxPartSizeBytes: maxPartSizeMB * 1024 * 1024,
      );

      final file = File(outputPath);
      await file.writeAsBytes(zipBytes, flush: true);

      return outputPath;
    } catch (e) {
      await _logger.logError('Failed to export logs: $e');
      rethrow;
    }
  }

  String _generateFileName({bool baseNameOnly = false}) {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyyMMdd_HHmmss');
    final name = 'taskho_logs_${dateFormat.format(now)}';
    return baseNameOnly ? name : '$name.txt';
  }

  // Single-file helpers removed in favor of chunked ZIP export

  /// Build a ZIP archive containing one or more text parts each under [maxPartSizeBytes].
  /// Each part contains a header, summary, and detailed logs (text format).
  List<int> _buildZipWithChunks({
    required List<LogEvent> logs,
    required int maxPartSizeBytes,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final archive = Archive();

    // Prepare chunking
    final parts = <String>[]; // part file contents
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    String buildHeader() {
      final buffer = StringBuffer();
      buffer.writeln('=' * 80);
      buffer.writeln('TASKHO DEVICE LOGS (CHUNKED)');
      buffer.writeln('=' * 80);
      buffer.writeln('Generated: ${dateFormat.format(DateTime.now())}');
      buffer.writeln('Total Events: ${logs.length}');
      if (startDate != null && endDate != null) {
        buffer.writeln('Date Range: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}');
      }
      buffer.writeln('-' * 80);
      buffer.writeln();
      return buffer.toString();
    }

    final header = buildHeader();
    final baseOverhead = utf8.encode(header).length + utf8.encode('\nEND OF PART\n').length;

    // Start first part buffer with header
    var current = StringBuffer()..write(header);
    int currentBytes = utf8.encode(header).length;

    void flushPart() {
      current.writeln('-' * 80);
      current.writeln('END OF PART');
      parts.add(current.toString());
      current = StringBuffer();
      currentBytes = 0;
    }

    // Write logs into parts
    for (final log in logs) {
      final entry = StringBuffer();
      entry.writeln('[${dateFormat.format(log.timestamp)}] ${log.type.name.toUpperCase()}');
      entry.writeln('  Message: ${log.message}');
      if (log.metadata != null && log.metadata!.isNotEmpty) {
        entry.writeln('  Metadata:');
        for (final m in log.metadata!.entries) {
          entry.writeln('    ${m.key}: ${m.value}');
        }
      }
      entry.writeln();

      final entryBytes = utf8.encode(entry.toString());
      final projected = currentBytes + entryBytes.length + baseOverhead;
      if (currentBytes == 0) {
        // new part — write header first
        current.write(header);
        currentBytes = utf8.encode(header).length;
      }
      if (projected > maxPartSizeBytes && currentBytes > 0) {
        flushPart();
        current.write(header);
        currentBytes = utf8.encode(header).length;
      }
      current.write(entry.toString());
      currentBytes += entryBytes.length;
    }

    if (currentBytes > 0) {
      flushPart();
    }

    // Add parts to zip
    for (var i = 0; i < parts.length; i++) {
      final filename = 'logs_part_${(i + 1).toString().padLeft(2, '0')}.txt';
      final bytes = utf8.encode(parts[i]);
      archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    }

    // Add manifest
    final manifest = jsonEncode({
      'generatedAt': DateTime.now().toIso8601String(),
      'totalEvents': logs.length,
      'partCount': parts.length,
      'maxPartSizeBytes': maxPartSizeBytes,
      'range': {
        'start': startDate?.toIso8601String(),
        'end': endDate?.toIso8601String(),
      },
      'format': 'text-with-header',
    });
    final manifestBytes = utf8.encode(manifest);
    archive.addFile(ArchiveFile('manifest.json', manifestBytes.length, manifestBytes));

    return ZipEncoder().encode(archive)!;
  }

  Future<Map<String, dynamic>> getLogStats() async {
    final logs = await _logger.getAllLogs();

    final Map<LogEventType, int> typeCounts = {};
    for (final log in logs) {
      typeCounts[log.type] = (typeCounts[log.type] ?? 0) + 1;
    }

    final oldestLog = logs.isNotEmpty ? logs.last.timestamp : null;
    final newestLog = logs.isNotEmpty ? logs.first.timestamp : null;

    return {
      'totalLogs': logs.length,
      'typeCounts': typeCounts.map((key, value) => MapEntry(key.name, value)),
      'oldestLog': oldestLog?.toIso8601String(),
      'newestLog': newestLog?.toIso8601String(),
    };
  }
}
