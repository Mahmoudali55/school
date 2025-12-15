import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ParentInfoSection extends StatelessWidget {
  final info = [
    {'label': 'الاسم', 'value': 'أحمد السعيد', 'icon': Icons.person},
    {'label': 'البريد', 'value': 'ahmed@email.com', 'icon': Icons.email},
    {'label': 'الهاتف', 'value': '+966 50 123 4567', 'icon': Icons.phone},
    {'label': 'العنوان', 'value': 'الرياض - العليا', 'icon': Icons.location_on},
    {'label': 'الهوية', 'value': '1234567890', 'icon': Icons.badge},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.personal_info.tr(),
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ...info.map((i) => _row(context, i)).toList(),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, Map i) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(i['icon'] as IconData, color: Colors.blue),
    title: Text(
      i['label'] as String,
      style: AppTextStyle.bodySmall(context, color: Colors.grey).copyWith(fontSize: 12),
    ),
    subtitle: Text(
      i['value'] as String,
      style: AppTextStyle.bodyMedium(context).copyWith(fontSize: 14),
    ),
  );
}
