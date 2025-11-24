import 'package:flutter/material.dart';

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const StatItem({super.key, required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}
