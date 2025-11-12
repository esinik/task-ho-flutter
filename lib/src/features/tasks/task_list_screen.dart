import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskho/src/core/enums/enums.dart';
import 'package:taskho/src/core/enums/router_enums.dart';
import 'package:taskho/src/core/providers/providers.dart';
import 'package:taskho/src/features/tasks/widgets/customer_manager_dialog.dart';
import 'package:taskho/src/features/tasks/widgets/filter_bar.dart';
import 'package:taskho/src/features/tasks/widgets/task_table.dart';
import 'package:taskho/src/features/tasks/widgets/title_and_logo.dart';
import 'package:taskho/src/features/tasks/widgets/tools_button_list.dart';
import 'package:taskho/src/features/tasks/widgets/task_detail_dialog.dart';
import '../../core/models/task.dart';
import 'package:taskho/src/core/repo/tasks.dart';
import 'package:taskho/src/core/repo/customers.dart';

const _tabs = ['inbox', 'today', 'week', 'month', 'later', 'waiting', 'done'];

class TaskListScreen extends ConsumerWidget implements ToolsButtonsDelegate {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(currentTabProvider);
    final tasks = ref.watch(taskListProvider);

    // Fetch all tab counts on initial load
    final allCounts = ref.watch(allTabCountsProvider);

    initProviderListeners(ref);

    // Update all counts when allCounts loads
    allCounts.whenData((counts) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(lastCountProvider.notifier).state = counts['inbox'] ?? 0;
        ref.read(todayCountProvider.notifier).state = counts['today'] ?? 0;
        ref.read(thisWeekCountProvider.notifier).state = counts['week'] ?? 0;
        ref.read(thisMonthCountProvider.notifier).state = counts['month'] ?? 0;
        ref.read(laterCountProvider.notifier).state = counts['later'] ?? 0;
        ref.read(waitingCountProvider.notifier).state = counts['waiting'] ?? 0;
        ref.read(doneCountProvider.notifier).state = counts['done'] ?? 0;
      });
    });

    final totalCount = ref.watch(lastCountProvider);
    final todayCount = ref.watch(todayCountProvider);
    final thisWeekCount = ref.watch(thisWeekCountProvider);
    final laterCount = ref.watch(laterCountProvider);
    final waitingCount = ref.watch(waitingCountProvider);
    final doneCount = ref.watch(doneCountProvider);

    final filteredTasks = tasks.when(
      data: (rows) => TaskTable(rows: rows),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          headerBar(context),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _tabs.indexOf(tab),
                  onDestinationSelected: (i) {
                    ref.read(currentTabProvider.notifier).state = _tabs[i];
                    ref.invalidate(taskListProvider);
                  },
                  minWidth: 120,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.inbox_outlined),
                      label: Text('Inbox: $totalCount'),
                    ),
                    NavigationRailDestination(icon: Icon(Icons.today_outlined), label: Text('Today: $todayCount')),
                    NavigationRailDestination(
                        icon: Icon(Icons.view_week_outlined), label: Text('This Week: $thisWeekCount')),
                    NavigationRailDestination(
                        icon: Icon(Icons.calendar_month_outlined),
                        label: Text('This Month: ${ref.watch(thisMonthCountProvider)}')),
                    NavigationRailDestination(icon: Icon(Icons.schedule_outlined), label: Text('Later: $laterCount')),
                    NavigationRailDestination(
                        icon: Icon(Icons.hourglass_top_outlined), label: Text('Waiting: $waitingCount')),
                    NavigationRailDestination(icon: Icon(Icons.check_circle_outline), label: Text('Done: $doneCount')),
                  ],
                ),
                const VerticalDivider(width: 1),
                rightSide(totalCount, tab, filteredTasks, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void initProviderListeners(WidgetRef ref) {
    ref.listen<AsyncValue<List<Task>>>(taskListProvider, (previous, next) {
      next.whenData((tasks) {
        ref.read(screenTypeProvider.notifier).state = ScreenType.tasks;
        final tab = ref.read(currentTabProvider);
        final count = tasks.length;
        switch (tab) {
          case 'inbox':
            ref.read(lastCountProvider.notifier).state = count;
          case 'today':
            ref.read(todayCountProvider.notifier).state = count;
          case 'week':
            ref.read(thisWeekCountProvider.notifier).state = count;
          case 'month':
            ref.read(thisMonthCountProvider.notifier).state = count;
          case 'later':
            ref.read(laterCountProvider.notifier).state = count;
          case 'waiting':
            ref.read(waitingCountProvider.notifier).state = count;
          case 'done':
            ref.read(doneCountProvider.notifier).state = count;
          default:
            // do nothing
            break;
        }
      });
    });
  }

  headerBar(BuildContext context) {
    return Row(
      children: [
        TitleAndLogoWidget(),
        Spacer(),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.push(AppRoutes.settings),
          tooltip: 'Ayarlar',
        ),
        const SizedBox(width: 8),
        ToolsButtonsWidget(delegate: this),
      ],
    );
  }

  rightSide(int totalCount, String tab, Widget filteredTasks, WidgetRef ref) {
    final screenType = ref.watch(screenTypeProvider);

    return screenType == ScreenType.fees
        ? SizedBox.shrink()
        : Expanded(
            child: Column(
              children: [
                Container(
                  color: Colors.grey[200],
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tab.toUpperCase()),
                        Text("$totalCount Kayıt"),
                      ],
                    ),
                  ),
                ),
                FiltersBar(),
                Expanded(child: filteredTasks),
              ],
            ),
          );
  }

  @override
  Future<void> onAddTask(WidgetRef ref) async {
    final result = await TaskDetailDialog.show(ref.context);
    if (result == null) return;
    // Task oluşturma: form verisinden backend modeline dönüştür.
    String tab = 'inbox';
    final dueDate = result.dueDate;
    if (dueDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);
      final diff = dueDay.difference(today).inDays;
      if (diff == 0) {
        tab = 'today';
      } else if (diff >= 0 && diff <= 7) {
        tab = 'week';
      } else if (dueDate.month == now.month && dueDate.year == now.year) {
        tab = 'month';
      } else if (diff > 7) {
        tab = 'later';
      }
    }

    final isoDue = dueDate != null
        ? '${dueDate.year.toString().padLeft(4, '0')}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}'
        : DateTime.now().toIso8601String();

    final task = Task(
      tab: tab,
      status: result.status.value,
      customer: result.customer ?? '',
      title: result.title,
      type: 'Rapor',
      due: isoDue,
      priority: _priorityToString(result.priority),
      notes: result.notes ?? '',
    );

    final repo = ref.read(taskRepositoryProvider);
    await repo.create(task);
    ref.invalidate(taskListProvider);
  }

  @override
  Future<void> onAddOrEditCustomer(WidgetRef ref) async {
    final result = await CustomerManageDialog.show(ref.context);
    if (result == null || !result.hasChanges) return;

    final repo = ref.read(customerRepositoryProvider);

    // Yeni müşterileri oluştur
    for (final customer in result.created) {
      await repo.create(
        customer.name,
        isPaid: customer.isPaid,
        fee: customer.fee,
      );
    }

    // Güncellenmiş müşteriler için de create çağrılıyor (backend'de aynı name varsa update ediyor)
    for (final customer in result.updated) {
      await repo.create(
        customer.name,
        isPaid: customer.isPaid,
        fee: customer.fee,
      );
    }

    // Silme işlemleri için şu an backend endpoint yok, gerekirse eklenebilir
    // for (final customer in result.deleted) {
    //   if (customer.id != null) {
    //     await repo.delete(customer.id!);
    //   }
    // }

    // Müşteri listesini yenile
    ref.invalidate(customerListProvider);
    ref.invalidate(customerOptionsProvider);
  }

  @override
  void onShowAccountantFees(ref) {
    ref.read(screenTypeProvider.notifier).state = ScreenType.fees;
  }
}

String _priorityToString(TaskPriority p) {
  switch (p) {
    case TaskPriority.low:
      return 'Low';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.high:
      return 'High';
  }
}
