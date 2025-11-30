// features/class_management/presentation/view/class_management_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ClassManagementScreen extends StatelessWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        context,
        title: Text(
          'إدارة الفصول',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Statistics Cards
            _buildStatisticsCards(context),
            SizedBox(height: 20.h),
            // Classes Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: .865,
                ),
                itemCount: 8,
                itemBuilder: (context, index) => _buildClassCard(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new class
        },
        child: Icon(Icons.add, size: 24.w),
      ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('إجمالي الفصول', '24', Colors.blue, context)),
        SizedBox(width: 12.w),
        Expanded(child: _buildStatCard('فصول ممتلئة', '18', Colors.green, context)),
        SizedBox(width: 12.w),
        Expanded(child: _buildStatCard('فصول شاغرة', '6', Colors.orange, context)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, BuildContext context) {
    return Card(
      color: AppColor.whiteColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: AppColor.blackColor(context)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildClassCard(int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الصف ${index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'ممتلئ',
                    style: TextStyle(fontSize: 10.sp, color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'المعلم: أحمد محمد',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            Text(
              'الطلاب: 30/30',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.visibility, size: 18.w),
                  onPressed: () {
                    // View class details
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit, size: 18.w),
                  onPressed: () {
                    // Edit class
                  },
                ),
                IconButton(
                  icon: Icon(Icons.schedule, size: 18.w),
                  onPressed: () {
                    // View schedule
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
