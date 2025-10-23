// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeeImpl _$$FeeImplFromJson(Map<String, dynamic> json) => _$FeeImpl(
      id: json['id'] as String?,
      customer: json['customer'] as String,
      month: json['month'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      note: json['note'] as String? ?? '',
    );

Map<String, dynamic> _$$FeeImplToJson(_$FeeImpl instance) => <String, dynamic>{
      'id': instance.id,
      'customer': instance.customer,
      'month': instance.month,
      'amount': instance.amount,
      'status': instance.status,
      'note': instance.note,
    };
