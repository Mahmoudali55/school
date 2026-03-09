import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class UserManagementSCreen extends StatelessWidget {
  UserManagementSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة المستخدمين'), backgroundColor: Colors.blue),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
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
                  hintText: 'ابحث عن مستخدم...',
                  hintStyle: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),

            Gap(20.h),

            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelColor: AppColor.whiteColor(context),
                        unselectedLabelColor: Colors.grey[600],
                        tabs: const [
                          Tab(text: 'الطلاب'),
                          Tab(text: 'المعلمين'),
                        ],
                      ),
                    ),

                    Gap(16.h),

                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildUsersList(isStudents: true),

                          _buildUsersList(isStudents: false),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: Icon(Icons.person_add, color: AppColor.whiteColor(context)),
      ),
    );
  }

  Widget _buildUsersList({required bool isStudents}) {
    final users = isStudents ? _students : _teachers;

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: ListTile(
            leading: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(isStudents ? Icons.school : Icons.person, color: Colors.blue),
            ),
            title: Text(user['name'].toString()),
            subtitle: Text(user['details'].toString()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<Map<String, String>> _students = [
    {'name': 'أحمد محمد', 'details': 'الصف العاشر - القسم أ'},
    {'name': 'سارة عبدالله', 'details': 'الصف التاسع - القسم ب'},
    {'name': 'فاطمة خالد', 'details': 'الصف الحادي عشر - القسم أ'},
    {'name': 'محمد علي', 'details': 'الصف الثامن - القسم ج'},
  ];

  final List<Map<String, String>> _teachers = [
    {'name': 'أ. أحمد محمد', 'details': 'مدرس رياضيات'},
    {'name': 'أ. فاطمة علي', 'details': 'مدرسة لغة عربية'},
    {'name': 'أ. خالد إبراهيم', 'details': 'مدرس علوم'},
    {'name': 'أ. سارة عبدالله', 'details': 'مدرسة لغة إنجليزية'},
  ];
}

class TransportationManagementScreen extends StatelessWidget {
  TransportationManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة النقل'), backgroundColor: Colors.purple),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTransportStat(context, 'إجمالي الحافلات', '8', Colors.purple),
                ),
                Gap(12.w),
                Expanded(child: _buildTransportStat(context, 'نشطة', '7', Colors.green)),
                Gap(12.w),
                Expanded(child: _buildTransportStat(context, 'تحت الصيانة', '1', Colors.orange)),
              ],
            ),

            Gap(20.h),

            Expanded(
              child: ListView.builder(
                itemCount: _buses.length,
                itemBuilder: (context, index) {
                  final bus = _buses[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: ListTile(
                      leading: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.directions_bus, color: Colors.purple),
                      ),
                      title: Text(bus['number']!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('السائق: ${bus['driver']!}'),
                          Text('الطريق: ${bus['route']!}'),
                          Text('الطلاب: ${bus['students']!}'),
                        ],
                      ),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getBusStatusColor(bus['status']!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          bus['status']!,
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: AppColor.whiteColor(context)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.purple,
        child: Icon(Icons.directions_bus, color: AppColor.whiteColor(context)),
      ),
    );
  }

  Widget _buildTransportStat(BuildContext context, String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            Gap(4.h),
            Text(
              title,
              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBusStatusColor(String status) {
    switch (status) {
      case 'نشطة':
        return Colors.green;
      case 'تحت الصيانة':
        return Colors.orange;
      case 'متوقفة':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  final List<Map<String, String>> _buses = [
    {
      'number': 'BUS-001',
      'driver': 'علي محمد',
      'route': 'الطريق الرئيسي',
      'students': '25',
      'status': 'نشطة',
    },
    {
      'number': 'BUS-002',
      'driver': 'خالد أحمد',
      'route': 'طريق النهضة',
      'students': '30',
      'status': 'نشطة',
    },
    {
      'number': 'BUS-003',
      'driver': 'فهد سعيد',
      'route': 'طريق الجامعة',
      'students': '22',
      'status': 'تحت الصيانة',
    },
  ];
}
