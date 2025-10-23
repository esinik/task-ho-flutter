import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/repo/tasks.dart';
import '../../core/models/task.dart';
import '../customers/customer_picker.dart';

const _tabs = ['inbox', 'today', 'week', 'later', 'waiting', 'done'];

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

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(currentTabProvider);
    final tasks = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskHo — Tasks'),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CustomerPickerDialog()),
            ),
            icon: const Icon(Icons.person_search_outlined),
            label: const Text('Müşteri Seç'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () async {
              final repo = ref.read(taskRepositoryProvider);
              final created = await repo.create(Task(
                tab: tab == 'done' ? 'inbox' : tab,
                customer: '',
                title: 'Yeni Görev',
                type: 'Rapor',
                due: DateTime.now().toIso8601String().substring(0, 10),
                priority: 'Medium',
              ));
              // force refresh
              ref.invalidate(taskListProvider);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Görev eklendi: ${created.title}')),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Görev Ekle'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _tabs.indexOf(tab),
            onDestinationSelected: (i) {
              ref.read(currentTabProvider.notifier).state = _tabs[i];
              ref.invalidate(taskListProvider);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.inbox_outlined), label: Text('Inbox')),
              NavigationRailDestination(icon: Icon(Icons.today_outlined), label: Text('Today')),
              NavigationRailDestination(icon: Icon(Icons.view_week_outlined), label: Text('This Week')),
              NavigationRailDestination(icon: Icon(Icons.schedule_outlined), label: Text('Later')),
              NavigationRailDestination(icon: Icon(Icons.hourglass_top_outlined), label: Text('Waiting')),
              NavigationRailDestination(icon: Icon(Icons.check_circle_outline), label: Text('Done')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              children: [
                _FiltersBar(),
                Expanded(
                  child: tasks.when(
                    data: (rows) => _TaskTable(rows: rows),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(filterCustomerProvider);
    final typ = ref.watch(filterTypeProvider);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: customer ?? '',
                decoration: const InputDecoration(
                  labelText: 'Müşteri (tümü)',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onFieldSubmitted: (v) {
                  ref.read(filterCustomerProvider.notifier).state = v.isEmpty ? null : v;
                  ref.invalidate(taskListProvider);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                isDense: true,
                initialValue: typ,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Görev tipi (tümü)')),
                  DropdownMenuItem(value: 'Fatura', child: Text('Fatura')),
                  DropdownMenuItem(value: 'Rapor', child: Text('Rapor')),
                  DropdownMenuItem(value: 'Ödeme', child: Text('Ödeme')),
                ],
                onChanged: (v) {
                  ref.read(filterTypeProvider.notifier).state = v;
                  ref.invalidate(taskListProvider);
                },
                decoration: const InputDecoration(
                  labelText: 'Görev tipi',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                ref.read(filterCustomerProvider.notifier).state = null;
                ref.read(filterTypeProvider.notifier).state = null;
                ref.invalidate(taskListProvider);
              },
              child: const Text('Filtreyi Temizle'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTable extends ConsumerWidget {
  final List<Task> rows;
  const _TaskTable({required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('#')),
          DataColumn(label: Text('Müşteri')),
          DataColumn(label: Text('Görev')),
          DataColumn(label: Text('Vade')),
          DataColumn(label: Text('Öncelik')),
        ],
        rows: [
          for (int i = 0; i < rows.length; i++)
            DataRow(
              cells: [
                DataCell(Text('${i + 1}')),
                DataCell(Text(rows[i].customer)),
                DataCell(Text(rows[i].title)),
                DataCell(Text(rows[i].due)),
                DataCell(Text(rows[i].priority)),
              ],
              onSelectChanged: (_) async {
                await showDialog(context: context, builder: (_) => _EditTaskDialog(task: rows[i]));
                ref.invalidate(taskListProvider);
              },
            ),
        ],
      ),
    );
  }
}

class _EditTaskDialog extends ConsumerStatefulWidget {
  final Task task;
  const _EditTaskDialog({required this.task});

  @override
  ConsumerState<_EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<_EditTaskDialog> {
  late final TextEditingController customer;
  late final TextEditingController title;
  late final TextEditingController due;
  String priority = 'Medium';

  @override
  void initState() {
    super.initState();
    customer = TextEditingController(text: widget.task.customer);
    title = TextEditingController(text: widget.task.title);
    due = TextEditingController(text: widget.task.due);
    priority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Görev Düzenle'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: customer, decoration: const InputDecoration(labelText: 'Müşteri')),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Görev')),
            TextField(controller: due, decoration: const InputDecoration(labelText: 'Vade (YYYY-MM-DD)')),
            DropdownButtonFormField<String>(
              initialValue: priority,
              items: const [
                DropdownMenuItem(value: 'High', child: Text('High')),
                DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                DropdownMenuItem(value: 'Low', child: Text('Low')),
              ],
              onChanged: (v) => setState(() => priority = v ?? 'Medium'),
              decoration: const InputDecoration(labelText: 'Öncelik'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: () async {
            // basic validation
            if (title.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Görev adı zorunlu')));
              return;
            }
            final repo = ref.read(taskRepositoryProvider);
            await repo.update(widget.task.id!, {
              'customer': customer.text.trim(),
              'title': title.text.trim(),
              'due': due.text.trim(),
              'priority': priority,
            });
            if (mounted) Navigator.pop(context);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
