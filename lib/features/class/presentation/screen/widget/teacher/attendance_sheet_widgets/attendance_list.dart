import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'attendance_item.dart';

class AttendanceList extends StatelessWidget {
  final List list;
  final Function(dynamic item) onEdit;
  final Function(dynamic item) onDelete;

  const AttendanceList({
    super.key,
    required this.list,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(24.r),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return AttendanceItem(
          index: index,
          item: item,
          onEdit: () => onEdit(item),
          onDelete: () => onDelete(item),
        );
      },
    );
  }
}
