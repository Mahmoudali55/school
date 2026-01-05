import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BusCubit>();

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الإجراءات السريعة",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.7,
            children: [
              _buildQuickActionItem(
                "تسجيل حضور",
                Icons.people_alt_rounded,
                const Color(0xFF4CAF50),
                () => _takeAttendance(cubit, context),
              ),
              _buildQuickActionItem(
                "اتصال بالسائق",
                Icons.phone_rounded,
                const Color(0xFF2196F3),
                () => _callDriver(context),
              ),
              _buildQuickActionItem(
                "إشعار أولياء الأمور",
                Icons.notifications_rounded,
                const Color(0xFFFF9800),
                () => _notifyParents(context),
              ),
              _buildQuickActionItem(
                "تقرير الحضور",
                Icons.assessment_rounded,
                const Color(0xFF9C27B0),
                () => _showAttendanceReport(context),
              ),
              _buildQuickActionItem(
                "الرحلات",
                Icons.travel_explore_rounded,
                const Color(0xFFF44336),
                () => _showFieldTrips(context),
              ),
              _buildQuickActionItem(
                "الإعدادات",
                Icons.settings_rounded,
                const Color(0xFF607D8B),
                () => _openSettings(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(String title, IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, size: 24.w, color: color),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _takeAttendance(BusCubit cubit, BuildContext context) {
    cubit.takeAttendance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تسجيل الحضور بنجاح'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _callDriver(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اتصال بالسائق'),
        content: const Text('هل تريد الاتصال بالسائق؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: تنفيذ الاتصال
            },
            child: const Text('اتصال'),
          ),
        ],
      ),
    );
  }

  void _notifyParents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إشعار أولياء الأمور'),
        content: const Text('إرسال إشعار لأولياء الأمور'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم إرسال الإشعار بنجاح'),
                  backgroundColor: const Color(0xFFFF9800),
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showAttendanceReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('فتح تقرير الحضور'), backgroundColor: const Color(0xFF9C27B0)),
    );
  }

  void _showFieldTrips(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('فتح إدارة الرحلات الميدانية'),
        backgroundColor: const Color(0xFFF44336),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('فتح إعدادات المتابعة'),
        backgroundColor: const Color(0xFF607D8B),
      ),
    );
  }
}
