import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';
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
          Expanded(child: _statItem(context, AppLocalKay.checkin.tr(), '$attendance%')),
          Expanded(child: _statItem(context, AppLocalKay.gpa.tr(), '$avg')),
          Expanded(child: _statItem(context, AppLocalKay.level.tr(), 'ممتاز')),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyle.headlineSmall(context, color: Colors.blue).copyWith(fontSize: 20),
        ),
        Text(label, style: AppTextStyle.bodyMedium(context, color: Colors.grey)),
      ],
    );
  }
}
