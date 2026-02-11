import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/Events_response_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';

class ApiEventItemWidget extends StatelessWidget {
  final Event event;

  const ApiEventItemWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final color = _getColorFromString(event.eventColore);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Colored Strip
              Container(width: 6.w, color: color),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              event.eventTitel,
                              style: AppTextStyle.titleSmall(
                                context,
                              ).copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildActionMenu(context),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        event.eventDesc,
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.greyColor(context), height: 1.5),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14.sp,
                            color: AppColor.greyColor(context),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${event.eventDate} • ${event.eventTime}",
                            style: AppTextStyle.bodySmall(context).copyWith(
                              color: AppColor.greyColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: calendarCubit,
                child: AddEventScreen(
                  color: AppColor.primaryColor(context, listen: false),
                  eventToEdit: event,
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
                    context.read<CalendarCubit>().deleteEvent(event.id);
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
              Icon(
                Icons.edit_rounded,
                color: AppColor.primaryColor(context, listen: false),
                size: 20,
              ),
              SizedBox(width: 12.w),
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
              SizedBox(width: 12.w),
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

  Color _getColorFromString(String colorStr) {
    switch (colorStr.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'yellow':
        return Colors.yellow;
      default:
        if (colorStr.startsWith('#')) {
          try {
            return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
          } catch (e) {
            return Colors.grey;
          }
        }
        return Colors.grey;
    }
  }
}
