import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            "المعلومات الشخصية",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          12.verticalSpace,
          ...info.map((i) => _row(i)).toList(),
        ],
      ),
    );
  }

  Widget _row(Map i) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(i['icon'] as IconData, color: Colors.blue),
    title: Text(i['label'] as String, style: TextStyle(fontSize: 12, color: Colors.grey)),
    subtitle: Text(i['value'] as String, style: const TextStyle(fontSize: 14)),
  );
}
