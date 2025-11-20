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
  final customers = await ref.read(customerRepositoryProvider).list();

  final set = <String>{};
  for (final c in customers) {
    final name = c.name.trim();
    if (name.isNotEmpty) set.add(name);
  }
  final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return list;
});

final customerListProvider = FutureProvider.autoDispose<List<Customer>>((ref) async {
  final repo = ref.read(customerRepositoryProvider);
  return repo.list();
});

// State providers to hold last-known counts for various tabs
final lastCountProvider = StateProvider<int>((ref) => 0);
final todayCountProvider = StateProvider<int>((ref) => 0);
final thisWeekCountProvider = StateProvider<int>((ref) => 0);
final thisMonthCountProvider = StateProvider<int>((ref) => 0);
final prevMonthsCountProvider = StateProvider<int>((ref) => 0);
final laterCountProvider = StateProvider<int>((ref) => 0);
final waitingCountProvider = StateProvider<int>((ref) => 0);
final doneCountProvider = StateProvider<int>((ref) => 0);

final screenTypeProvider = StateProvider<ScreenType>((ref) => ScreenType.tasks);

// Calendar sub-view mode: calendar table or list view
enum CalendarViewMode { calendar, list }

final calendarViewModeProvider = StateProvider<CalendarViewMode>((ref) => CalendarViewMode.calendar);

// Date range for calendar list view
final calendarStartDateProvider = StateProvider<DateTime?>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1); // First day of current month
});
final calendarEndDateProvider = StateProvider<DateTime?>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month + 1, 0); // Last day of current month
});

// Provider that fetches all tab counts at once
final allTabCountsProvider = FutureProvider.autoDispose<Map<String, int>>((ref) async {
  final repo = ref.read(taskRepositoryProvider);
  final counts = <String, int>{};

  // Fetch counts for all tabs in parallel
  final results = await Future.wait([
    repo.list(tab: 'inbox'),
    repo.list(tab: 'today'),
    repo.list(tab: 'week'),
    repo.list(tab: 'month'),
    repo.list(tab: 'later'),
    repo.list(tab: 'waiting'),
    repo.list(tab: 'done'),
  ]);

  counts['inbox'] = results[0].length;
  counts['today'] = results[1].length;
  counts['week'] = results[2].length;
  counts['month'] = results[3].length;
  counts['later'] = results[4].length;
  counts['waiting'] = results[5].length;
  counts['done'] = results[6].length;

  return counts;
});
