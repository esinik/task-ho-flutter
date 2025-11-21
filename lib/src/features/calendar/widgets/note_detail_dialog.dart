import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskho/l10n/app_localizations.dart';
import 'package:taskho/src/core/providers/providers.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final customersAsync = ref.watch(customerOptionsProvider);

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
                    widget.initial == null ? l10n.newNote : l10n.editNote,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.close,
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
                        Text(
                          l10n.customer,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        customersAsync.when(
                          data: (customers) {
                            return DropdownButtonFormField<String>(
                              initialValue: _selectedCustomer,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: l10n.selectCustomer,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                              items: customers.map((name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(name),
                                );
                              }).toList(),
                              onChanged: (val) => setState(() => _selectedCustomer = val),
                              validator: (v) => v == null || v.isEmpty ? l10n.customerRequired : null,
                            );
                          },
                          loading: () => const LinearProgressIndicator(),
                          error: (e, st) => Text('${l10n.customersLoadFailed}: $e'),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          l10n.title,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: l10n.noteTitle,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? l10n.titleRequired : null,
                        ),
                        const SizedBox(height: 16),

                        // Date
                        Text(
                          l10n.date,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
                              errorText: _date == null ? l10n.dateRequired : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _date == null
                                      ? l10n.selectDatePrompt
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
                        Text(
                          l10n.notesOptional,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: l10n.additionalNotes,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),

                        // Completed toggle
                        SwitchListTile(
                          value: _isCompleted,
                          onChanged: (val) => setState(() => _isCompleted = val),
                          title: Text(
                            l10n.completed,
                            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save, size: 18),
                    label: Text(l10n.save),
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
