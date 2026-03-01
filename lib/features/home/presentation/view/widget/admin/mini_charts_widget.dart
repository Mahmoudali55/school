import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class MiniCharts extends StatelessWidget {
  const MiniCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.quickAnalysis.tr(),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Gap(16.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildProgressAnalysisCard(
                context,
                title: "معدل الحضور اليومي",
                percentage: 0.92,
                percentageText: "92%",
                subtitle: "ارتفاع بنسبة 2% عن الأسبوع الماضي",
                isPositiveTrend: true,
                icon: Icons.how_to_reg_rounded,
                color: AppColor.successColor(context),
              ),
              Gap(16.w),
              _buildProgressAnalysisCard(
                context,
                title: "نسبة تحصيل الرسوم",
                percentage: 0.78,
                percentageText: "78%",
                subtitle: "ثبات مقارنة بالشهر السابق",
                isPositiveTrend: null, // Neutral
                icon: Icons.account_balance_wallet_rounded,
                color: AppColor.primaryColor(context),
              ),
              Gap(16.w),
              _buildProgressAnalysisCard(
                context,
                title: "اكتمال المهام والخطة",
                percentage: 0.65,
                percentageText: "65%",
                subtitle: "انخفاض بنسبة 5% للأسف",
                isPositiveTrend: false,
                icon: Icons.assignment_turned_in_rounded,
                color: AppColor.warningColor(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressAnalysisCard(
    BuildContext context, {
    required String title,
    required double percentage,
    required String percentageText,
    required String subtitle,
    required bool? isPositiveTrend,
    required IconData icon,
    required Color color,
  }) {
    Color trendIconColor;
    IconData trendIcon;

    if (isPositiveTrend == true) {
      trendIconColor = AppColor.successColor(context);
      trendIcon = Icons.trending_up_rounded;
    } else if (isPositiveTrend == false) {
      trendIconColor = AppColor.errorColor(context);
      trendIcon = Icons.trending_down_rounded;
    } else {
      trendIconColor = AppColor.hintColor(context);
      trendIcon = Icons.trending_flat_rounded;
    }

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.borderColor(context).withValues(alpha: (0.5))),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: (0.08)),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.hintColor(context), fontWeight: FontWeight.w600),
                    ),
                    Gap(8.h),
                    Text(
                      percentageText,
                      style: AppTextStyle.headlineSmall(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: AppColor.textColor(context)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
            ],
          ),
          Gap(24.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColor.surfaceVariant(context),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8.h,
            ),
          ),
          Gap(16.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: trendIconColor.withValues(alpha: (0.1)),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(trendIcon, color: trendIconColor, size: 14.sp),
              ),
              Gap(8.w),
              Expanded(
                child: Text(
                  subtitle,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.hintColor(context), fontSize: 11.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
