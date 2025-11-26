import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

class AssignmentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> assignment;

  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(assignment['title']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  assignment['title'],
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text('المادة: ${assignment['subject']}'),
            Text('تاريخ التسليم: ${assignment['dueDate'] ?? assignment['submittedDate']}'),
            if (assignment['grade'] != null) Text('الدرجة: ${assignment['grade']}'),
            SizedBox(height: 16.h),
            if (assignment['status'] == 'معلق')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: const Text('تسليم الواجب')),
              ),
          ],
        ),
      ),
    );
  }
}
