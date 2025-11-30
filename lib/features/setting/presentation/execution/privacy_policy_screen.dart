// lib/features/settings/presentation/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          'سياسة الخصوصية',
          style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('آخر تحديث: 20 مارس 2024', style: AppTextStyle.bodyMedium(context)),
                    SizedBox(height: 8.h),
                    Text(
                      'نحن في مدرسة النموذجية نلتزم بحماية خصوصيتك وبياناتك الشخصية.',
                      style: AppTextStyle.bodyMedium(context),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '1. المعلومات التي نجمعها',
              'نقوم بجمع المعلومات التالية:\n\n'
                  '• المعلومات الشخصية (الاسم، البريد الإلكتروني، رقم الهاتف)\n'
                  '• المعلومات الأكاديمية (الدرجات، الحضور، السلوك)\n'
                  '• معلومات الجهاز وعنوان IP\n'
                  '• سجل النشاط على النظام',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '2. كيفية استخدام المعلومات',
              'نستخدم المعلومات التي نجمعها للأغراض التالية:\n\n'
                  '• توفير الخدمات التعليمية\n'
                  '• تحسين تجربة المستخدم\n'
                  '• التواصل مع أولياء الأمور والطلاب\n'
                  '• تحليل الأداء الأكاديمي\n'
                  '• الالتزام بالمتطلبات القانونية',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '3. مشاركة المعلومات',
              'نحن لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك المعلومات في الحالات التالية:\n\n'
                  '• مع الجهات التعليمية المختصة\n'
                  '• عند وجود متطلبات قانونية\n'
                  '• مع مزودي الخدمات الذين يعملون نيابة عننا\n'
                  '• للحفاظ على سلامة وأمن المستخدمين',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '4. حماية المعلومات',
              'نحن نستخدم إجراءات أمنية متعددة لحماية معلوماتك:\n\n'
                  '• تشفير البيانات أثناء النقل والتخزين\n'
                  '• التحكم في الوصول بناءً على الصلاحيات\n'
                  '• مراجعة دورية لإجراءات الأمان\n'
                  '• تدريب الموظفين على حماية البيانات',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '5. حقوق المستخدم',
              'لديك الحق في:\n\n'
                  '• الوصول إلى بياناتك الشخصية\n'
                  '• تصحيح البيانات غير الدقيقة\n'
                  '• طلب حذف بياناتك الشخصية\n'
                  '• الاعتراض على معالجة بياناتك\n'
                  '• نقل بياناتك إلى نظام آخر',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '6. ملفات تعريف الارتباط',
              'نستخدم ملفات تعريف الارتباط (Cookies) لتحسين تجربة المستخدم وتذكر تفضيلاتك. يمكنك التحكم في ملفات تعريف الارتباط من خلال إعدادات المتصفح.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '7. التغييرات على السياسة',
              'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإعلامك بأي تغييرات جوهرية من خلال الإشعارات في التطبيق أو عبر البريد الإلكتروني.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '8. الاتصال بنا',
              'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى الاتصال بنا:\n\n'
                  '• البريد الإلكتروني: privacy@school.edu\n'
                  '• الهاتف: +966 123 456 789\n'
                  '• العنوان: الرياض، حي العليا',
              context,
            ),
            SizedBox(height: 32.h),

            // موافقة
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'موافقتك',
                      style: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.green[800]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'باستخدامك لهذا التطبيق، فإنك توافق على شروط وسياسة الخصوصية المذكورة أعلاه.',
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(height: 1.6, color: Colors.green[800]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Text(
          content,
          style: AppTextStyle.bodyMedium(context).copyWith(height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
