import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/setting/presentation/execution/class_management_screen.dart';

class AddOrEditClassSheet extends StatefulWidget {
  final SchoolClass? schoolClass;
  final Function(SchoolClass) onSubmit;

  const AddOrEditClassSheet({super.key, this.schoolClass, required this.onSubmit});

  @override
  State<AddOrEditClassSheet> createState() => _AddOrEditClassSheetState();
}

class _AddOrEditClassSheetState extends State<AddOrEditClassSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController grade;
  late TextEditingController section;
  late TextEditingController teacher;
  late TextEditingController studentCount;

  @override
  void initState() {
    super.initState();
    grade = TextEditingController(text: widget.schoolClass?.grade ?? "");
    section = TextEditingController(text: widget.schoolClass?.section ?? "");
    teacher = TextEditingController(text: widget.schoolClass?.teacher ?? "");
    studentCount = TextEditingController(text: widget.schoolClass?.studentCount.toString() ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Text(
              widget.schoolClass == null ? "إضافة صف" : "تعديل الصف",
              style: AppTextStyle.headlineMedium(context).copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  _field("الصف", grade),
                  _gap(),
                  _field("الشعبة", section),
                  _gap(),
                  _field("المعلم", teacher),
                  _gap(),
                  _field("عدد الطلاب", studentCount, number: true),
                ],
              ),
            ),
            SizedBox(height: 18),

            _actionButton(),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, {bool number = false}) {
    return TextFormField(
      controller: c,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      validator: (v) => v == null || v.isEmpty ? "يرجى إدخال $label" : null,
    );
  }

  Widget _actionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;

          widget.onSubmit(
            SchoolClass(
              grade.text.trim(),
              section.text.trim(),
              int.parse(studentCount.text.trim()),
              teacher.text.trim(),
            ),
          );

          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E5BFF),
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          widget.schoolClass == null ? "إضافة" : "حفظ",
          style: AppTextStyle.bodyMedium(context, color: Colors.white),
        ),
      ),
    );
  }

  Widget _gap() => SizedBox(height: 14.h);
}
