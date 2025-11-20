import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/customer_provider.dart';

class NoteFormResult {
  final String? customer;
  final String title;
  final DateTime? date;
  final String? notes;
  final bool isCompleted;

  NoteFormResult({
    required this.customer,
    required this.title,
    required this.date,
    this.notes,
    this.isCompleted = false,
  });
}

class NoteDetailDialog extends ConsumerStatefulWidget {
  final NoteFormResult? initial;

  const NoteDetailDialog({super.key, this.initial});

  /// Dialog'u açıp sonucu döndürmek için helper
  static Future<NoteFormResult?> show(
    BuildContext context, {
    NoteFormResult? initial,
  }) {
    return showDialog<NoteFormResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProviderScope(
        child: NoteDetailDialog(initial: initial),
      ),
    );
  }

  @override
  ConsumerState<NoteDetailDialog> createState() => _NoteDetailDialogState();
}

class _NoteDetailDialogState extends ConsumerState<NoteDetailDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  String? _selectedCustomer;
  DateTime? _date;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    final i = widget.initial;
    _selectedCustomer = i?.customer;
    _titleController = TextEditingController(text: i?.title ?? '');
    _notesController = TextEditingController(text: i?.notes ?? '');
    _date = i?.date ?? DateTime.now();
    _isCompleted = i?.isCompleted ?? false;
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
      initialDate: _date ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final result = NoteFormResult(
      customer: _selectedCustomer,
      title: _titleController.text.trim(),
      date: _date,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      isCompleted: _isCompleted,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(customerListProvider);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 650,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.note_add, size: 28, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    widget.initial == null ? 'Yeni Not' : 'Not Düzenle',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Kapat',
                  ),
                ],
              ),
              const Divider(height: 24),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer dropdown
                        const Text(
                          'Müşteri',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        customersAsync.when(
                          data: (customers) {
                            final customerNames = customers.map((c) => c.name).toList();
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedCustomer,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Müşteri seçin',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                              items: customerNames.map((name) {
                                return DropdownMenuItem(value: name, child: Text(name));
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedCustomer = val),
                              validator: (v) => v == null || v.isEmpty ? 'Müşteri seçmelisiniz' : null,
                            );
                          },
                          loading: () => const LinearProgressIndicator(),
                          error: (e, st) => Text('Müşteriler yüklenemedi: $e'),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        const Text(
                          'Başlık',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Not başlığı',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Başlık zorunludur' : null,
                        ),
                        const SizedBox(height: 16),

                        // Date
                        const Text(
                          'Tarih',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _pickDate,
                          borderRadius: BorderRadius.circular(4),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              suffixIcon: _date != null
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20),
                                      onPressed: () => setState(() => _date = null),
                                    )
                                  : null,
                              errorText: _date == null ? 'Tarih seçmelisiniz' : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _date == null
                                      ? 'Tarih seçin'
                                      : DateFormat('d MMMM yyyy, EEEE', 'tr_TR').format(_date!),
                                  style: TextStyle(
                                    color: _date == null ? Colors.grey[600] : Colors.black87,
                                  ),
                                ),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Notes
                        const Text(
                          'Notlar (Opsiyonel)',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ek notlar...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Completed toggle
                        SwitchListTile(
                          value: _isCompleted,
                          onChanged: (val) => setState(() => _isCompleted = val),
                          title: const Text(
                            'Tamamlandı',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(height: 24),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('İptal'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Kaydet'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
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
