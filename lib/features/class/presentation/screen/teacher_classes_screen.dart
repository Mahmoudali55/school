import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          'فصولي الدراسية',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),

        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTeacherInfoCard(),

            const SizedBox(height: 20),

            _buildQuickStats(),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الفصول المدرسية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.green),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Classes List
            Expanded(
              child: ListView(
                children: [
                  _buildClassCard(
                    className: 'الصف العاشر - الرياضيات',
                    studentCount: 32,
                    schedule: 'السبت، الإثنين، الأربعاء',
                    time: '٨:٠٠ ص - ٩:٣٠ ص',
                    room: 'القاعة ١٠١',
                    progress: 0.75,
                    assignments: 3,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'الصف التاسع - الرياضيات',
                    studentCount: 28,
                    schedule: 'الأحد، الثلاثاء، الخميس',
                    time: '١٠:٠٠ ص - ١١:٣٠ ص',
                    room: 'القاعة ٢٠٣',
                    progress: 0.60,
                    assignments: 2,
                    context: context,
                  ),

                  _buildClassCard(
                    className: 'الصف الحادي عشر - الرياضيات',
                    studentCount: 25,
                    schedule: 'السبت، الإثنين، الأربعاء',
                    time: '١٢:٠٠ م - ١:٣٠ م',
                    room: 'القاعة ٣٠١',
                    progress: 0.85,
                    assignments: 4,
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

  Widget _buildTeacherInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Teacher Avatar
            const SizedBox(width: 16),

            // Teacher Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'أ. أحمد محمد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text('مدرس الرياضيات', style: TextStyle(color: Colors.green[700], fontSize: 14)),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.email, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'ahmed@school.edu',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Edit Profile Button
            IconButton(
              onPressed: () {
                // TODO: تعديل الملف الشخصي
              },
              icon: Icon(Icons.edit, color: Colors.green[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'إجمالي الطلاب',
            value: '85',
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildStatCard(
            title: 'الواجبات',
            value: '9',
            icon: Icons.assignment,
            color: Colors.orange,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _buildStatCard(
            title: 'الحضور اليوم',
            value: '92%',
            icon: Icons.check,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required String className,
    required int studentCount,
    required String schedule,
    required String time,
    required String room,
    required double progress,
    required int assignments,
    required BuildContext context,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Class Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  className,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$studentCount طالب',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Class Details
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(schedule, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.room, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(room, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),

            const SizedBox(height: 12),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('تقدم المنهج', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    text: 'الطلاب',
                    icon: Icons.people,
                    onPressed: () {
                      // TODO: عرض قائمة الطلاب
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _buildActionButton(
                    text: 'الواجبات ',
                    icon: Icons.assignment,
                    onPressed: () {
                      // TODO: عرض الواجبات
                    },
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _buildActionButton(
                    text: 'الحضور',
                    icon: Icons.class_,
                    onPressed: () {
                      // TODO: تسجيل الحضور
                    },
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green,
        side: BorderSide(color: Colors.green!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
