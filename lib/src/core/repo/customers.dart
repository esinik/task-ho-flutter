import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../repo/common.dart';
import '../../core/models/customer.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final client = ref.watch(apiClientProvider).dio;
  return CustomerRepository(client);
});

class CustomerRepository {
  final Dio _dio;
  CustomerRepository(this._dio);

  Future<List<Customer>> list({String? q}) async {
    final res = await _dio.get('/customers', queryParameters: {
      if (q != null && q.isNotEmpty) 'q': q,
    });
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Customer.fromJson).toList();
  }

  Future<Customer> create(String name, {bool isPaid = false, double fee = 0}) async {
    final res = await _dio.post('/customers', data: {
      'name': name,
      'isPaid': isPaid,
      'fee': fee,
    });
    return Customer.fromJson(res.data);
  }
}
