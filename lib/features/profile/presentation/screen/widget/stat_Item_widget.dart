import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';

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
        Text(
          value,
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyle.bodySmall(context, color: Colors.grey).copyWith(fontSize: 13),
        ),
      ],
    );
  }
}
