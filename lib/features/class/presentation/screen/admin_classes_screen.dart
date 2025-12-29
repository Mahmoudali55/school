import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/execution/add_edit_class_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_details_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_students_screen.dart';

import '../../data/model/school_class_model.dart';

class AdminClassesScreen extends StatefulWidget {
  const AdminClassesScreen({super.key});

  @override
  State<AdminClassesScreen> createState() => _AdminClassesScreenState();
}

class _AdminClassesScreenState extends State<AdminClassesScreen> {
  final List<SchoolClass> _classes = [
    SchoolClass(
      id: '1',
      name: 'الصف الأول - أ',
      grade: 'الأول',
      section: 'أ',
      capacity: 30,
      currentStudents: 25,
      teacher: 'أحمد محمد',
      room: '101',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
    SchoolClass(
      id: '2',
      name: 'الصف الأول - ب',
      grade: 'الأول',
      section: 'ب',
      capacity: 30,
      currentStudents: 28,
      teacher: 'فاطمة علي',
      room: '102',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
    SchoolClass(
      id: '3',
      name: 'الصف الثاني - أ',
      grade: 'الثاني',
      section: 'أ',
      capacity: 30,
      currentStudents: 22,
      teacher: 'خالد إبراهيم',
      room: '201',
      schedule: 'من الأحد إلى الخميس - 8:30 صباحاً',
    ),
    SchoolClass(
      id: '4',
      name: 'الصف الثاني - ب',
      grade: 'الثاني',
      section: 'ب',
      capacity: 30,
      currentStudents: 30,
      teacher: 'سارة عبدالله',
      room: '202',
      schedule: 'من الأحد إلى الخميس - 8:30 صباحاً',
    ),
    SchoolClass(
      id: '5',
      name: 'الصف الثالث - أ',
      grade: 'الثالث',
      section: 'أ',
      capacity: 30,
      currentStudents: 24,
      teacher: 'محمد حسن',
      room: '301',
      schedule: 'من الأحد إلى الخميس - 9:30 صباحاً',
    ),
  ];

  List<SchoolClass> _filteredClasses = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = AppLocalKay.filter_all.tr();

  @override
  void initState() {
    super.initState();
    _filteredClasses = _classes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              AppLocalKay.admin_classes_title.tr(),
              style: AppTextStyle.titleMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            // شريط البحث والتصفية
            _buildSearchAndFilter(),

            // إحصائيات سريعة
            _buildClassStats(),

            // قائمة الفصول
            Expanded(
              child: _filteredClasses.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _filteredClasses.length,
                      itemBuilder: (context, index) {
                        return _buildClassCard(_filteredClasses[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewClass,
        backgroundColor: Color(0xFF9C27B0),
        child: Icon(Icons.add, color: AppColor.whiteColor(context)),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.grey[50],
      child: Column(
        children: [
          // شريط البحث
          CustomFormField(
            radius: 12.r,
            controller: _searchController,
            hintText: context.locale.languageCode == 'ar'
                ? 'ابحث عن فصل...'
                : 'Search for a class...',
            prefixIcon: Icon(Icons.search),
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 12.h),

          // أزرار التصفية
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(AppLocalKay.all.tr(), AppLocalKay.all.tr()),
                SizedBox(width: 8.w),
                _buildFilterChip('الصف الأول', 'الأول'),
                SizedBox(width: 8.w),
                _buildFilterChip('الصف الثاني', 'الثاني'),
                SizedBox(width: 8.w),
                _buildFilterChip('الصف الثالث', 'الثالث'),
                SizedBox(width: 8.w),
                _buildFilterChip(AppLocalKay.filter_full.tr(), AppLocalKay.filter_full.tr()),
                SizedBox(width: 8.w),
                _buildFilterChip(
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

  Widget _buildFilterChip(String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: _selectedFilter == value,
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? value : 'الكل';
          _applyFilters();
        });
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: const Color(0xFF9C27B0).withOpacity(0.1),
      checkmarkColor: const Color(0xFF9C27B0),
      labelStyle: AppTextStyle.bodyMedium(
        context,
      ).copyWith(color: _selectedFilter == value ? const Color(0xFF9C27B0) : Colors.grey[700]),
    );
  }

  Widget _buildClassStats() {
    final totalStudents = _classes.fold(0, (sum, classItem) => sum + classItem.currentStudents);
    final totalCapacity = _classes.fold(0, (sum, classItem) => sum + classItem.capacity);
    final fullClasses = _classes
        .where((classItem) => classItem.currentStudents >= classItem.capacity)
        .length;
    final availableClasses = _classes
        .where((classItem) => classItem.currentStudents < classItem.capacity)
        .length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(_classes.length.toString(), AppLocalKay.classes.tr(), Colors.blue),
          _buildStatItem(totalStudents.toString(), AppLocalKay.students.tr(), Colors.green),
          _buildStatItem(
            '${((totalStudents / totalCapacity) * 100).toStringAsFixed(1)}%',
            AppLocalKay.stats_fill_rate.tr(),
            Colors.orange,
          ),
          _buildStatItem(
            '$availableClasses/$fullClasses',
            AppLocalKay.stats_available_full.tr(),
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildClassCard(SchoolClass schoolClass) {
    double fillPercentage = (schoolClass.currentStudents / schoolClass.capacity) * 100;
    Color statusColor = fillPercentage >= 90
        ? Colors.red
        : fillPercentage >= 70
        ? Colors.orange
        : Colors.green;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    schoolClass.name,
                    style: AppTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    fillPercentage >= 90
                        ? AppLocalKay.filter_full.tr()
                        : fillPercentage >= 70
                        ? AppLocalKay.class_status_almost_full.tr()
                        : AppLocalKay.filter_available.tr(),
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontSize: 10.sp, color: statusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // معلومات الفصل
            Row(
              children: [
                Icon(Icons.person, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  '${AppLocalKay.teacher.tr()}: ${schoolClass.teacher}',
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            Row(
              children: [
                Icon(Icons.room, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  '${AppLocalKay.label_room.tr()}: ${schoolClass.room}',
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8.h),

            Row(
              children: [
                Icon(Icons.schedule, size: 16.w, color: Colors.grey),
                SizedBox(width: 8.w),
                Text(
                  schoolClass.schedule,
                  style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // شريط التقدم
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalKay.label_capacity.tr(),
                      style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                    ),
                    Text(
                      '${schoolClass.currentStudents}/${schoolClass.capacity} طالب',
                      style: AppTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: schoolClass.currentStudents / schoolClass.capacity,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 8.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // أزرار الإجراءات
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _viewClassDetails(schoolClass),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16.w,
                              color: AppColor.primaryColor(context),
                            ),
                            SizedBox(height: 4.h),
                            Text(AppLocalKay.btn_view.tr(), style: AppTextStyle.bodySmall(context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _editClass(schoolClass),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, size: 16.w, color: AppColor.accentColor(context)),
                            SizedBox(height: 4.h),
                            Text(
                              AppLocalKay.user_management_edit.tr(),
                              style: AppTextStyle.bodySmall(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _manageStudents(schoolClass),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.people, size: 16.w, color: AppColor.secondAppColor(context)),
                            SizedBox(height: 4.h),
                            Text(
                              AppLocalKay.btn_manage_students.tr(),
                              style: AppTextStyle.bodySmall(context).copyWith(fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.class_, size: 80.w, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            context.locale.languageCode == 'ar' ? 'لا توجد فصول' : 'No classes found',
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
          ),
          SizedBox(height: 8.h),
          Text(
            _searchController.text.isEmpty
                ? AppLocalKay.empty_subtitle_no_classes.tr()
                : AppLocalKay.empty_subtitle_no_search.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey.shade400),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: _addNewClass,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF9C27B0),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              AppLocalKay.btn_add_class.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(color: AppColor.whiteColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    _applyFilters();
  }

  void _applyFilters() {
    List<SchoolClass> filtered = _classes;

    // تطبيق البحث
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((classItem) {
        return classItem.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            classItem.teacher.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            classItem.room.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    }

    // تطبيق التصفية
    if (_selectedFilter != AppLocalKay.all.tr()) {
      if (_selectedFilter == AppLocalKay.filter_full.tr()) {
        filtered = filtered
            .where((classItem) => classItem.currentStudents >= classItem.capacity)
            .toList();
      } else if (_selectedFilter == AppLocalKay.filter_available.tr()) {
        filtered = filtered
            .where((classItem) => classItem.currentStudents < classItem.capacity)
            .toList();
      } else {
        filtered = filtered.where((classItem) => classItem.grade == _selectedFilter).toList();
      }
    }

    setState(() {
      _filteredClasses = filtered;
    });
  }

  void _addNewClass() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddEditClassScreen())).then((
      value,
    ) {
      if (value != null) {
        setState(() {
          _classes.add(value as SchoolClass);
          _applyFilters();
        });
      }
    });
  }

  void _viewClassDetails(SchoolClass schoolClass) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassDetailsScreen(schoolClass: schoolClass)),
    );
  }

  void _editClass(SchoolClass schoolClass) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditClassScreen(schoolClass: schoolClass)),
    ).then((value) {
      if (value != null) {
        setState(() {
          final index = _classes.indexWhere((c) => c.id == schoolClass.id);
          if (index != -1) {
            _classes[index] = value as SchoolClass;
          }
          _applyFilters();
        });
      }
    });
  }

  void _manageStudents(SchoolClass schoolClass) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassStudentsScreen(schoolClass: schoolClass)),
    );
  }
}
