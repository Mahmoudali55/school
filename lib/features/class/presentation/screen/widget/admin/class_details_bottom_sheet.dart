import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';
import 'package:my_template/features/class/presentation/execution/widget/interactive_schedule_table.dart';

class ClassDetailsBottomSheet extends StatefulWidget {
  final String className;
  final int classCode;

  const ClassDetailsBottomSheet({super.key, required this.className, required this.classCode});

  @override
  State<ClassDetailsBottomSheet> createState() => _ClassDetailsBottomSheetState();
}

class _ClassDetailsBottomSheetState extends State<ClassDetailsBottomSheet>
    with SingleTickerProviderStateMixin {
  int _selectedMonth = DateTime.now().month;
  late TabController _tabController;

  final List<String> _daysEn = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  final List<String> _daysAr = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];
  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchData() {
    final cubit = context.read<ClassCubit>();
    cubit.studentAbsentCount(classCode: widget.classCode);
    cubit.classMonthResult(classCode: widget.classCode, month: _selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScheduleCubit>()..getScheduleFromApi(widget.classCode),
      child: Container(
        height: 0.9.sh,
        decoration: BoxDecoration(
          color: AppColor.scaffoldColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          children: [
            Gap(12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.grey200Color(context),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Gap(16.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalKay.class_details.tr(),
                          style: AppTextStyle.titleMedium(
                            context,
                          ).copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.className,
                          style: AppTextStyle.bodySmall(context).copyWith(
                            color: AppColor.primaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close_rounded, color: AppColor.greyColor(context)),
                  ),
                ],
              ),
            ),
            Gap(12.h),

            // Tab Bar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColor.grey100Color(context),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColor.primaryColor(context),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColor.whiteColor(context),
                unselectedLabelColor: AppColor.greyColor(context),
                labelStyle: AppTextStyle.bodySmall(context).copyWith(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: AppLocalKay.class_details.tr()),
                  const Tab(text: 'الجدول الدراسي'),
                ],
              ),
            ),
            Gap(8.h),
            const Divider(height: 1),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ─── Tab 1: Details ──────────────────────────────────────
                  BlocBuilder<ClassCubit, ClassState>(
                    builder: (context, state) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalKay.selectMonth.tr(),
                              style: AppTextStyle.titleSmall(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            Gap(12.h),
                            _buildMonthPicker(),
                            Gap(24.h),
                            _buildAbsentSection(context, state),
                            Gap(24.h),
                            _buildResultsSection(context, state),
                          ],
                        ),
                      );
                    },
                  ),

                  // ─── Tab 2: Schedule ─────────────────────────────────────
                  BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, state) {
                      if (state.getScheduleApiStatus.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.getScheduleApiStatus.isFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off_rounded, size: 48.w, color: Colors.grey),
                              Gap(12.h),
                              Text(
                                state.getScheduleApiStatus.error ?? 'حدث خطأ',
                                style: AppTextStyle.bodySmall(context),
                                textAlign: TextAlign.center,
                              ),
                              Gap(16.h),
                              ElevatedButton.icon(
                                onPressed: () => context.read<ScheduleCubit>().getScheduleFromApi(
                                  widget.classCode,
                                ),
                                icon: const Icon(Icons.refresh),
                                label: Text(AppLocalKay.retry.tr()),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: InteractiveScheduleTable(
                                className: widget.className,
                                startTime: state.startTime,
                                periodsCount: state.periodsCount,
                                periodDuration: state.periodDuration,
                                breakDuration: state.breakDuration,
                                thursdayPeriodsCount: state.thursdayPeriodsCount,
                                breakAfterPeriod: state.breakAfterPeriod,
                                classCode: widget.classCode,
                              ),
                            ),
                          ),
                          // Save Button Footer
                          Container(
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor(context),
                              border: Border(top: BorderSide(color: AppColor.borderColor(context))),
                            ),
                            child: BlocConsumer<ScheduleCubit, ScheduleState>(
                              listenWhen: (prev, curr) =>
                                  prev.editScheduleStatus != curr.editScheduleStatus,
                              listener: (context, state) {
                                if (state.editScheduleStatus.isSuccess) {
                                  CommonMethods.showToast(
                                    message: state.editScheduleStatus.data?.msg ?? '',
                                  );
                                } else if (state.editScheduleStatus.isFailure) {
                                  CommonMethods.showToast(
                                    message: state.editScheduleStatus.error ?? '',
                                    backgroundColor: AppColor.errorColor(context, listen: false),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return Visibility(
                                  visible: state.hasChanges,
                                  child: CustomButton(
                                    radius: 12.r,
                                    onPressed: state.editScheduleStatus.isLoading
                                        ? null
                                        : () {
                                            context.read<ScheduleCubit>().editSchedule(
                                              widget.classCode,
                                            );
                                          },
                                    child: state.editScheduleStatus.isLoading
                                        ? CustomLoading(
                                            color: AppColor.whiteColor(context),
                                            size: 20.sp,
                                          )
                                        : Text(
                                            AppLocalKay.edit.tr(),
                                            style: AppTextStyle.bodyMedium(
                                              context,
                                            ).copyWith(color: AppColor.whiteColor(context)),
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Schedule Card ──────────────────────────────────────────────────────────
  Widget _buildScheduleCard(ScheduleModel period) {
    final isBreak = period.subjectName == 'فسحة' || period.subjectName == 'Break';
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      color: isBreak ? Colors.orange.shade50 : AppColor.whiteColor(context),
      elevation: 0,
      child: ListTile(
        leading: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: isBreak
                ? Colors.orange.withValues(alpha: 0.15)
                : AppColor.primaryColor(context).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              '${period.period}',
              style: AppTextStyle.titleSmall(context).copyWith(
                fontWeight: FontWeight.bold,
                color: isBreak ? Colors.orange : AppColor.primaryColor(context),
              ),
            ),
          ),
        ),
        title: Text(
          period.subjectName,
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          period.teacherName,
          style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${period.startTime} - ${period.endTime}',
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: AppColor.textColor(context)),
            ),
            if (period.room != null && period.room!.isNotEmpty)
              Text(
                period.room!,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Month Picker ───────────────────────────────────────────────────────────
  Widget _buildMonthPicker() {
    return SizedBox(
      height: 45.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 12,
        separatorBuilder: (context, index) => Gap(10.w),
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = _selectedMonth == month;
          return GestureDetector(
            onTap: () {
              if (isSelected) return;
              setState(() => _selectedMonth = month);
              context.read<ClassCubit>().classMonthResult(
                classCode: widget.classCode,
                month: month,
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor(context) : AppColor.whiteColor(context),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primaryColor(context)
                      : AppColor.borderColor(context),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColor.primaryColor(context).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                "${AppLocalKay.month.tr()} $month",
                style: AppTextStyle.bodySmall(context).copyWith(
                  color: isSelected ? AppColor.whiteColor(context) : AppColor.textColor(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Absent Section ─────────────────────────────────────────────────────────
  Widget _buildAbsentSection(BuildContext context, ClassState state) {
    final status = state.studentAbsentCountStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.totalAbsences.tr(),
          style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.errorColor(context).withValues(alpha: 0.1),
                AppColor.errorColor(context).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColor.errorColor(context).withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(Icons.person_off_rounded, color: AppColor.errorColor(context), size: 32.sp),
              Gap(12.h),
              if (status?.isLoading ?? false)
                const CircularProgressIndicator()
              else if (status?.isFailure ?? false)
                Text(
                  status?.error ?? "Error",
                  style: TextStyle(color: AppColor.errorColor(context)),
                )
              else if (status?.data == null || status!.data!.isEmpty)
                Text(
                  "0",
                  style: AppTextStyle.titleLarge(
                    context,
                  ).copyWith(color: AppColor.errorColor(context), fontWeight: FontWeight.bold),
                )
              else
                Column(
                  children: [
                    Text(
                      "${status.data!.first.absentCount ?? 0}",
                      style: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(color: AppColor.errorColor(context), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalKay.unknownStudent.tr(),
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(color: AppColor.errorColor(context).withValues(alpha: 0.8)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Results Section ────────────────────────────────────────────────────────
  Widget _buildResultsSection(BuildContext context, ClassState state) {
    final status = state.classMonthResultStatus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.subjectResults.tr(),
              style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
            ),
            if ((status?.isSuccess ?? false) && (status?.data?.isNotEmpty ?? false))
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  "${AppLocalKay.month.tr()}${status?.data?.first.monthNo ?? _selectedMonth}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        Gap(16.h),
        if (status?.isLoading ?? false)
          const Center(
            child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
          )
        else if (status?.isFailure ?? false)
          Center(
            child: Text(
              status?.error ?? "Error loading results",
              style: TextStyle(color: AppColor.errorColor(context)),
            ),
          )
        else if (status?.data == null || status!.data!.isEmpty)
          Center(
            child: Text(
              AppLocalKay.noResults.tr(),
              style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: status.data!.length,
            separatorBuilder: (context, index) => Gap(12.h),
            itemBuilder: (context, index) {
              final result = status.data![index];
              return _buildResultCard(context, result);
            },
          ),
      ],
    );
  }

  Widget _buildResultCard(BuildContext context, dynamic result) {
    final double percentage = (result.studentDegree ?? 0) / (result.courseDegree ?? 1);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  color: AppColor.primaryColor(context),
                  size: 18.sp,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.courseName ?? "مادة غير معروفة",
                      style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (result.notes != null)
                      Text(
                        result.notes!,
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${result.studentDegree}",
                    style: AppTextStyle.titleSmall(
                      context,
                    ).copyWith(color: AppColor.primaryColor(context), fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "من ${result.courseDegree}",
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
                  ),
                ],
              ),
            ],
          ),
          Gap(12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6.h,
              backgroundColor: AppColor.grey100Color(context),
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 0.9
                    ? AppColor.successColor(context)
                    : percentage >= 0.7
                    ? AppColor.primaryColor(context)
                    : AppColor.warningColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
