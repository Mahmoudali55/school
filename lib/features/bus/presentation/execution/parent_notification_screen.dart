import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class ParentNotificationPage extends StatelessWidget {
  const ParentNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.ParentNotification.tr(),
      child: Column(
        children: [
          TextField(
            maxLines: 6,
            decoration: InputDecoration(
              hintText: 'أدخل نص الإشعار هنا',
              fillColor: Colors.white.withOpacity(0.9),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFFF9800),
              ),
              child: Text('إرسال'),
            ),
          ),
        ],
      ),
    );
  }
}
