// features/transport/presentation/view/transport_management_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TransportManagementScreen extends StatelessWidget {
  const TransportManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalKay.transport_desc.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Buses Overview
            _buildBusesOverview(context),
            SizedBox(height: 20.h),
            // Buses List
            Expanded(child: _buildBusesList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new bus
        },
        child: Icon(Icons.directions_bus, size: 24.w),
      ),
    );
  }

  Widget _buildBusesOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOverviewItem(
              AppLocalKay.user_management_total_buses.tr(),
              '12',
              Icons.directions_bus,
              context,
            ),
            _buildOverviewItem(
              AppLocalKay.user_management_active.tr(),
              '10',
              Icons.check_circle,
              context,
            ),
            _buildOverviewItem(
              AppLocalKay.user_management_maintenance.tr(),
              '2',
              Icons.build,
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String value, IconData icon, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30.w, color: Colors.blue),
        SizedBox(height: 8.h),
        Text(value, style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold)),
        Text(title, style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildBusesList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => _buildBusCard(index, context),
    );
  }

  Widget _buildBusCard(int index, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'حافلة ${index + 1}',
                  style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8.w, color: Colors.green),
                      SizedBox(width: 4.w),
                      Text(
                        AppLocalKay.user_management_active.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.confirmation_number, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text('رقم الحافلة: BUS-00${index + 1}', style: AppTextStyle.bodySmall(context)),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.person, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text('السائق: محمد أحمد', style: AppTextStyle.bodySmall(context)),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.phone, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text('رقم الهاتف: 05xxxxxxxx', style: AppTextStyle.bodySmall(context)),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.people, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text('الطلاب: ٢٥/٣٠', style: AppTextStyle.bodySmall(context)),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // View bus details
                  },
                  icon: Icon(Icons.visibility, size: 16.w),
                  label: Text(
                    AppLocalKay.user_management_view.tr(),
                    style: AppTextStyle.bodyMedium(
                      context,
                    ).copyWith(color: AppColor.whiteColor(context)),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Edit bus
                  },
                  icon: Icon(Icons.edit, size: 16.w),
                  label: Text(AppLocalKay.user_management_edit.tr()),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Track bus
                  },
                  icon: Icon(Icons.location_on, size: 16.w),
                  label: Text(AppLocalKay.user_management_track.tr()),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
