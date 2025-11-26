// lib/features/settings/presentation/screens/help_center_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<FAQItem> _faqItems = [
    FAQItem(
      'كيف يمكنني إضافة مستخدم جديد؟',
      'لإضافة مستخدم جديد:\n1. انتقل إلى إدارة المستخدمين\n2. انقر على زر الإضافة (+)\n3. املأ بيانات المستخدم\n4. انقر على حفظ',
    ),
    FAQItem(
      'كيفية إنشاء نسخة احتياطية؟',
      'لإنشاء نسخة احتياطية:\n1. انتقل إلى الإعدادات\n2. اختر النسخ الاحتياطي\n3. حدد البيانات المطلوبة\n4. انقر على إنشاء نسخة احتياطية',
    ),
    FAQItem(
      'كيفية إعداد السنة الدراسية؟',
      'لإعداد السنة الدراسية:\n1. انتقل إلى إعدادات النظام\n2. اختر السنة الدراسية\n3. حدد السنة المطلوبة\n4. احفظ التغييرات',
    ),
    FAQItem(
      'ماذا أفعل إذا نسيت كلمة المرور؟',
      'إذا نسيت كلمة المرور:\n1. انقر على "نسيت كلمة المرور"\n2. اتبع التعليمات المرسلة للبريد\n3. قم بتعيين كلمة مرور جديدة',
    ),
    FAQItem(
      'كيفية إعداد الإشعارات؟',
      'لإعداد الإشعارات:\n1. انتقل إلى إعدادات الإشعارات\n2. قم بتفعيل أنواع الإشعارات المطلوبة\n3. حدد توقيت الإشعارات\n4. احفظ الإعدادات',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<FAQItem> _filteredFaqItems = [];

  @override
  void initState() {
    super.initState();
    _filteredFaqItems = _faqItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'مركز المساعدة',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث في الأسئلة الشائعة...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.r),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // البطاقات السريعة
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                _buildQuickCard('الدعم الفني', Icons.support_agent, Colors.blue),
                SizedBox(width: 12.w),
                _buildQuickCard('الفيديو التعليمي', Icons.video_library, Colors.green),
                SizedBox(width: 12.w),
                _buildQuickCard('الاتصال بالدعم', Icons.contact_support, Colors.orange),
                SizedBox(width: 12.w),
                _buildQuickCard('التقارير', Icons.report, Colors.purple),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // الأسئلة الشائعة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  'الأسئلة الشائعة',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // قائمة الأسئلة
          Expanded(
            child: _filteredFaqItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _filteredFaqItems.length,
                    itemBuilder: (context, index) {
                      return _buildFAQItem(_filteredFaqItems[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _contactSupport,
        backgroundColor: const Color(0xFF2E5BFF),
        child: Icon(Icons.chat, color: Colors.white),
      ),
    );
  }

  Widget _buildQuickCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        width: 120.w,
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.w, color: color),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(FAQItem faqItem) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ExpansionTile(
        leading: Icon(Icons.help_outline, color: const Color(0xFF2E5BFF)),
        title: Text(
          faqItem.question,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              faqItem.answer,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700], height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80.w, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'لم نتمكن من العثور على أي سؤال يتطابق مع بحثك',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFaqItems = _faqItems;
      } else {
        _filteredFaqItems = _faqItems.where((faq) {
          return faq.question.toLowerCase().contains(query.toLowerCase()) ||
              faq.answer.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _contactSupport() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اتصل بالدعم الفني',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text('الهاتف'),
                subtitle: Text('+966 123 456 789'),
                onTap: () {
                  // TODO: فتح تطبيق الهاتف
                },
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('البريد الإلكتروني'),
                subtitle: Text('support@school.edu'),
                onTap: () {
                  // TODO: فتح تطبيق البريد
                },
              ),
              ListTile(
                leading: Icon(Icons.chat, color: Colors.orange),
                title: Text('الدردشة المباشرة'),
                subtitle: Text('متاح من 8 صباحاً إلى 4 مساءً'),
                onTap: () {
                  // TODO: فتح الدردشة
                },
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E5BFF)),
                  child: Text('إغلاق'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem(this.question, this.answer);
}
