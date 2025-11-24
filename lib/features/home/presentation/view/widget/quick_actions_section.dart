import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/utils/navigator_methods.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      ("المكتبة الرقمية", Icons.menu_book, Colors.blue, RoutesName.digitalLibraryScreen),
      ("الواجبات", Icons.assignment, Colors.orange, RoutesName.assignmentsScreen),
      ("جدول الحصص", Icons.schedule, Colors.green, RoutesName.scheduleScreen),
      ("الدرجات", Icons.bar_chart, Colors.purple, RoutesName.gradesScreen),
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
                GestureDetector(
                  onTap: () {
                    NavigatorMethods.pushNamed(context, item.$4);
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: item.$3.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(item.$2, color: item.$3, size: 28.w),
                  ),
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
