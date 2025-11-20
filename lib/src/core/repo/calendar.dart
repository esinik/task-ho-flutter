import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../repo/common.dart';
import '../models/weekly_task.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final client = ref.watch(apiClientProvider).dio;
  return CalendarRepository(client);
});

class CalendarRepository {
  final Dio _dio;
  CalendarRepository(this._dio);

  /// Fetch weekly calendar data starting from Monday
  Future<WeeklyCalendarData> getWeeklyData({String? startDate}) async {
    try {
      final res = await _dio.get('/calendar/weekly', queryParameters: {
        if (startDate != null) 'startDate': startDate,
      });
      return WeeklyCalendarData.fromJson(res.data);
    } catch (e) {
      // Return empty data structure on error
      return WeeklyCalendarData(
        startDate: startDate ?? _getMonday(),
        endDate: _getSunday(startDate ?? _getMonday()),
        notes: {},
      );
    }
  }

  String _getMonday() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: (now.weekday - 1) % 7));
    return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
  }

  String _getSunday(String startDate) {
    final start = DateTime.parse(startDate);
    final sunday = start.add(const Duration(days: 6));
    return '${sunday.year}-${sunday.month.toString().padLeft(2, '0')}-${sunday.day.toString().padLeft(2, '0')}';
  }

  /// Create a new calendar note
  Future<void> createNote({
    required String customer,
    required String title,
    required String date, // YYYY-MM-DD
    String? notes,
    bool isCompleted = false,
  }) async {
    await _dio.post('/calendar', data: {
      'customer': customer,
      'title': title,
      'date': date,
      'notes': notes ?? '',
      'isCompleted': isCompleted,
    });
  }

  /// Update an existing calendar note
  Future<void> updateNote({
    required String id,
    required String customer,
    required String title,
    required String date, // YYYY-MM-DD
    String? notes,
    bool isCompleted = false,
  }) async {
    await _dio.put('/calendar/$id', data: {
      'customer': customer,
      'title': title,
      'date': date,
      'notes': notes ?? '',
      'isCompleted': isCompleted,
    });
  }

  /// Get notes in date range with full metadata (customer, date)
  Future<List<Map<String, dynamic>>> getRawNotesInRange({
    String? startDate,
    String? endDate,
    String? customer,
  }) async {
    try {
      final res = await _dio.get('/calendar', queryParameters: {
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
        if (customer != null && customer.isNotEmpty) 'customer': customer,
      });
      return (res.data as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ Error fetching raw notes: $e');
      return [];
    }
  }

  /// Delete a calendar note by id
  Future<bool> deleteNote(String id) async {
    try {
      await _dio.delete('/calendar/$id');
      return true;
    } catch (e) {
      print('❌ Error deleting note $id: $e');
      return false;
    }
  }
}
