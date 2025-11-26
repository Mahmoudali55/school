// lib/features/settings/presentation/screens/user_management_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User('أحمد محمد', 'مدير', 'admin@school.edu', true),
    User('محمد أحمد', 'نائب المدير', 'vice@school.edu', true),
    User('فاطمة علي', 'معلم', 'teacher1@school.edu', true),
    User('خالد إبراهيم', 'معلم', 'teacher2@school.edu', false),
    User('سارة عبدالله', 'سكرتيرة', 'secretary@school.edu', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة المستخدمين',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [IconButton(icon: Icon(Icons.person_add), onPressed: _addNewUser)],
      ),
      body: Column(
        children: [
          // إحصائيات سريعة
          _buildUserStats(),

          // قائمة المستخدمين
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return _buildUserCard(_users[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewUser,
        backgroundColor: const Color(0xFF2E5BFF),
        child: Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildUserStats() {
    final activeUsers = _users.where((user) => user.isActive).length;
    final teachers = _users.where((user) => user.role == 'معلم').length;
    final admins = _users.where((user) => user.role == 'مدير' || user.role == 'نائب المدير').length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(_users.length.toString(), 'المستخدمين', Colors.blue),
          _buildStatItem(activeUsers.toString(), 'نشطين', Colors.green),
          _buildStatItem(teachers.toString(), 'معلمين', Colors.orange),
          _buildStatItem(admins.toString(), 'إداريين', Colors.purple),
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

  Widget _buildUserCard(User user) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role),
          child: Text(
            user.name.split(' ').first[0],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user.name,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.role),
            Text(
              user.email,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              user.isActive ? Icons.check_circle : Icons.remove_circle,
              color: user.isActive ? Colors.green : Colors.red,
              size: 20.w,
            ),
            SizedBox(width: 8.w),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),
              onSelected: (value) => _handleUserAction(value, user),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(value: 'edit', child: Text('تعديل')),
                PopupMenuItem(value: 'toggle', child: Text(user.isActive ? 'تعطيل' : 'تفعيل')),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('حذف', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'مدير':
        return Colors.red;
      case 'نائب المدير':
        return Colors.orange;
      case 'معلم':
        return Colors.blue;
      case 'سكرتيرة':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _addNewUser() {
    // TODO: إضافة مستخدم جديد
  }

  void _handleUserAction(String action, User user) {
    switch (action) {
      case 'edit':
        _editUser(user);
        break;
      case 'toggle':
        _toggleUser(user);
        break;
      case 'delete':
        _deleteUser(user);
        break;
    }
  }

  void _editUser(User user) {
    // TODO: تعديل المستخدم
  }

  void _toggleUser(User user) {
    setState(() {
      user.isActive = !user.isActive;
    });
  }

  void _deleteUser(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف المستخدم'),
          content: Text('هل أنت متأكد من أنك تريد حذف المستخدم ${user.name}؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('إلغاء')),
            TextButton(
              onPressed: () {
                setState(() {
                  _users.remove(user);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف المستخدم بنجاح'), backgroundColor: Colors.green),
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

class User {
  String name;
  String role;
  String email;
  bool isActive;

  User(this.name, this.role, this.email, this.isActive);
}
