import 'package:flutter/material.dart';
import 'package:my_template/features/profile/presentation/screen/widget/activity_tile_widget.dart';

class ActivitiesTab extends StatelessWidget {
  final List<Map<String, dynamic>> activities;
  const ActivitiesTab({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => ActivityTile(item: activities[i]),
    );
  }
}
