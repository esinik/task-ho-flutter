import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taskho/src/core/enums/enums.dart';
import '../../../l10n/app_localizations.dart';
import 'package:taskho/src/core/enums/router_enums.dart';
import 'package:taskho/src/core/providers/providers.dart';
import 'package:taskho/src/features/tasks/widgets/customer_manager_dialog.dart';
import 'package:taskho/src/features/tasks/widgets/filter_bar.dart';
import 'package:taskho/src/features/tasks/widgets/task_table.dart';
import 'package:taskho/src/features/tasks/widgets/title_and_logo.dart';
import 'package:taskho/src/features/tasks/widgets/tools_button_list.dart';
import '../../core/models/task.dart';
import 'package:taskho/src/core/repo/customers.dart';
import '../fees/fees_screen.dart';
import '../../core/logging/app_logger.dart';

const _tabs = ['inbox', 'today', 'week', 'month', 'later', 'waiting', 'done'];

class TaskListScreen extends ConsumerWidget implements ToolsButtonsDelegate {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Log screen view
    AppLogger().logScreenView('TaskList');
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

    final l10n = AppLocalizations.of(context)!;
    final filteredTasks = tasks.when(
      data: (rows) => TaskTable(rows: rows),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('${l10n.error}: $e')),
    );

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          headerBar(context),
          const SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _tabs.indexOf(tab),
                  onDestinationSelected: (i) {
                    ref.read(currentTabProvider.notifier).state = _tabs[i];
                    ref.invalidate(taskListProvider);
                    AppLogger().logButtonClick('NavRail', 'TaskList', metadata: {
                      'tab': _tabs[i],
                    });
                  },
                  minWidth: 120,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.inbox_outlined),
                      label: Text('${l10n.tabInbox}: $totalCount'),
                    ),
                    NavigationRailDestination(
                        icon: const Icon(Icons.today_outlined), label: Text('${l10n.tabToday}: $todayCount')),
                    NavigationRailDestination(
                        icon: const Icon(Icons.view_week_outlined), label: Text('${l10n.tabWeek}: $thisWeekCount')),
                    NavigationRailDestination(
                        icon: const Icon(Icons.calendar_month_outlined),
                        label: Text('${l10n.tabMonth}: ${ref.watch(thisMonthCountProvider)}')),
                    NavigationRailDestination(
                        icon: const Icon(Icons.schedule_outlined), label: Text('${l10n.tabLater}: $laterCount')),
                    NavigationRailDestination(
                        icon: const Icon(Icons.hourglass_top_outlined),
                        label: Text('${l10n.tabWaiting}: $waitingCount')),
                    NavigationRailDestination(
                        icon: const Icon(Icons.check_circle_outline), label: Text('${l10n.tabDone}: $doneCount')),
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
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        const TitleAndLogoWidget(),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            AppLogger().logButtonClick('OpenSettings', 'TaskList');
            context.push(AppRoutes.settings);
          },
          tooltip: l10n.settings,
        ),
        const SizedBox(width: 8),
        ToolsButtonsWidget(delegate: this),
      ],
    );
  }

  rightSide(int totalCount, String tab, Widget filteredTasks, WidgetRef ref) {
    final l10n = AppLocalizations.of(ref.context)!;
    final screenType = ref.watch(screenTypeProvider);

    return screenType == ScreenType.fees
        ? const Expanded(child: FeesScreen())
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
                        Text(_localizedTabTitle(l10n, tab)),
                        Text(l10n.recordsCount(totalCount)),
                      ],
                    ),
                  ),
                ),
                const FiltersBar(),
                Expanded(child: filteredTasks),
              ],
            ),
          );
  }

  @override
  Future<void> onAddOrEditCustomer(WidgetRef ref) async {
    AppLogger().logButtonClick('AddEditCustomer', 'TaskList');
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
  void onShowTaskList(WidgetRef ref) {
    final currentType = ref.read(screenTypeProvider);
    // Sadece eğer tasks ekranı açık değilse değiştir
    if (currentType != ScreenType.tasks) {
      ref.read(screenTypeProvider.notifier).state = ScreenType.tasks;
      AppLogger().logButtonClick('ShowTaskList', 'TaskList');
    }
  }

  @override
  void onShowAccountantFees(WidgetRef ref) {
    final currentType = ref.read(screenTypeProvider);
    // Sadece eğer fees ekranı açık değilse değiştir
    if (currentType != ScreenType.fees) {
      ref.read(screenTypeProvider.notifier).state = ScreenType.fees;
      AppLogger().logButtonClick('ShowFees', 'TaskList');
    }
  }
}

String _localizedTabTitle(AppLocalizations l10n, String tab) {
  switch (tab) {
    case 'inbox':
      return l10n.tabInbox;
    case 'today':
      return l10n.tabToday;
    case 'week':
      return l10n.tabWeek;
    case 'month':
      return l10n.tabMonth;
    case 'later':
      return l10n.tabLater;
    case 'waiting':
      return l10n.tabWaiting;
    case 'done':
      return l10n.tabDone;
    default:
      return tab.toUpperCase();
  }
}
