import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/cubit/teacher_classes_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/teacher_classes_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_classes_list.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_info_card.dart';
import 'package:my_template/features/class/presentation/screen/widget/teacher/teacher_quick_stats.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeacherClassesCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(
          context,
          title: Text(
            AppLocalKay.classestitle.tr(),
            style: AppTextStyle.titleMedium(context, color: AppColor.blackColor(context)),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: const _TeacherClassesBody(),
      ),
    );
  }
}

class _TeacherClassesBody extends StatelessWidget {
  const _TeacherClassesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherClassesCubit, TeacherClassesState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TeacherInfoCard(teacherInfo: state.teacherInfo),
                const SizedBox(height: 20),
                TeacherQuickStats(stats: state.stats),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalKay.classestitle.tr(),
                      style: AppTextStyle.titleMedium(
                        context,
                        color: AppColor.secondAppColor(context),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list, color: AppColor.secondAppColor(context)),
                      onPressed: () {
                        _showFilterDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(child: TeacherClassesList(classes: state.filteredClasses)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تصفية الفصول'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption(context, 'جميع الفصول'.tr(), null),
            _buildFilterOption(context, 'الصف العاشر'.tr(), 'العاشر'.tr()),
            _buildFilterOption(context, 'الصف التاسع'.tr(), 'التاسع'.tr()),
            _buildFilterOption(context, 'الصف الحادي عشر'.tr(), 'الحادي عشر'.tr()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(BuildContext context, String title, String? filter) {
    return ListTile(
      title: Text(title),
      onTap: () {
        if (filter == null) {
          context.read<TeacherClassesCubit>().clearFilter();
        } else {
          context.read<TeacherClassesCubit>().filterClasses(filter);
        }
        Navigator.pop(context);
      },
    );
  }
}
