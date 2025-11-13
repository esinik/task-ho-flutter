import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class CustomerPickerDialog extends StatelessWidget {
  const CustomerPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.customers),
      content: const SizedBox(width: 420),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
      ],
    );
  }
}
