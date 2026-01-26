import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_shimmer.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key, this.height = 100});
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomShimmer(width: 60.w, height: 60.w, radius: 8),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomShimmer(width: 120.w, height: 14.h, radius: 4),
                SizedBox(height: 8.h),
                CustomShimmer(width: 180.w, height: 12.h, radius: 4),
                SizedBox(height: 8.h),
                CustomShimmer(width: 80.w, height: 10.h, radius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CustomShimmer(width: 50.w, height: 50.w, radius: 25), // Circle profile
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmer(width: 100.w, height: 16.h, radius: 4),
              SizedBox(height: 6.h),
              CustomShimmer(width: 140.w, height: 12.h, radius: 4),
            ],
          ),
          const Spacer(),
          CustomShimmer(width: 30.w, height: 30.w, radius: 15), // Notification icon
        ],
      ),
    );
  }
}

class GridShimmer extends StatelessWidget {
  const GridShimmer({super.key, this.itemCount = 4});
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomShimmer(width: 40.w, height: 40.w, radius: 10),
              SizedBox(height: 12.h),
              CustomShimmer(width: 80.w, height: 14.h, radius: 4),
            ],
          ),
        );
      },
    );
  }
}

class BusTrackingShimmer extends StatelessWidget {
  const BusTrackingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Map/Tracking Card Placeholder
          Container(
            height: 250.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const CustomShimmer(height: 250, radius: 20),
          ),
          SizedBox(height: 20.h),
          // Info Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(child: CustomShimmer(height: 80.h, radius: 12)),
                SizedBox(width: 12.w),
                Expanded(child: CustomShimmer(height: 80.h, radius: 12)),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // List of stops
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, __) => const CardShimmer(height: 70),
          ),
        ],
      ),
    );
  }
}

class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  const ListShimmer({super.key, this.itemCount = 5, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, __) => CardShimmer(height: itemHeight),
    );
  }
}
