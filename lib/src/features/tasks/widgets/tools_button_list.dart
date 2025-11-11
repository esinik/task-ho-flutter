import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Swift protocol benzeri bir delege yapısı.
/// Bu interface'i implement eden sınıflar, buton aksiyonlarını zorunlu olarak sağlar.
abstract class ToolsButtonsDelegate {
  void onAddTask(WidgetRef ref);
  //void onExportCsv(WidgetRef ref);
  //void onExportPdf(WidgetRef ref);
  void onAddOrEditCustomer(WidgetRef ref);
  void onShowAccountantFees(WidgetRef ref);
}

class ToolsButtonsWidget extends ConsumerWidget {
  const ToolsButtonsWidget({
    super.key,
    required this.delegate,
  });

  /// Zorunlu delege
  final ToolsButtonsDelegate delegate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        FilledButton.icon(
          onPressed: () => delegate.onAddTask(ref),
          icon: const Icon(Icons.add),
          label: const Text('Görev Ekle'),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          onPressed: () => delegate.onShowAccountantFees(ref),
          icon: const Icon(Icons.account_balance),
          label: const Text('Muhasebe Ücretleri'),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () => delegate.onAddOrEditCustomer(ref),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: const Text('Müşteri Ekle/Düzenle'),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            side: const BorderSide(color: Colors.blue),
          ),
        ),
        const SizedBox(width: 8),
        /*
        TextButton.icon(
          onPressed: () => delegate.onExportCsv(ref),
          label: const Text('CSV'),
          icon: const Icon(Icons.file_download_outlined),
        ),
        const SizedBox(width: 8),
        TextButton.icon(
          onPressed: () => delegate.onExportPdf(ref),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('PDF'),
        ),
        const SizedBox(width: 8),
        */
      ],
    );
  }
}
