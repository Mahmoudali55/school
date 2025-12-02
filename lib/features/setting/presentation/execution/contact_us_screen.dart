import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedDepartment = 'الدعم الفني';

  final List<String> _departments = [
    'الدعم الفني',
    'الشؤون الأكاديمية',
    'شؤون الطلاب',
    'المالية',
    'التسجيل والقبول',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.contact.tr(),
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // معلومات التواصل
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalKay.contact_info.tr(),
                        style: AppTextStyle.titleSmall(
                          context,
                          color: AppColor.blackColor(context),
                        ),
                      ),

                      const SizedBox(height: 12),
                      _buildContactInfo(icon: Icons.location_on, text: "مجموعه النظم التطبيقة "),
                      _buildContactInfo(icon: Icons.phone, text: '+966 580926448'),
                      _buildContactInfo(icon: Icons.email, text: ' erp@delta-asg.com'),
                      _buildContactInfo(
                        icon: Icons.access_time,
                        text: 'الأحد - الخميس: 8:00 صباحاً - 5:00 مساءً',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // نموذج الاتصال
              Text(
                AppLocalKay.send_message.tr(),
                style: AppTextStyle.titleSmall(context, color: AppColor.blackColor(context)),
              ),
              const SizedBox(height: 12),
              // القسم
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                items: _departments
                    .map(
                      (dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept, style: AppTextStyle.bodyMedium(context)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDepartment = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: AppLocalKay.select_section.tr(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              // الاسم
              CustomFormField(
                controller: _nameController,
                prefixIcon: Icon(Icons.person, color: AppColor.primaryColor(context)),
                title: AppLocalKay.full_name.tr(),
                hintText: AppLocalKay.full_name_hint.tr(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.full_name_hint.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // البريد الإلكتروني
              CustomFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email, color: AppColor.primaryColor(context)),
                title: AppLocalKay.email.tr(),
                hintText: AppLocalKay.email_hint.tr(),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.email_hint.tr();
                  }
                  if (!value.contains('@')) {
                    return AppLocalKay.email_hint.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // الموضوع
              CustomFormField(
                controller: _subjectController,
                title: AppLocalKay.subject.tr(),
                hintText: AppLocalKay.subject_hint.tr(),
                prefixIcon: Icon(Icons.subject, color: AppColor.primaryColor(context)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.subject_hint.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // الرسالة
              CustomFormField(
                controller: _messageController,
                maxLines: 5,
                title: AppLocalKay.message.tr(),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalKay.message_hint.tr();
                  }
                  if (value.length < 10) {
                    return AppLocalKay.short_message.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              // زر الإرسال
              CustomButton(radius: 12.r, text: AppLocalKay.send.tr(), onPressed: _submitForm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primaryColor(context), size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyle.bodyMedium(context))),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // إرسال البيانات
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('تم الإرسال', style: AppTextStyle.titleMedium(context)),
          content: Text(
            'شكراً لتواصلك معنا. سنرد على رسالتك في أقرب وقت ممكن.',
            style: AppTextStyle.bodyMedium(context),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الـ AlertDialog
                Navigator.pop(context); // العودة للشاشة السابقة
              },
              child: Text('حسناً', style: AppTextStyle.bodyMedium(context)),
            ),
          ],
        ),
      );
    }
  }
}
