import 'package:flutter/material.dart';
import 'package:my_template/features/profile/presentation/screen/widget/achievement_tile.dart';

class AchievementsTab extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  const AchievementsTab({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: achievements.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => AchievementTile(item: achievements[i]),
    );
  }
}
