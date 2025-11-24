import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

class LibraryItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const LibraryItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(context, title: Text(item['title'])),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: item['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item['icon'], size: 80.w, color: item['color']),
            ),
            SizedBox(height: 16.h),
            Text(
              item['title'],
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text('النوع: ${item['type']}'),
            Text('المادة: ${item['subject']}'),
            Text('الحجم: ${item['size']}'),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () {}, child: const Text('تحميل')),
            ),
          ],
        ),
      ),
    );
  }
}
