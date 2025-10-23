// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String?,
      tab: json['tab'] as String,
      customer: json['customer'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      due: json['due'] as String,
      priority: json['priority'] as String,
      notes: json['notes'] as String? ?? '',
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tab': instance.tab,
      'customer': instance.customer,
      'title': instance.title,
      'type': instance.type,
      'due': instance.due,
      'priority': instance.priority,
      'notes': instance.notes,
    };
