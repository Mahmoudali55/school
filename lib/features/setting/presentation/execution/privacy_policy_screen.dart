// lib/features/settings/presentation/screens/privacy_policy_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سياسة الخصوصية',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
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
                    Text(
                      'آخر تحديث: 20 مارس 2024',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'نحن في مدرسة النموذجية نلتزم بحماية خصوصيتك وبياناتك الشخصية.',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
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
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '3. مشاركة المعلومات',
              'نحن لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك المعلومات في الحالات التالية:\n\n'
                  '• مع الجهات التعليمية المختصة\n'
                  '• عند وجود متطلبات قانونية\n'
                  '• مع مزودي الخدمات الذين يعملون نيابة عننا\n'
                  '• للحفاظ على سلامة وأمن المستخدمين',
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '4. حماية المعلومات',
              'نحن نستخدم إجراءات أمنية متعددة لحماية معلوماتك:\n\n'
                  '• تشفير البيانات أثناء النقل والتخزين\n'
                  '• التحكم في الوصول بناءً على الصلاحيات\n'
                  '• مراجعة دورية لإجراءات الأمان\n'
                  '• تدريب الموظفين على حماية البيانات',
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
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '6. ملفات تعريف الارتباط',
              'نستخدم ملفات تعريف الارتباط (Cookies) لتحسين تجربة المستخدم وتذكر تفضيلاتك. يمكنك التحكم في ملفات تعريف الارتباط من خلال إعدادات المتصفح.',
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '7. التغييرات على السياسة',
              'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإعلامك بأي تغييرات جوهرية من خلال الإشعارات في التطبيق أو عبر البريد الإلكتروني.',
            ),
            SizedBox(height: 24.h),

            _buildPrivacySection(
              '8. الاتصال بنا',
              'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى الاتصال بنا:\n\n'
                  '• البريد الإلكتروني: privacy@school.edu\n'
                  '• الهاتف: +966 123 456 789\n'
                  '• العنوان: الرياض، حي العليا',
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
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'باستخدامك لهذا التطبيق، فإنك توافق على شروط وسياسة الخصوصية المذكورة أعلاه.',
                      style: TextStyle(fontSize: 14.sp, color: Colors.green[700]),
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

  Widget _buildPrivacySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.6),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
