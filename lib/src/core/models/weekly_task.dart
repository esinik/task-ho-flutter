import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_task.freezed.dart';
part 'weekly_task.g.dart';

/// Takvim hücresinde gösterilecek not bilgisi
@freezed
class WeeklyNote with _$WeeklyNote {
  const factory WeeklyNote({
    required String id,
    required String title,
    @Default('') String notes,
    @Default(false) bool isCompleted,
  }) = _WeeklyNote;

  factory WeeklyNote.fromJson(Map<String, dynamic> json) => _$WeeklyNoteFromJson(json);
}

/// Haftalık takvim verisi
@freezed
class WeeklyCalendarData with _$WeeklyCalendarData {
  const factory WeeklyCalendarData({
    required String startDate, // YYYY-MM-DD (Monday)
    required String endDate, // YYYY-MM-DD (Sunday)
    required Map<String, Map<String, List<WeeklyNote>>> notes, // customer -> date -> notes[]
  }) = _WeeklyCalendarData;

  factory WeeklyCalendarData.fromJson(Map<String, dynamic> json) {
    final notesRaw = json['notes'] as Map<String, dynamic>? ?? {};
    final Map<String, Map<String, List<WeeklyNote>>> parsedNotes = {};

    notesRaw.forEach((customer, datesMap) {
      final Map<String, List<WeeklyNote>> customerNotes = {};
      (datesMap as Map<String, dynamic>).forEach((date, notesList) {
        customerNotes[date] = (notesList as List).map((n) => WeeklyNote.fromJson(n as Map<String, dynamic>)).toList();
      });
      parsedNotes[customer] = customerNotes;
    });

    return WeeklyCalendarData(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      notes: parsedNotes,
    );
  }
}
