// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskFormResultImpl _$$TaskFormResultImplFromJson(Map<String, dynamic> json) =>
    _$TaskFormResultImpl(
      id: json['id'] as String?,
      customer: json['customer'] as String?,
      title: json['title'] as String,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      notes: json['notes'] as String?,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskFormResultImplToJson(
        _$TaskFormResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'title': instance.title,
      'dueDate': instance.dueDate?.toIso8601String(),
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'notes': instance.notes,
      'isCompleted': instance.isCompleted,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
};
