import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_weekly_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: شهري, 1: أسبوعي, 2: يومي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // رأس الصفحة
            StudentCalendarHeader(selectedDate: _selectedDate, getFormattedDate: _getFormattedDate),
            // شريط التحكم
            StudentCalendarControlBar(
              currentView: _currentView,
              onViewSelected: (index) => setState(() => _currentView = index),
              onPrevious: _goToPrevious,
              onNext: _goToNext,
            ),
            // عرض التقويم
            Expanded(child: _buildCalendarContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_currentView) {
      case 0:
        return StudentMonthlyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          upcomingEvents: _getUpcomingEvents(),
        );
      case 1:
        return StudentWeeklyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getDayName: _getDayName,
          isSameDay: _isSameDay,
          upcomingEvents: _getUpcomingEvents(),
        );
      case 2:
        return StudentDailyView(
          selectedDate: _selectedDate,
          dailyEvents: _getEventsForDay(_selectedDate),
          getFormattedDate: _getFormattedDate,
          getDayName: _getDayName,
        );
      default:
        return StudentMonthlyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          upcomingEvents: _getUpcomingEvents(),
        );
    }
  }

  // الدوال المساعدة
  void _goToPrevious() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.subtract(const Duration(days: 7));
      } else {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentView == 0) {
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
      } else if (_currentView == 1) {
        _selectedDate = _selectedDate.add(const Duration(days: 7));
      } else {
        _selectedDate = _selectedDate.add(const Duration(days: 1));
      }
    });
  }

  String _getFormattedDate(DateTime date) {
    List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // بيانات تجريبية للأحداث
  List<StudentCalendarEvent> _getEventsForDay(DateTime day) {
    List<StudentCalendarEvent> allEvents = [
      StudentCalendarEvent(
        title: "اختبار الرياضيات",
        date: "١٥ نوفمبر",
        time: "٨:٠٠ ص - ٩:٣٠ ص",
        type: "امتحان",
        color: const Color(0xFFDC2626),
        location: "القاعة ١٠١",
        description: "الوحدة الثالثة - الجبر",
      ),
      StudentCalendarEvent(
        title: "حصة العلوم",
        date: "١٥ نوفمبر",
        time: "١٠:٠٠ ص - ١٠:٤٥ ص",
        type: "حصّة",
        color: const Color(0xFF10B981),
        location: "المعمل",
        description: "تجربة التفاعلات الكيميائية",
      ),
      StudentCalendarEvent(
        title: "رحلة علمية",
        date: "١٨ نوفمبر",
        time: "٨:٠٠ ص - ١٢:٠٠ م",
        type: "نشاط",
        color: const Color(0xFFF59E0B),
        location: "متحف العلوم",
        description: "زيارة إلى متحف العلوم الوطني",
      ),
      StudentCalendarEvent(
        title: "مسابقة القرآن",
        date: "٢٠ نوفمبر",
        time: "٩:٠٠ ص - ١١:٠٠ ص",
        type: "مسابقة",
        color: const Color(0xFF7C3AED),
        location: "المسجد",
        description: "المسابقة السنوية لحفظ القرآن",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<StudentCalendarEvent> _getUpcomingEvents() {
    return _getEventsForDay(_selectedDate);
  }
}
