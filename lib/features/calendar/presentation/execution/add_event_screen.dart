import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Color? selectedColor;

  final List<Color> eventColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFormField(
              radius: 12.r,
              title: AppLocalKay.event_title.tr(),
              controller: titleController,
              hintText: AppLocalKay.event_title_hint.tr(),
            ),

            SizedBox(height: 20.h),

            /// Description
            CustomFormField(
              radius: 12.r,
              title: AppLocalKay.event_description.tr(),
              controller: descriptionController,
              hintText: AppLocalKay.event_description_hint.tr(),

              maxLines: 3,
            ),

            SizedBox(height: 20.h),

            Row(
              children: [
                Expanded(
                  child: CustomFormField(
                    radius: 12.r,
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
                    controller: TextEditingController(
                      text: selectedTime == null ? '' : selectedTime!.format(context).toString(),
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

            SizedBox(height: 20.h),

            /// ---------------- Event Color ----------------
            Text(AppLocalKay.event_Color.tr(), style: AppTextStyle.titleSmall(context)),
            SizedBox(height: 10.h),

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
                      border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 100.h),
            CustomButton(
              color: AppColor.accentColor(context),
              text: AppLocalKay.add.tr(),
              radius: 12.r,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Input Field
}
