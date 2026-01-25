import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_children_selection.dart';
import 'package:my_template/features/class/presentation/screen/widget/parent/parent_tabs_section.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class ParentClassScreen extends StatefulWidget {
  const ParentClassScreen({super.key});

  @override
  State<ParentClassScreen> createState() => _ParentClassScreenState();
}

class _ParentClassScreenState extends State<ParentClassScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeCubit>().parentData(int.parse(HiveMethods.getUserCode()));
      context.read<ClassCubit>().getClassData('parent');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalKay.classes.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: AppColor.whiteColor(context),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, homeState) {
            final students = (homeState.parentsStudentStatus.data ?? [])
                .map((e) => e.toMiniInfo())
                .toList();

            if (homeState.parentsStudentStatus.isLoading ||
                homeState.parentsStudentStatus.isInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (students.isEmpty) {
              return const Center(child: Text("لا يوجد طلاب"));
            }

            return BlocBuilder<ClassCubit, ClassState>(
              builder: (context, state) {
                if (state.classesStatus.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.classesStatus.isFailure) {
                  return Center(child: Text(state.classesStatus.error ?? "حدث خطأ ما"));
                } else if (state.classesStatus.isSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ParentChildrenSelection(
                          children: students,
                          selectedIndex: _selectedIndex,
                          onSelected: (index) {
                            setState(() => _selectedIndex = index);
                            context.read<ClassCubit>().getHomeWork(
                              code: students[index].studentCode,
                              hwDate: DateFormat("yyyy-MM-dd", "en").format(DateTime.now()),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ParentTabsSection(
                            classState: state,
                            studentCode: students[_selectedIndex].studentCode,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
