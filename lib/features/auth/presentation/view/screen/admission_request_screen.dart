import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_dropdown_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_searchable_dropdown.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/custom_widgets/custom_toast/custom_toast.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/common_methods.dart';
import 'package:my_template/features/auth/data/model/nationality_model.dart';
import 'package:my_template/features/auth/data/model/parent_registration_model.dart';
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

  final _parentPhoneController = TextEditingController();
  final _parentPassportNumberController = TextEditingController();
  final _parentNationalIdController = TextEditingController();
  final _studentCountController = TextEditingController(text: "1");

  String _parentResidencyType = "2";
  String _parentGender = "0";
  int? _parentNationalityCode;
  int? _parentReligionCode;

  // Student data list
  List<_StudentFormControllers> _studentControllers = [];

  @override
  void initState() {
    super.initState();
    _updateStudentForms(1);
    context.read<AuthCubit>().loadReligionCodes();
    context.read<AuthCubit>().loadNationalityCodes();
    context.read<AuthCubit>().loadSections();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.admissionStatus.isSuccess) {
            final msg = (state.admissionStatus.data is Map)
                ? (state.admissionStatus.data['msg'] ?? "تم إرسال الطلبات بنجاح")
                : "تم إرسال الطلبات بنجاح";
            CommonMethods.showToast(message: msg, type: ToastType.success);
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
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) => p.nationalityStatus != c.nationalityStatus,
                    builder: (context, state) {
                      final nationalities = state.nationalityStatus.data ?? [];
                      final isLoading = state.nationalityStatus.isLoading;

                      // Auto-select first if not selected and data available
                      if (_parentNationalityCode == null && nationalities.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(
                            () => _parentNationalityCode = nationalities.first.nationalityCode,
                          );
                        });
                      }

                      final selectedNationality = nationalities.firstWhere(
                        (n) => n.nationalityCode == _parentNationalityCode,
                        orElse: () => NationalityModel(nationalityCode: 0, nationalityNameAr: ''),
                      );

                      return CustomSearchableDropdown<NationalityModel>(
                        title: AppLocalKay.nationality.tr(),
                        hint: isLoading ? "Loading..." : AppLocalKay.nationality.tr(),
                        value: selectedNationality.nationalityCode == 0
                            ? null
                            : selectedNationality,
                        items: nationalities,
                        itemLabel: (n) => n.nationalityNameAr,
                        onChanged: (n) =>
                            setState(() => _parentNationalityCode = n?.nationalityCode),
                        submitted: false,
                        errorText: AppLocalKay.required.tr(),
                      );
                    },
                  ),
                  Gap(12.h),
                  Text(AppLocalKay.religion.tr(), style: AppTextStyle.formTitleStyle(context)),
                  Gap(8.h),
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (p, c) => p.religionStatus != c.religionStatus,
                    builder: (context, state) {
                      final religions = state.religionStatus.data ?? [];
                      final isLoading = state.religionStatus.isLoading;

                      // Auto-select first if not selected yet and data is available
                      if (_parentReligionCode == null && religions.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => _parentReligionCode = religions.first.religionCode);
                        });
                      }

                      return CustomDropdownFormField<int>(
                        value: _parentReligionCode,
                        hint: isLoading ? "Loading..." : AppLocalKay.religion.tr(),
                        items: isLoading
                            ? []
                            : religions
                                  .map(
                                    (r) => DropdownMenuItem<int>(
                                      value: r.religionCode,
                                      child: Text(r.religionNameAr),
                                    ),
                                  )
                                  .toList(),
                        onChanged: isLoading
                            ? null
                            : (v) => setState(() => _parentReligionCode = v),
                        errorText: AppLocalKay.required.tr(),
                        submitted: false,
                      );
                    },
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
                      DropdownMenuItem(value: "2", child: Text(AppLocalKay.national_id_card.tr())),
                      DropdownMenuItem(value: "1", child: Text(AppLocalKay.resident_card.tr())),
                    ],
                    onChanged: (v) => setState(() => _parentResidencyType = v!),
                    errorText: AppLocalKay.required.tr(),
                    submitted: false,
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.nationalId.tr(),
                    controller: _parentNationalIdController,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v!.isEmpty) return AppLocalKay.required.tr();
                      if (v.length != 10) return "يجب أن يكون 10 أرقام";
                      return null;
                    },
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.passport_number.tr(),
                    controller: _parentPassportNumberController,
                  ),
                  Gap(12.h),
                  CustomFormField(
                    title: AppLocalKay.student_phone.tr(),
                    keyboardType: TextInputType.phone,
                    controller: _parentPhoneController,
                    validator: (v) {
                      if (v!.isEmpty) return AppLocalKay.required.tr();
                      if (v.length != 10 || !v.startsWith("05")) {
                        return "يجب أن يكون 10 أرقام ويبدأ بـ 05";
                      }
                      return null;
                    },
                  ),
                  Gap(12.h),
                  Text(AppLocalKay.gender.tr(), style: AppTextStyle.formTitleStyle(context)),
                  Gap(8.h),
                  CustomDropdownFormField<String>(
                    errorText: '',
                    submitted: false,
                    value: _parentGender,
                    items: [
                      DropdownMenuItem(value: "0", child: Text(AppLocalKay.male.tr())),
                      DropdownMenuItem(value: "1", child: Text(AppLocalKay.female.tr())),
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
                        final parentModel = ParentRegistrationModel(
                          pFirstName: _parentFirstNameController.text,
                          pSecondName: _parentLastNameController.text,
                          pGrandName: _parentGrandfatherNameController.text,
                          pFamilyName: _parentFamilyNameController.text,
                          pNationCode: _parentNationalityCode ?? 0,
                          pReligionCode: _parentReligionCode ?? 0,
                          idType: int.tryParse(_parentResidencyType) ?? 1,
                          idNo: _parentNationalIdController.text,
                          pPassportNo: _parentPassportNumberController.text,
                          pMobNo: _parentPhoneController.text,
                          pGender: int.tryParse(_parentGender) ?? 0,
                          registrationStudents: _studentControllers.map((s) {
                            return StudentRegistrationModel(
                              sFirstName: s.name.text,
                              sIdNo: s.idNo.text,
                              regDate: s.regDate.text,
                              birthDate: s.birthDate.text,
                              ageYear: int.tryParse(s.years.text) ?? 0,
                              ageMonth: int.tryParse(s.months.text) ?? 0,
                              ageDay: int.tryParse(s.days.text) ?? 0,
                              gender: int.tryParse(s.gender) ?? 0,
                              sectionCode: int.tryParse(s.section ?? '') ?? 0,
                              stageCode: int.tryParse(s.stage ?? '') ?? 0,
                              levelCode: int.tryParse(s.grade ?? '') ?? 0,
                            );
                          }).toList(),
                        );
                        context.read<AuthCubit>().registerParent(parentModel);
                      }
                    },
                    child: state.admissionStatus.isLoading
                        ? CustomLoading(color: AppColor.whiteColor(context), size: 20)
                        : Text(
                            AppLocalKay.submit_admission.tr(),
                            style: AppTextStyle.bodyLarge(
                              context,
                              color: AppColor.whiteColor(context),
                            ),
                          ),
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
            validator: (v) {
              if (v!.isEmpty) return AppLocalKay.required.tr();
              if (v.length != 10) return "يجب أن يكون 10 أرقام";
              return null;
            },
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
              DropdownMenuItem(value: "0", child: Text(AppLocalKay.male.tr())),
              DropdownMenuItem(value: "1", child: Text(AppLocalKay.female.tr())),
            ],
            onChanged: (v) => setState(() => s.gender = v!),
            errorText: AppLocalKay.required.tr(),
            submitted: false,
          ),
          Gap(12.h),
          Text(AppLocalKay.student_section.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (p, c) => p.sectionStatus != c.sectionStatus,
            builder: (context, state) {
              final sections = state.sectionStatus.data ?? [];
              final isLoading = state.sectionStatus.isLoading;

              // Auto-select first if not selected and data available
              if (s.section == null && sections.isNotEmpty) {
                final firstSection = sections.first.sectionCode;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => s.section = firstSection.toString());
                  context.read<AuthCubit>().loadStages(firstSection);
                });
              }

              return CustomDropdownFormField<String>(
                value: s.section,
                hint: isLoading ? "Loading..." : AppLocalKay.student_section.tr(),
                items: isLoading
                    ? []
                    : sections
                          .map(
                            (sec) => DropdownMenuItem<String>(
                              value: sec.sectionCode.toString(),
                              child: Text(sec.sectionNameAr),
                            ),
                          )
                          .toList(),
                onChanged: isLoading
                    ? null
                    : (v) {
                        setState(() {
                          s.section = v;
                          s.stage = null; // Reset stage when section changes
                        });
                        if (v != null) {
                          context.read<AuthCubit>().loadStages(int.parse(v));
                        }
                      },
                errorText: AppLocalKay.required.tr(),
                submitted: false,
              );
            },
          ),
          Gap(12.h),
          Text(AppLocalKay.student_stage.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (p, c) => p.stagesMapStatus != c.stagesMapStatus,
            builder: (context, state) {
              final sectionCode = int.tryParse(s.section ?? '');
              final stages = sectionCode != null
                  ? (state.stagesMapStatus.data?[sectionCode] ?? [])
                  : [];
              final isLoading = state.stagesMapStatus.isLoading;

              // Auto-select first if not selected and data available
              if (s.stage == null && stages.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => s.stage = stages.first.stageCode.toString());
                });
              }

              return CustomDropdownFormField<String>(
                errorText: AppLocalKay.required.tr(),
                submitted: false,
                value: s.stage,
                hint: isLoading ? "Loading..." : AppLocalKay.student_stage.tr(),
                items: stages
                    .map(
                      (stg) => DropdownMenuItem<String>(
                        value: stg.stageCode.toString(),
                        child: Text(stg.stageNameAr),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    s.stage = v;
                    s.grade = null; // Reset grade when stage changes
                  });
                  if (v != null && s.section != null) {
                    context.read<AuthCubit>().loadLevels(int.parse(s.section!), int.parse(v));
                  }
                },
              );
            },
          ),
          Gap(12.h),
          Text(AppLocalKay.student_grade.tr(), style: AppTextStyle.formTitleStyle(context)),
          Gap(8.h),
          BlocBuilder<AuthCubit, AuthState>(
            buildWhen: (p, c) => p.levelsMapStatus != c.levelsMapStatus,
            builder: (context, state) {
              final sectionCode = int.tryParse(s.section ?? '');
              final stageCode = int.tryParse(s.stage ?? '');
              final key = "${sectionCode}_$stageCode";
              final levels = (sectionCode != null && stageCode != null)
                  ? (state.levelsMapStatus.data?[key] ?? [])
                  : [];
              final isLoading = state.levelsMapStatus.isLoading;

              // Auto-select first if not selected and data available
              if (s.grade == null && levels.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() => s.grade = levels.first.levelCode.toString());
                });
              }

              return CustomDropdownFormField<String>(
                errorText: AppLocalKay.required.tr(),
                submitted: false,
                value: s.grade,
                hint: isLoading ? "Loading..." : AppLocalKay.student_grade.tr(),
                items: levels
                    .map(
                      (lvl) => DropdownMenuItem<String>(
                        value: lvl.levelCode.toString(),
                        child: Text(lvl.levelNameAr),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => s.grade = v!),
              );
            },
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
  String gender = "0";
  String? section;
  String? stage;
  String? grade;

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
