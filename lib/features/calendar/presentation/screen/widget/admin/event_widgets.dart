import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

class EventCard extends StatelessWidget {
  final AdminCalendarEvent event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.type,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: event.color, fontWeight: FontWeight.bold, fontSize: 10.sp),
                ),
              ),
              const Spacer(),
              // Priority fallback
              if (event.priority == "مهم")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high_rounded, color: Colors.red, size: 10.w),
                      Gap(2.w),
                      Text(
                        "أولوية عالية",
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
              if (event.originalEvent != null) _buildActionMenu(context),
            ],
          ),
          Gap(12.h),
          Text(
            event.title,
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          Gap(8.h),

          if (event.description.isNotEmpty) ...[
            Gap(12.h),
            Text(
              event.description,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: const Color(0xFF4B5563), height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Gap(12.h),
          const Divider(),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // المشاركون
              SizedBox(
                height: 24.h,
                child: Stack(
                  children: List.generate(
                    event.participants.length,
                    (index) => Positioned(
                      left: index * 16.w,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor(context).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.whiteColor(context), width: 1.5),
                        ),
                        child: Center(child: Icon(Icons.person_outline_rounded, size: 12.w)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(minWidth: 120.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        if (value == 'edit') {
          final calendarCubit = context.read<CalendarCubit>();
          final homeCubit = context.read<HomeCubit>();
          final classCubit = context.read<ClassCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: calendarCubit),
                  BlocProvider.value(value: homeCubit),
                  BlocProvider.value(value: classCubit),
                ],
                child: AddEventScreen(
                  color: const Color(0xFF9C27B0),
                  eventToEdit: event.originalEvent!,
                  isManagement: true,
                ),
              ),
            ),
          );
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                AppLocalKay.delete.tr(),
                style: AppTextStyle.titleLarge(context, listen: false),
              ),
              content: Text(
                AppLocalKay.delete_event_message.tr(),
                style: AppTextStyle.bodyMedium(context, listen: false),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    AppLocalKay.cancel.tr(),
                    style: AppTextStyle.bodyMedium(
                      context,
                      listen: false,
                    ).copyWith(color: AppColor.greyColor(context, listen: false)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<CalendarCubit>().deleteEvent(event.originalEvent!.id);
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    AppLocalKay.delete.tr(),
                    style: AppTextStyle.bodyMedium(context, listen: false).copyWith(
                      color: AppColor.errorColor(context, listen: false),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_rounded, color: const Color(0xFF9C27B0), size: 20),
              Gap(12.w),
              Text(AppLocalKay.edit.tr(), style: AppTextStyle.bodyMedium(context, listen: false)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_rounded,
                color: AppColor.errorColor(context, listen: false),
                size: 20,
              ),
              Gap(12.w),
              Text(AppLocalKay.delete.tr(), style: AppTextStyle.bodyMedium(context, listen: false)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColor.greyColor(context).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.more_horiz_rounded, color: AppColor.greyColor(context), size: 20.sp),
      ),
    );
  }
}

class CalendarEmptyState extends StatelessWidget {
  const CalendarEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: Icon(
                Icons.event_available_rounded,
                color: const Color(0xFF9C27B0).withOpacity(0.3),
                size: 48.w,
              ),
            ),
            Gap(16.h),
            Text(
              AppLocalKay.no_events.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF4B5563)),
            ),
            Gap(8.h),
            Text(
              AppLocalKay.free_time.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
            ),
            Gap(20.h),
            CustomButton(
              radius: 12.r,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<CalendarCubit>()),
                        BlocProvider.value(value: context.read<HomeCubit>()),
                        BlocProvider.value(value: context.read<ClassCubit>()),
                      ],
                      child: AddEventScreen(color: const Color(0xFF9C27B0), isManagement: true),
                    ),
                  ),
                );
              },

              color: const Color(0xFF9C27B0),
              child: Text(
                AppLocalKay.new_event.tr(),
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
