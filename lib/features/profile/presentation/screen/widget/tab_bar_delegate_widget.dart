import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;

  TabBarDelegate(this.tabController);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.center, // Center the TabBar vertically
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: AppColor.primaryColor(context),
        unselectedLabelColor: Colors.grey,
        indicatorColor: AppColor.primaryColor(context),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: AppTextStyle.bodyMedium(
          context,
        ).copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp),
        labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
        tabs: const [
          Tab(text: "الشخصية", icon: Icon(Icons.person)),
          Tab(text: "الأكاديمية", icon: Icon(Icons.school)),
          Tab(text: "ولي الأمر", icon: Icon(Icons.family_restroom)),
          Tab(text: "أخرى", icon: Icon(Icons.info)),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 70.h;

  @override
  double get minExtent => 70.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
