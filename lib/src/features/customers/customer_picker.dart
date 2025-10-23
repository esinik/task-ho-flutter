import 'package:flutter/material.dart';

class CustomerPickerDialog extends StatelessWidget {
  const CustomerPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Müşteri Seç'),
      content: const SizedBox(width: 420, child: Text('Arama ve seçme işlevleri burada genişletilebilir.')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat')),
      ],
    );
  }
}
