import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/execution/add_event_screen.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/weekly_view.dart';

class AdminCalendarScreen extends StatefulWidget {
  const AdminCalendarScreen({super.key});

  @override
  State<AdminCalendarScreen> createState() => _AdminCalendarScreenState();
}

class _AdminCalendarScreenState extends State<AdminCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: يومي, 1: أسبوعي, 2: شهري
  String _selectedFilter = AppLocalKay.filter_all.tr(); // تصفية الأحداث
  final List<String> _filters = [
    AppLocalKay.filter_all.tr(),
    AppLocalKay.school_events.tr(),
    AppLocalKay.school_activities.tr(),
    AppLocalKay.school_exams.tr(),
    AppLocalKay.school_holidays.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            CalendarHeader(selectedDate: _selectedDate, getFormattedDate: _getFormattedDate),
            // شريط التحكم والتصفية
            CalendarControlBar(
              selectedFilter: _selectedFilter,
              filters: _filters,
              currentView: _currentView,
              onFilterSelected: (filter) => setState(() => _selectedFilter = filter),
              onViewSelected: (index) => setState(() => _currentView = index),
              onPrevious: _goToPrevious,
              onNext: _goToNext,
            ),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewEvent,
        backgroundColor: const Color(0xFF9C27B0),
        child: Icon(Icons.add_rounded, color: AppColor.whiteColor(context), size: 24.w),
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case 0:
        return DailyView(
          selectedDate: _selectedDate,
          dailyEvents: _getEventsForDay(_selectedDate),
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getFormattedDate: _getFormattedDate,
          onEditEvent: _editEvent,
          onSetReminder: _setReminder,
          onShareEvent: _shareEvent,
        );
      case 1:
        return WeeklyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getWeeklyEvents: _getWeeklyEvents,
          getWeekNumber: _getWeekNumber,
          getDayName: _getDayName,
          isSameDay: _isSameDay,
        );
      case 2:
        return MonthlyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getEventsForMonth: _getEventsForMonth,
          upcomingEvents: _getUpcomingEvents(),
        );
      default:
        return DailyView(
          selectedDate: _selectedDate,
          dailyEvents: _getEventsForDay(_selectedDate),
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getFormattedDate: _getFormattedDate,
          onEditEvent: _editEvent,
          onSetReminder: _setReminder,
          onShareEvent: _shareEvent,
        );
    }
  }

  // دوال مساعدة
  String _getFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'ar').format(date);
  }

  void _goToPrevious() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      } else {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
      }
    });
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  int _getWeekNumber(DateTime date) {
    int firstDay = DateTime(date.year, 1, 1).weekday;
    int days = date.difference(DateTime(date.year, 1, 1)).inDays;
    return ((days + firstDay - 1) / 7).floor() + 1;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // دوال الإجراءات
  void _addNewEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEventScreen(color: Color(0xFF9C27B0))),
    );
  }

  void _editEvent(AdminCalendarEvent event) {}

  void _setReminder(AdminCalendarEvent event) {}

  void _shareEvent(AdminCalendarEvent event) {}

  // بيانات تجريبية للأحداث
  List<AdminCalendarEvent> _getEventsForDay(DateTime day) {
    List<AdminCalendarEvent> allEvents = [
      AdminCalendarEvent(
        title: "اجتماع مجلس الإدارة",
        date: "١٥ نوفمبر",
        time: "٩:٠٠ ص - ١٠:٣٠ ص",
        type: "اجتماع",
        color: const Color(0xFFF59E0B),
        location: "قاعة الاجتماعات الرئيسية",
        description: "مناقشة الميزانية والتخطيط للفصل الدراسي الثاني",
        participants: ["مدير المدرسة", "نائب المدير", "رؤساء الأقسام"],
        priority: "عالي",
      ),
      AdminCalendarEvent(
        title: "حفل تكريم المتفوقين",
        date: "١٥ نوفمبر",
        time: "١١:٠٠ ص - ١٢:٣٠ م",
        type: "فعالية",
        color: const Color(0xFF10B981),
        location: "المسرح المدرسي",
        description: "تكريم الطلاب المتفوقين في الفصل الدراسي الأول",
        participants: ["جميع الطلاب", "أولياء الأمور", "الهيئة التعليمية"],
        priority: "متوسط",
      ),
      AdminCalendarEvent(
        title: "اختبارات منتصف الفصل",
        date: "١٨ نوفمبر",
        time: "كامل اليوم",
        type: "اختبار",
        color: const Color(0xFFDC2626),
        location: "الفصول الدراسية",
        description: "اختبارات منتصف الفصل الدراسي الثاني لجميع الصفوف",
        participants: ["جميع الطلاب", "المعلمين"],
        priority: "عالي",
      ),
      AdminCalendarEvent(
        title: "عطلة العيد الوطني",
        date: "٢٠ نوفمبر",
        time: "كامل اليوم",
        type: "عطلة",
        color: const Color(0xFF7C3AED),
        location: "-",
        description: "عطلة بمناسبة العيد الوطني",
        participants: ["جميع الطلاب", "الهيئة التعليمية"],
        priority: "منخفض",
      ),
      AdminCalendarEvent(
        title: "ورشة تطوير المعلمين",
        date: "٢٢ نوفمبر",
        time: "٢:٠٠ م - ٤:٠٠ م",
        type: "اجتماع",
        color: const Color(0xFFF59E0B),
        location: "معمل الحاسوب",
        description: "ورشة عمل حول استراتيجيات التدريس الحديثة",
        participants: ["جميع المعلمين"],
        priority: "متوسط",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<AdminCalendarEvent> _getEventsForMonth(DateTime month) {
    return _getEventsForDay(month);
  }

  List<AdminCalendarEvent> _getWeeklyEvents() {
    return _getEventsForDay(_selectedDate);
  }

  List<AdminCalendarEvent> _getUpcomingEvents() {
    return _getEventsForDay(_selectedDate);
  }
}
