import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/teacher_data_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/execution/widget/custom_teacher_error.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher_card.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({super.key});

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().teacherData(searchVal: '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    setState(() => _searchQuery = value);
    context.read<HomeCubit>().teacherData(searchVal: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.teachers_ar.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.textColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ─── Search Bar ───
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: CustomFormField(
              controller: _searchController,
              hintText: AppLocalKay.SEARCH_TEACHER.tr(),
              radius: 14,
              prefixIcon: Icon(Icons.search_rounded, color: AppColor.primaryColor(context)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded, color: AppColor.textColor(context)),
                      onPressed: () {
                        _searchController.clear();
                        _onSearch('');
                      },
                    )
                  : null,
              onChanged: _onSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (prev, curr) =>
                  prev.teacherDataStatus != curr.teacherDataStatus,
              builder: (context, state) {
                final status = state.teacherDataStatus;

                if (status == null || status.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (status.isFailure) {
                  return CustomTeacherError(status: status, searchQuery: _searchQuery);
                }

                final teachers = status.data ?? <TeacherDataModel>[];

                if (teachers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_search_rounded,
                            size: 72.r,
                            color: AppColor.primaryColor(context).withValues(alpha: 0.25)),
                        Gap(16.h),
                        Text(
                          AppLocalKay.NO_TEACHERS_FOUND.tr(),
                          style: AppTextStyle.bodyLarge(context).copyWith(
                            color: AppColor.textColor(context).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      context.read<HomeCubit>().teacherData(searchVal: _searchQuery),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: teachers.length,
                    separatorBuilder: (_, __) => Gap(10.h),
                    itemBuilder: (context, index) =>
                        TeacherCard(teacher: teachers[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

