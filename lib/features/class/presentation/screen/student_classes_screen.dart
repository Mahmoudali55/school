import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/presentation/screen/widget/student/student_class_widgets.dart';

class StudentClassesScreen extends StatelessWidget {
  const StudentClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.classesSection.tr(),
          style: AppTextStyle.titleLarge(
            context,
            color: AppColor.blackColor(context),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            CustomFormField(
              controller: TextEditingController(),
              radius: 12.r,
              prefixIcon: const Icon(Icons.search),
              hintText: 'ابحث في الفصول الدراسية',
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              AppLocalKay.classes_section.tr(),
              style: AppTextStyle.titleLarge(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            // Classes List
            Expanded(
              child: ListView(
                children: [
                  StudentClassCard(
                    className: 'الرياضيات',
                    teacherName: 'أ. أحمد محمد',
                    room: 'القاعة ١٠١',
                    time: '٨:٠٠ ص - ٩:٣٠ ص',
                    color: Colors.blue,
                    icon: Icons.calculate,
                    onEnter: () {},
                  ),
                  StudentClassCard(
                    className: 'اللغة العربية',
                    teacherName: 'أ. فاطمة علي',
                    room: 'القاعة ٢٠٣',
                    time: '١٠:٠٠ ص - ١١:٣٠ ص',
                    color: Colors.green,
                    icon: Icons.menu_book,
                    onEnter: () {},
                  ),
                  StudentClassCard(
                    className: 'العلوم',
                    teacherName: 'أ. خالد إبراهيم',
                    room: 'المعمل ٣٠١',
                    time: '١٢:٠٠ م - ١:٣٠ م',
                    color: Colors.orange,
                    icon: Icons.science,
                    onEnter: () {},
                  ),
                  StudentClassCard(
                    className: 'اللغة الإنجليزية',
                    teacherName: 'أ. سارة عبدالله',
                    room: 'القاعة ١٠٥',
                    time: '٢:٠٠ م - ٣:٣٠ م',
                    color: Colors.purple,
                    icon: Icons.language,
                    onEnter: () {},
                  ),
                  StudentClassCard(
                    className: 'التاريخ',
                    teacherName: 'أ. محمد حسن',
                    room: 'القاعة ٢٠١',
                    time: '٤:٠٠ م - ٥:٣٠ م',
                    color: Colors.brown,
                    icon: Icons.history,
                    onEnter: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
