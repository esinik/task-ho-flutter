import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/l10n/app_localizations.dart';
import 'package:taskho/src/core/providers/providers.dart';

/// Değişiklikleri üst seviyeye taşımak için sade bir model.
/// id zorunlu değil; sadece isme göre çalışıyorsanız null bırakabilirsiniz.
class CustomerChange {
  final String? id;
  final String name;
  final bool isPaid;
  final double fee;

  const CustomerChange({
    this.id,
    required this.name,
    this.isPaid = false,
    this.fee = 0,
  });
}

class CustomerManageResult {
  final List<CustomerChange> created;
  final List<CustomerChange> updated;
  final List<CustomerChange> deleted;

  const CustomerManageResult({
    this.created = const [],
    this.updated = const [],
    this.deleted = const [],
  });

  bool get hasChanges => created.isNotEmpty || updated.isNotEmpty || deleted.isNotEmpty;
}

class CustomerManageDialog extends ConsumerStatefulWidget {
  const CustomerManageDialog._();

  /// TaskListScreen içinden:
  /// final result = await CustomerManageDialog.show(ref.context);
  static Future<CustomerManageResult?> show(BuildContext context) {
    return showDialog<CustomerManageResult>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        backgroundColor: Colors.transparent,
        child: CustomerManageDialog._(),
      ),
    );
  }

  @override
  ConsumerState<CustomerManageDialog> createState() => _CustomerManageDialogState();
}

class _CustomerManageDialogState extends ConsumerState<CustomerManageDialog> {
  final TextEditingController _searchCtrl = TextEditingController();

  // Local değişiklikler
  final List<CustomerChange> _created = [];
  final Map<String, CustomerChange> _updatedById = {};
  final Set<String> _deletedIds = {};

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const brand = Color(0xFF2563EB);

    final customersAsync = ref.watch(customerListProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(90),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 640),
          child: Material(
            color: Colors.white,
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        l10n.updateCustomer,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF111827),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: brand,
                        ),
                        child: Text(l10n.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // SEARCH + YENİ
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: l10n.searchHint,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() {});
                        },
                        child: Text(l10n.clear),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _onAddNewCustomer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brand,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child: Text('+ ${l10n.newBtn}'),
                      ),
                    ],
                  ),
                ),

                // LIST
                Expanded(
                  child: customersAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (e, st) => Center(
                      child: Text(
                        '${l10n.customerListLoadFailed}\n$e',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.red[700]),
                      ),
                    ),
                    data: (customers) {
                      // customers tipiniz Customer modeliyse:
                      // final items = customers.cast<Customer>();
                      // burada name/id alanlarını uyarlayın.
                      final query = _searchCtrl.text.trim().toLowerCase();
                      final visible = <_UiCustomer>[];

                      for (final c in customers) {
                        // Varsayılan alan isimleri:
                        final id = _getId(c);
                        final name = _getName(c);
                        final isPaid = _getIsPaid(c);
                        final fee = _getFee(c);

                        if (_deletedIds.contains(id)) continue;

                        if (query.isNotEmpty && !name.toLowerCase().contains(query)) {
                          continue;
                        }

                        final updated = _updatedById[id];
                        visible.add(
                          _UiCustomer(
                            id: id,
                            name: updated?.name ?? name,
                            isPaid: updated?.isPaid ?? isPaid,
                            fee: updated?.fee ?? fee,
                            isEdited: updated != null,
                          ),
                        );
                      }

                      // Yeni eklenen local kayıtlar (henüz backend'de olmayan)
                      for (final created in _created) {
                        if (query.isNotEmpty && !created.name.toLowerCase().contains(query)) continue;
                        visible.add(
                          _UiCustomer(
                            id: created.id ?? created.name,
                            name: created.name,
                            isPaid: created.isPaid,
                            fee: created.fee,
                            isNew: true,
                          ),
                        );
                      }

                      if (visible.isEmpty) {
                        return Center(
                          child: Text(
                            query.isEmpty ? l10n.noCustomersFound : l10n.noCustomersInSearch,
                            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        itemBuilder: (context, index) {
                          final item = visible[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                  color: Colors.black12,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF111827),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            item.isPaid ? Icons.check_circle : Icons.cancel,
                                            size: 14,
                                            color: item.isPaid ? Colors.green : Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            item.isPaid
                                                ? '${l10n.isPaid} (€${item.fee.toStringAsFixed(0)}/ay)'
                                                : l10n.isFree,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (item.isNew || item.isEdited)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: _Tag(
                                      label: item.isNew ? l10n.newBtn : l10n.update,
                                    ),
                                  ),
                                IconButton(
                                  tooltip: l10n.editCustomer,
                                  onPressed: () => _onRename(item),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                ),
                                IconButton(
                                  tooltip: l10n.delete,
                                  onPressed: () => _onDelete(item),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemCount: visible.length,
                      );
                    },
                  ),
                ),

                const Divider(height: 1),

                // FOOTER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancel),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brand,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(l10n.saveChanges),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers -------------------------------------------------------------

  // Burada Customer modelinizin alanlarını uyarlayın.
  // Şu an generic bıraktım ki compile kalsın:
  String _getId(dynamic c) {
    // ignore: avoid_dynamic_calls
    return (c.id ?? c.customerId ?? c.name ?? '').toString();
  }

  String _getName(dynamic c) {
    // ignore: avoid_dynamic_calls
    return (c.name ?? c.title ?? c.toString()) as String;
  }

  bool _getIsPaid(dynamic c) {
    // ignore: avoid_dynamic_calls
    return (c.isPaid ?? false) as bool;
  }

  double _getFee(dynamic c) {
    // ignore: avoid_dynamic_calls
    final feeValue = c.fee ?? 0;
    if (feeValue is int) return feeValue.toDouble();
    return (feeValue as num).toDouble();
  }

  void _onAddNewCustomer() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _openCustomerDialog(
      title: l10n.newCustomer,
    );
    if (result == null) return;
    setState(() {
      _created.add(result);
    });
  }

  void _onRename(_UiCustomer item) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await _openCustomerDialog(
      title: l10n.editCustomer,
      initialName: item.name,
      initialIsPaid: item.isPaid,
      initialFee: item.fee,
    );
    if (result == null) return;

    setState(() {
      // Yeni eklenmişse (henüz backend'e kaydedilmemiş) direkt _created içinde güncelle
      if (item.isNew) {
        final createdIndex = _created.indexWhere(
          (c) => c.name == item.name,
        );
        if (createdIndex != -1) {
          _created[createdIndex] = CustomerChange(
            id: null, // Yeni kayıt, henüz ID yok
            name: result.name,
            isPaid: result.isPaid,
            fee: result.fee,
          );
        }
      } else {
        // Backend'den gelen kayıt, ID'si var
        _updatedById[item.id] = CustomerChange(
          id: item.id, // ID'yi mutlaka set et
          name: result.name,
          isPaid: result.isPaid,
          fee: result.fee,
        );
      }
    });
  }

  void _onDelete(_UiCustomer item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteCustomer),
        content: Text(
          l10n.deleteCustomerConfirm(item.name),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      if (item.isNew) {
        // Yeni eklenen kayıt henüz backend'de yok, sadece local listeden sil
        _created.removeWhere((c) => c.name == item.name);
      } else {
        // Backend'den gelen kayıt
        // Güncellenmiş kaydı da kaldır (eğer varsa)
        _updatedById.remove(item.id);
        // Var olan kaydı silinmek üzere işaretle
        _deletedIds.add(item.id);
      }
    });
  }

  Future<CustomerChange?> _openCustomerDialog({
    required String title,
    String? initialName,
    bool? initialIsPaid,
    double? initialFee,
  }) async {
    final nameController = TextEditingController(text: initialName ?? '');
    bool isPaid = initialIsPaid ?? false;
    final feeController = TextEditingController(
      text: initialFee != null && initialFee > 0 ? initialFee.toStringAsFixed(0) : '',
    );

    final result = await showDialog<CustomerChange>(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.customerName),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.customerNameHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(l10n.paidCustomer),
                    value: isPaid,
                    onChanged: (value) {
                      setState(() => isPaid = value ?? false);
                    },
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  if (isPaid) ...[
                    const SizedBox(height: 8),
                    Text(l10n.monthlyFeeAmount),
                    const SizedBox(height: 8),
                    TextField(
                      controller: feeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(),
                        prefixText: '€ ',
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.customerNameRequired)),
                    );
                    return;
                  }
                  final feeValue = isPaid ? (double.tryParse(feeController.text.trim()) ?? 0.0) : 0.0;
                  Navigator.of(context).pop(
                    CustomerChange(
                      name: name,
                      isPaid: isPaid,
                      fee: feeValue,
                    ),
                  );
                },
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );

    nameController.dispose();
    feeController.dispose();
    return result;
  }

  void _onSave() {
    final result = CustomerManageResult(
      created: List.unmodifiable(_created),
      updated: List.unmodifiable(_updatedById.values),
      deleted: _deletedIds.map((id) => CustomerChange(id: id, name: '')).toList(growable: false),
    );

    Navigator.of(context).pop(
      result.hasChanges ? result : null,
    );
  }
}

class _UiCustomer {
  final String id;
  final String name;
  final bool isPaid;
  final double fee;
  final bool isNew;
  final bool isEdited;

  _UiCustomer({
    required this.id,
    required this.name,
    this.isPaid = false,
    this.fee = 0,
    this.isNew = false,
    this.isEdited = false,
  });
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF4F46E5),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
