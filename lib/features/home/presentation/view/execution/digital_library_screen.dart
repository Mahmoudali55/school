import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/features/home/presentation/view/execution/library_item_detail_screen.dart';
import 'package:my_template/features/home/presentation/view/execution/library_search_delegate_screen.dart';

class DigitalLibraryScreen extends StatefulWidget {
  const DigitalLibraryScreen({super.key});

  @override
  State<DigitalLibraryScreen> createState() => _DigitalLibraryScreenState();
}

class _DigitalLibraryScreenState extends State<DigitalLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;

  final List<String> _categories = ['الكل', 'الكتب', 'الفيديوهات', 'الملخصات', 'أوراق العمل'];

  final List<Map<String, dynamic>> _libraryItems = [
    {
      'title': 'كتاب الرياضيات',
      'type': 'كتاب',
      'subject': 'الرياضيات',
      'size': '15.2 MB',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
    {
      'title': 'فيديو شرح الفيزياء',
      'type': 'فيديو',
      'subject': 'الفيزياء',
      'size': '45.7 MB',
      'icon': Icons.video_library,
      'color': Colors.blue,
    },
    {
      'title': 'ملخص الكيمياء',
      'type': 'ملخص',
      'subject': 'الكيمياء',
      'size': '2.1 MB',
      'icon': Icons.description,
      'color': Colors.green,
    },
    {
      'title': 'ورقة عمل الرياضيات',
      'type': 'ورقة عمل',
      'subject': 'الرياضيات',
      'size': '1.8 MB',
      'icon': Icons.assignment,
      'color': Colors.orange,
    },
    {
      'title': 'كتاب اللغة العربية',
      'type': 'كتاب',
      'subject': 'اللغة العربية',
      'size': '12.3 MB',
      'icon': Icons.picture_as_pdf,
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
      initialIndex: _selectedCategory,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        context,
        title: const Text('المكتبة الرقمية'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: _searchLibrary)],
      ),
      body: Column(
        children: [
          // TabBar بدلاً من القائمة الأفقية
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              tabs: _categories.map((category) {
                return Tab(text: category);
              }).toList(),
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 3.0,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 14.sp),
              isScrollable: true,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
          SizedBox(height: 8.h),

          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildTabContent(category);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String category) {
    // تصفية العناصر حسب التبويب المحدد
    List<Map<String, dynamic>> filteredItems = _libraryItems.where((item) {
      if (category == 'الكل') return true;
      if (category == 'الكتب') return item['type'] == 'كتاب';
      if (category == 'الفيديوهات') return item['type'] == 'فيديو';
      if (category == 'الملخصات') return item['type'] == 'ملخص';
      if (category == 'أوراق العمل') return item['type'] == 'ورقة عمل';
      return true;
    }).toList();

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getCategoryIcon(category), size: 60.w, color: Colors.grey.shade400),
            SizedBox(height: 16.h),
            Text(
              'لا توجد عناصر في $category',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildLibraryItem(item, index);
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'الكل':
        return Icons.all_inclusive;
      case 'الكتب':
        return Icons.menu_book;
      case 'الفيديوهات':
        return Icons.video_library;
      case 'الملخصات':
        return Icons.description;
      case 'أوراق العمل':
        return Icons.assignment;
      default:
        return Icons.folder;
    }
  }

  Widget _buildLibraryItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: item['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(item['icon'], color: item['color']),
        ),
        title: Text(
          item['title'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text('${item['type']} - ${item['subject']}'),
            SizedBox(height: 2.h),
            Text(
              item['size'],
              style: TextStyle(fontSize: 10.sp, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.download, color: Colors.blue, size: 20.w),
              onPressed: () => _downloadItem(item),
            ),
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.grey, size: 20.w),
              onPressed: () => _viewItem(item),
            ),
          ],
        ),
        onTap: () => _viewItem(item),
      ),
    );
  }

  void _searchLibrary() {
    showSearch(context: context, delegate: LibrarySearchDelegate());
  }

  void _downloadItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جاري تحميل ${item['title']}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewItem(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LibraryItemDetailScreen(item: item)),
    );
  }
}
