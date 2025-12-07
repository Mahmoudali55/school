import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AssignmentCard extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final bool showActions;
  final Function(Map<String, dynamic>) onSubmit;
  final Function(Map<String, dynamic>) onViewDetails;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.showActions,
    required this.onSubmit,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.pending;

    switch (assignment['status']) {
      case AppLocalKay.status_pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case AppLocalKay.status_submitted:
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle;
        break;
      case AppLocalKay.status_graded:
        statusColor = Colors.green;
        statusIcon = Icons.grade;
        break;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(
          assignment['title'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('${assignment['subject']}'),
            SizedBox(height: 2.h),
            Text(
              assignment['dueDate'] ?? assignment['submittedDate'],
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
            if (assignment['grade'] != null) ...[
              SizedBox(height: 2.h),
              Text(
                'الدرجة: ${assignment['grade']}',
                style: TextStyle(fontSize: 12.sp, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
        trailing: showActions
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.upload), onPressed: () => onSubmit(assignment)),
                  IconButton(
                    icon: const Icon(Icons.info),
                    onPressed: () => onViewDetails(assignment),
                  ),
                ],
              )
            : null,
        onTap: () => onViewDetails(assignment),
      ),
    );
  }
}
