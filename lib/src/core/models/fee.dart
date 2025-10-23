import 'package:freezed_annotation/freezed_annotation.dart';

part 'fee.freezed.dart';
part 'fee.g.dart';

@freezed
class Fee with _$Fee {
  const factory Fee({
    String? id,
    required String customer,
    required String month, // YYYY-MM
    required double amount,
    required String status, // Açık / Ödendi
    @Default('') String note,
  }) = _Fee;

  factory Fee.fromJson(Map<String, dynamic> json) => _$FeeFromJson(json);
}
