import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class ReportBusScreen extends StatelessWidget {
  const ReportBusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.reportS.tr(),
      isScrollable: false,
      child: ListView.separated(
        padding: EdgeInsets.only(top: 12.h, bottom: 16.h),
        itemCount: 10,
        separatorBuilder: (_, __) => SizedBox(height: 10.h),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor(context),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              leading: Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.insert_drive_file_rounded, color: Colors.orange, size: 26),
              ),
              title: Text(
                'تقرير رقم ${index + 1}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  'تاريخ: 10/12/2025',
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.download_rounded, color: Colors.orange),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
