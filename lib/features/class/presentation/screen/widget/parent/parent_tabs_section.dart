import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/home_work_model.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';

class ParentTabsSection extends StatefulWidget {
  final ClassState classState;
  final int studentCode;
  const ParentTabsSection({super.key, required this.classState, required this.studentCode});

  @override
  State<ParentTabsSection> createState() => _ParentTabsSectionState();
}

class _ParentTabsSectionState extends State<ParentTabsSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 3) {
        context.read<ClassCubit>().getHomeWork(
          code: widget.studentCode,
          hwDate: DateFormat('yyyy-MM-dd', 'en').format(DateTime.now()),
        );
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColor.whiteColor(context),
            unselectedLabelColor: Colors.black54,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            tabs: [
              Tab(text: AppLocalKay.scheduls.tr()),
              Tab(text: AppLocalKay.grades.tr()),
              Tab(text: AppLocalKay.checkin.tr()),
              Tab(text: AppLocalKay.todostitle.tr()),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const Center(child: Text('📆 شاشة الجدول')),
              const Center(child: Text('📊 شاشة الدرجات')),
              const Center(child: Text('📁 شاشة الحضور')),
              _buildHomeWorkSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHomeWorkSection(BuildContext context) {
    final status = widget.classState.homeWorkStatus;

    if (status.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (status.isFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const Gap(16),
            Text(status.error ?? "Error loading homework", textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (status.isSuccess) {
      final List<HomeWorkModel>? hwList = status.data;
      if (hwList == null || hwList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey[300]),
              const Gap(16),
              Text(
                AppLocalKay.no_task.tr(),
                style: AppTextStyle.bodyLarge(context).copyWith(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: hwList.length,
        separatorBuilder: (context, index) => const Gap(12),
        itemBuilder: (context, index) {
          final hw = hwList[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue.withOpacity(0.02)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.book_outlined, color: Colors.blue, size: 20),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hw.courseName,
                              style: AppTextStyle.titleMedium(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              hw.hwDate,
                              style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: const Icon(
                          Icons.assignment_outlined,
                          size: 16,
                          color: Colors.orange,
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalKay.todostitle.tr(),
                              style: AppTextStyle.bodySmall(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold, color: Colors.orange[800]),
                            ),
                            const Gap(4),
                            Text(hw.hw, style: AppTextStyle.bodyMedium(context)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (hw.notes.isNotEmpty) ...[
                    const Gap(12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: const Icon(Icons.notes_outlined, size: 16, color: Colors.grey),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalKay.note.tr(),
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                              ),
                              const Gap(4),
                              Text(hw.notes, style: AppTextStyle.bodySmall(context)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      );
    }

    return const Center(child: Text("Select a child to see homework"));
  }
}
