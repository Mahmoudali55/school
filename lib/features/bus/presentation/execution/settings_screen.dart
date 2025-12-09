import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalKay.settings.tr())),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('إشعارات'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(leading: Icon(Icons.language), title: Text('اللغة'), trailing: Text('العربية')),
          ListTile(leading: Icon(Icons.logout), title: Text('تسجيل الخروج'), onTap: () {}),
        ],
      ),
    );
  }
}
