import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/teacher_classes_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/teacher_classes_state.dart';
import 'package:my_template/features/class/presentation/screen/widget/teatcher/classes_list_widget.dart';
import 'package:my_template/features/class/presentation/screen/widget/teatcher/quick_stats_widget.dart';
import 'package:my_template/features/class/presentation/screen/widget/teatcher/teacher_info_card.dart';

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
            // يمكن إضافة تجديد البيانات هنا
            await Future.delayed(const Duration(seconds: 1));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Teacher Info Card
                TeacherInfoCard(
                  teacherInfo: state.teacherInfo,
                  onEditPressed: () {
                    _showEditProfileDialog(context, state.teacherInfo);
                  },
                ),

                const SizedBox(height: 20),

                // Quick Stats
                QuickStatsWidget(stats: state.stats),

                const SizedBox(height: 20),

                // Classes Header
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

                // Classes List
                Expanded(child: ClassesListWidget(classes: state.filteredClasses)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, TeacherInfo teacherInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تعديل الملف الشخصي'.tr()),
        content: Text('هنا يمكن تعديل معلومات الملف الشخصي...'.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('إلغاء'.tr())),
          ElevatedButton(
            onPressed: () {
              // TODO: تحديث معلومات المدرس
              Navigator.pop(context);
            },
            child: Text('حفظ'.tr()),
          ),
        ],
      ),
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
            ListTile(
              title: Text('جميع الفصول'.tr()),
              onTap: () {
                context.read<TeacherClassesCubit>().clearFilter();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('الصف العاشر'.tr()),
              onTap: () {
                context.read<TeacherClassesCubit>().filterClasses('العاشر'.tr());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('الصف التاسع'.tr()),
              onTap: () {
                context.read<TeacherClassesCubit>().filterClasses('التاسع'.tr());
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('الصف الحادي عشر'.tr()),
              onTap: () {
                context.read<TeacherClassesCubit>().filterClasses('الحادي عشر'.tr());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
