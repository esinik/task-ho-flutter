import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/models/task.dart';
import 'package:taskho/src/core/providers/providers.dart';
import 'package:taskho/src/features/tasks/widgets/edit_task_dialog.dart';

class TaskTable extends ConsumerWidget {
  final List<Task> rows;
  const TaskTable({required this.rows});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
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
                  await showDialog(context: context, builder: (_) => EditTaskDialog(task: rows[i]));
                  ref.invalidate(taskListProvider);
                },
              ),
          ],
        ),
      ),
    );
  }
}
