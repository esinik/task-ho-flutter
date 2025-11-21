import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/l10n/app_localizations.dart';
import 'package:taskho/src/core/models/task.dart';
import 'package:taskho/src/core/repo/tasks.dart';

class EditTaskDialog extends ConsumerStatefulWidget {
  final Task task;
  const EditTaskDialog({super.key, required this.task});

  @override
  ConsumerState<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends ConsumerState<EditTaskDialog> {
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
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editTask),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: customer, decoration: InputDecoration(labelText: l10n.customer)),
            TextField(controller: title, decoration: InputDecoration(labelText: l10n.task)),
            TextField(controller: due, decoration: InputDecoration(labelText: l10n.due)),
            DropdownButtonFormField<String>(
              initialValue: priority,
              items: [
                DropdownMenuItem(value: 'High', child: Text(l10n.priorityHigh)),
                DropdownMenuItem(value: 'Medium', child: Text(l10n.priorityMedium)),
                DropdownMenuItem(value: 'Low', child: Text(l10n.priorityLow)),
              ],
              onChanged: (v) => setState(() => priority = v ?? 'Medium'),
              decoration: InputDecoration(labelText: l10n.priority),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () async {
            // basic validation
            if (title.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.errorTaskRequired)));
              return;
            }
            final repo = ref.read(taskRepositoryProvider);
            await repo.update(widget.task.id!, {
              'customer': customer.text.trim(),
              'title': title.text.trim(),
              'due': due.text.trim(),
              'priority': priority,
            });
            if (context.mounted) Navigator.pop(context);
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
