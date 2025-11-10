import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/providers/providers.dart';

class FiltersBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customer = ref.watch(filterCustomerProvider);
    final typ = ref.watch(filterTypeProvider);

    List<String> _customerList = ref.watch(customerOptionsProvider).when(
          data: (list) => list,
          loading: () => [],
          error: (_, __) => [],
        );

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
                  const DropdownMenuItem(value: null, child: Text('Müşteri (tümü)')),
                  for (final c in _customerList) DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) {
                  ref.read(filterCustomerProvider.notifier).state = v;
                  ref.invalidate(taskListProvider);
                },
                decoration: const InputDecoration(
                  labelText: 'Müşteri',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String?>(
                isDense: true,
                initialValue: typ,
                items: const [
                  DropdownMenuItem(value: null, child: Text('Görev tipi (tümü)')),
                  DropdownMenuItem(value: 'Fatura', child: Text('Fatura')),
                  DropdownMenuItem(value: 'Rapor', child: Text('Rapor')),
                  DropdownMenuItem(value: 'Ödeme', child: Text('Ödeme')),
                ],
                onChanged: (v) {
                  ref.read(filterTypeProvider.notifier).state = v;
                  ref.invalidate(taskListProvider);
                },
                decoration: const InputDecoration(
                  labelText: 'Görev tipi',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                ref.read(filterCustomerProvider.notifier).state = null;
                ref.read(filterTypeProvider.notifier).state = null;
                ref.invalidate(taskListProvider);
              },
              child: const Text('Filtreyi Temizle'),
            ),
          ],
        ),
      ),
    );
  }
}
