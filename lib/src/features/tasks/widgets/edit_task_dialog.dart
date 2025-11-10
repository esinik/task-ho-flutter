import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/models/task.dart';
import 'package:taskho/src/core/repo/tasks.dart';

class EditTaskDialog extends ConsumerStatefulWidget {
  final Task task;
  const EditTaskDialog({required this.task});

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
