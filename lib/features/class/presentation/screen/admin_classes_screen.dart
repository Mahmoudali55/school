import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/execution/add_edit_class_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_details_screen.dart';
import 'package:my_template/features/class/presentation/execution/class_students_screen.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/admin_class_widgets.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/admin_classes_control_bar.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/admin_classes_header.dart';
import 'package:my_template/features/class/presentation/screen/widget/admin/admin_classes_stats.dart';

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

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = AppLocalKay.all.tr();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ClassCubit, ClassState>(
          builder: (context, state) {
            if (state is ClassLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ClassError) {
              return Center(child: Text(state.message));
            } else if (state is ClassLoaded) {
              final classes = state.classes.cast<AdminClassModel>();
              return Column(
                children: [
                  const AdminClassesHeader(),
                  AdminClassesControlBar(
                    searchController: _searchController,
                    selectedFilter: _selectedFilter,
                    onSearchChanged: (query) => _applyFilters(),
                    onFilterSelected: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                        _applyFilters();
                      });
                    },
                  ),
                  AdminClassesStats(
                    classes: classes
                        .map(
                          (c) => SchoolClass(
                            id: c.id,
                            name: c.name,
                            grade: c.grade,
                            section: c.section,
                            capacity: c.capacity,
                            currentStudents: c.currentStudents,
                            teacher: c.teacher,
                            room: c.room,
                            schedule: c.schedule,
                          ),
                        )
                        .toList(),
                  ),
                  Expanded(
                    child: classes.isEmpty
                        ? AdminClassesEmptyState(
                            isSearch: _searchController.text.isNotEmpty,
                            onAddClass: _addNewClass,
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16.w),
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              final classItem = classes[index];
                              final schoolClass = SchoolClass(
                                id: classItem.id,
                                name: classItem.name,
                                grade: classItem.grade,
                                section: classItem.section,
                                capacity: classItem.capacity,
                                currentStudents: classItem.currentStudents,
                                teacher: classItem.teacher,
                                room: classItem.room,
                                schedule: classItem.schedule,
                              );
                              return AdminClassCard(
                                schoolClass: schoolClass,
                                onViewDetails: () => _viewClassDetails(schoolClass),
                                onEdit: () => _editClass(schoolClass),
                                onManageStudents: () => _manageStudents(schoolClass),
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewClass,
        backgroundColor: const Color(0xFF9C27B0),
        child: Icon(Icons.add, color: AppColor.whiteColor(context)),
      ),
    );
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
      // Logic for filtering would go here if we were filtering local list
    });
  }

  void _addNewClass() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditClassScreen()),
    ).then((value) {
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
