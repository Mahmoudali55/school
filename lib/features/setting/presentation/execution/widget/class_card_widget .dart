import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/setting/presentation/execution/class_management_screen.dart';

class ClassCardWidget extends StatelessWidget {
  final SchoolClass schoolClass;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClassCardWidget({
    super.key,
    required this.schoolClass,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColor.primaryColor(context).withOpacity(0.1),
          child: Icon(Icons.class_, color: AppColor.primaryColor(context)),
        ),
        title: Text(
          '${schoolClass.grade} - ${schoolClass.section}',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المعلم: ${schoolClass.teacher}'),
            Text('عدد الطلاب: ${schoolClass.studentCount}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
            IconButton(
              icon: Icon(Icons.delete, color: AppColor.errorColor(context)),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
