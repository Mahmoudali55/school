import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/calendar/data/model/add_event_request_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, required this.color});
  final Color color;
  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Color? selectedColor;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<Color> eventColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  String _getColorName(Color? color) {
    if (color == Colors.red) return "red";
    if (color == Colors.blue) return "blue";
    if (color == Colors.green) return "green";
    if (color == Colors.orange) return "orange";
    if (color == Colors.purple) return "purple";
    if (color == Colors.teal) return "teal";
    return "red";
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarCubit, CalendarState>(
      listener: (context, state) {
        if (state.addEventStatus.isSuccess) {
          CommonMethods.showToast(
            message: state.addEventStatus.data?.msg ?? "",
            backgroundColor: AppColor.successColor(context, listen: false),
          );
          Navigator.pop(context);
        } else if (state.addEventStatus.isFailure) {
          CommonMethods.showToast(
            message: state.addEventStatus.error ?? "",
            backgroundColor: AppColor.errorColor(context, listen: false),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.whiteColor(context),
          appBar: CustomAppBar(
            context,
            centerTitle: true,
            title: Text(
              AppLocalKay.new_event.tr(),
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, size: 24.w),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          body: SingleChildScrollView(
            padding: EdgeInsets.all(18.w),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomFormField(
                    radius: 12.r,
                    title: AppLocalKay.event_title.tr(),
                    controller: titleController,
                    hintText: AppLocalKay.event_title_hint.tr(),
                    validator: (value) => value!.isEmpty ? AppLocalKay.required.tr() : null,
                  ),

                  Gap(20.h),

                  /// Description
                  CustomFormField(
                    radius: 12.r,
                    title: AppLocalKay.event_description.tr(),
                    controller: descriptionController,
                    hintText: AppLocalKay.event_description_hint.tr(),
                    validator: (value) => value!.isEmpty ? AppLocalKay.required.tr() : null,

                    maxLines: 3,
                  ),
                  Gap(20.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          radius: 12.r,
                          readOnly: true,
                          validator: (value) =>
                              value!.isEmpty ? AppLocalKay.select_date.tr() : null,
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : selectedDate!.toLocal().toString().split(' ')[0],
                          ),
                          title: AppLocalKay.select_date.tr(),
                          prefixIcon: Icon(
                            Icons.date_range_rounded,
                            color: AppColor.primaryColor(context),
                          ),
                          onTap: _pickDate,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomFormField(
                          radius: 12.r,
                          readOnly: true,
                          validator: (value) =>
                              value!.isEmpty ? AppLocalKay.select_time.tr() : null,
                          controller: TextEditingController(
                            text: selectedTime == null
                                ? ''
                                : selectedTime!.format(context).toString(),
                          ),
                          title: AppLocalKay.select_time.tr(),
                          prefixIcon: Icon(
                            Icons.access_time_rounded,
                            color: AppColor.primaryColor(context),
                          ),
                          onTap: _pickTime,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Text(AppLocalKay.event_Color.tr(), style: AppTextStyle.titleSmall(context)),
                  Gap(10.h),
                  Wrap(
                    spacing: 12.w,
                    children: eventColors.map((color) {
                      final bool isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: AppColor.blackColor(context), width: 2.5)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Gap(100.h),
                  CustomButton(
                    color: widget.color,
                    child: context.watch<CalendarCubit>().state.addEventStatus.isLoading
                        ? CustomLoading(color: AppColor.whiteColor(context), size: 15.w)
                        : Text(
                            AppLocalKay.add.tr(),
                            style: AppTextStyle.bodyMedium(
                              context,
                            ).copyWith(color: AppColor.whiteColor(context)),
                          ),
                    radius: 12.r,

                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final request = AddEventRequestModel(
                          id: "",
                          eventTitel: titleController.text,
                          eventDesc: descriptionController.text,
                          eventDate: selectedDate!.toIso8601String().split('T')[0],
                          eventTime:
                              "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                          eventColor: _getColorName(selectedColor),
                        );

                        context.read<CalendarCubit>().addEvent(request);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
