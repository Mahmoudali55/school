import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key});

  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _selectedAudience;
  List<String> selectedClasses = [];

  List<String> audienceTypes = ['جميع الطلاب', 'صفوف محددة', 'معلمين فقط'];
  List<String> classes = ['الصف الأول', 'الصف الثاني', 'الصف الثالث', 'الصف الرابع', 'الصف الخامس'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.send_notification.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(AppLocalKay.to.tr(), style: AppTextStyle.formTitleStyle(context)),
              SizedBox(height: 5.h),
              DropdownButtonFormField<String>(
                value: _selectedAudience,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: AppColor.textFormFillColor(context),
                ),
                items: audienceTypes.map((String type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAudience = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.select_audience_error.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              if (_selectedAudience == 'صفوف محددة') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalKay.select_classes.tr(),
                      style: AppTextStyle.formTitleStyle(context),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: classes.map((classItem) {
                        return FilterChip(
                          label: Text(classItem),
                          selected: selectedClasses.contains(classItem),
                          selectedColor: AppColor.primaryColor(context),
                          labelStyle: AppTextStyle.bodyMedium(
                            context,
                          ).copyWith(color: AppColor.whiteColor(context)),
                          checkmarkColor: AppColor.whiteColor(context),

                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedClasses.add(classItem);
                              } else {
                                selectedClasses.remove(classItem);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ],

              CustomFormField(
                radius: 12.r,

                controller: _titleController,
                title: AppLocalKay.notification_title.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_title_error.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              CustomFormField(
                radius: 12.r,
                controller: _messageController,
                maxLines: 5,
                title: AppLocalKay.notification_message.tr(),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.enter_message_error.tr();
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalKay.additional_options.tr(),
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.important_devices, color: Colors.grey),
                          SizedBox(width: 8.w),
                          Text(
                            AppLocalKay.will_send_via.tr(),
                            style: AppTextStyle.bodyMedium(context),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (v) {}),
                          Text(AppLocalKay.app.tr(), style: AppTextStyle.bodyMedium(context)),
                          SizedBox(width: 16.w),
                          Checkbox(value: false, onChanged: (v) {}),
                          Text(AppLocalKay.email.tr(), style: AppTextStyle.bodyMedium(context)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              CustomButton(
                text: AppLocalKay.send.tr(),
                radius: 12.r,
                color: const Color(0xFFEC4899),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _sendNotification();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إرسال الإشعار بنجاح'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
