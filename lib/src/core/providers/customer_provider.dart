import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/customers.dart';
import '../models/customer.dart';

/// Provider for the list of all customers
final customerListProvider = FutureProvider.autoDispose<List<Customer>>((ref) async {
  final repo = ref.read(customerRepositoryProvider);
  return repo.list();
});
