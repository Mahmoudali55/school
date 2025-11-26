import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/layout/presentation/screen/widget/nav_Item_data_widget.dart';

class BottomNavBar extends StatelessWidget {
  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;

  const BottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: currentIndex,
          selectedItemColor: selectedColor,
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedFontSize: 11.sp,
          unselectedFontSize: 10.sp,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, height: 1.5),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, height: 1.5),
          elevation: 0,
          onTap: onTap,
          items: items.map((e) => _NavBarItem(item: e, selectedColor: selectedColor)).toList(),
        ),
      ),
    );
  }
}

class _NavBarItem extends BottomNavigationBarItem {
  _NavBarItem({required NavItemData item, required Color selectedColor})
    : super(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(item.icon, size: 24.w),
            ),
            if (item.showBadge)
              Positioned(
                right: -2.w,
                top: -2.w,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
        activeIcon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: selectedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(item.activeIcon, size: 24.w, color: selectedColor),
        ),
        label: item.label,
      );
}
