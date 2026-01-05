import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/profile/presentation/screen/widget/card_style.dart';

class ActivityTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const ActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color color = item['color'] as Color;
    final IconData icon = item['icon'] as IconData;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardStyle(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: color.withAlpha((0.15 * 255).round()),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'].toString(),
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time'].toString(),
                  style: AppTextStyle.bodySmall(
                    context,
                    color: Colors.grey.shade600,
                  ).copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
