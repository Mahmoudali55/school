import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          'الفصول الدراسية',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),

        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث عن فصل...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'فصولك الدراسية',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
            ),

            const SizedBox(height: 16),

            // Classes List
            Expanded(
              child: ListView(
                children: [
                  _buildClassCard(
                    className: 'الرياضيات',
                    teacherName: 'أ. أحمد محمد',
                    room: 'القاعة ١٠١',
                    time: '٨:٠٠ ص - ٩:٣٠ ص',
                    color: Colors.blue,
                    icon: Icons.calculate,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'اللغة العربية',
                    teacherName: 'أ. فاطمة علي',
                    room: 'القاعة ٢٠٣',
                    time: '١٠:٠٠ ص - ١١:٣٠ ص',
                    color: Colors.green,
                    icon: Icons.menu_book,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'العلوم',
                    teacherName: 'أ. خالد إبراهيم',
                    room: 'المعمل ٣٠١',
                    time: '١٢:٠٠ م - ١:٣٠ م',
                    color: Colors.orange,
                    icon: Icons.science,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'اللغة الإنجليزية',
                    teacherName: 'أ. سارة عبدالله',
                    room: 'القاعة ١٠٥',
                    time: '٢:٠٠ م - ٣:٣٠ م',
                    color: Colors.purple,
                    icon: Icons.language,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'التاريخ',
                    teacherName: 'أ. محمد حسن',
                    room: 'القاعة ٢٠١',
                    time: '٤:٠٠ م - ٥:٣٠ م',
                    color: Colors.brown,
                    icon: Icons.history,
                    context: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required String className,
    required String teacherName,
    required String room,
    required String time,
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),

            const SizedBox(width: 16),

            // Class Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    className,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(teacherName, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.room, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(room, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(time, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            // Enter Class Button
            Container(
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                onPressed: () {
                  // TODO: Add navigation to class details
                },
                icon: Icon(Icons.arrow_forward, color: AppColor.whiteColor(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
