import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:my_template/features/notifications/presentation/cubit/notification_state.dart';

class RecentNotificationsSection extends StatelessWidget {
  const RecentNotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        final notifications = state.notifications.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalKay.last_notifications.tr(),
                  style: AppTextStyle.headlineMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    NavigatorMethods.pushNamed(context, RoutesName.notificationsScreen);
                  },
                  child: Text(
                    AppLocalKay.show_all.tr(),
                    style: AppTextStyle.bodyMedium(context, color: Colors.green),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (notifications.isEmpty)
              const Text("لا توجد إشعارات حديثة")
            else
              Column(
                children: notifications.map((item) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor(context).withOpacity(0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: item.iconColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: item.iconColor, size: 20.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyle.titleSmall(
                                  context,
                                ).copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.message,
                                style: AppTextStyle.bodySmall(
                                  context,
                                  color: AppColor.greyColor(context),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.time,
                                style: AppTextStyle.bodySmall(
                                  context,
                                  color: AppColor.greyColor(context),
                                ).copyWith(fontSize: 10.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}
