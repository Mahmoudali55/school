import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/notifications/data/model/notification_model.dart';
import 'package:my_template/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:my_template/features/notifications/presentation/cubit/notification_state.dart';
import 'package:my_template/features/notifications/presentation/screen/widget/notification_Item_widget.dart';
import 'package:my_template/features/notifications/presentation/screen/widget/parent/notification_section_widget.dart';

class NotificationsParentScreen extends StatelessWidget {
  const NotificationsParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        context,
        centerTitle: true,
        title: Text(
          AppLocalKay.notification.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text(state.error!));
          }
          if (state.notifications.isEmpty) {
            return const Center(child: Text("لا توجد إشعارات"));
          }

          // Grouping notifications by category
          final categories = ["اليوم", "الأمس", "هذا الأسبوع"];
          final groupedNotifications = categories
              .map((category) {
                return {
                  'category': category,
                  'items': state.notifications.where((n) => n.category == category).toList(),
                };
              })
              .where((group) => (group['items'] as List).isNotEmpty)
              .toList();

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    children: groupedNotifications.map((group) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: NotificationSectionWidget(
                          title: group['category'] as String,
                          notifications: (group['items'] as List).map((n) {
                            final item = n as NotificationModel;
                            return NotificationItemWidget(
                              icon: item.icon,
                              iconColor: item.iconColor,
                              iconBgColor: item.iconBgColor,
                              title: item.title,
                              message: item.message,
                              time: item.time,
                              isUrgent: item.isUrgent,
                              isRead: item.isRead,
                            );
                          }).toList(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
