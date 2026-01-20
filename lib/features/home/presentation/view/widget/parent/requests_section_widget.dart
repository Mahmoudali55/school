import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class RequestsSectionWidget extends StatelessWidget {
  final String? studentId;
  const RequestsSectionWidget({super.key, this.studentId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.requests.tr(),
          style: AppTextStyle.headlineMedium(
            context,
            color: const Color(0xFF1F2937),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _buildRequestCard(
                context,
                title: AppLocalKay.fees.tr(),
                subtitle: "2,000 ريال",
                icon: Icons.payments,
                color: const Color(0xFFDC2626),
                onTap: () {
                  // Navigate to fees details or pay
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildRequestCard(
                context,
                title: AppLocalKay.school_uniform.tr(),
                subtitle: AppLocalKay.request_uniform.tr(),
                icon: Icons.checkroom,
                color: const Color(0xFF2E5BFF),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RoutesName.uniformParentScreen,
                    arguments: studentId,
                  );
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildRequestCard(
                context,
                title: AppLocalKay.student_leave.tr(),
                subtitle: AppLocalKay.request_leave.tr(),
                icon: Icons.exit_to_app,
                color: const Color(0xFFEA580C),
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.leaveParentScreen, arguments: studentId);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequestCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColor.whiteColor(context),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor(context).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmall(
                context,
                color: const Color(0xFF1F2937),
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 10.sp),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.labelSmall(
                context,
                color: Colors.grey[600],
              ).copyWith(fontSize: 8.sp),
            ),
          ],
        ),
      ),
    );
  }
}
