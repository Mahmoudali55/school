import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TeacherDigitalLibraryScreen extends StatefulWidget {
  const TeacherDigitalLibraryScreen({super.key});

  @override
  State<TeacherDigitalLibraryScreen> createState() => _TeacherDigitalLibraryScreenState();
}

class _TeacherDigitalLibraryScreenState extends State<TeacherDigitalLibraryScreen> {
  String _selectedCategory = "all";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.digital_library.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(child: _buildResourcesList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "ابحث عن كتب، فيديوهات، أو ملخصات...",
                  hintStyle: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                  border: InputBorder.none,
                  icon: Icon(Icons.search_rounded, color: AppColor.greyColor(context)),
                ),
              ),
            ),
          ),
          Gap(20.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip("all", "الكل", Icons.grid_view_rounded),
                _buildCategoryChip("books", "الكتب", Icons.book_rounded),
                _buildCategoryChip("videos", "الفيديوهات", Icons.play_circle_fill_rounded),
                _buildCategoryChip("files", "الملفات", Icons.description_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String id, String label, IconData icon) {
    bool isSelected = _selectedCategory == id;
    return FadeInRight(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = id),
        child: Container(
          margin: EdgeInsets.only(left: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18.w,
                color: isSelected ? Colors.white : AppColor.greyColor(context),
              ),
              Gap(8.w),
              Text(
                label,
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColor.blackColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourcesList() {
    return ListView(
      padding: EdgeInsets.all(20.w),
      children: [
        FadeInUp(
          duration: const Duration(milliseconds: 600),
          child: Text(
            "المصادر الحديثة",
            style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Gap(16.h),
        _buildResourceCard(
          "كتاب الرياضيات - المستوى الثالث",
          "PDF • 12.5 MB",
          Icons.picture_as_pdf_rounded,
          Colors.redAccent,
          200,
        ),
        _buildResourceCard(
          "شرح الوحدة الخامسة (فيديو)",
          "MP4 • 45:12",
          Icons.play_circle_outline_rounded,
          Colors.blueAccent,
          400,
        ),
        _buildResourceCard(
          "ملخص قوانين الفيزياء",
          "DOCX • 2.1 MB",
          Icons.article_rounded,
          Colors.indigoAccent,
          600,
        ),
        _buildResourceCard(
          "خطة الفصل الدراسي الثاني",
          "PDF • 1.2 MB",
          Icons.picture_as_pdf_rounded,
          Colors.redAccent,
          800,
        ),
      ],
    );
  }

  Widget _buildResourceCard(String title, String info, IconData icon, Color color, int delay) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      delay: Duration(milliseconds: delay),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                  Gap(4.h),
                  Text(
                    info,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.greyColor(context)),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
              color: AppColor.greyColor(context),
            ),
          ],
        ),
      ),
    );
  }
}
