// features/class_management/presentation/view/class_management_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

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
          AppLocalKay.class_management_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
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
                itemBuilder: (context, index) => _buildClassCard(index, context),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add new class
      //   },
      //   child: Icon(Icons.add, size: 24.w),
      // ),
    );
  }

  Widget _buildStatisticsCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            AppLocalKay.user_management_total_classes.tr(),
            '24',
            Colors.blue,
            context,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            AppLocalKay.user_management_absent_classes.tr(),
            '18',
            Colors.green,
            context,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            AppLocalKay.user_management_present_classes.tr(),
            '6',
            Colors.orange,
            context,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, BuildContext context) {
    return Card(
      color: AppColor.whiteColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyle.headlineLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.blackColor(context)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard(int index, BuildContext context) {
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
                  style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'ممتلئ',
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontSize: 10.sp, color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              'المعلم: أحمد محمد',
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
            ),
            Text(
              'الطلاب: 30/30',
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
            ),
            SizedBox(height: 8.h),
            LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.visibility, size: 18.w),
                Icon(Icons.edit, size: 18.w),
                Icon(Icons.schedule, size: 18.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
