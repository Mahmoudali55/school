import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BehaviorReportScreen extends StatefulWidget {
  const BehaviorReportScreen({super.key});

  @override
  State<BehaviorReportScreen> createState() => _BehaviorReportScreenState();
}

class _BehaviorReportScreenState extends State<BehaviorReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  String? _selectedStudent;
  String? _selectedBehaviorType;
  String? _selectedSeverity;
  DateTime? _incidentDate;

  List<String> students = ['أحمد محمد', 'فاطمة علي', 'خالد إبراهيم', 'سارة عبدالله', 'محمد حسن'];
  List<String> behaviorTypes = ['إيجابي', 'سلبي', 'محايد'];
  List<String> severityLevels = ['منخفض', 'متوسط', 'مرتفع'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          'تقرير سلوك',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
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
              Text('الطالب', style: AppTextStyle.formTitleStyle(context)),
              DropdownButtonFormField<String>(
                value: _selectedStudent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: AppColor.textFormFillColor(context),
                ),
                items: students.map((String student) {
                  return DropdownMenuItem<String>(value: student, child: Text(student));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStudent = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار الطالب';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              Text('نوع السلوك', style: AppTextStyle.formTitleStyle(context)),
              DropdownButtonFormField<String>(
                value: _selectedBehaviorType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  filled: true,
                  fillColor: AppColor.textFormFillColor(context),
                ),
                items: behaviorTypes.map((String type) {
                  return DropdownMenuItem<String>(value: type, child: Text(type));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedBehaviorType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار نوع السلوك';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              if (_selectedBehaviorType == 'سلبي') ...[
                Text('مستوى الخطورة', style: AppTextStyle.formTitleStyle(context)),
                DropdownButtonFormField<String>(
                  value: _selectedSeverity,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.textFormFillColor(context),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  items: severityLevels.map((String level) {
                    return DropdownMenuItem<String>(value: level, child: Text(level));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSeverity = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار مستوى الخطورة';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
              ],

              // تاريخ الحادث
              CustomFormField(
                readOnly: true,
                radius: 12,
                title: 'تاريخ الحادث',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _selectIncidentDate,
                ),
                controller: TextEditingController(
                  text: _incidentDate != null
                      ? '${_incidentDate!.day}/${_incidentDate!.month}/${_incidentDate!.year}'
                      : 'اختر تاريخ الحادث',
                ),
                validator: (value) {
                  if (_incidentDate == null) {
                    return 'يرجى اختيار تاريخ الحادث';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // تفاصيل السلوك
              CustomFormField(
                controller: _detailsController,
                maxLines: 4,
                title: 'تفاصيل السلوك',
                hintText: 'صف السلوك الذي لاحظته...',

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال تفاصيل السلوك';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // إجراء متبع
              if (_selectedBehaviorType == 'سلبي') ...[
                CustomFormField(
                  maxLines: 2,
                  title: 'الإجراء المتخذ',
                  hintText: 'صف الإجراء الذي اتبعته...',
                ),
                SizedBox(height: 16.h),
              ],

              CustomFormField(maxLines: 2, title: 'توصيات', hintText: 'أي توصيات إضافية...'),
              SizedBox(height: 24.h),

              CustomButton(
                text: 'حفظ',
                onPressed: _saveBehaviorReport,
                radius: 12.r,
                color: AppColor.errorColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectIncidentDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _incidentDate) {
      setState(() {
        _incidentDate = picked;
      });
    }
  }

  void _saveBehaviorReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم حفظ تقرير السلوك بنجاح'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }
}
