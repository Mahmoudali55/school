import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/images/app_images.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/schedule_Item_widget.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final scheduleStatus = state.teacherTimeTableStatus;

        if (scheduleStatus?.isLoading ?? false) {
          return const Center(child: CustomLoading());
        }

        if (scheduleStatus?.isFailure ?? false) {
          return Center(child: Text(scheduleStatus?.error ?? ""));
        }

        final List<ScheduleItem> scheduleItems = [];
        if (scheduleStatus?.isSuccess ?? false) {
          final allData = scheduleStatus!.data!;
          final now = DateTime.now();
          final days = ["الأحد", "الاثنين", "الثلاثاء", "الأربعاء", "الخميس", "الجمعة", "السبت"];
          final englishToArabicDays = {
            'Sunday': 'الأحد',
            'Monday': 'الاثنين',
            'Tuesday': 'الثلاثاء',
            'Wednesday': 'الأربعاء',
            'Thursday': 'الخميس',
            'Friday': 'الجمعة',
            'Saturday': 'السبت',
          };

          final currentDayArabic = days[now.weekday % 7];

          final filteredData = allData.where((item) {
            final arabicDay = englishToArabicDays[item.day] ?? item.day;
            return arabicDay == currentDayArabic;
          }).toList();

          filteredData.sort((a, b) => a.startTime.compareTo(b.startTime));

          for (var item in filteredData) {
            bool isCurrent = false;
            try {
              final timeFormat = DateFormat('HH:mm');
              final startStr = item.startTime.substring(0, 5);
              final endStr = item.endTime.substring(0, 5);
              final start = timeFormat.parse(startStr);
              final end = timeFormat.parse(endStr);
              final current = timeFormat.parse(DateFormat('HH:mm').format(now));
              isCurrent = current.isAfter(start) && current.isBefore(end);
            } catch (_) {}

            scheduleItems.add(
              ScheduleItem(
                time: "${item.startTime.substring(0, 5)} - ${item.endTime.substring(0, 5)}",
                subject: item.subjectName,
                classroom: " ${AppLocalKay.class_name_assigment.tr()} ${item.classCode}",
                room: "${AppLocalKay.room.tr()} ${item.room}",
                isCurrent: isCurrent,
              ),
            );
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalKay.schedule.tr(),
                  style: AppTextStyle.bodyLarge(context).copyWith(color: const Color(0xFF1F2937)),
                ),
                Text(
                  "${AppLocalKay.today.tr()} - ${_getTodayDate()}",
                  style: AppTextStyle.bodyMedium(context).copyWith(color: const Color(0xFF1F2937)),
                ),
              ],
            ),
            Gap(16.h),
            if (scheduleItems.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppImages.assetsGlobalIconEmptyFolderIcon,
                        height: 100.h,
                        width: 100.w,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          AppColor.primaryColor(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      Gap(16.h),
                      Text(
                        AppLocalKay.no_classe_today.tr(),
                        style: AppTextStyle.bodyMedium(
                          context,
                        ).copyWith(color: AppColor.greyColor(context)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: scheduleItems.map((item) => ScheduleItemWidget(item: item)).toList(),
              ),
          ],
        );
      },
    );
  }

  String _getTodayDate() {
    DateTime now = DateTime.now();
    List<String> days = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return '${now.day}/${now.month}/${now.year} - ${days[now.weekday % 7]}';
  }
}
