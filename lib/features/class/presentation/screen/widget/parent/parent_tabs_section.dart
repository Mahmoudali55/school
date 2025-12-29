import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ParentTabsSection extends StatelessWidget {
  const ParentTabsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              labelColor: AppColor.whiteColor(context),
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
              tabs: [
                Tab(text: AppLocalKay.scheduls.tr()),
                Tab(text: AppLocalKay.grades.tr()),
                Tab(text: AppLocalKay.checkin.tr()),
                Tab(text: AppLocalKay.todostitle.tr()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                Center(child: Text('📆 شاشة الجدول'.tr())),
                Center(child: Text('📊 شاشة الدرجات'.tr())),
                Center(child: Text('📁 شاشة الحضور'.tr())),
                Center(child: Text('📝 شاشة الواجبات'.tr())),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
