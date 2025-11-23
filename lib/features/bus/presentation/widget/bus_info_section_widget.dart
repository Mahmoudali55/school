import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BusInfoSectionWidget extends StatelessWidget {
  const BusInfoSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "معلومات الحافلة",
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            _buildInfoRow("رقم الحافلة", "باص ٠١", context),
            _buildInfoRow("السائق", "أحمد محمد", context),
            _buildInfoRow("رقم الهاتف", "+٢٠١٢٣٤٥٦٧٨٩", context),
            _buildInfoRow("سعة الحافلة", "٤٠ طالب", context),
            _buildInfoRow("وقت الصباح", "٦:٣٠ ص", context),
            _buildInfoRow("وقت الظهر", "٢:٠٠ م", context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: AppTextStyle.titleLarge(context))),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyle.text14RGrey(context).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
