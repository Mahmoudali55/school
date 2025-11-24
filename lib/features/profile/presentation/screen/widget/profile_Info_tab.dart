import 'package:flutter/material.dart';
import 'package:my_template/features/profile/presentation/screen/widget/info_tile_widget.dart';
import 'package:my_template/features/profile/presentation/screen/widget/stat_card_widget.dart';

class InfoTab extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const InfoTab({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          StatCard(studentData: studentData),
          const SizedBox(height: 20),
          InfoTile(label: 'الصف', value: studentData['grade'].toString()),
          InfoTile(label: 'القسم', value: studentData['section'].toString()),
          InfoTile(label: 'عدد المواد', value: '12 مادة'),
          InfoTile(label: 'الدعم الفني', value: '+966500000000'),
        ],
      ),
    );
  }
}
