import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/setting/presentation/execution/change_password_screen.dart';
import 'package:my_template/features/setting/presentation/execution/class_management_screen.dart';
import 'package:my_template/features/setting/presentation/execution/edit_profile_screen.dart';
import 'package:my_template/features/setting/presentation/execution/help_center_screen.dart';
import 'package:my_template/features/setting/presentation/execution/notification_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/privacy_policy_screen.dart';
import 'package:my_template/features/setting/presentation/execution/school_info_screen.dart';
import 'package:my_template/features/setting/presentation/execution/security_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/system_settings_screen.dart';
import 'package:my_template/features/setting/presentation/execution/terms_screen.dart';
import 'package:my_template/features/setting/presentation/execution/user_management_screen.dart';
import 'package:my_template/features/setting/presentation/screen/widget/admin_settings/setting_item_widget.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'العربية';
  String _selectedTheme = 'فاتح';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الإعدادات',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الملف الشخصي
            _buildProfileCard(),
            SizedBox(height: 24.h),

            // إعدادات الحساب
            _buildSectionTitle('إعدادات الحساب'),
            SizedBox(height: 16.h),
            _buildAccountSettings(),
            SizedBox(height: 24.h),

            // إعدادات المدرسة
            _buildSectionTitle('إعدادات المدرسة'),
            SizedBox(height: 16.h),
            _buildSchoolSettings(),
            SizedBox(height: 24.h),

            // إعدادات التطبيق
            _buildSectionTitle('إعدادات التطبيق'),
            SizedBox(height: 16.h),
            _buildAppSettings(),
            SizedBox(height: 24.h),

            // معلومات التطبيق
            _buildSectionTitle('المعلومات'),
            SizedBox(height: 16.h),
            _buildAppInfo(),
            SizedBox(height: 32.h),

            // أزرار الإجراءات
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: const Color(0xFF2E5BFF).withOpacity(0.1),
              child: Icon(Icons.school, size: 30.w, color: const Color(0xFF2E5BFF)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحمد المدير',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'مدير المدرسة',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'admin@school.edu',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: const Color(0xFF2E5BFF)),
              onPressed: _editProfile,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.person,
          title: 'الملف الشخصي',
          subtitle: 'تعديل المعلومات الشخصية',
          onTap: _editProfile,
        ),
        SettingItemWidget(
          icon: Icons.lock,
          title: 'كلمة المرور',
          subtitle: 'تغيير كلمة المرور',
          onTap: _changePassword,
        ),
        SettingItemWidget(
          icon: Icons.security,
          title: 'الأمان',
          subtitle: 'المصادقة الثنائية والإعدادات الأمنية',
          onTap: _securitySettings,
        ),
        SettingItemWidget(
          icon: Icons.notifications,
          title: 'الإشعارات',
          subtitle: 'إدارة الإشعارات والتنبيهات',
          onTap: _notificationSettings,
        ),
      ],
    );
  }

  Widget _buildSchoolSettings() {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.school,
          title: 'معلومات المدرسة',
          subtitle: 'تعديل بيانات المدرسة',
          onTap: _editSchoolInfo,
        ),
        SettingItemWidget(
          icon: Icons.group,
          title: 'إدارة المستخدمين',
          subtitle: 'إضافة وحذف المستخدمين',
          onTap: _manageUsers,
        ),
        SettingItemWidget(
          icon: Icons.class_,
          title: 'إدارة الصفوف',
          subtitle: 'تنظيم الصفوف والشعب',
          onTap: _manageClasses,
        ),
        SettingItemWidget(
          icon: Icons.assignment,
          title: 'إعدادات النظام',
          subtitle: 'إعدادات الدرجات والتقارير',
          onTap: _systemSettings,
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      children: [
        // اللغة
        Card(
          child: ListTile(
            leading: Icon(Icons.language, color: const Color(0xFF2E5BFF)),
            title: Text('اللغة'),
            subtitle: Text(_selectedLanguage),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              items: ['العربية', 'English', 'Français']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              underline: SizedBox(),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // المظهر
        Card(
          child: ListTile(
            leading: Icon(Icons.palette, color: const Color(0xFF2E5BFF)),
            title: Text('المظهر'),
            subtitle: Text(_selectedTheme),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              items: ['فاتح', 'غامق', 'تلقائي']
                  .map((String value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
              underline: SizedBox(),
            ),
          ),
        ),
        SizedBox(height: 8.h),

        // الإشعارات
        Card(
          child: SwitchListTile(
            secondary: Icon(Icons.notifications_active, color: const Color(0xFF2E5BFF)),
            title: Text('الإشعارات'),
            subtitle: Text('تفعيل/تعطيل الإشعارات'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
        ),
        SizedBox(height: 8.h),

        // المصادقة البيومترية
        Card(
          child: SwitchListTile(
            secondary: Icon(Icons.fingerprint, color: const Color(0xFF2E5BFF)),
            title: Text('المصادقة البيومترية'),
            subtitle: Text('استخدام البصمة أو التعرف على الوجه'),
            value: _biometricEnabled,
            onChanged: (bool value) {
              setState(() {
                _biometricEnabled = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        SettingItemWidget(
          icon: Icons.help,
          title: 'مركز المساعدة',
          subtitle: 'الدعم والأسئلة الشائعة',
          onTap: _showHelpCenter,
        ),
        SettingItemWidget(
          icon: Icons.privacy_tip,
          title: 'الخصوصية',
          subtitle: 'سياسة الخصوصية',
          onTap: _showPrivacyPolicy,
        ),
        SettingItemWidget(
          icon: Icons.description,
          title: 'الشروط والأحكام',
          subtitle: 'شروط استخدام التطبيق',
          onTap: _showTerms,
        ),
        SettingItemWidget(
          icon: Icons.info,
          title: 'حول التطبيق',
          subtitle: 'الإصدار والمعلومات',
          onTap: _showAbout,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _backupData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.backup, color: Colors.white),
                SizedBox(width: 8.w),
                Text(
                  'نسخ احتياطي للبيانات',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: OutlinedButton(
            onPressed: _logout,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8.w),
                Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontSize: 16.sp, color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // دوال الإجراءات
  void _editProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }

  void _changePassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
  }

  void _securitySettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SecuritySettingsScreen()));
  }

  void _notificationSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
  }

  void _editSchoolInfo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SchoolInfoScreen()));
  }

  void _manageUsers() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserManagementScreen()));
  }

  void _manageClasses() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ClassManagementScreen()));
  }

  void _systemSettings() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SystemSettingsScreen()));
  }

  void _showHelpCenter() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCenterScreen()));
  }

  void _showPrivacyPolicy() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
  }

  void _showTerms() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TermsScreen()));
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'نظام إدارة المدرسة',
      applicationVersion: 'الإصدار 2.1.0',
      applicationIcon: Icon(Icons.school, size: 50.w),
    );
  }

  void _backupData() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نسخ احتياطي'),
          content: Text('هل تريد إنشاء نسخة احتياطية من جميع بيانات النظام؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم إنشاء النسخة الاحتياطية بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('تأكيد'),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تسجيل الخروج'),
          content: Text('هل أنت متأكد من أنك تريد تسجيل الخروج؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: تنفيذ تسجيل الخروج
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم تسجيل الخروج بنجاح'), backgroundColor: Colors.green),
                );
              },
              child: Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
