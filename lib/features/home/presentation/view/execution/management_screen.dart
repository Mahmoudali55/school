import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

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
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
              ),
            ),

            SizedBox(height: 20.h),

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

                    SizedBox(height: 16.h),

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
                Expanded(child: _buildTransportStat('إجمالي الحافلات', '8', Colors.purple)),
                SizedBox(width: 12.w),
                Expanded(child: _buildTransportStat('نشطة', '7', Colors.green)),
                SizedBox(width: 12.w),
                Expanded(child: _buildTransportStat('تحت الصيانة', '1', Colors.orange)),
              ],
            ),

            SizedBox(height: 20.h),

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
                          style: TextStyle(color: AppColor.whiteColor(context), fontSize: 12),
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

  Widget _buildTransportStat(String title, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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

// صفحة الإعدادات المالية
class FinancialSettingsScreen extends StatelessWidget {
  FinancialSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات المالية'), backgroundColor: Colors.pink),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Financial Overview
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFinancialItem('الإيرادات', '٥٨,٤٠٠ ر.س', Colors.green),
                        _buildFinancialItem('المصروفات', '٤٢,٣٠٠ ر.س', Colors.red),
                        _buildFinancialItem('صافي الربح', '١٦,١٠٠ ر.س', Colors.blue),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    LinearProgressIndicator(
                      value: 0.72,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Fees Management
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إدارة الرسوم',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _fees.length,
                      itemBuilder: (context, index) {
                        final fee = _fees[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            leading: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.payments, color: Colors.pink),
                            ),
                            title: Text(fee['type']!),
                            subtitle: Text('${fee['amount']!} ر.س'),
                            trailing: Text(
                              fee['status']!,
                              style: TextStyle(
                                color: _getFeeStatusColor(fee['status']!),
                                fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        SizedBox(height: 4.h),
        Text(
          amount,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Color _getFeeStatusColor(String status) {
    switch (status) {
      case 'مدفوعة':
        return Colors.green;
      case 'متأخرة':
        return Colors.red;
      case 'معلقة':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  final List<Map<String, String>> _fees = [
    {'type': 'رسوم التسجيل', 'amount': '٢,٠٠٠', 'status': 'مدفوعة'},
    {'type': 'رسوم الفصل الأول', 'amount': '٣,٠٠٠', 'status': 'مدفوعة'},
    {'type': 'رسوم الفصل الثاني', 'amount': '٣,٠٠٠', 'status': 'متأخرة'},
    {'type': 'رسوم الأنشطة', 'amount': '٥٠٠', 'status': 'معلقة'},
  ];
}

// صفحة الإعدادات العامة
class GeneralSettingsScreen extends StatelessWidget {
  GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات العامة'), backgroundColor: Colors.grey),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            _buildSettingsSection('إعدادات النظام', _systemSettings),
            SizedBox(height: 20.h),
            _buildSettingsSection('إعدادات المدرسة', _schoolSettings),
            SizedBox(height: 20.h),
            _buildSettingsSection('إعدادات التواصل', _communicationSettings),
            SizedBox(height: 20.h),
            _buildSettingsSection('الأمان والخصوصية', _securitySettings),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Map<String, dynamic>> settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Card(
          child: Column(
            children: settings
                .map(
                  (setting) => ListTile(
                    leading: Icon(setting['icon'], color: Colors.grey),
                    title: Text(setting['title']!),
                    subtitle: setting['subtitle'] != null ? Text(setting['subtitle']!) : null,
                    trailing: setting['isToggle'] == true
                        ? Switch(
                            value: setting['value'] as bool,
                            onChanged: (value) {
                              // TODO: تغيير الإعداد
                            },
                          )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: فتح الإعداد المحدد
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _systemSettings = [
    {'title': 'اللغة', 'subtitle': 'العربية', 'icon': Icons.language, 'isToggle': false},
    {
      'title': 'الإشعارات',
      'subtitle': 'مفعل',
      'icon': Icons.notifications,
      'isToggle': true,
      'value': true,
    },
    {'title': 'المظهر', 'subtitle': 'فاتح', 'icon': Icons.palette, 'isToggle': false},
  ];

  final List<Map<String, dynamic>> _schoolSettings = [
    {'title': 'معلومات المدرسة', 'subtitle': null, 'icon': Icons.school, 'isToggle': false},
    {'title': 'العطل الرسمية', 'subtitle': null, 'icon': Icons.calendar_today, 'isToggle': false},
    {'title': 'الفصول الدراسية', 'subtitle': null, 'icon': Icons.class_, 'isToggle': false},
  ];

  final List<Map<String, dynamic>> _communicationSettings = [
    {
      'title': 'إشعارات البريد الإلكتروني',
      'subtitle': 'مفعل',
      'icon': Icons.email,
      'isToggle': true,
      'value': true,
    },
    {
      'title': 'إشعارات SMS',
      'subtitle': 'معطل',
      'icon': Icons.sms,
      'isToggle': true,
      'value': false,
    },
    {
      'title': 'إشعارات التطبيق',
      'subtitle': 'مفعل',
      'icon': Icons.notifications_active,
      'isToggle': true,
      'value': true,
    },
  ];

  final List<Map<String, dynamic>> _securitySettings = [
    {
      'title': 'كلمة المرور',
      'subtitle': 'تغيير كلمة المرور',
      'icon': Icons.lock,
      'isToggle': false,
    },
    {
      'title': 'المصادقة الثنائية',
      'subtitle': 'معطل',
      'icon': Icons.security,
      'isToggle': true,
      'value': false,
    },
    {'title': 'جلسات التسجيل', 'subtitle': null, 'icon': Icons.computer, 'isToggle': false},
  ];
}
