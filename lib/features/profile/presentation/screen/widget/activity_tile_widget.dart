import 'package:flutter/material.dart';
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
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'].toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  item['time'].toString(),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
