import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

void showAbsenceDetails(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<HomeCubit>(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final absenceDetails = state.studentAbsentDataStatus.data ?? [];

          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColor.grey300Color(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Gap(24.h),
                Text(
                  AppLocalKay.absence.tr(),
                  style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
                ),
                Gap(20.h),
                if (state.studentAbsentDataStatus.isLoading)
                  const Expanded(child: Center(child: CircularProgressIndicator()))
                else if (absenceDetails.isEmpty)
                  Expanded(child: Center(child: Text(AppLocalKay.no_absence.tr())))
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: absenceDetails.length,
                      itemBuilder: (context, index) {
                        final item = absenceDetails[index];

                        return _buildAbsenceTile(
                          context,
                          item.absentDate,
                          item.notes ?? "بدون عذر",
                          item.absentType == 1
                              ? AppColor.errorColor(context)
                              : AppColor.accentColor(context),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildAbsenceTile(BuildContext context, String date, String reason, Color color) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: AppColor.grey50Color(context),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 8.w,
          height: 40.h,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        Gap(16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              reason,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.grey600Color(context)),
            ),
          ],
        ),
      ],
    ),
  );
}
