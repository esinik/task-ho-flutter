// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      isPaid: json['isPaid'] as bool? ?? false,
      fee: (json['fee'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isPaid': instance.isPaid,
      'fee': instance.fee,
    };
