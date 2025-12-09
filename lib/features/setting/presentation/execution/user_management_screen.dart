// lib/features/settings/presentation/screens/user_management_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User('أحمد محمد', 'مدير', 'admin@school.edu', true),
    User('محمد أحمد', 'نائب المدير', 'vice@school.edu', true),
    User('فاطمة علي', 'معلم', 'teacher1@school.edu', true),
    User('خالد إبراهيم', 'معلم', 'teacher2@school.edu', false),
    User('سارة عبدالله', 'سكرتيرة', 'secretary@school.edu', true),
  ];

  @override
  Widget build(BuildContext context) {
    // خزّن ألوان الثيم داخل build method لتجنب مشاكل Provider
    final primaryColor = AppColor.primaryColor(context);
    final secondColor = AppColor.secondAppColor(context);
    final errorColor = AppColor.errorColor(context);
    final greyColor = AppColor.greyColor(context);

    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        context,
        title: Text(
          AppLocalKay.user_management_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildUserStats(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return _buildUserCard(_users[index], secondColor, errorColor, greyColor);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewUser,
        backgroundColor: primaryColor,
        child: Icon(Icons.person_add, color: AppColor.whiteColor(context)),
      ),
    );
  }

  Widget _buildUserStats() {
    final activeUsers = _users.where((user) => user.isActive).length;
    final teachers = _users.where((user) => user.role == 'معلم').length;
    final admins = _users.where((user) => user.role == 'مدير' || user.role == 'نائب المدير').length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.grey50Color(context),
        border: Border(bottom: BorderSide(color: AppColor.grey300Color(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            _users.length.toString(),
            AppLocalKay.users.tr(),
            AppColor.infoColor(context),
          ),
          _buildStatItem(
            activeUsers.toString(),
            AppLocalKay.active_users.tr(),
            AppColor.successColor(context),
          ),
          _buildStatItem(
            teachers.toString(),
            AppLocalKay.teachers.tr(),
            AppColor.warningColor(context),
          ),
          _buildStatItem(admins.toString(), 'إداريين', AppColor.purpleColor(context)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.titleSmall(context).copyWith(color: AppColor.greyColor(context)),
        ),
      ],
    );
  }

  Widget _buildUserCard(User user, Color secondColor, Color errorColor, Color greyColor) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(context, user.role),
          child: Text(
            user.name.split(' ').first[0],
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.whiteColor(context)),
          ),
        ),
        title: Text(
          user.name,
          style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.role),
            Text(user.email, style: AppTextStyle.bodyMedium(context).copyWith(color: greyColor)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              user.isActive ? Icons.check_circle : Icons.remove_circle,
              color: user.isActive ? secondColor : errorColor,
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) => _handleUserAction(value, user, errorColor),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(value: 'edit', child: Text(AppLocalKay.user_management_edit.tr())),
                PopupMenuItem(
                  value: 'toggle',
                  child: Text(user.isActive ? AppLocalKay.disable.tr() : AppLocalKay.enable.tr()),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(
                    AppLocalKay.user_management_delete.tr(),
                    style: TextStyle(color: errorColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(BuildContext context, String role) {
    switch (role) {
      case AppLocalKay.admin:
        return AppColor.errorColor(context);
      case AppLocalKay.vice_manager:
        return AppColor.warningColor(context);
      case AppLocalKay.teacher:
        return AppColor.infoColor(context);
      case AppLocalKay.secretary:
        return AppColor.purpleColor(context);
      default:
        return AppColor.greyColor(context);
    }
  }

  void _addNewUser() {
    // TODO: إضافة مستخدم جديد
  }

  void _handleUserAction(String action, User user, Color errorColor) {
    switch (action) {
      case 'edit':
        _editUser(user);
        break;
      case 'toggle':
        _toggleUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
    }
  }

  void _editUser(User user) {}

  void _toggleUser(User user) {
    setState(() {
      user.isActive = !user.isActive;
    });
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalKay.delete_user_title.tr(), style: AppTextStyle.titleMedium(context)),
          content: Text('${AppLocalKay.delete_user_message.tr()}${user.name}؟'),
          actions: [
            CustomButton(
              onPressed: () => Navigator.of(context).pop(),
              text: AppLocalKay.cancel.tr(),
            ),
            SizedBox(height: 16.w),
            CustomButton(
              color: AppColor.errorColor(context),
              onPressed: () {
                setState(() {
                  _users.remove(user);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف المستخدم بنجاح'),
                    backgroundColor: AppColor.secondAppColor(context),
                  ),
                );
              },
              text: AppLocalKay.delete.tr(),
            ),
          ],
        );
      },
    );
  }
}

class User {
  String name;
  String role;
  String email;
  bool isActive;

  User(this.name, this.role, this.email, this.isActive);
}
