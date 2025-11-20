import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weekly_task.dart';
import '../repo/calendar.dart';

/// Current week's Monday date (YYYY-MM-DD)
final currentWeekStartProvider = StateProvider<String>((ref) {
  final now = DateTime.now();
  final monday = now.subtract(Duration(days: (now.weekday - 1) % 7));
  return '${monday.year}-${monday.month.toString().padLeft(2, '0')}-${monday.day.toString().padLeft(2, '0')}';
});

/// Weekly calendar data provider
final weeklyCalendarProvider = FutureProvider.autoDispose<WeeklyCalendarData>((ref) async {
  final repo = ref.read(calendarRepositoryProvider);
  final startDate = ref.watch(currentWeekStartProvider);
  return repo.getWeeklyData(startDate: startDate);
});
