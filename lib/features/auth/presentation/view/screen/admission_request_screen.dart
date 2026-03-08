import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/auth/data/model/admission_request_model.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_cubit.dart';
import 'package:my_template/features/auth/presentation/view/cubit/auth_state.dart';

class AdmissionRequestScreen extends StatefulWidget {
  const AdmissionRequestScreen({super.key});

  @override
  State<AdmissionRequestScreen> createState() => _AdmissionRequestScreenState();
}

class _AdmissionRequestScreenState extends State<AdmissionRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Parent controllers
  final _parentFirstNameController = TextEditingController();
  final _parentLastNameController = TextEditingController();
  final _parentFamilyNameController = TextEditingController();
  final _parentGrandfatherNameController = TextEditingController();
  final _parentNationalityController = TextEditingController();
  final _parentReligionController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentPassportNumberController = TextEditingController();
  final _parentNationalIdController = TextEditingController();
  final _studentCountController = TextEditingController(text: "1");

  String _parentResidencyType = "national_id_card";
  String _parentGender = "male";

  // Student data list
  List<_StudentFormControllers> _studentControllers = [];

  @override
  void initState() {
    super.initState();
    _updateStudentForms(1);
  }

  void _updateStudentForms(int count) {
    if (count < 0) return;
    setState(() {
      if (_studentControllers.length < count) {
        for (int i = _studentControllers.length; i < count; i++) {
          _studentControllers.add(_StudentFormControllers());
        }
      } else if (_studentControllers.length > count) {
        _studentControllers = _studentControllers.sublist(0, count);
      }
    });
  }

  @override
  void dispose() {
    _parentFirstNameController.dispose();
    _parentLastNameController.dispose();
    _parentFamilyNameController.dispose();
    _parentGrandfatherNameController.dispose();
    _parentNationalityController.dispose();
    _parentReligionController.dispose();
    _parentPhoneController.dispose();
    _parentPassportNumberController.dispose();
    _parentNationalIdController.dispose();
    _studentCountController.dispose();
    for (var controller in _studentControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _calculateAge(String birthDate, _StudentFormControllers s) {
    if (birthDate.isEmpty) return;
    try {
      DateTime birth = DateFormat('yyyy-MM-dd').parse(birthDate);
      DateTime now = DateTime.now();

      int years = now.year - birth.year;
      int months = now.month - birth.month;
      int days = now.day - birth.day;

      if (days < 0) {
        months--;
        DateTime lastMonth = DateTime(now.year, now.month, 0);
        days += lastMonth.day;
      }

      if (months < 0) {
        years--;
        months += 12;
      }

      s.years.text = years.toString();
      s.months.text = months.toString();
      s.days.text = days.toString();
    } catch (e) {
      debugPrint("Age calculation error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(AppLocalKay.apply_for_admission.tr()),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.admissionStatus.isSuccess) {
            CommonMethods.showToast(message: "تم إرسال الطلبات بنجاح", type: ToastType.success);
            Navigator.pop(context);
          } else if (state.admissionStatus.isFailure) {
            CommonMethods.showToast(
              message: state.admissionStatus.error ?? "حدث خطأ ما",
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: AppLocalKay.parent_info.tr()),
                  Gap(12.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.first_name.tr(),
                          controller: _parentFirstNameController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.last_name.tr(),
                          controller: _parentLastNameController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.grandfather_name.tr(),
                          controller: _parentGrandfatherNameController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.family_name.tr(),
                          controller: _parentFamilyNameController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.nationality.tr(),
                          controller: _parentNationalityController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: CustomFormField(
                          title: AppLocalKay.religion.tr(),
                          controller: _parentReligionController,
                          validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                        ),
                      ),
                    ],
                  ),
                  Gap(12.h),
                  Text(
                    AppLocalKay.residency_type.tr(),
                    style: AppTextStyle.formTitleStyle(context),
                  ),
                  Gap(8.h),
                  CustomDropdownFormField<String>(
                    value: _parentResidencyType,
                    items: [
                      DropdownMenuItem(
                        value: "national_id_card",
                        child: Text(AppLocalKay.national_id_card.tr()),
                      ),
                      DropdownMenuItem(
                        value: "resident_card",
                        child: Text(AppLocalKay.resident_card.tr()),
                      ),
                    ],
                    onChanged: (v) => setState(() => _parentResidencyType = v!),
                    errorText: '',
                    submitted: false,
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.nationalId.tr(),
                    controller: _parentNationalIdController,
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.passport_number.tr(),
                    controller: _parentPassportNumberController,
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: "رقم الهاتف",
                    controller: _parentPhoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
                  ),
                  Gap(12.h),
                  Text(AppLocalKay.gender.tr(), style: AppTextStyle.formTitleStyle(context)),
                  Gap(8.h),
                  CustomDropdownFormField<String>(
                    errorText: '',
                    submitted: false,
                    value: _parentGender,
                    items: [
                      DropdownMenuItem(value: "male", child: Text(AppLocalKay.male.tr())),
                      DropdownMenuItem(value: "female", child: Text(AppLocalKay.female.tr())),
                    ],
                    onChanged: (v) => setState(() => _parentGender = v!),
                  ),
                  Gap(12.h),
                  _SectionHeader(title: AppLocalKay.student_info.tr()),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.student_count.tr(),
                    controller: _studentCountController,
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      int? count = int.tryParse(v);
                      if (count != null && count > 0) _updateStudentForms(count);
                    },
                  ),
                  const Divider(),
                  ...List.generate(_studentControllers.length, (index) {
                    return _buildStudentSection(index);
                  }),
                  Gap(32.h),
                  CustomButton(
                    isLoading: state.admissionStatus.isLoading,
                    radius: 12.r,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final admissionModel = AdmissionRequestModel(
                          parentFirstName: _parentFirstNameController.text,
                          parentLastName: _parentLastNameController.text,
                          parentFamilyName: _parentFamilyNameController.text,
                          parentGrandfatherName: _parentGrandfatherNameController.text,
                          parentNationality: _parentNationalityController.text,
                          parentReligion: _parentReligionController.text,
                          parentResidencyType: _parentResidencyType,
                          parentPhone: _parentPhoneController.text,
                          parentGender: _parentGender,
                          parentPassportNumber: _parentPassportNumberController.text,
                          parentNationalId: _parentNationalIdController.text,
                          studentCount: _studentControllers.length,
                          students: _studentControllers.map((s) {
                            return StudentAdmissionModel(
                              studentName: s.name.text,
                              registrationDate: s.regDate.text,
                              studentBirthDate: s.birthDate.text,
                              studentIdNo: s.idNo.text,
                              gender: s.gender,
                              section: s.section,
                              stage: s.stage,
                              grade: s.grade,
                            );
                          }).toList(),
                        );
                        context.read<AuthCubit>().submitAdmissionRequest(admissionModel);
                      }
                    },
                    text: AppLocalKay.submit_admission.tr(),
                  ),
                  Gap(40.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentSection(int index) {
    final s = _studentControllers[index];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${AppLocalKay.student_info.tr()} (${index + 1})",
            style: AppTextStyle.bodyLarge(context).copyWith(fontWeight: FontWeight.bold),
          ),
          Gap(12.h),
          CustomFormField(
            title: "اسم الطالب",
            controller: s.name,
            validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
          ),
          Gap(12.h),
          CustomFormField(
            title: AppLocalKay.student_id_no.tr(),
            controller: s.idNo,
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
          ),
          Gap(12.h),
          CustomFormField(
            title: AppLocalKay.registration_date.tr(),
            controller: s.regDate,
            suffixIcon: IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => s.regDate.text = DateFormat('yyyy-MM-dd').format(picked));
              }
            },
            validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
          ),
          Gap(12.h),
          CustomFormField(
            title: AppLocalKay.student_birthday.tr(),
            controller: s.birthDate,
            suffixIcon: IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().subtract(const Duration(days: 365 * 6)),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  s.birthDate.text = DateFormat('yyyy-MM-dd').format(picked);
                  _calculateAge(s.birthDate.text, s);
                });
              }
            },
            validator: (v) => v!.isEmpty ? AppLocalKay.required.tr() : null,
          ),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  title: AppLocalKay.years.tr(),
                  controller: s.years,
                  readOnly: true,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: CustomFormField(
                  title: AppLocalKay.months.tr(),
                  controller: s.months,
                  readOnly: true,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: CustomFormField(
                  title: AppLocalKay.student_days.tr(),
                  controller: s.days,
                  readOnly: true,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Text(AppLocalKay.gender.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          CustomDropdownFormField<String>(
            value: s.gender,
            items: [
              DropdownMenuItem(value: "male", child: Text(AppLocalKay.male.tr())),
              DropdownMenuItem(value: "female", child: Text(AppLocalKay.female.tr())),
            ],
            onChanged: (v) => setState(() => s.gender = v!),
            errorText: '',
            submitted: false,
          ),
          Gap(12.h),
          Text(AppLocalKay.student_section.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          CustomDropdownFormField<String>(
            value: s.section,
            items: const [
              DropdownMenuItem(value: "arabic", child: Text("عربي")),
              DropdownMenuItem(value: "language", child: Text("لغات")),
            ],
            onChanged: (v) => setState(() => s.section = v!),
            errorText: '',
            submitted: false,
          ),
          Gap(12.h),
          Text(AppLocalKay.student_stage.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          CustomDropdownFormField<String>(
            errorText: '',
            submitted: false,
            value: s.stage,
            items: const [
              DropdownMenuItem(value: "kg", child: Text("رياض أطفال")),
              DropdownMenuItem(value: "primary", child: Text("ابتدائي")),
              DropdownMenuItem(value: "preparatory", child: Text("اعدادي")),
              DropdownMenuItem(value: "secondary", child: Text("ثانوي")),
            ],
            onChanged: (v) => setState(() => s.stage = v!),
          ),
          Gap(12.h),
          Text(AppLocalKay.student_grade.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          CustomDropdownFormField<String>(
            errorText: '',
            submitted: false,
            value: s.grade,
            items: const [
              DropdownMenuItem(value: "1", child: Text("الصف الأول")),
              DropdownMenuItem(value: "2", child: Text("الصف الثاني")),
              DropdownMenuItem(value: "3", child: Text("الصف الثالث")),
            ],
            onChanged: (v) => setState(() => s.grade = v!),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.primaryColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: AppTextStyle.bodyLarge(
          context,
        ).copyWith(fontWeight: FontWeight.bold, color: AppColor.primaryColor(context)),
      ),
    );
  }
}

class _StudentFormControllers {
  final name = TextEditingController();
  final idNo = TextEditingController();
  final regDate = TextEditingController();
  final birthDate = TextEditingController();
  final years = TextEditingController();
  final months = TextEditingController();
  final days = TextEditingController();
  String gender = "male";
  String section = "arabic";
  String stage = "primary";
  String grade = "1";

  void dispose() {
    name.dispose();
    idNo.dispose();
    regDate.dispose();
    birthDate.dispose();
    years.dispose();
    months.dispose();
    days.dispose();
  }
}
