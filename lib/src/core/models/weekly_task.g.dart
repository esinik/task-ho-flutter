// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WeeklyNoteImpl _$$WeeklyNoteImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyNoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      notes: json['notes'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$WeeklyNoteImplToJson(_$WeeklyNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'notes': instance.notes,
      'isCompleted': instance.isCompleted,
    };
