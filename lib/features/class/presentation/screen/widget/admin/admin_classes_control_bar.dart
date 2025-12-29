import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AdminClassesControlBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedFilter;
  final Function(String) onSearchChanged;
  final Function(String) onFilterSelected;

  const AdminClassesControlBar({
    super.key,
    required this.searchController,
    required this.selectedFilter,
    required this.onSearchChanged,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.grey[50],
      child: Column(
        children: [
          // شريط البحث
          CustomFormField(
            radius: 12.r,
            controller: searchController,
            hintText: context.locale.languageCode == 'ar'
                ? 'ابحث عن فصل...'
                : 'Search for a class...',
            prefixIcon: const Icon(Icons.search),
            onChanged: onSearchChanged,
          ),
          SizedBox(height: 12.h),

          // أزرار التصفية
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(context, AppLocalKay.all.tr(), AppLocalKay.all.tr()),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'الصف الأول', 'الأول'),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'الصف الثاني', 'الثاني'),
                SizedBox(width: 8.w),
                _buildFilterChip(context, 'الصف الثالث', 'الثالث'),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  context,
                  AppLocalKay.filter_full.tr(),
                  AppLocalKay.filter_full.tr(),
                ),
                SizedBox(width: 8.w),
                _buildFilterChip(
                  context,
                  AppLocalKay.filter_available.tr(),
                  AppLocalKay.filter_available.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value) {
    bool isSelected = selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        onFilterSelected(selected ? value : AppLocalKay.all.tr());
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: const Color(0xFF9C27B0).withOpacity(0.1),
      checkmarkColor: const Color(0xFF9C27B0),
      labelStyle: AppTextStyle.bodyMedium(
        context,
      ).copyWith(color: isSelected ? const Color(0xFF9C27B0) : Colors.grey[700]),
    );
  }
}
