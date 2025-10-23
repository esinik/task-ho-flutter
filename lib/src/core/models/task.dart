import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
class Task with _$Task {
  const factory Task({
    String? id,
    required String tab,
    required String customer,
    required String title,
    required String type,
    required String due, // ISO date
    required String priority, // High/Medium/Low
    @Default('') String notes,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
