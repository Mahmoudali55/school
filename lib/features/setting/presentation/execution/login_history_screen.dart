// lib/features/settings/presentation/screens/login_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginHistoryScreen extends StatelessWidget {
  final List<LoginRecord> _loginHistory = [
    LoginRecord(
      'جهاز iPhone 13',
      '192.168.1.100',
      'الرياض، السعودية',
      DateTime.now().subtract(Duration(hours: 2)),
      true,
    ),
    LoginRecord(
      'جهاز كمبيوتر',
      '192.168.1.101',
      'الرياض، السعودية',
      DateTime.now().subtract(Duration(days: 1)),
      true,
    ),
    LoginRecord(
      'جهاز Android',
      '192.168.1.102',
      'جدة، السعودية',
      DateTime.now().subtract(Duration(days: 3)),
      false,
    ),
    LoginRecord(
      'جهاز iPad',
      '192.168.1.103',
      'الدمام، السعودية',
      DateTime.now().subtract(Duration(days: 7)),
      true,
    ),
  ];

  LoginHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سجل الدخول',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // إحصائيات
          _buildStats(),

          // قائمة سجل الدخول
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _loginHistory.length,
              itemBuilder: (context, index) {
                return _buildLoginRecord(_loginHistory[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final successfulLogins = _loginHistory.where((record) => record.successful).length;
    final failedLogins = _loginHistory.length - successfulLogins;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(_loginHistory.length.toString(), 'محاولات الدخول', Colors.blue),
          _buildStatItem(successfulLogins.toString(), 'ناجحة', Colors.green),
          _buildStatItem(failedLogins.toString(), 'فاشلة', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildLoginRecord(LoginRecord record) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Icon(
          record.successful ? Icons.check_circle : Icons.error,
          color: record.successful ? Colors.green : Colors.red,
        ),
        title: Text(
          record.device,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('IP: ${record.ipAddress}'),
            Text(record.location),
            Text(
              _formatDate(record.timestamp),
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
        trailing: record.successful
            ? null
            : Text(
                'فاشل',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

class LoginRecord {
  final String device;
  final String ipAddress;
  final String location;
  final DateTime timestamp;
  final bool successful;

  LoginRecord(this.device, this.ipAddress, this.location, this.timestamp, this.successful);
}
