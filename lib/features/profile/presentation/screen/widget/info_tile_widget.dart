import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/profile/presentation/screen/widget/card_style.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: cardStyle(),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(label, style: AppTextStyle.bodyMedium(context, color: Colors.grey.shade700)),
          const Spacer(),
          Text(
            value,
            style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
