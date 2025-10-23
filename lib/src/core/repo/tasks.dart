import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../repo/common.dart';
import '../../core/models/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final client = ref.watch(apiClientProvider).dio;
  return TaskRepository(client);
});

class TaskRepository {
  final Dio _dio;
  TaskRepository(this._dio);

  Future<List<Task>> list({String? tab, String? customer, String? type, bool? overdue}) async {
    final res = await _dio.get('/tasks', queryParameters: {
      if (tab != null && tab.isNotEmpty) 'tab': tab,
      if (customer != null && customer.isNotEmpty) 'customer': customer,
      if (type != null && type.isNotEmpty) 'type': type,
      if (overdue != null) 'overdue': overdue,
    });
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Task.fromJson).toList();
  }

  Future<Task> create(Task t) async {
    final res = await _dio.post('/tasks', data: t.toJson());
    return Task.fromJson(res.data);
  }

  Future<Task> update(String id, Map<String, dynamic> patch) async {
    final res = await _dio.patch('/tasks/$id', data: patch);
    return Task.fromJson(res.data);
  }

  Future<void> remove(String id) async {
    await _dio.delete('/tasks/$id');
  }
}
