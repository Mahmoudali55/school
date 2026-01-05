import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController tabController;
  const ProfileTabBar({super.key, required this.tabController});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withAlpha((0.05 * 255).round()),
            blurRadius: 10,
          ),
        ],
      ),
      child: TabBar(
        controller: tabController,
        indicatorColor: AppColor.primaryColor(context),
        labelColor: AppColor.primaryColor(context),
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
        tabs: [
          Tab(text: AppLocalKay.info.tr()),
          Tab(text: AppLocalKay.activities.tr()),
          Tab(text: AppLocalKay.achievements.tr()),
        ],
      ),
    );
  }
}
