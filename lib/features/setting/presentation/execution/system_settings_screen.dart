// lib/features/settings/presentation/screens/system_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/setting_item_widget.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() => _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  bool _autoBackup = true;
  bool _maintenanceMode = false;
  bool _debugMode = false;
  String _backupFrequency = 'أسبوعي';
  String _dataRetention = '3 سنوات';
  String _academicYear = '2024-2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'إعدادات النظام',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),

        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveSystemSettings)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // السنة الدراسية
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: AppColor.primaryColor(context)),
                title: Text('السنة الدراسية الحالية'),
                subtitle: Text(_academicYear),
                trailing: DropdownButton<String>(
                  value: _academicYear,
                  items: ['2023-2024', '2024-2025', '2025-2026']
                      .map(
                        (String value) =>
                            DropdownMenuItem<String>(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _academicYear = newValue!;
                    });
                  },
                  underline: SizedBox(),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // النسخ الاحتياطي التلقائي
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.backup, color: AppColor.primaryColor(context)),
                title: Text('النسخ الاحتياطي التلقائي'),
                subtitle: Text('نسخ البيانات تلقائياً بشكل دوري'),
                value: _autoBackup,
                onChanged: (bool value) {
                  setState(() {
                    _autoBackup = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // تردد النسخ الاحتياطي
            if (_autoBackup) ...[
              Card(
                child: ListTile(
                  leading: Icon(Icons.schedule, color: AppColor.primaryColor(context)),
                  title: Text('تردد النسخ الاحتياطي'),
                  subtitle: Text(_backupFrequency),
                  trailing: DropdownButton<String>(
                    value: _backupFrequency,
                    items: ['يومي', 'أسبوعي', 'شهري']
                        .map(
                          (String value) =>
                              DropdownMenuItem<String>(value: value, child: Text(value)),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _backupFrequency = newValue!;
                      });
                    },
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],

            // فترة احتفاظ البيانات
            Card(
              child: ListTile(
                leading: Icon(Icons.storage, color: AppColor.primaryColor(context)),
                title: Text('فترة احتفاظ البيانات'),
                subtitle: Text(_dataRetention),
                trailing: DropdownButton<String>(
                  value: _dataRetention,
                  items: ['1 سنة', '3 سنوات', '5 سنوات', 'دائم']
                      .map(
                        (String value) =>
                            DropdownMenuItem<String>(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dataRetention = newValue!;
                    });
                  },
                  underline: SizedBox(),
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // وضع الصيانة
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.engineering, color: AppColor.primaryColor(context)),
                title: Text('وضع الصيانة'),
                subtitle: Text('إيقاف النظام للصيانة (للمشرفين فقط)'),
                value: _maintenanceMode,
                onChanged: (bool value) {
                  setState(() {
                    _maintenanceMode = value;
                  });
                },
              ),
            ),
            SizedBox(height: 8.h),

            // وضع التصحيح
            Card(
              child: SwitchListTile(
                secondary: Icon(Icons.bug_report, color: AppColor.primaryColor(context)),
                title: Text('وضع التصحيح'),
                subtitle: Text('تفعيل سجلات التصحيح للأخطاء'),
                value: _debugMode,
                onChanged: (bool value) {
                  setState(() {
                    _debugMode = value;
                  });
                },
              ),
            ),
            SizedBox(height: 24.h),

            // إعدادات متقدمة
            Text(
              'الإعدادات المتقدمة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16.h),

            SettingItemWidget(
              icon: Icons.cleaning_services,
              title: 'تنظيف النظام',
              subtitle: 'حذف الملفات المؤقتة والبيانات غير المستخدمة',
              onTap: _cleanSystem,
            ),
            SettingItemWidget(
              icon: Icons.update,
              title: 'تحديث النظام',
              subtitle: 'التحقق من التحديثات وتثبيتها',
              onTap: _checkForUpdates,
            ),
            SettingItemWidget(
              icon: Icons.restore,
              title: 'استعادة الإعدادات الافتراضية',
              subtitle: 'إعادة تعيين جميع إعدادات النظام',
              onTap: _resetSystemSettings,
            ),
            SizedBox(height: 32.h),

            // معلومات النظام
            Card(
              color: AppColor.grey50Color(context),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات النظام',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildSystemInfoItem('إصدار النظام', '2.1.0'),
                    _buildSystemInfoItem('آخر تحديث', '2024-03-20'),
                    _buildSystemInfoItem('حجم قاعدة البيانات', '245 MB'),
                    _buildSystemInfoItem('مساحة التخزين', '1.2 GB / 5 GB'),
                    _buildSystemInfoItem('آخر نسخ احتياطي', '2024-03-19 22:30'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _saveSystemSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text(
                  'حفظ إعدادات النظام',
                  style: TextStyle(fontSize: 16.sp, color: AppColor.whiteColor(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoItem(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: AppColor.grey600Color(context)),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _saveSystemSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ إعدادات النظام بنجاح'),
        backgroundColor: AppColor.successColor(context),
      ),
    );
    Navigator.pop(context);
  }

  void _cleanSystem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تنظيف النظام'),
          content: Text('هل تريد حذف الملفات المؤقتة وبيانات التخزين غير المستخدمة؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تنظيف النظام بنجاح'),
                    backgroundColor: AppColor.successColor(context),
                  ),
                );
              },
              child: Text('تنظيف'),
            ),
          ],
        );
      },
    );
  }

  void _checkForUpdates() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تحديث النظام'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: AppColor.successColor(context), size: 50.w),
              SizedBox(height: 16.h),
              Text('النظام محدث لأحدث إصدار (2.1.0)'),
            ],
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('موافق'))],
        );
      },
    );
  }

  void _resetSystemSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('استعادة الإعدادات الافتراضية'),
          content: Text(
            'هل أنت متأكد من أنك تريد استعادة جميع إعدادات النظام إلى القيم الافتراضية؟ هذا الإجراء لا يمكن التراجع عنه.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم استعادة الإعدادات الافتراضية'),
                    backgroundColor: AppColor.secondAppColor(context),
                  ),
                );
              },
              child: Text('استعادة', style: TextStyle(color: AppColor.errorColor(context))),
            ),
          ],
        );
      },
    );
  }
}
