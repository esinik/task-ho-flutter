import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/enums/enums.dart';
import 'package:taskho/src/core/models/task_form_result.dart';

class TaskDetailDialog extends ConsumerStatefulWidget {
  final TaskFormResult? initial;

  const TaskDetailDialog({super.key, this.initial});

  /// Dialog'u açıp sonucu döndürmek için helper
  static Future<TaskFormResult?> show(
    BuildContext context,
  ) {
    // Riverpod context’i koruyarak açıyoruz
    return showDialog<TaskFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProviderScope(
        child: const TaskDetailDialog(),
      ),
    );
  }

  @override
  ConsumerState<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends ConsumerState<TaskDetailDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _customerController;
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _customerController = TextEditingController(text: i?.customer ?? '');
    _titleController = TextEditingController(text: i?.title ?? '');
    _notesController = TextEditingController(text: i?.notes ?? '');
    _dueDate = i?.dueDate;
    _priority = i?.priority ?? TaskPriority.medium;
    _isCompleted = i?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _customerController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = TaskFormResult(
      customer: _customerController.text.trim().isEmpty ? null : _customerController.text.trim(),
      title: _titleController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      isCompleted: _isCompleted,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 650,
          maxHeight: 650,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Görev Detayı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // Müşteri
                      const Text('Müşteri'),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _customerController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Görev Adı
                      const Text('Görev Adı'),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Görev adı zorunlu';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Vade & Öncelik
                      Row(
                        children: [
                          // Vade
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Vade'),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: _pickDate,
                                  child: InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _dueDate == null
                                              ? ''
                                              : '${_dueDate!.day.toString().padLeft(2, '0')}.'
                                                  '${_dueDate!.month.toString().padLeft(2, '0')}.'
                                                  '${_dueDate!.year}',
                                        ),
                                        const Icon(Icons.calendar_today, size: 18),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Öncelik
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Öncelik'),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<TaskPriority>(
                                  initialValue: _priority,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: TaskPriority.low,
                                      child: Text('Low'),
                                    ),
                                    DropdownMenuItem(
                                      value: TaskPriority.medium,
                                      child: Text('Medium'),
                                    ),
                                    DropdownMenuItem(
                                      value: TaskPriority.high,
                                      child: Text('High'),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => _priority = v);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Notlar
                      const Text('Notlar'),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 160,
                        child: TextFormField(
                          controller: _notesController,
                          maxLines: null,
                          expands: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Tamamlandı
                      Row(
                        children: [
                          Checkbox(
                            value: _isCompleted,
                            onChanged: (v) => setState(() => _isCompleted = v ?? false),
                          ),
                          const Text('Tamamlandı'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // İptal / Kaydet
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
