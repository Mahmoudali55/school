import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/student/student_class_widgets.dart';

class StudentClassesScreen extends StatefulWidget {
  const StudentClassesScreen({super.key});

  @override
  State<StudentClassesScreen> createState() => _StudentClassesScreenState();
}

class _StudentClassesScreenState extends State<StudentClassesScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final levelCode = HiveMethods.getUserLevelCode();
    context.read<ClassCubit>().studentCoursesStatus(level: int.tryParse(levelCode.toString()) ?? 0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.classesSection.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomFormField(
              controller: _searchController,
              radius: 12.r,
              prefixIcon: const Icon(Icons.search),
              hintText: AppLocalKay.search.tr(),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const Gap(20),
            // Title
            Text(
              AppLocalKay.classes_section.tr(),
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Gap(16),

            Expanded(
              child: BlocBuilder<ClassCubit, ClassState>(
                builder: (context, state) {
                  if (state.studentCoursesStatus.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.studentCoursesStatus.isFailure) {
                    return Center(child: Text(state.studentCoursesStatus.error ?? 'حدث خطأ ما'));
                  } else if (state.studentCoursesStatus.isSuccess) {
                    final allAvailableClasses = state.studentCoursesStatus.data ?? [];

                    final filteredClasses = allAvailableClasses.where((classItem) {
                      return classItem.courseNameAr.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                    }).toList();

                    if (filteredClasses.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 64.sp, color: Colors.grey[300]),
                            const Gap(16),
                            Text(
                              'لا توجد نتائج بحث مطابقة',
                              style: AppTextStyle.bodyMedium(context).copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredClasses.length,
                      itemBuilder: (context, index) {
                        final classItem = filteredClasses[index];
                        return StudentClassCard(
                          className: classItem.courseNameAr,
                          notes: classItem.notes ?? "",
                          onEnter: () {},
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
