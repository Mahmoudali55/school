import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';

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
          'إرسال إشعار',
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
              // اختيار نوع المستلمين
              DropdownButtonFormField<String>(
                value: _selectedAudience,
                decoration: InputDecoration(
                  labelText: 'إلى',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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
                    return 'يرجى اختيار المستلمين';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // اختيار الصفوف (إذا كانت الصفوف محددة)
              if (_selectedAudience == 'صفوف محددة') ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر الصفوف:',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: classes.map((classItem) {
                        return FilterChip(
                          label: Text(classItem),
                          selected: selectedClasses.contains(classItem),
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

              // عنوان الإشعار
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'عنوان الإشعار',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال عنوان الإشعار';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // نص الإشعار
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'نص الإشعار',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال نص الإشعار';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.h),

              // خيارات إضافية
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خيارات إضافية',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(Icons.important_devices, color: Colors.grey),
                          SizedBox(width: 8.w),
                          Text('سيتم إرسال الإشعار عبر:', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (v) {}),
                          Text('التطبيق', style: TextStyle(fontSize: 14.sp)),
                          SizedBox(width: 16.w),
                          Checkbox(value: false, onChanged: (v) {}),
                          Text('البريد الإلكتروني', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // زر الإرسال
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _sendNotification();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEC4899),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Text(
                    'إرسال الإشعار',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
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
