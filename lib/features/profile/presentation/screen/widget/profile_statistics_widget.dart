import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ProfileStatistics extends StatelessWidget {
  final double attendance;
  final double avg;

  const ProfileStatistics({super.key, required this.attendance, required this.avg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: _statItem(AppLocalKay.checkin.tr(), '$attendance%')),
          Expanded(child: _statItem(AppLocalKay.gpa.tr(), '$avg')),
          Expanded(child: _statItem(AppLocalKay.level.tr(), 'ممتاز')),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
