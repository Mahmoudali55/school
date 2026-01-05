import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/student/student_class_widgets.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
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
              controller: TextEditingController(),
              radius: 12.r,
              prefixIcon: const Icon(Icons.search),
              hintText: 'ابحث في الفصول الدراسية',
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              AppLocalKay.classes_section.tr(),
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            // Classes List
            Expanded(
              child: BlocBuilder<ClassCubit, ClassState>(
                builder: (context, state) {
                  if (state is ClassLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ClassError) {
                    return Center(child: Text(state.message));
                  } else if (state is ClassLoaded) {
                    final classes = state.classes.cast<StudentClassModel>();
                    if (classes.isEmpty) {
                      return const Center(child: Text("No classes found"));
                    }
                    return ListView.builder(
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final classItem = classes[index];
                        return StudentClassCard(
                          className: classItem.className,
                          teacherName: classItem.teacherName,
                          room: classItem.room,
                          time: classItem.time,
                          color: classItem.color,
                          icon: classItem.icon,
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
