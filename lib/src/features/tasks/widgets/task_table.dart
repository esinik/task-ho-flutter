import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/models/task.dart';
import 'package:taskho/src/core/providers/providers.dart';
import 'package:taskho/src/features/tasks/widgets/edit_task_dialog.dart';
import '../../../../l10n/app_localizations.dart';

class TaskTable extends ConsumerWidget {
  final List<Task> rows;
  const TaskTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(l10n.columnNumber)),
            DataColumn(label: Text(l10n.columnCustomer)),
            DataColumn(label: Text(l10n.columnTask)),
            DataColumn(label: Text(l10n.columnDue)),
            DataColumn(label: Text(l10n.columnPriority)),
          ],
          rows: [
            for (int i = 0; i < rows.length; i++)
              DataRow(
                cells: [
                  DataCell(
                    Text('${i + 1}'),
                    onTap: () async {
                      await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                      ref.invalidate(taskListProvider);
                    },
                  ),
                  DataCell(
                    Text(rows[i].customer),
                    onTap: () async {
                      await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                      ref.invalidate(taskListProvider);
                    },
                  ),
                  DataCell(
                    Text(rows[i].title),
                    onTap: () async {
                      await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                      ref.invalidate(taskListProvider);
                    },
                  ),
                  DataCell(
                    Text(rows[i].due),
                    onTap: () async {
                      await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                      ref.invalidate(taskListProvider);
                    },
                  ),
                  DataCell(
                    Text(rows[i].priority),
                    onTap: () async {
                      await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                      ref.invalidate(taskListProvider);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
