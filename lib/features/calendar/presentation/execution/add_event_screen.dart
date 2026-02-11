import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/calendar/data/model/Events_response_model.dart';
import 'package:my_template/features/calendar/data/model/add_event_request_model.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key, required this.color, this.eventToEdit});
  final Color color;
  final Event? eventToEdit;

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

  // Variables for functionality
  int? _selectedLevelCode;
  int? _selectedClassCode;
  bool _submitted = false;

  final List<Color> eventColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  bool get isEdit => widget.eventToEdit != null;

  @override
  void initState() {
    super.initState();
    // Initialize HomeCubit data
    final stageStr = HiveMethods.getUserStage();
    if (stageStr != null && stageStr.toString().isNotEmpty) {
      context.read<HomeCubit>().teacherLevel(int.parse(stageStr.toString()));
    }

    if (widget.eventToEdit != null) {
      final event = widget.eventToEdit!;
      titleController.text = event.eventTitel;
      descriptionController.text = event.eventDesc;

      _selectedLevelCode = event.levelCode;
      _selectedClassCode = event.classCode;

      if (_selectedLevelCode != null) {
        context.read<HomeCubit>().teacherClasses(
          int.parse(HiveMethods.getUserSection().toString()),
          int.parse(HiveMethods.getUserStage().toString()),
          _selectedLevelCode!,
        );
      }

      try {
        selectedDate = DateTime.parse(event.eventDate);
      } catch (_) {
        selectedDate = DateTime.now();
      }
      try {
        // As time comes as string (e.g. "08:00"), we need to parse it
        final timeParts = event.eventTime.split(':');
        if (timeParts.length == 2) {
          selectedTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
        }
      } catch (_) {
        selectedTime = TimeOfDay.now();
      }
      selectedColor = _getColorFromString(event.eventColore);
    }
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
      case 'teal':
        return Colors.teal;
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
      initialDate: selectedDate ?? DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
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

        if (state.editEventStatus.isSuccess) {
          CommonMethods.showToast(
            message: state.editEventStatus.data?.msg ?? "",
            backgroundColor: AppColor.successColor(context, listen: false),
          );
          Navigator.pop(context);
        } else if (state.editEventStatus.isFailure) {
          CommonMethods.showToast(
            message: state.editEventStatus.error ?? "",
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
              widget.eventToEdit != null ? "تعديل الحدث" : AppLocalKay.new_event.tr(),
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, size: 24.w),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(18.w),
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, homeState) {
                final levels = homeState.teacherLevelStatus.data ?? [];
                final classesList = homeState.teacherClassesStatus.data ?? [];

                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Level Dropdown
                      Text(
                        AppLocalKay.user_management_class.tr(),
                        style: AppTextStyle.formTitleStyle(context),
                      ),
                      SizedBox(height: 8.h),
                      IgnorePointer(
                        ignoring: isEdit,
                        child: Opacity(
                          opacity: isEdit ? 0.5 : 1,
                          child: CustomDropdownFormField<int>(
                            value: levels.any((e) => e.levelCode == _selectedLevelCode)
                                ? _selectedLevelCode
                                : null,
                            submitted: _submitted,
                            hint: AppLocalKay.user_management_class.tr(),
                            errorText: AppLocalKay.user_management_select_class.tr(),
                            items: levels
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.levelCode,
                                    child: Text(e.levelName),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _selectedLevelCode = v;
                                _selectedClassCode = null;
                              });
                              if (v != null) {
                                context.read<HomeCubit>().teacherClasses(
                                  int.parse(HiveMethods.getUserSection().toString()),
                                  int.parse(HiveMethods.getUserStage().toString()),
                                  v,
                                );
                              }
                            },
                          ),
                        ),
                      ),

                      Gap(8.h),

                      /// Class Dropdown
                      Text(
                        AppLocalKay.class_name_assigment.tr(),
                        style: AppTextStyle.formTitleStyle(context),
                      ),
                      SizedBox(height: 8.h),
                      IgnorePointer(
                        ignoring: isEdit,
                        child: Opacity(
                          opacity: isEdit ? 0.5 : 1,
                          child: CustomDropdownFormField<int>(
                            value: classesList.any((e) => e.classCode == _selectedClassCode)
                                ? _selectedClassCode
                                : null,
                            submitted: _submitted,
                            hint: AppLocalKay.class_name_assigment.tr(),
                            errorText: AppLocalKay.user_management_select_classs.tr(),
                            items: classesList
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.classCode,
                                    child: Text(e.classNameAr),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _selectedClassCode = v),
                          ),
                        ),
                      ),

                      Gap(8.h),

                      CustomFormField(
                        radius: 12.r,
                        title: AppLocalKay.event_title.tr(),
                        controller: titleController,
                        hintText: AppLocalKay.event_title_hint.tr(),
                        validator: (value) => value!.isEmpty ? AppLocalKay.required.tr() : null,
                      ),
                      Gap(8.h),
                      CustomFormField(
                        radius: 12.r,
                        title: AppLocalKay.event_description.tr(),
                        controller: descriptionController,
                        hintText: AppLocalKay.event_description_hint.tr(),
                        validator: (value) => value!.isEmpty ? AppLocalKay.required.tr() : null,
                        maxLines: 3,
                      ),
                      Gap(8.h),
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
                                    : selectedDate!.toIso8601String().split('T')[0],
                              ),
                              title: AppLocalKay.select_date.tr(),
                              suffixIcon: Icon(
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
                              suffixIcon: Icon(
                                Icons.access_time_rounded,
                                color: AppColor.primaryColor(context),
                              ),
                              onTap: _pickTime,
                            ),
                          ),
                        ],
                      ),
                      Gap(8.h),
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
                      Gap(20.h),
                      CustomButton(
                        color: widget.color,
                        child:
                            (widget.eventToEdit != null
                                ? context.watch<CalendarCubit>().state.editEventStatus.isLoading
                                : context.watch<CalendarCubit>().state.addEventStatus.isLoading)
                            ? CustomLoading(color: AppColor.whiteColor(context), size: 15.w)
                            : Text(
                                widget.eventToEdit != null ? "تعديل" : AppLocalKay.add.tr(),
                                style: AppTextStyle.bodyMedium(
                                  context,
                                ).copyWith(color: AppColor.whiteColor(context)),
                              ),
                        radius: 12.r,
                        onPressed: () {
                          setState(() => _submitted = true);
                          if (formKey.currentState!.validate()) {
                            final request = AddEventRequestModel(
                              id: widget.eventToEdit?.id.toString() ?? "",
                              eventTitel: titleController.text,
                              eventDesc: descriptionController.text,
                              eventDate: selectedDate!.toIso8601String().split('T')[0],
                              eventTime:
                                  "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                              eventColor: _getColorName(selectedColor),
                              sectionCode: int.parse(HiveMethods.getUserSection().toString()),
                              stageCode: int.parse(HiveMethods.getUserStage().toString()),
                              levelCode: int.parse(_selectedLevelCode.toString()),
                              classCode: int.parse(_selectedClassCode.toString()),
                            );

                            if (widget.eventToEdit != null) {
                              context.read<CalendarCubit>().editEvent(request);
                            } else {
                              context.read<CalendarCubit>().addEvent(request);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
