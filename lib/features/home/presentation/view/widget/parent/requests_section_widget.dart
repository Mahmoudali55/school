import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/home_models.dart';

class RequestsSectionWidget extends StatelessWidget {
  final StudentMiniInfo? selectedStudent;
  final List<StudentMiniInfo> students;
  const RequestsSectionWidget({super.key, this.selectedStudent, this.students = const []});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.requests.tr(),
          style: AppTextStyle.headlineMedium(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(16.h),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildRequestCard(
                    context,
                    title: AppLocalKay.fees.tr(),
                    subtitle: "2,000 ريال",
                    icon: Icons.payments,
                    color: AppColor.errorColor(context),
                    onTap: () {},
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: _buildRequestCard(
                    context,
                    title: AppLocalKay.school_uniform.tr(),
                    subtitle: AppLocalKay.request_uniform.tr(),
                    icon: Icons.checkroom,
                    color: AppColor.primaryColor(context),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.uniformParentScreen,
                        arguments: selectedStudent?.name,
                      );
                    },
                  ),
                ),
              ],
            ),
            Gap(12.h),
            Row(
              children: [
                Expanded(
                  child: _buildRequestCard(
                    context,
                    title: AppLocalKay.student_leave.tr(),
                    subtitle: AppLocalKay.request_leave.tr(),
                    icon: Icons.exit_to_app,
                    color: AppColor.errorColor(context),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutesName.leaveParentScreen,
                        arguments: selectedStudent?.name,
                      );
                    },
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: _buildRequestCard(
                    context,
                    title: AppLocalKay.student_call.tr(),
                    subtitle: AppLocalKay.i_am_arriving.tr(),
                    icon: Icons.record_voice_over,
                    color: AppColor.successColor(context),
                    onTap: () {
                      _showArrivingConfirmation(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showArrivingConfirmation(BuildContext context) {
    final String displayNames = students.isNotEmpty
        ? students.map((s) => "${s.name} (${s.grade})").join(" - ")
        : (selectedStudent?.name ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (dialogContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Text(AppLocalKay.student_call.tr(), style: AppTextStyle.headlineMedium(context)),
              const Gap(12),
              Text("${AppLocalKay.i_am_arriving.tr()}:", style: AppTextStyle.bodyMedium(context)),
              const Gap(10),
              Expanded(
                child: ListView(
                  children: students
                      .map(
                        (s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: AppColor.successColor(context),
                                size: 18,
                              ),
                              const Gap(10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.name,
                                      style: AppTextStyle.bodyMedium(
                                        context,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "${s.grade}${s.school != null ? ' - ${s.school}' : ''}",
                                      style: AppTextStyle.labelSmall(
                                        context,
                                        color: AppColor.grey600Color(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),

              const Gap(10),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: AppLocalKay.cancel.tr(),
                      radius: 12,
                      color: AppColor.errorColor(context),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: CustomButton(
                      text: AppLocalKay.i_am_arriving.tr(),
                      radius: 12,
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ),
                  const Gap(12),
                ],
              ),
            ],
          ),
        );
      },
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
            Gap(8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodySmall(
                context,
                color: AppColor.blackColor(context),
              ).copyWith(fontWeight: FontWeight.bold, fontSize: 10.sp),
            ),
            Gap(4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.labelSmall(
                context,
                color: AppColor.grey400Color(context),
              ).copyWith(fontSize: 8.sp),
            ),
          ],
        ),
      ),
    );
  }
}
