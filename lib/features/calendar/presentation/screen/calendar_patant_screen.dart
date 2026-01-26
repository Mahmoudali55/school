import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_control_bar.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_header.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_daily_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_monthly_view.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_weekly_view.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class CalendarPatentScreen extends StatefulWidget {
  const CalendarPatentScreen({super.key});

  @override
  State<CalendarPatentScreen> createState() => _CalendarPatentScreenState();
}

class _CalendarPatentScreenState extends State<CalendarPatentScreen> {
  DateTime _selectedDate = DateTime.now();
  int _currentView = 0; // 0: شهري, 1: أسبوعي, 2: يومي
  String _selectedStudent = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        List<String> students = [];
        if (state.parentsStudentStatus.isSuccess) {
          students = state.parentsStudentStatus.data!.map((e) => e.studentName).toList();
          if (students.isNotEmpty && _selectedStudent.isEmpty) {
            // Initialize selected student if empty
            _selectedStudent = students.first;
          } else if (students.isNotEmpty && !students.contains(_selectedStudent)) {
            // Reset if selected student is not in the new list
            _selectedStudent = students.first;
          }
        }

        // Ensure "جميع الأبناء" or similar option if needed, but for now matching previous logic
        // logic says: String _selectedStudent = "أحمد"; // initially

        return Scaffold(
          backgroundColor: AppColor.whiteColor(context),
          body: SafeArea(
            child: Column(
              children: [
                // رأس الصفحة
                ParentCalendarHeader(
                  selectedDate: _selectedDate,
                  getFormattedDate: _getFormattedDate,
                ),
                // اختيار الطالب وشريط التحكم
                state.parentsStudentStatus.isLoading
                    ? const LinearProgressIndicator()
                    : ParentCalendarControlBar(
                        selectedStudent: _selectedStudent.isEmpty && students.isNotEmpty
                            ? students.first
                            : _selectedStudent,
                        students: students,
                        currentView: _currentView,
                        onStudentChanged: (student) => setState(() => _selectedStudent = student),
                        onViewSelected: (index) => setState(() => _currentView = index),
                        onPrevious: _goToPrevious,
                        onNext: _goToNext,
                      ),
                // عرض التقويم
                Expanded(child: _buildCalendarContent(students)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarContent(List<String> students) {
    switch (_currentView) {
      case 0:
        return ParentMonthlyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getEventsForMonth: _getEventsForMonth,
          upcomingEvents: _getUpcomingEvents(),
        );
      case 1:
        return ParentWeeklyView(
          selectedDate: _selectedDate,
          students: students,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getEventsForStudent: _getEventsForStudent,
          getDayName: _getDayName,
          isSameDay: _isSameDay,
        );
      case 2:
        return ParentDailyView(
          selectedDate: _selectedDate,
          dailyEvents: _getEventsForDay(_selectedDate),
          getFormattedDate: _getFormattedDate,
        );
      default:
        return ParentMonthlyView(
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
          getEventsForDay: _getEventsForDay,
          getEventsForMonth: _getEventsForMonth,
          upcomingEvents: _getUpcomingEvents(),
        );
    }
  }

  // دوال مساعدة
  String _getFormattedDate(DateTime date) {
    return DateFormat('EEEE, d MMMM y', 'ar').format(date);
  }

  void _goToPrevious() {
    setState(() {
      if (_currentView == 2) {
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
      if (_currentView == 2) {
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

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // بيانات تجريبية للأحداث
  List<ParentCalendarEvent> _getEventsForDay(DateTime day) {
    List<ParentCalendarEvent> allEvents = [
      ParentCalendarEvent(
        title: "اختبار مادة العلوم",
        date: "١٥ نوفمبر",
        time: "٨:٣٠ ص - ١٠:٠٠ ص",
        type: "امتحان",
        color: const Color(0xFFDC2626),
        location: "مبنى ب - الطابق الثاني",
        description: "اختبار الفصل الأول في مادة العلوم العامة",
        student: "أحمد",
      ),
      ParentCalendarEvent(
        title: "اجتماع أولياء الأمور",
        date: "١٥ نوفمبر",
        time: "١:٠٠ م - ٢:٠٠ م",
        type: "اجتماع",
        color: const Color(0xFFF59E0B),
        location: "قاعة الاجتماعات",
        description: "مناقشة المستوى الدراسي",
        student: "جميع الأبناء",
      ),
      ParentCalendarEvent(
        title: "رحلة علمية",
        date: "٢٠ نوفمبر",
        time: "٨:٠٠ ص - ١٢:٠٠ م",
        type: "نشاط",
        color: const Color(0xFF7C3AED),
        location: "متحف العلوم",
        description: "زيارة إلى متحف العلوم الوطني",
        student: "محمد",
      ),
    ];

    return allEvents.where((event) => event.date.contains('${day.day}')).toList();
  }

  List<ParentCalendarEvent> _getEventsForMonth(DateTime month) {
    return _getEventsForDay(month);
  }

  List<ParentCalendarEvent> _getEventsForStudent(String student) {
    return _getEventsForDay(
      _selectedDate,
    ).where((event) => event.student == student || event.student == "جميع الأبناء").toList();
  }

  List<ParentCalendarEvent> _getUpcomingEvents() {
    return _getEventsForDay(_selectedDate);
  }
}
