import 'package:flutter/material.dart';

class TitleAndLogoWidget extends StatelessWidget {
  const TitleAndLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(33)),
              color: Color(0xFF2563eb),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "TH",
                style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'TaskHo',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
              Text(
                'Get tasks done — the Ho way.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
