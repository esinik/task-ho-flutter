import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/enums/enums.dart';
import 'package:taskho/src/core/models/task_form_result.dart';
import 'package:taskho/src/core/providers/customer_provider.dart';

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
      builder: (_) => const ProviderScope(
        child: TaskDetailDialog(),
      ),
    );
  }

  @override
  ConsumerState<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends ConsumerState<TaskDetailDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  String? _selectedCustomer;
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  TaskStatus _status = TaskStatus.idle;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _selectedCustomer = i?.customer;
    _titleController = TextEditingController(text: i?.title ?? '');
    _notesController = TextEditingController(text: i?.notes ?? '');
    _dueDate = i?.dueDate;
    _priority = i?.priority ?? TaskPriority.medium;
    _status = i?.status ?? TaskStatus.idle;
  }

  @override
  void dispose() {
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
      customer: _selectedCustomer,
      title: _titleController.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      status: _status,
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
                      Consumer(
                        builder: (context, ref, _) {
                          final customersAsync = ref.watch(customerListProvider);
                          return customersAsync.when(
                            data: (customers) => DropdownButtonFormField<String>(
                              initialValue: _selectedCustomer,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Müşteri seçin',
                              ),
                              items: [
                                const DropdownMenuItem<String>(
                                  value: null,
                                  child: Text('Seçiniz'),
                                ),
                                ...customers.map((c) => DropdownMenuItem<String>(
                                      value: c.name,
                                      child: Text(c.name),
                                    )),
                              ],
                              onChanged: (v) {
                                setState(() => _selectedCustomer = v);
                              },
                            ),
                            loading: () => const InputDecorator(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              child: Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                            error: (e, _) => InputDecorator(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              child: Text('Müşteri yükleme hatası: $e'),
                            ),
                          );
                        },
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
                        height: 120,
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

                      // Durum Seçimi
                      const Text('Durum'),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<TaskStatus>(
                        initialValue: _status,
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(value: TaskStatus.idle, child: Text('Idle')),
                          DropdownMenuItem(value: TaskStatus.inprogress, child: Text('In Progress')),
                          DropdownMenuItem(value: TaskStatus.later, child: Text('Later')),
                          DropdownMenuItem(value: TaskStatus.waiting, child: Text('Waiting')),
                          DropdownMenuItem(value: TaskStatus.done, child: Text('Done')),
                        ],
                        onChanged: (v) => setState(() => _status = v ?? TaskStatus.idle),
                      ),
                      const SizedBox(height: 16),
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
