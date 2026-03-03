import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/images/app_images.dart';
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
              child: Column(
                children: [
                  SvgPicture.asset(AppImages.assetsGlobalIconEmptyFolderIcon),
                  Gap(20.h),
                  Text(
                    state.homeWorkStatus.error ?? "حدث خطأ ما",
                    style: AppTextStyle.bodyMedium(
                      context,
                    ).copyWith(color: AppColor.errorColor(context)),
                  ),
                ],
              ),
            );
          } else if (state.homeWorkStatus.isSuccess) {
            final assignments = state.homeWorkStatus.data ?? [];
            if (assignments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.assetsGlobalIconEmptyFolderIcon,
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryColor(context),
                        BlendMode.srcIn,
                      ),
                      width: 150.w,
                      height: 150.h,
                    ),
                    Gap(20.h),
                    Text(
                      AppLocalKay.no_assignments.tr(),
                      style: AppTextStyle.bodyLarge(
                        context,
                      ).copyWith(color: AppColor.blackColor(context), fontWeight: FontWeight.bold),
                    ),
                  ],
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          colors: [
            AppColor.primaryColor(context).withValues(alpha: (0.05)),
            AppColor.whiteColor(context),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.06)),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColor.primaryColor(context).withValues(alpha: (0.1))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔵 Top Row
            Row(
              children: [
                /// Icon Circle
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.primaryColor(context).withValues(alpha: (0.1)),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: AppColor.primaryColor(context),
                    size: 20,
                  ),
                ),
                Gap(10.w),

                /// Course Name
                Expanded(
                  child: Text(
                    assignment.courseName,
                    style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),

                /// Date Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(context),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Text(
                    assignment.hwDate,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),

            Gap(16.h),

            /// Homework Title
            Text(
              assignment.hw,
              style: AppTextStyle.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w600, height: 1.4),
            ),

            if (assignment.notes.isNotEmpty) ...[
              Gap(8.h),
              Text(
                assignment.notes,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: AppColor.grey600Color(context)),
              ),
            ],

            Gap(16.h),

            Divider(color: AppColor.grey300Color(context)),

            Gap(8.h),

            /// Bottom Row
            Row(
              children: [
                Icon(Icons.class_, size: 16, color: AppColor.greyColor(context)),
                Gap(6.w),
                Text(
                  "${AppLocalKay.code.tr()}: ${assignment.classCode}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColor.greyColor(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
