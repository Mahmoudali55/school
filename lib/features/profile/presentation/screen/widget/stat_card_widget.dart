import 'package:flutter/material.dart';
import 'package:my_template/features/profile/presentation/screen/widget/card_style.dart';
import 'package:my_template/features/profile/presentation/screen/widget/stat_Item_widget.dart';

class StatCard extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const StatCard({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: cardStyle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(
            icon: Icons.calendar_today,
            value: '${studentData['attendanceRate']}%',
            label: 'الحضور',
          ),
          StatItem(icon: Icons.grade, value: '${studentData['averageGrade']}', label: 'المعدل'),
          StatItem(icon: Icons.star, value: 'ممتاز', label: 'التقييم'),
        ],
      ),
    );
  }
}
