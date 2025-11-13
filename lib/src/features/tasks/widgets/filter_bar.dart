import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/providers/providers.dart';
import '../../../../l10n/app_localizations.dart';
import 'task_detail_dialog.dart';
import '../../../core/logging/app_logger.dart';

class FiltersBar extends ConsumerWidget {
  const FiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(filterCustomerProvider);
    final typ = ref.watch(filterTypeProvider);

    List<String> customerList = ref.watch(customerOptionsProvider).when(
          data: (list) => list,
          loading: () => [],
          error: (_, __) => [],
        );

    final l10n = AppLocalizations.of(context)!;

    // Filtrelerin aktif olup olmadığını kontrol et
    final hasActiveFilters = customer != null || typ != null;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                isDense: true,
                initialValue: customer,
                items: [
                  DropdownMenuItem(value: null, child: Text('${l10n.filterCustomer} (${l10n.all})')),
                  for (final c in customerList) DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) {
                  ref.read(filterCustomerProvider.notifier).state = v;
                  ref.invalidate(taskListProvider);
                  AppLogger().logButtonClick(
                    'FilterCustomer',
                    'Tasks',
                    metadata: {'value': v ?? 'All'},
                  );
                },
                decoration: InputDecoration(
                  labelText: l10n.filterCustomer,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String?>(
                isDense: true,
                initialValue: typ,
                items: [
                  DropdownMenuItem(value: null, child: Text('${l10n.filterTaskType} (${l10n.all})')),
                  const DropdownMenuItem(value: 'Fatura', child: Text('')), // label set below
                  const DropdownMenuItem(value: 'Rapor', child: Text('')),
                  const DropdownMenuItem(value: 'Ödeme', child: Text('')),
                ].map((item) {
                  if (item.value == 'Fatura') {
                    return DropdownMenuItem(value: item.value, child: Text(l10n.taskTypeInvoice));
                  } else if (item.value == 'Rapor') {
                    return DropdownMenuItem(value: item.value, child: Text(l10n.taskTypeReport));
                  } else if (item.value == 'Ödeme') {
                    return DropdownMenuItem(value: item.value, child: Text(l10n.taskTypePayment));
                  }
                  return item;
                }).toList(),
                onChanged: (v) {
                  ref.read(filterTypeProvider.notifier).state = v;
                  ref.invalidate(taskListProvider);
                  AppLogger().logButtonClick(
                    'FilterTaskType',
                    'Tasks',
                    metadata: {'value': v ?? 'All'},
                  );
                },
                decoration: InputDecoration(
                  labelText: l10n.filterTaskType,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const Spacer(),
            // Filtreyi Temizle butonu sadece aktif filtre varsa gösterilir
            if (hasActiveFilters) ...[
              OutlinedButton(
                onPressed: () {
                  ref.read(filterCustomerProvider.notifier).state = null;
                  ref.read(filterTypeProvider.notifier).state = null;
                  ref.invalidate(taskListProvider);
                  AppLogger().logButtonClick('ClearFilter', 'Tasks');
                },
                child: Text(l10n.clearFilter),
              ),
              const SizedBox(width: 8),
            ],
            // Görev Ekle butonu
            FilledButton.icon(
              onPressed: () async {
                AppLogger().logButtonClick('AddTask', 'Tasks');
                await TaskDetailDialog.show(context);
                ref.invalidate(taskListProvider);
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addTask),
            ),
          ],
        ),
      ),
    );
  }
}
