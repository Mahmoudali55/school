// lib/features/settings/presentation/screens/terms_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context,
        title: Text(
          'الشروط والأحكام',
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
                    Text(
                      'آخر تحديث: 20 مارس 2024',
                      style: AppTextStyle.titleSmall(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: AppColor.greyColor(context)),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام تطبيق إدارة المدرسة.',
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.greyColor(context)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '1. القبول بالشروط',
              'باستخدامك لهذا التطبيق، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي جزء من هذه الشروط، فيرجى عدم استخدام التطبيق.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '2. وصف الخدمة',
              'يوفر تطبيق إدارة المدرسة نظاماً متكاملاً لإدارة العمليات التعليمية والإدارية في المدرسة، بما في ذلك:\n\n'
                  '• إدارة الطلاب والمعلمين\n'
                  '• متابعة الحضور والغياب\n'
                  '• تسجيل الدرجات والتقارير\n'
                  '• التواصل مع أولياء الأمور\n'
                  '• الإشعارات والتنبيهات',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '3. حساب المستخدم',
              '• يجب أن تكون المعلومات المسجلة في الحساب دقيقة وكاملة\n'
                  '• أنت مسؤول عن الحفاظ على سرية معلومات حسابك\n'
                  '• يجب إبلاغنا فوراً عن أي استخدام غير مصرح لحسابك\n'
                  '• يحق لنا تعليق أو إنهاء الحساب في حالة المخالفة',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '4. الالتزامات',
              'يتعهد المستخدم بالالتزام بالتالي:\n\n'
                  '• استخدام التطبيق للأغراض التعليمية فقط\n'
                  '• عدم مشاركة معلومات الحساب مع الآخرين\n'
                  '• احترام خصوصية الآخرين\n'
                  '• الالتزام بالأنظمة والتعليمات المدرسية\n'
                  '• الإبلاغ عن أي خلل أو إساءة استخدام',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '5. المحتوى',
              '• أنت المسؤول عن المحتوى الذي تقوم برفعه أو مشاركته\n'
                  '• يجب أن يكون المحتوى مناسباً ولأغراض تعليمية\n'
                  '• يحظر رفع محتوى مسيء أو غير قانوني\n'
                  '• نحتفظ بالحق في حذف أي محتوى غير مناسب',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '6. الملكية الفكرية',
              'جميع حقوق الملكية الفكرية في التطبيق والشعارات والمحتوى مملوكة لمدرسة النموذجية. لا يسمح بنسخ أو توزيع أو تعديل أي جزء من التطبيق دون إذن كتابي مسبق.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '7. حدود المسؤولية',
              '• لا نتحمل مسؤولية أي أضرار ناتجة عن استخدام التطبيق\n'
                  '• نعمل على توفير خدمة مستمرة ولكن لا نضمن عدم وجود انقطاعات\n'
                  '• المستخدم يتحمل المسؤولية الكاملة عن استخدامه للتطبيق\n'
                  '• نتحفظ الحق في تعديل أو إيقاف الخدمة في أي وقت',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '8. الإنهاء',
              'يحق لنا إنهاء أو تعليق حسابك في الحالات التالية:\n\n'
                  '• مخالفة هذه الشروط والأحكام\n'
                  '• الاستخدام غير القانوني أو غير المصرح به\n'
                  '• الإضرار بالمنصة أو المستخدمين الآخرين\n'
                  '• عدم النشاط لفترات طويلة',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '9. التعديلات',
              'نحتفظ بالحق في تعديل هذه الشروط والأحكام في أي وقت. سيتم إشعار المستخدمين بأي تغييرات جوهرية وسيكون الاستمرار في استخدام التطبيق بمثابة موافقة على التعديلات.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '10. القوانين المطبقة',
              'تخضع هذه الشروط والأحكام لقوانين المملكة العربية السعودية. أي نزاعات تنشأ عن استخدام التطبيق ستخضع للاختصاص القضائي لمحاكم الرياض.',
              context,
            ),
            SizedBox(height: 24.h),

            _buildTermSection(
              '11. الاتصال',
              'للاستفسارات حول هذه الشروط والأحكام، يرجى الاتصال بنا:\n\n'
                  '• البريد الإلكتروني: legal@school.edu\n'
                  '• الهاتف: +966 123 456 789\n'
                  '• أوقات العمل: من الأحد إلى الخميس، 8 صباحاً - 4 مساءً',
              context,
            ),
            SizedBox(height: 32.h),

            // تنويه
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تنويه مهم',
                      style: AppTextStyle.titleLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold, color: Colors.orange[700]),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'يجب على جميع المستخدمين قراءة وفهم هذه الشروط والأحكام قبل استخدام التطبيق. الاستمرار في استخدام التطبيق يعني الموافقة على جميع البنود المذكورة أعلاه.',
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(height: 1.6, color: Colors.orange[700]),
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

  Widget _buildTermSection(String title, String content, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: AppTextStyle.bodyMedium(
            context,
          ).copyWith(height: 1.6, color: AppColor.greyColor(context)),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
