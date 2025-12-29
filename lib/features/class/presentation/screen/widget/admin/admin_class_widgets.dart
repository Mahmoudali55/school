import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';

class AdminClassCard extends StatelessWidget {
  final SchoolClass schoolClass;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onManageStudents;

  const AdminClassCard({
    super.key,
    required this.schoolClass,
    required this.onViewDetails,
    required this.onEdit,
    required this.onManageStudents,
  });

  @override
  Widget build(BuildContext context) {
    double fillPercentage = (schoolClass.currentStudents / schoolClass.capacity) * 100;
    Color statusColor = fillPercentage >= 90
        ? Colors.red
        : fillPercentage >= 70
        ? Colors.orange
        : Colors.green;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    schoolClass.name,
                    style: AppTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    fillPercentage >= 90
                        ? AppLocalKay.filter_full.tr()
                        : fillPercentage >= 70
                        ? AppLocalKay.class_status_almost_full.tr()
                        : AppLocalKay.filter_available.tr(),
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontSize: 10.sp, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // معلومات الفصل
            _buildInfoRow(
              context,
              Icons.person,
              '${AppLocalKay.teacher.tr()}: ${schoolClass.teacher}',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              context,
              Icons.room,
              '${AppLocalKay.label_room.tr()}: ${schoolClass.room}',
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(context, Icons.schedule, schoolClass.schedule),
            SizedBox(height: 16.h),

            // شريط التقدم
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalKay.label_capacity.tr(),
                      style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                    ),
                    Text(
                      '${schoolClass.currentStudents}/${schoolClass.capacity} طالب',
                      style: AppTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: schoolClass.currentStudents / schoolClass.capacity,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // أزرار الإجراءات
            Row(
              children: [
                _buildActionButton(
                  context,
                  Icons.visibility,
                  AppLocalKay.btn_view.tr(),
                  AppColor.primaryColor(context),
                  onViewDetails,
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  context,
                  Icons.edit,
                  AppLocalKay.user_management_edit.tr(),
                  AppColor.accentColor(context),
                  onEdit,
                ),
                SizedBox(width: 8.w),
                _buildActionButton(
                  context,
                  Icons.people,
                  AppLocalKay.btn_manage_students.tr(),
                  AppColor.secondAppColor(context),
                  onManageStudents,
                  fontSize: 10.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap, {
    double? fontSize,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16.w, color: color),
                SizedBox(height: 4.h),
                Text(
                  label,
                  style: AppTextStyle.bodySmall(context).copyWith(fontSize: fontSize),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminClassesEmptyState extends StatelessWidget {
  final bool isSearch;
  final VoidCallback onAddClass;

  const AdminClassesEmptyState({super.key, required this.isSearch, required this.onAddClass});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.class_, size: 80.w, color: Colors.grey.shade300),
            SizedBox(height: 16.h),
            Text(
              context.locale.languageCode == 'ar' ? 'لا توجد فصول' : 'No classes found',
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
            ),
            SizedBox(height: 8.h),
            Text(
              !isSearch
                  ? AppLocalKay.empty_subtitle_no_classes.tr()
                  : AppLocalKay.empty_subtitle_no_search.tr(),
              style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: onAddClass,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              child: Text(
                AppLocalKay.btn_add_class.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(color: AppColor.whiteColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
