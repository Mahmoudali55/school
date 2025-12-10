import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class ParentNotificationScreen extends StatefulWidget {
  const ParentNotificationScreen({super.key});

  @override
  State<ParentNotificationScreen> createState() => _ParentNotificationScreenState();
}

class _ParentNotificationScreenState extends State<ParentNotificationScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.ParentNotification.tr(),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomFormField(
              title: AppLocalKay.notification_message.tr(),
              radius: 12.r,
              controller: messageController,
              maxLines: 6,
              hintText: context.locale.languageCode == 'ar'
                  ? "ادخل نص الاشعار هنا..."
                  : "Enter notification text here...",
            ),

            SizedBox(height: 24.h),

            // Send Button
            CustomButton(
              text: AppLocalKay.send_notification.tr(),
              onPressed: () {},
              radius: 12.r,
              color: AppColor.accentColor(context),
            ),
          ],
        ),
      ),
    );
  }
}
