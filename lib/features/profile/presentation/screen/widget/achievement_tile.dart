import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/profile/presentation/screen/widget/card_style.dart';

class AchievementTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const AchievementTile({super.key, required this.item});

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
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'].toString(),
                  style: AppTextStyle.titleMedium(context, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  item['desc'].toString(),
                  style: AppTextStyle.bodyMedium(context, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const Icon(Icons.verified, color: Colors.green),
        ],
      ),
    );
  }
}
