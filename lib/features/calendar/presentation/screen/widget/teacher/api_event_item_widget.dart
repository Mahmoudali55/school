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
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: (0.03)),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.eventTitel,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.blackColor(context)),
                ),
                SizedBox(height: 2.h),
                Text(
                  event.eventDesc,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  "${event.eventDate} • ${event.eventTime}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: AppColor.accentColor(context)),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
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
                    title: Text(AppLocalKay.delete.tr(), style: AppTextStyle.titleLarge(context)),
                    content: Text(
                      AppLocalKay.delete_event_message.tr(),
                      style: AppTextStyle.bodyMedium(context),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(AppLocalKay.cancel.tr()),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<CalendarCubit>().deleteEvent(event.id);
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          AppLocalKay.delete.tr(),
                          style: TextStyle(color: AppColor.errorColor(context)),
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
                      Icons.edit,
                      color: AppColor.primaryColor(context, listen: false),
                      size: 18,
                    ),
                    SizedBox(width: 8.w),
                    Text(AppLocalKay.edit.tr()),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColor.errorColor(context, listen: false),
                      size: 18,
                    ),
                    SizedBox(width: 8.w),
                    Text(AppLocalKay.delete.tr()),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.more_vert, color: AppColor.greyColor(context)),
          ),
        ],
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
