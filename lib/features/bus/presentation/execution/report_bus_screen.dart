import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/execution/widget/base_page_widget.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePageWidget(
      title: AppLocalKay.reportS.tr(),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Card(
          color: Colors.white.withOpacity(0.9),
          child: ListTile(
            leading: Icon(Icons.assessment, color: Color(0xFFFF9800)),
            title: Text('تقرير ${index + 1}'),
            subtitle: Text('تاريخ: 10/12/2025'),
            trailing: IconButton(icon: Icon(Icons.download), onPressed: () {}),
          ),
        ),
      ),
    );
  }
}
