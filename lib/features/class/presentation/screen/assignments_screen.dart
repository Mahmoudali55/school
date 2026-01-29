import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/home_work_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

class AssignmentsScreen extends StatefulWidget {
  final int? code;
  final String? hwDate;

  const AssignmentsScreen({super.key, this.code, this.hwDate});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  @override
  void initState() {
    super.initState();
    _fetchHomeWork();
  }

  void _fetchHomeWork() {
    int targetCode = widget.code ?? 0;
    String targetDate = widget.hwDate ?? DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());

    if (targetCode == 0) {
      // Try HomeCubit
      try {
        final homeCubit = context.read<HomeCubit>();
        targetCode = homeCubit.state.selectedStudent?.studentCode ?? 0;

        if (targetCode == 0) {
          final parentsStudents = homeCubit.state.parentsStudentStatus.data;
          if (parentsStudents != null && parentsStudents.isNotEmpty) {
            targetCode = parentsStudents[0].studentCode;
          }
        }
      } catch (_) {}
    }

    if (targetCode == 0) {
      // Try Hive
      String hiveCode = HiveMethods.getUserCode();
      if (hiveCode.isNotEmpty) {
        targetCode = int.tryParse(hiveCode) ?? 0;
      }
    }

    if (targetCode != 0) {
      context.read<ClassCubit>().getHomeWork(code: targetCode, hwDate: targetDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.todostitle.tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ClassCubit, ClassState>(
        builder: (context, state) {
          if (state.homeWorkStatus.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.homeWorkStatus.isFailure) {
            return Center(
              child: Text(
                state.homeWorkStatus.error ?? "حدث خطأ ما",
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.errorColor(context)),
              ),
            );
          } else if (state.homeWorkStatus.isSuccess) {
            final assignments = state.homeWorkStatus.data ?? [];
            if (assignments.isEmpty) {
              return Center(
                child: Text(
                  AppLocalKay.no_assignments.tr(),
                  style: AppTextStyle.bodyMedium(context),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                return _buildAssignmentCard(assignments[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildAssignmentCard(HomeWorkModel assignment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.05)),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  assignment.courseName,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                assignment.hwDate,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: AppColor.grey600Color(context)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            assignment.hw,
            style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          if (assignment.notes.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              assignment.notes,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.blackColor(context)),
            ),
          ],
          SizedBox(height: 16.h),
          const Divider(),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.school_outlined, size: 16, color: AppColor.greyColor(context)),
              SizedBox(width: 4.w),
              Text(
                "${AppLocalKay.code.tr()}: ${assignment.classCode}",
                style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
