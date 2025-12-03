// features/finance/presentation/view/financial_settings_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class FinancialSettingsScreen extends StatelessWidget {
  const FinancialSettingsScreen({super.key});

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
          AppLocalKay.financial_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildFinancialSummary(),
            SizedBox(height: 20.h),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TabBar(
                        labelColor: AppColor.whiteColor(context),
                        unselectedLabelColor: Colors.grey,
                        indicator: BoxDecoration(
                          color: AppColor.primaryColor(context),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        tabs: [
                          Tab(text: AppLocalKay.user_management_Fees.tr()),
                          Tab(text: AppLocalKay.user_management_Expenses.tr()),
                          Tab(text: AppLocalKay.user_management_settings.tr()),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: TabBarView(
                        children: [_buildFeesTab(), _buildExpensesTab(), _buildSettingsTab()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              AppLocalKay.user_management_expenses.tr(),
              '١٢٥,٠٠٠ ر.س',
              Colors.green,
            ),
            _buildSummaryItem(AppLocalKay.user_management_revenue.tr(), '٨٥,٠٠٠ ر.س', Colors.red),
            _buildSummaryItem(AppLocalKay.user_management_net.tr(), '٤٠,٠٠٠ ر.س', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildFeesTab() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(Icons.attach_money, color: Colors.blue, size: 20.w),
          ),
          title: Text(
            'رسوم الفصل الدراسي ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          subtitle: Text('٢٠٠٠ ر.س - تنتهي في ٣٠/٠٦/٢٠٢٤', style: TextStyle(fontSize: 12.sp)),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildExpensesTab() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: Icon(Icons.money_off, color: Colors.red, size: 20.w),
          ),
          title: Text(
            'مصروفات ${['مرتبات', 'صيانة', 'كهرباء', 'مياه', 'إنترنت'][index]}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
          ),
          subtitle: Text(
            '${[50000, 15000, 5000, 3000, 2000][index]} ر.س',
            style: TextStyle(fontSize: 12.sp),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      children: [
        _buildSettingSwitch('تفعيل الدفع الإلكتروني', true),
        _buildSettingSwitch('إشعارات الدفع', true),
        _buildSettingSwitch('الدفع بالتقسيط', false),
        _buildSettingItem('عملة النظام', 'ريال سعودي (ر.س)'),
        _buildSettingItem('ضريبة القيمة المضافة', '١٥٪'),
        _buildSettingItem('غرامة التأخير', '٥٠ ر.س'),
      ],
    );
  }

  Widget _buildSettingSwitch(String title, bool value) {
    return SwitchListTile(title: Text(title), value: value, onChanged: (bool newValue) {});
  }

  Widget _buildSettingItem(String title, String value) {
    return ListTile(title: Text(title), trailing: Text(value), onTap: () {});
  }
}
