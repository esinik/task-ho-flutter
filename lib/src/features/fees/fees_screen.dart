import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/repo/fees.dart';
import '../../core/models/fee.dart';

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
    final fees = ref.watch(feeListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskHo — Muhasebe Ücretleri'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.go('/settings'),
            tooltip: 'Ayarlar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: _TextFilter(label: 'Müşteri', provider: feeFilterCustomer)),
                const SizedBox(width: 8),
                Expanded(child: _TextFilter(label: 'Ay (YYYY-MM)', provider: feeFilterMonth)),
                const SizedBox(width: 8),
                Expanded(child: _TextFilter(label: 'Durum (Açık/Ödendi)', provider: feeFilterStatus)),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    ref.read(feeFilterCustomer.notifier).state = null;
                    ref.read(feeFilterMonth.notifier).state = null;
                    ref.read(feeFilterStatus.notifier).state = null;
                    ref.invalidate(feeListProvider);
                  },
                  child: const Text('Filtreyi Temizle'),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () async {
                    final created = await showDialog<Fee>(
                      context: context,
                      builder: (_) => const _FeeDialog(),
                    );
                    if (created != null) {
                      ref.invalidate(feeListProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Ücret kaydedildi.')),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Ücret'),
                ),
              ],
            ),
          ),
          Expanded(
            child: fees.when(
              data: (rows) => SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Müşteri')),
                    DataColumn(label: Text('Ay')),
                    DataColumn(label: Text('Ücret (€)')),
                    DataColumn(label: Text('Durum')),
                    DataColumn(label: Text('Not')),
                    DataColumn(label: Text('İşlem')),
                  ],
                  rows: [
                    for (int i = 0; i < rows.length; i++)
                      DataRow(cells: [
                        DataCell(Text('${i + 1}')),
                        DataCell(Text(rows[i].customer)),
                        DataCell(Text(rows[i].month)),
                        DataCell(Text(rows[i].amount.toStringAsFixed(2))),
                        DataCell(Text(rows[i].status)),
                        DataCell(Text(rows[i].note)),
                        DataCell(Row(
                          children: [
                            TextButton(
                              onPressed: () async {
                                await ref.read(feeRepositoryProvider).update(rows[i].id!, {
                                  'status': rows[i].status == 'Ödendi' ? 'Açık' : 'Ödendi',
                                });
                                ref.invalidate(feeListProvider);
                              },
                              child: Text(rows[i].status == 'Ödendi' ? 'Geri Al' : 'Ödendi İşaretle'),
                            ),
                            const SizedBox(width: 6),
                            TextButton(
                              onPressed: () async {
                                await ref.read(feeRepositoryProvider).remove(rows[i].id!);
                                ref.invalidate(feeListProvider);
                              },
                              child: const Text('Sil'),
                            ),
                          ],
                        )),
                      ]),
                  ],
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          )
        ],
      ),
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

class _FeeDialog extends ConsumerStatefulWidget {
  const _FeeDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<_FeeDialog> createState() => _FeeDialogState();
}

class _FeeDialogState extends ConsumerState<_FeeDialog> {
  final TextEditingController customer = TextEditingController();
  final TextEditingController month = TextEditingController(text: '2025-10');
  final TextEditingController amount = TextEditingController();
  final TextEditingController status = TextEditingController(text: 'Açık');
  final TextEditingController note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ücret Kaydı'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: customer, decoration: const InputDecoration(labelText: 'Müşteri')),
            TextField(controller: month, decoration: const InputDecoration(labelText: 'Ay (YYYY-MM)')),
            TextField(
                controller: amount,
                decoration: const InputDecoration(labelText: 'Ücret (€)'),
                keyboardType: TextInputType.number),
            TextField(controller: status, decoration: const InputDecoration(labelText: 'Durum (Açık/Ödendi)')),
            TextField(controller: note, decoration: const InputDecoration(labelText: 'Not')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
        FilledButton(
          onPressed: () async {
            final amt = double.tryParse(amount.text.replaceAll(',', '.'));
            if (customer.text.trim().isEmpty || month.text.trim().isEmpty || amt == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zorunlu alanları doldurun')));
              return;
            }
            final repo = ref.read(feeRepositoryProvider);
            await repo.create(Fee(
                customer: customer.text.trim(),
                month: month.text.trim(),
                amount: amt,
                status: status.text.trim(),
                note: note.text.trim()));
            if (mounted) Navigator.pop(context, true);
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
