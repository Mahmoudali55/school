import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController tabController;
  const ProfileTabBar({super.key, required this.tabController});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: AppColor.primaryColor(context),
        labelColor: AppColor.primaryColor(context),
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(text: "المعلومات"),
          Tab(text: "النشاطات"),
          Tab(text: "الإنجازات"),
        ],
      ),
    );
  }
}
