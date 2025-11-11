import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskho/src/core/providers/providers.dart';

/// Değişiklikleri üst seviyeye taşımak için sade bir model.
/// id zorunlu değil; sadece isme göre çalışıyorsanız null bırakabilirsiniz.
class CustomerChange {
  final String? id;
  final String name;

  const CustomerChange({this.id, required this.name});
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
    final brand = const Color(0xFF2563EB);

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
                        'Müşteri Güncelle',
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
                        child: const Text('Kapat'),
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
                            hintText: 'Ara (en az 1 harf)',
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
                        child: const Text('Temizle'),
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
                        child: const Text('+ Yeni'),
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
                        'Müşteri listesi yüklenemedi\n$e',
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

                        if (_deletedIds.contains(id)) continue;

                        if (query.isNotEmpty && !name.toLowerCase().contains(query)) {
                          continue;
                        }

                        final updated = _updatedById[id];
                        visible.add(
                          _UiCustomer(
                            id: id,
                            name: updated?.name ?? name,
                            isEdited: updated != null,
                          ),
                        );
                      }

                      // Yeni eklenen local kayıtlar (henüz backend’de olmayan)
                      for (final created in _created) {
                        if (query.isNotEmpty && !created.name.toLowerCase().contains(query)) continue;
                        visible.add(
                          _UiCustomer(
                            id: created.id ?? created.name,
                            name: created.name,
                            isNew: true,
                          ),
                        );
                      }

                      if (visible.isEmpty) {
                        return Center(
                          child: Text(
                            'Hiç müşteri bulunamadı.',
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
                                  child: Text(
                                    item.name,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                ),
                                if (item.isNew || item.isEdited)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: _Tag(
                                      label: item.isNew ? 'Yeni' : 'Düzenlendi',
                                    ),
                                  ),
                                IconButton(
                                  tooltip: 'Düzenle',
                                  onPressed: () => _onRename(item),
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Sil',
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
                        child: const Text('Vazgeç'),
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
                        child: const Text('Değişiklikleri Kaydet'),
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

  void _onAddNewCustomer() async {
    final name = await _openNameDialog(
      title: 'Yeni Müşteri',
      hint: 'Örn. ACME LLC',
    );
    if (name == null || name.trim().isEmpty) return;
    setState(() {
      _created.add(CustomerChange(name: name.trim()));
    });
  }

  void _onRename(_UiCustomer item) async {
    final name = await _openNameDialog(
      title: 'Müşteri Adını Düzenle',
      initialValue: item.name,
    );
    if (name == null || name.trim().isEmpty || name == item.name) return;

    setState(() {
      // Yeni eklenmişse direkt _created içinde güncelle
      final createdIndex = _created.indexWhere(
        (c) => (c.id ?? c.name) == item.id && !(_deletedIds.contains(item.id)),
      );
      if (createdIndex != -1) {
        _created[createdIndex] = CustomerChange(id: _created[createdIndex].id, name: name.trim());
      } else {
        _updatedById[item.id] = CustomerChange(id: item.id, name: name.trim());
      }
    });
  }

  void _onDelete(_UiCustomer item) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Müşteri Sil'),
        content: Text(
          '"${item.name}" müşterisini silmek istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sil',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      // Yeni eklenmişse created listesinden at
      _created.removeWhere((c) => (c.id ?? c.name) == item.id || c.name == item.name);
      // Güncellenmiş kaydı da kaldır
      _updatedById.remove(item.id);
      // Var olan kaydı silinmek üzere işaretle
      _deletedIds.add(item.id);
    });
  }

  Future<String?> _openNameDialog({
    required String title,
    String? initialValue,
    String? hint,
  }) async {
    final controller = TextEditingController(text: initialValue ?? '');
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: hint ?? 'Müşteri adı',
          ),
          onSubmitted: (v) => Navigator.of(context).pop(v.trim().isEmpty ? null : v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final v = controller.text.trim();
              Navigator.of(context).pop(v.isEmpty ? null : v);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    controller.dispose();
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
  final bool isNew;
  final bool isEdited;

  _UiCustomer({
    required this.id,
    required this.name,
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
