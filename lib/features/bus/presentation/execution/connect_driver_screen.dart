import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class ConnectDriverScreen extends StatelessWidget {
  const ConnectDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.ConnectDriver.tr(),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('أحمد محمد'),
          subtitle: Text('رقم الهاتف: 0501234567'),
          trailing: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.phone),
            label: Text(AppLocalKay.Connect.tr()),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF9800)),
          ),
        ),
      ),
    );
  }
}
