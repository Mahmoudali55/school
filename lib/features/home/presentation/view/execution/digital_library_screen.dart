import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_digital_library_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/execution/library_item_detail_screen.dart';

class DigitalLibraryScreen extends StatefulWidget {
  const DigitalLibraryScreen({super.key});

  @override
  State<DigitalLibraryScreen> createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends State<DigitalLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['الكل', 'الكتب', 'الفيديوهات', 'المذكرات'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _selectedCategoryIndex = _tabController.index);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final levelCodeStr = HiveMethods.getUserLevelCode().toString();
      final levelCode = int.tryParse(levelCodeStr) ?? 0;
      if (levelCode > 0) {
        context.read<HomeCubit>().getDigitalLibrary(levelCode: levelCode);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final allItems = state.getDigitalLibraryStatus.data ?? [];

          return Column(
            children: [
              // ── Modern Gradient Header ──
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    MediaQuery.of(context).padding.top + 10.h,
                    20.w,
                    10.h,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4F46E5),
                        Color(0xFF6366F1),
                      ], // Indigo gradient for students
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            padding: EdgeInsets.zero,
                          ),
                          Gap(8.w),
                          Text(
                            AppLocalKay.digital_library.tr(),
                            style: AppTextStyle.titleLarge(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 24.w,
                          ),
                        ],
                      ),
                      Gap(15.h),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن كتب، مذكرات، أو فيديوهات...',
                            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.sp),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: Colors.grey.shade400,
                              size: 22.w,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear_rounded, size: 20),
                                    color: Colors.grey.shade400,
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                      Gap(15.h),
                      // Custom Tabs Implementation
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white.withOpacity(0.6),
                        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Files List ──
              Expanded(
                child: state.getDigitalLibraryStatus.isLoading
                    ? Center(
                        child: CustomLoading(color: const Color(0xFF4F46E5), size: 40.w),
                      )
                    : _buildFilesList(allItems),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilesList(List<DigitalLibraryItem> allItems) {
    // 1. Filter by Search
    var filteredItems = allItems.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.fileName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.notes.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.teacherName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // 2. Filter by Category
    if (_selectedCategoryIndex > 0) {
      final category = _categories[_selectedCategoryIndex];
      filteredItems = filteredItems.where((item) {
        final ext = item.fileExtension.toLowerCase();
        if (category == 'الكتب') return ['pdf'].contains(ext);
        if (category == 'الفيديوهات') return ['mp4', 'avi', 'mov'].contains(ext);
        if (category == 'المذكرات') return ['doc', 'docx', 'ppt', 'pptx'].contains(ext);
        return true;
      }).toList();
    }

    if (filteredItems.isEmpty) {
      return FadeInUp(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off_rounded, size: 70.w, color: Colors.grey.shade200),
              Gap(16.h),
              Text(
                _searchQuery.isNotEmpty ? 'لا توجد نتائج للبحث' : 'لا توجد ملفات حالياً',
                style: AppTextStyle.titleMedium(context).copyWith(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 20.h),
      itemCount: filteredItems.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildResourceCard(filteredItems[index], index);
      },
    );
  }

  Widget _buildResourceCard(DigitalLibraryItem item, int index) {
    final ext = item.fileExtension.toLowerCase();
    IconData icon;
    Color iconColor;
    Color cardAccent;

    if (['pdf'].contains(ext)) {
      icon = Icons.picture_as_pdf_rounded;
      iconColor = const Color(0xFFEF4444);
      cardAccent = const Color(0xFFEF4444);
    } else if (['mp4', 'avi', 'mov'].contains(ext)) {
      icon = Icons.play_circle_fill_rounded;
      iconColor = const Color(0xFF3B82F6);
      cardAccent = const Color(0xFF3B82F6);
    } else if (['doc', 'docx'].contains(ext)) {
      icon = Icons.article_rounded;
      iconColor = const Color(0xFF6366F1);
      cardAccent = const Color(0xFF6366F1);
    } else if (['ppt', 'pptx'].contains(ext)) {
      icon = Icons.slideshow_rounded;
      iconColor = const Color(0xFFF97316);
      cardAccent = const Color(0xFFF97316);
    } else {
      icon = Icons.insert_drive_file_rounded;
      iconColor = const Color(0xFF10B981);
      cardAccent = const Color(0xFF10B981);
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      delay: Duration(milliseconds: index * 50),
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: cardAccent.withOpacity(0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            final homeCubit = context.read<HomeCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: homeCubit,
                  child: LibraryItemDetailScreen(item: item),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18.r),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 5.w, color: cardAccent),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Row(
                        children: [
                          Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Center(
                              child: Icon(icon, color: iconColor, size: 26.w),
                            ),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.fileName,
                                  style: AppTextStyle.bodyLarge(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Gap(3.h),
                                Text(
                                  item.teacherName.isNotEmpty ? item.teacherName : 'المدرسة',
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(color: Colors.grey.shade500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item.notes.isNotEmpty) ...[
                                  Gap(3.h),
                                  Text(
                                    item.notes,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: Colors.grey.shade400),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (ext.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: cardAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                ext.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cardAccent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
