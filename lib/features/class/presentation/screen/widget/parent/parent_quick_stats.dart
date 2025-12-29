import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ParentQuickStats extends StatelessWidget {
  const ParentQuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            context,
            AppLocalKay.checkin.tr(),
            '95%'.tr(),
            Icons.check,
            AppColor.secondAppColor(context),
            AppLocalKay.this_month.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            context,
            AppLocalKay.grades.tr(),
            '88%'.tr(),
            Icons.grade,
            AppColor.primaryColor(context),
            AppLocalKay.gpas.tr(),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            context,
            AppLocalKay.todostitle.tr(),
            '3'.tr(),
            Icons.assignment,
            AppColor.accentColor(context),
            AppLocalKay.pending.tr(),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String sub,
  ) {
    return Card(
      elevation: 1.3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(color: color, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey)),
            Text(
              sub,
              style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
