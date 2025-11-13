import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/enums/enums.dart';
import '../../../core/providers/providers.dart';

/// Swift protocol benzeri bir delege yapısı.
/// Bu interface'i implement eden sınıflar, buton aksiyonlarını zorunlu olarak sağlar.
abstract class ToolsButtonsDelegate {
  void onShowTaskList(WidgetRef ref);
  void onShowAccountantFees(WidgetRef ref);
  void onAddOrEditCustomer(WidgetRef ref);
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
    final l10n = AppLocalizations.of(context)!;
    final screenType = ref.watch(screenTypeProvider);
    final isTaskListActive = screenType == ScreenType.tasks;
    final isFeeScreenActive = screenType == ScreenType.fees;

    return Row(
      children: [
        // Task List Button
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: isTaskListActive ? Colors.blue : Colors.grey,
          ),
          onPressed: () => delegate.onShowTaskList(ref),
          icon: const Icon(Icons.list),
          label: Text(l10n.tasks),
        ),
        const SizedBox(width: 8),
        // Accounting Fees Button
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: isFeeScreenActive ? Colors.orange : Colors.grey,
          ),
          onPressed: () => delegate.onShowAccountantFees(ref),
          icon: const Icon(Icons.account_balance),
          label: Text(l10n.fees),
        ),
        const SizedBox(width: 8),
        // Add/Edit Customer Button
        TextButton.icon(
          onPressed: () => delegate.onAddOrEditCustomer(ref),
          icon: const Icon(Icons.person_add_alt_1_outlined),
          label: Text(l10n.addEditCustomer),
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
