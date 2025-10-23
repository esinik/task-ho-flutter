import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../repo/common.dart';
import '../../core/models/fee.dart';

final feeRepositoryProvider = Provider<FeeRepository>((ref) {
  final client = ref.watch(apiClientProvider).dio;
  return FeeRepository(client);
});

class FeeRepository {
  final Dio _dio;
  FeeRepository(this._dio);

  Future<List<Fee>> list({String? customer, String? month, String? status}) async {
    final res = await _dio.get('/fees', queryParameters: {
      if (customer != null && customer.isNotEmpty) 'customer': customer,
      if (month != null && month.isNotEmpty) 'month': month,
      if (status != null && status.isNotEmpty) 'status': status,
    });
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Fee.fromJson).toList();
  }

  Future<Fee> create(Fee f) async {
    final res = await _dio.post('/fees', data: f.toJson());
    return Fee.fromJson(res.data);
  }

  Future<Fee> update(String id, Map<String, dynamic> patch) async {
    final res = await _dio.patch('/fees/$id', data: patch);
    return Fee.fromJson(res.data);
  }

  Future<void> remove(String id) async {
    await _dio.delete('/fees/$id');
  }
}
