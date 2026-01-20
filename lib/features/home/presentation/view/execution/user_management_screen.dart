import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

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
          AppLocalKay.user_management_title.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Search and Filter Section
            _buildSearchSection(context),
            SizedBox(height: 20.h),
            // Users List
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => _buildUserCard(context, index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new user
        },
        child: Icon(Icons.person_add, size: 24.w),
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    return Column(
      children: [
        CustomFormField(
          radius: 12,
          controller: TextEditingController(),
          hintText: AppLocalKay.user_management_search_hint.tr(),
          prefixIcon: Icon(Icons.search),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: AppLocalKay.user_management_type_label.tr(),
                items: [
                  AppLocalKay.user_management_type_all.tr(),
                  AppLocalKay.user_management_type_teacher.tr(),
                  AppLocalKay.user_management_type_student.tr(),
                  AppLocalKay.user_management_type_admin.tr(),
                ],
                itemLabel: (item) => item,
                onChanged: (value) {
                  // cubit.changeUserType(value);
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppDropdown<String>(
                label: AppLocalKay.user_management_status_label.tr(),
                items: [
                  AppLocalKay.user_management_status_all.tr(),
                  AppLocalKay.user_management_status_active.tr(),
                  AppLocalKay.user_management_status_inactive.tr(),
                ],
                itemLabel: (item) => item,
                onChanged: (value) {
                  // cubit.changeStatus(value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserCard(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.blue.shade100,
          child: Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          'اسم المستخدم $index',
          style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('user$index@school.com', style: AppTextStyle.bodySmall(context)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue, size: 20.w),
              onPressed: () {
                // Edit user
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 20.w),
              onPressed: () {
                // Delete user
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true, // ⭐ مهم جدًا
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: SizedBox(
                width: double.infinity,
                child: Text(itemLabel(item), maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
