// lib/features/settings/presentation/screens/class_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  final List<SchoolClass> _classes = [
    SchoolClass('الصف الأول', 'أ', 25, 'فاطمة علي'),
    SchoolClass('الصف الثاني', 'ب', 30, 'خالد إبراهيم'),
    SchoolClass('الصف الثالث', 'أ', 28, 'سارة عبدالله'),
    SchoolClass('الصف الرابع', 'ج', 22, 'محمد حسن'),
    SchoolClass('الصف الخامس', 'أ', 26, 'نورة خالد'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة الصفوف',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _addNewClass)],
      ),
      body: Column(
        children: [
          // إحصائيات
          _buildClassStats(),

          // قائمة الصفوف
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                return _buildClassCard(_classes[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewClass,
        backgroundColor: const Color(0xFF2E5BFF),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildClassStats() {
    final totalStudents = _classes.fold(0, (sum, classItem) => sum + classItem.studentCount);
    final totalClasses = _classes.length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(totalClasses.toString(), 'الصفوف', Colors.blue),
          _buildStatItem(totalStudents.toString(), 'الطلاب', Colors.green),
          _buildStatItem('5', 'المعلمين', Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildClassCard(SchoolClass schoolClass) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2E5BFF).withOpacity(0.1),
          child: Icon(Icons.class_, color: const Color(0xFF2E5BFF)),
        ),
        title: Text(
          '${schoolClass.grade} - ${schoolClass.section}',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المعلم: ${schoolClass.teacher}'),
            Text('عدد الطلاب: ${schoolClass.studentCount}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, size: 20.w),
              onPressed: () => _editClass(schoolClass),
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20.w, color: Colors.red),
              onPressed: () => _deleteClass(schoolClass),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewClass() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddClassDialog(
          onClassAdded: (newClass) {
            setState(() {
              _classes.add(newClass);
            });
          },
        );
      },
    );
  }

  void _editClass(SchoolClass schoolClass) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditClassDialog(
          schoolClass: schoolClass,
          onClassUpdated: (updatedClass) {
            setState(() {
              final index = _classes.indexOf(schoolClass);
              _classes[index] = updatedClass;
            });
          },
        );
      },
    );
  }

  void _deleteClass(SchoolClass schoolClass) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف الصف'),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف ${schoolClass.grade} - ${schoolClass.section}؟',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                setState(() {
                  _classes.remove(schoolClass);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف الصف بنجاح'), backgroundColor: Colors.green),
                );
              },
              child: Text('حذف', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class SchoolClass {
  String grade;
  String section;
  int studentCount;
  String teacher;

  SchoolClass(this.grade, this.section, this.studentCount, this.teacher);
}

// ديالوج إضافة صف
class AddClassDialog extends StatefulWidget {
  final Function(SchoolClass) onClassAdded;

  const AddClassDialog({super.key, required this.onClassAdded});

  @override
  State<AddClassDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  final _sectionController = TextEditingController();
  final _teacherController = TextEditingController();
  final _studentCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('إضافة صف جديد'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _gradeController,
              decoration: InputDecoration(labelText: 'الصف', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم الصف';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _sectionController,
              decoration: InputDecoration(labelText: 'الشعبة', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الشعبة';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _teacherController,
              decoration: InputDecoration(labelText: 'المعلم', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم المعلم';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _studentCountController,
              decoration: InputDecoration(labelText: 'عدد الطلاب', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال عدد الطلاب';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newClass = SchoolClass(
                _gradeController.text,
                _sectionController.text,
                int.parse(_studentCountController.text),
                _teacherController.text,
              );
              widget.onClassAdded(newClass);
              Navigator.of(context).pop();
            }
          },
          child: Text('إضافة'),
        ),
      ],
    );
  }
}

// ديالوج تعديل الصف
class EditClassDialog extends StatefulWidget {
  final SchoolClass schoolClass;
  final Function(SchoolClass) onClassUpdated;

  const EditClassDialog({super.key, required this.schoolClass, required this.onClassUpdated});

  @override
  State<EditClassDialog> createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _gradeController;
  late TextEditingController _sectionController;
  late TextEditingController _teacherController;
  late TextEditingController _studentCountController;

  @override
  void initState() {
    super.initState();
    _gradeController = TextEditingController(text: widget.schoolClass.grade);
    _sectionController = TextEditingController(text: widget.schoolClass.section);
    _teacherController = TextEditingController(text: widget.schoolClass.teacher);
    _studentCountController = TextEditingController(
      text: widget.schoolClass.studentCount.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تعديل الصف'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _gradeController,
              decoration: InputDecoration(labelText: 'الصف', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم الصف';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _sectionController,
              decoration: InputDecoration(labelText: 'الشعبة', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الشعبة';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _teacherController,
              decoration: InputDecoration(labelText: 'المعلم', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم المعلم';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _studentCountController,
              decoration: InputDecoration(labelText: 'عدد الطلاب', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال عدد الطلاب';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedClass = SchoolClass(
                _gradeController.text,
                _sectionController.text,
                int.parse(_studentCountController.text),
                _teacherController.text,
              );
              widget.onClassUpdated(updatedClass);
              Navigator.of(context).pop();
            }
          },
          child: Text('حفظ'),
        ),
      ],
    );
  }
}
