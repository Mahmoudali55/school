import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      ("المكتبة الرقمية", Icons.menu_book, Colors.blue),
      ("الواجبات", Icons.assignment, Colors.orange),
      ("جدول الحصص", Icons.schedule, Colors.green),
      ("الدرجات", Icons.bar_chart, Colors.purple),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الوصول السريع",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(actions.length, (i) {
            final item = actions[i];
            return Column(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: item.$3.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.$2, color: item.$3, size: 28.w),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.$1,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
