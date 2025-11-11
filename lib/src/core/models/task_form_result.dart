import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskho/src/core/enums/enums.dart';

part 'task_form_result.freezed.dart';
part 'task_form_result.g.dart';

@freezed
class TaskFormResult with _$TaskFormResult {
  const factory TaskFormResult({
    String? id,
    String? customer,
    required String title,
    DateTime? dueDate,
    required TaskPriority priority,
    String? notes,
    @Default(false) bool isCompleted,
  }) = _TaskFormResult;

  factory TaskFormResult.fromJson(Map<String, dynamic> json) => _$TaskFormResultFromJson(json);
}
