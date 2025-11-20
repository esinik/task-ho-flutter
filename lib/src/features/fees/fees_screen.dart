import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/repo/fees.dart';
import '../../core/repo/calendar.dart';
import '../../core/models/fee.dart';
import '../../core/providers/providers.dart';
import '../../core/logging/app_logger.dart';

final feeFilterCustomer = StateProvider<String?>((_) => null);
final feeFilterMonth = StateProvider<String?>((_) => null);
final feeFilterStatus = StateProvider<String?>((_) => null);

final feeListProvider = FutureProvider.autoDispose<List<Fee>>((ref) async {
  final repo = ref.read(feeRepositoryProvider);
  return repo.list(
    customer: ref.watch(feeFilterCustomer),
    month: ref.watch(feeFilterMonth),
    status: ref.watch(feeFilterStatus),
  );
});

class FeesScreen extends ConsumerWidget {
  const FeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Log screen view
    AppLogger().logScreenView('Fees');
    final l10n = AppLocalizations.of(context)!;
    final fees = ref.watch(feeListProvider);
    final customerOptions = ref.watch(customerOptionsProvider);

    // Correct total count derived from AsyncValue
    final totalCount = fees.maybeWhen(data: (rows) => rows.length, orElse: () => 0);
    // Determine if any filter is active to toggle Clear Filter button visibility
    final hasAnyFilter =
        ref.watch(feeFilterCustomer) != null || ref.watch(feeFilterMonth) != null || ref.watch(feeFilterStatus) != null;

    return Column(
      children: [
        // Header bar
        Container(
          color: Colors.grey[200],
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.fees,
                ),
                Text(l10n.recordsCount(totalCount)),
              ],
            ),
          ),
        ),
        const Divider(height: 1),

        // Filter bar
        Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Customer dropdown filter
              Expanded(
                flex: 2,
                child: customerOptions.when(
                  data: (customers) {
                    final selectedCustomer = ref.watch(feeFilterCustomer);
                    return DropdownButtonFormField<String?>(
                      initialValue: selectedCustomer,
                      decoration: InputDecoration(
                        labelText: '${l10n.filterCustomer} (${l10n.all})',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text(l10n.all),
                        ),
                        ...customers.map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c),
                            )),
                      ],
                      onChanged: (value) {
                        ref.read(feeFilterCustomer.notifier).state = value;
                        AppLogger().logButtonClick(
                          'FeesFilterCustomer',
                          'Fees',
                          metadata: {'value': value ?? 'All'},
                        );
                      },
                    );
                  },
                  loading: () => const SizedBox(
                    height: 48,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => _TextFilter(label: l10n.filterCustomer, provider: feeFilterCustomer),
                ),
              ),
              const SizedBox(width: 12),

              // Month filter - Date Picker
              Expanded(
                child: _MonthPickerFilter(
                  label: l10n.filterMonth,
                  provider: feeFilterMonth,
                ),
              ),
              const SizedBox(width: 12),

              // Status filter - Dropdown
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: ref.watch(feeFilterStatus),
                  decoration: InputDecoration(
                    labelText: '${l10n.filterStatus} (${l10n.all})',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.all),
                    ),
                    DropdownMenuItem(
                      value: 'Açık',
                      child: Text(l10n.statusOpen),
                    ),
                    DropdownMenuItem(
                      value: 'Ödendi',
                      child: Text(l10n.statusPaid),
                    ),
                  ],
                  onChanged: (value) {
                    ref.read(feeFilterStatus.notifier).state = value;
                    AppLogger().logButtonClick(
                      'FeesFilterStatus',
                      'Fees',
                      metadata: {'value': value ?? 'All'},
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Clear filter button (only show when any filter is active)
              if (hasAnyFilter) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(feeFilterCustomer.notifier).state = null;
                    ref.read(feeFilterMonth.notifier).state = null;
                    ref.read(feeFilterStatus.notifier).state = null;
                    AppLogger().logButtonClick('FeesClearFilter', 'Fees');
                  },
                  icon: const Icon(Icons.clear),
                  label: Text(l10n.clearFilter),
                ),
                const SizedBox(width: 12),
              ],

              // Add record button
              FilledButton.icon(
                onPressed: () async {
                  AppLogger().logButtonClick('FeesAddRecord', 'Fees');
                  final created = await _FeeDialog.show(context);
                  if (created != null) {
                    ref.invalidate(feeListProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.feeSaved)),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.addRecord),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Data table
        Expanded(
          child: fees.when(
            data: (rows) {
              if (rows.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noRecordsFound,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              return SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                    columns: [
                      DataColumn(label: Text(l10n.columnNumber, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnCustomer, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnMonth, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnAmount, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnStatus, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnNote, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text(l10n.columnActions, style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: [
                      for (int i = 0; i < rows.length; i++)
                        DataRow(
                          cells: [
                            DataCell(Text('${i + 1}')),
                            DataCell(Text(rows[i].customer)),
                            DataCell(Text(rows[i].month)),
                            DataCell(Text(rows[i].amount.toStringAsFixed(2))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: rows[i].status == 'Ödendi' ? Colors.green[100] : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  rows[i].status == 'Ödendi' ? l10n.statusPaid : l10n.statusOpen,
                                  style: TextStyle(
                                    color: rows[i].status == 'Ödendi' ? Colors.green[900] : Colors.orange[900],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(rows[i].note)),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Mark as paid / Undo button
                                  TextButton(
                                    onPressed: () async {
                                      final wasPaid = rows[i].status == 'Ödendi';
                                      final newStatus = wasPaid ? 'Açık' : 'Ödendi';
                                      // Update fee status
                                      await ref.read(feeRepositoryProvider).update(
                                        rows[i].id!,
                                        {'status': newStatus},
                                      );
                                      ref.invalidate(feeListProvider);

                                      // Sync with calendar notes
                                      final calendarRepo = ref.read(calendarRepositoryProvider);
                                      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                                      try {
                                        if (!wasPaid && newStatus == 'Ödendi') {
                                          // Create completed note titled 'Ödendi'
                                          await calendarRepo.createNote(
                                            customer: rows[i].customer,
                                            title: 'Ödendi',
                                            date: today,
                                            isCompleted: true,
                                          );
                                        } else if (wasPaid && newStatus == 'Açık') {
                                          // Delete existing 'Ödendi' note for today & customer
                                          final notes =
                                              await calendarRepo.getRawNotesInRange(startDate: today, endDate: today);
                                          final matches = notes
                                              .where((n) =>
                                                  n['customer'] == rows[i].customer &&
                                                  (n['title'] == 'Ödendi') &&
                                                  n['date'] == today)
                                              .toList();
                                          if (matches.isNotEmpty) {
                                            final note = matches.first;
                                            final noteId = note['id'] ?? note['_id'];
                                            if (noteId != null) {
                                              await calendarRepo.deleteNote(noteId);
                                            }
                                          }
                                        }
                                      } catch (e) {
                                        // Fail silently; calendar sync shouldn't block fee update
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: rows[i].status == 'Ödendi' ? Colors.orange : Colors.green,
                                    ),
                                    child: Text(
                                      rows[i].status == 'Ödendi' ? l10n.undoPayment : l10n.markAsPaid,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  // Delete button
                                  TextButton(
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(l10n.delete),
                                          content: Text('${l10n.delete}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx, false),
                                              child: Text(l10n.cancel),
                                            ),
                                            FilledButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              style: FilledButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                              child: Text(l10n.delete),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await ref.read(feeRepositoryProvider).remove(rows[i].id!);
                                        ref.invalidate(feeListProvider);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: Text(l10n.delete, style: const TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('${l10n.error}: $e')),
          ),
        ),
      ],
    );
  }
}

class _TextFilter extends ConsumerWidget {
  final String label;
  final StateProvider<String?> provider;
  const _TextFilter({required this.label, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    return TextFormField(
      initialValue: value ?? '',
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
      onFieldSubmitted: (v) {
        ref.read(provider.notifier).state = v.isEmpty ? null : v;
        ref.invalidate(feeListProvider);
      },
    );
  }
}

class _MonthPickerFilter extends ConsumerWidget {
  final String label;
  final StateProvider<String?> provider;
  const _MonthPickerFilter({required this.label, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    final displayText = value ?? '';

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
        suffixIcon: value != null
            ? IconButton(
                icon: const Icon(Icons.clear, size: 18),
                onPressed: () {
                  ref.read(provider.notifier).state = null;
                  AppLogger().logButtonClick('FeesFilterMonthClear', 'Fees');
                },
              )
            : const Icon(Icons.calendar_today, size: 18),
      ),
      controller: TextEditingController(text: displayText),
      onTap: () async {
        final selected = await _showMonthYearPicker(context, value);
        if (selected != null) {
          ref.read(provider.notifier).state = selected;
          AppLogger().logButtonClick(
            'FeesFilterMonth',
            'Fees',
            metadata: {'value': selected},
          );
        }
      },
    );
  }
}

Future<String?> _showMonthYearPicker(BuildContext context, String? initialValue) async {
  final now = DateTime.now();
  int selectedYear = now.year;
  int selectedMonth = now.month;

  // Parse initial value if exists
  if (initialValue != null && initialValue.isNotEmpty) {
    final parts = initialValue.split('-');
    if (parts.length == 2) {
      selectedYear = int.tryParse(parts[0]) ?? now.year;
      selectedMonth = int.tryParse(parts[1]) ?? now.month;
    }
  }

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      final l10n = AppLocalizations.of(context)!;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(l10n.monthYearPickerTitle),
            content: SizedBox(
              width: 300,
              height: 300,
              child: Column(
                children: [
                  // Year selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() => selectedYear--);
                        },
                      ),
                      SizedBox(
                        width: 100,
                        child: Text(
                          '$selectedYear',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() => selectedYear++);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Month grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = month == selectedMonth;
                        final locale = Localizations.localeOf(context).toString();
                        final monthName = DateFormat.MMMM(locale).format(DateTime(2000, month));

                        return InkWell(
                          onTap: () {
                            setState(() => selectedMonth = month);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              monthName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () {
                  final result = '$selectedYear-${selectedMonth.toString().padLeft(2, '0')}';
                  Navigator.pop(context, result);
                },
                child: Text(l10n.ok),
              ),
            ],
          );
        },
      );
    },
  );
}

class _FeeDialog extends ConsumerStatefulWidget {
  const _FeeDialog();

  static Future<Fee?> show(BuildContext context) {
    return showDialog<Fee>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ProviderScope(child: _FeeDialog()),
    );
  }

  @override
  ConsumerState<_FeeDialog> createState() => _FeeDialogState();
}

class _FeeDialogState extends ConsumerState<_FeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerController = TextEditingController();
  final _monthController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedStatus = 'Açık';

  @override
  void initState() {
    super.initState();
    // Set default month to current month
    final now = DateTime.now();
    _monthController.text = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _customerController.dispose();
    _monthController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customerOptions = ref.watch(customerOptionsProvider);

    return AlertDialog(
      title: Text(l10n.feeRecord),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer dropdown
                Text(l10n.columnCustomer, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                customerOptions.when(
                  data: (customers) => DropdownButtonFormField<String>(
                    initialValue: null,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText: l10n.columnCustomer,
                    ),
                    items: [
                      for (final customer in customers) DropdownMenuItem(value: customer, child: Text(customer)),
                    ],
                    onChanged: (value) {
                      if (value != null) _customerController.text = value;
                    },
                    validator: (value) {
                      if (_customerController.text.trim().isEmpty) {
                        return l10n.requiredFields;
                      }
                      return null;
                    },
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => TextFormField(
                    controller: _customerController,
                    decoration: InputDecoration(
                      labelText: l10n.columnCustomer,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.requiredFields;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Month field - Month/Year Picker
                Text(l10n.columnMonth, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _monthController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'YYYY-MM',
                    border: OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: Icon(Icons.calendar_today, size: 18),
                  ),
                  onTap: () async {
                    final selected = await _showMonthYearPicker(context, _monthController.text);
                    if (selected != null) {
                      _monthController.text = selected;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.requiredFields;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount field
                Text(l10n.columnAmount, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.requiredFields;
                    }
                    final amount = double.tryParse(value.replaceAll(',', '.'));
                    if (amount == null) {
                      return l10n.invalidNumber;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Status dropdown
                Text(l10n.columnStatus, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    DropdownMenuItem(value: 'Açık', child: Text(l10n.statusOpen)),
                    DropdownMenuItem(value: 'Ödendi', child: Text(l10n.statusPaid)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedStatus = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Note field
                Text(l10n.columnNote, style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final amount = double.parse(_amountController.text.replaceAll(',', '.'));
            final fee = Fee(
              customer: _customerController.text.trim(),
              month: _monthController.text.trim(),
              amount: amount,
              status: _selectedStatus,
              note: _noteController.text.trim(),
            );

            try {
              await ref.read(feeRepositoryProvider).create(fee);
              await AppLogger().logDataCreate('Fee', metadata: {
                'customer': fee.customer,
                'month': fee.month,
                'amount': fee.amount,
                'status': fee.status,
              });
              if (context.mounted) Navigator.pop(context, fee);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.error}: $e')),
                );
              }
            }
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
