import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/enums/enums.dart';
import 'package:taskho/src/core/providers/providers.dart';
import 'package:taskho/src/features/tasks/widgets/customer_manager_dialog.dart';
import 'package:taskho/src/features/tasks/widgets/filter_bar.dart';
import 'package:taskho/src/features/tasks/widgets/task_table.dart';
import 'package:taskho/src/features/tasks/widgets/title_and_logo.dart';
import 'package:taskho/src/features/tasks/widgets/tools_button_list.dart';
import 'package:taskho/src/features/tasks/widgets/task_detail_dialog.dart';
import '../../core/models/task.dart';

const _tabs = ['inbox', 'today', 'week', 'later', 'waiting', 'done'];

class TaskListScreen extends ConsumerWidget implements ToolsButtonsDelegate {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(currentTabProvider);
    final tasks = ref.watch(taskListProvider);

    initProviderListeners(ref);
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
                    NavigationRailDestination(icon: Icon(Icons.today_outlined), label: Text('Today :$todayCount')),
                    NavigationRailDestination(
                        icon: Icon(Icons.view_week_outlined), label: Text('This Week: $thisWeekCount')),
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
    // TODO: Burada result verisini backend servisinizle entegre edin.
    // Örnek:
    // await ref.read(taskApiProvider).createTask(result.toJson());
    // ref.invalidate(taskListProvider);
  }

  @override
  Future<void> onAddOrEditCustomer(WidgetRef ref) async {
    await CustomerManageDialog.show(ref.context);
  }

  @override
  void onShowAccountantFees(ref) {
    ref.read(screenTypeProvider.notifier).state = ScreenType.fees;
  }
}
