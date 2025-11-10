import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/enums/enums.dart';
import 'package:taskho/src/core/models/customer.dart';
import 'package:taskho/src/core/models/task.dart';
import 'package:taskho/src/core/repo/customers.dart';
import 'package:taskho/src/core/repo/tasks.dart';

final currentTabProvider = StateProvider<String>((_) => 'inbox');
final filterCustomerProvider = StateProvider<String?>((_) => null);
final filterTypeProvider = StateProvider<String?>((_) => null);

final taskListProvider = FutureProvider.autoDispose<List<Task>>((ref) async {
  final repo = ref.read(taskRepositoryProvider);
  final tab = ref.watch(currentTabProvider);
  final customer = ref.watch(filterCustomerProvider);
  final typ = ref.watch(filterTypeProvider);
  return repo.list(tab: tab, customer: customer, type: typ);
});

// Distinct customer options derived from the full customer list in DB
final customerOptionsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final customers = await ref
      .read(customerRepositoryProvider)
      .list()
      .then((list) => list.map((c) => Customer(name: c.name)).toList());

  final set = <String>{};
  for (final c in customers) {
    // handle either String list or model objects with a `name` field
    String name;
    try {
      // ignore: avoid_dynamic_calls
      name = c.name.toString();
    } catch (_) {
      name = c.toString();
    }
    name = name.trim();
    if (name.isNotEmpty) set.add(name);
  }
  final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return list;
});

// State providers to hold last-known counts for various tabs
final lastCountProvider = StateProvider<int>((ref) => 0);
final todayCountProvider = StateProvider<int>((ref) => 0);
final thisWeekCountProvider = StateProvider<int>((ref) => 0);
final laterCountProvider = StateProvider<int>((ref) => 0);
final waitingCountProvider = StateProvider<int>((ref) => 0);
final doneCountProvider = StateProvider<int>((ref) => 0);

final screenTypeProvider = StateProvider<ScreenType>((ref) => ScreenType.tasks);
